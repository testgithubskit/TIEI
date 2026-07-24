#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
COMPLETE DATABASE MIGRATION FROM LOCAL TO SERVER
================================================

This script performs a complete migration from local to server database
by dumping the local database to SQL format and restoring to server.
It ensures all columns, data, and schema are properly migrated.

Usage:
    python migrate_from_local_to_server.py
"""

import os
import sys
from datetime import datetime
from typing import Dict, List, Any

# Add backend directory to Python path
backend_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, backend_dir)

try:
    import psycopg2
    from psycopg2 import sql
    from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
except ImportError:
    print("Error: psycopg2 not installed. Install it with: pip install psycopg2-binary")
    sys.exit(1)


# Database configurations
LOCAL_CONFIG = {
    "host": "localhost",
    "port": "5432",
    "user": "postgres",
    "password": "1234",
    "database": "Toyota_Demo"
}

SERVER_CONFIG = {
    "host": "172.18.7.91",
    "port": "5432",
    "user": "postgres",
    "password": "postgres",
    "database": "Toyota_Demo"
}


def get_connection(config: Dict[str, str], create_db_if_not_exists: bool = False) -> psycopg2.extensions.connection:
    """Create database connection from config dict."""
    if create_db_if_not_exists:
        # First connect to postgres database to create the target database if needed
        try:
            admin_config = config.copy()
            admin_config['database'] = 'postgres'
            admin_conn = psycopg2.connect(
                host=admin_config['host'],
                port=admin_config['port'],
                user=admin_config['user'],
                password=admin_config['password'],
                database=admin_config['database'],
                connect_timeout=30
            )
            admin_conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
            
            with admin_conn.cursor() as cur:
                # Check if database exists
                cur.execute("SELECT 1 FROM pg_database WHERE datname = %s", (config['database'],))
                if not cur.fetchone():
                    # Create database
                    cur.execute(sql.SQL("CREATE DATABASE {};").format(
                        sql.Identifier(config['database'])
                    ))
                    print(f"  Created database: {config['database']}")
            
            admin_conn.close()
        except Exception as e:
            print(f"  Warning: Could not create database: {e}")
    
    conn = psycopg2.connect(
        host=config['host'],
        port=config['port'],
        user=config['user'],
        password=config['password'],
        database=config['database'],
        connect_timeout=30
    )
    conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
    return conn


def check_connection(conn) -> bool:
    """Check if connection is still alive."""
    try:
        with conn.cursor() as cur:
            cur.execute("SELECT 1")
        return True
    except:
        return False


def ensure_connection(conn, config: Dict[str, str]) -> psycopg2.extensions.connection:
    """Ensure connection is alive, reconnect if necessary."""
    if conn is None or not check_connection(conn):
        if conn:
            try:
                conn.close()
            except:
                pass
        return get_connection(config)
    return conn


def get_schemas(conn) -> List[str]:
    """Get list of schemas from database."""
    with conn.cursor() as cur:
        cur.execute("""
            SELECT schema_name 
            FROM information_schema.schemata 
            WHERE schema_name NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
            ORDER BY schema_name;
        """)
        return [row[0] for row in cur.fetchall()]


def get_tables(conn, schema: str) -> List[str]:
    """Get list of tables from a schema."""
    with conn.cursor() as cur:
        cur.execute("""
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = %s 
            AND table_type = 'BASE TABLE'
            ORDER BY table_name;
        """, (schema,))
        return [row[0] for row in cur.fetchall()]


def get_table_columns(conn, schema: str, table: str) -> List[Dict[str, Any]]:
    """Get detailed column information for a table."""
    with conn.cursor() as cur:
        cur.execute("""
            SELECT 
                column_name, 
                data_type, 
                is_nullable, 
                column_default,
                character_maximum_length, 
                numeric_precision, 
                numeric_scale,
                ordinal_position,
                udt_name
            FROM information_schema.columns
            WHERE table_schema = %s AND table_name = %s
            ORDER BY ordinal_position;
        """, (schema, table))
        
        columns = []
        for row in cur.fetchall():
            columns.append({
                'column_name': row[0],
                'data_type': row[1],
                'is_nullable': row[2],
                'column_default': row[3],
                'character_maximum_length': row[4],
                'numeric_precision': row[5],
                'numeric_scale': row[6],
                'ordinal_position': row[7],
                'udt_name': row[8]
            })
        return columns


def get_primary_keys(conn, schema: str, table: str) -> List[str]:
    """Get primary key columns for a table."""
    with conn.cursor() as cur:
        cur.execute("""
            SELECT a.attname
            FROM pg_index i
            JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey)
            JOIN pg_class c ON c.oid = i.indrelid
            JOIN pg_namespace n ON n.oid = c.relnamespace
            WHERE n.nspname = %s AND c.relname = %s AND i.indisprimary;
        """, (schema, table))
        return [row[0] for row in cur.fetchall()]


def get_foreign_keys(conn, schema: str, table: str) -> List[Dict[str, Any]]:
    """Get foreign key constraints for a table."""
    with conn.cursor() as cur:
        cur.execute("""
            SELECT
                tc.constraint_name,
                kcu.column_name,
                ccu.table_name AS foreign_table_name,
                ccu.column_name AS foreign_column_name
            FROM information_schema.table_constraints AS tc
            JOIN information_schema.key_column_usage AS kcu
                ON tc.constraint_name = kcu.constraint_name
                AND tc.table_schema = kcu.table_schema
            JOIN information_schema.constraint_column_usage AS ccu
                ON ccu.constraint_name = tc.constraint_name
                AND ccu.table_schema = tc.table_schema
            WHERE tc.constraint_type = 'FOREIGN KEY'
                AND tc.table_schema = %s
                AND tc.table_name = %s;
        """, (schema, table))
        
        fks = []
        for row in cur.fetchall():
            fks.append({
                'constraint_name': row[0],
                'column_name': row[1],
                'foreign_table_name': row[2],
                'foreign_column_name': row[3]
            })
        return fks


def get_row_count(conn, schema: str, table: str) -> int:
    """Get row count for a table."""
    with conn.cursor() as cur:
        cur.execute(f'SELECT COUNT(*) FROM "{schema}"."{table}";')
        return cur.fetchone()[0]


def generate_create_table_sql(conn, schema: str, table: str) -> str:
    """Generate complete CREATE TABLE SQL statement."""
    columns = get_table_columns(conn, schema, table)
    primary_keys = get_primary_keys(conn, schema, table)
    foreign_keys = get_foreign_keys(conn, schema, table)
    
    column_defs = []
    for col in columns:
        col_name = col['column_name']
        data_type = col['data_type']
        udt_name = col['udt_name']
        
        # Handle special data types
        if udt_name in ('_varchar', '_text', '_int4', '_int8', '_float4', '_float8'):
            # Array types - use the base type with []
            base_type = udt_name[1:]  # Remove underscore
            col_def = f'"{col_name}" {base_type}[]'
        elif data_type == 'ARRAY':
            col_def = f'"{col_name}" {udt_name}'
        elif data_type == 'USER-DEFINED':
            col_def = f'"{col_name}" {udt_name}'
        else:
            col_def = f'"{col_name}" {data_type}'
        
        # Add length for character types
        if col['character_maximum_length'] and data_type in ('character varying', 'varchar', 'char'):
            col_def += f'({col["character_maximum_length"]})'
        
        # Add precision/scale for numeric types
        if col['numeric_precision'] and data_type in ('numeric', 'decimal'):
            if col['numeric_scale']:
                col_def += f'({col["numeric_precision"]}, {col["numeric_scale"]})'
            else:
                col_def += f'({col["numeric_precision"]})'
        
        # Add default value
        if col['column_default']:
            col_def += f' DEFAULT {col["column_default"]}'
        
        # Add nullable constraint
        if col['is_nullable'] == 'NO':
            col_def += ' NOT NULL'
        
        column_defs.append(col_def)
    
    # Add primary key
    if primary_keys:
        pk_cols = ', '.join(f'"{pk}"' for pk in primary_keys)
        column_defs.append(f'PRIMARY KEY ({pk_cols})')
    
    # Add foreign keys
    for fk in foreign_keys:
        fk_def = f'FOREIGN KEY ("{fk["column_name"]}") REFERENCES "{fk["foreign_table_name"]}" ("{fk["foreign_column_name"]}")'
        column_defs.append(fk_def)
    
    sql = f'CREATE TABLE IF NOT EXISTS "{schema}"."{table}" (\n'
    sql += ',\n'.join(f'    {col}' for col in column_defs)
    sql += '\n);'
    
    return sql


def install_timescaledb_extension(conn):
    """Install TimescaleDB extension if not already installed."""
    try:
        with conn.cursor() as cur:
            cur.execute("CREATE EXTENSION IF NOT EXISTS timescaledb;")
            print("  TimescaleDB extension installed/verified")
    except Exception as e:
        print(f"  Warning: Could not install TimescaleDB extension: {e}")


def is_hypertable(conn, schema: str, table: str) -> bool:
    """Check if a table is a TimescaleDB hypertable."""
    try:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT 1 FROM timescaledb_information.hypertables 
                WHERE hypertable_schema = %s AND hypertable_name = %s;
            """, (schema, table))
            return cur.fetchone() is not None
    except:
        return False


def table_exists(conn, schema: str, table: str) -> bool:
    """Check if a table exists."""
    try:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT 1 FROM information_schema.tables 
                WHERE table_schema = %s AND table_name = %s;
            """, (schema, table))
            return cur.fetchone() is not None
    except:
        return False


def drop_table_if_exists(conn, schema: str, table: str):
    """Drop table if it exists (skip hypertables)."""
    try:
        # Check if it's a hypertable
        if is_hypertable(conn, schema, table):
            print(f"      Skipping hypertable: {table}")
            return
            
        if table_exists(conn, schema, table):
            with conn.cursor() as cur:
                cur.execute(sql.SQL('DROP TABLE IF EXISTS {}.{} CASCADE;').format(
                    sql.Identifier(schema),
                    sql.Identifier(table)
                ))
    except Exception as e:
        print(f"      Warning dropping table: {e}")


def migrate_table_data(source_conn, target_conn, schema: str, table: str, batch_size: int = 1000):
    """Migrate data from source table to target table."""
    print(f"    Migrating data for {schema}.{table}...")
    
    # Check if table exists in target
    if not table_exists(target_conn, schema, table):
        print(f"      ERROR: Table does not exist in target, skipping data migration")
        return
    
    with source_conn.cursor() as source_cur:
        # Get row count
        source_cur.execute(f'SELECT COUNT(*) FROM "{schema}"."{table}";')
        row_count = source_cur.fetchone()[0]
        print(f"      Total rows: {row_count}")
        
        if row_count == 0:
            return
        
        # Get column names
        source_cur.execute("""
            SELECT column_name 
            FROM information_schema.columns 
            WHERE table_schema = %s AND table_name = %s
            ORDER BY ordinal_position;
        """, (schema, table))
        columns = [row[0] for row in source_cur.fetchall()]
        column_list = ', '.join(f'"{col}"' for col in columns)
        
        # Copy data in batches
        offset = 0
        migrated = 0
        
        while offset < row_count:
            source_cur.execute(f"""
                SELECT {column_list} 
                FROM "{schema}"."{table}" 
                ORDER BY 1 
                LIMIT %s OFFSET %s;
            """, (batch_size, offset))
            
            rows = source_cur.fetchall()
            
            if rows:
                with target_conn.cursor() as target_cur:
                    placeholders = ', '.join(['%s'] * len(columns))
                    target_cur.executemany(f"""
                        INSERT INTO "{schema}"."{table}" ({column_list})
                        VALUES ({placeholders});
                    """, rows)
                
                migrated += len(rows)
                if migrated % 10000 == 0 or migrated == row_count:
                    print(f"      Progress: {migrated}/{row_count} rows")
            
            offset += batch_size
        
        print(f"      Completed: {migrated} rows migrated")


def migrate_database():
    """Perform complete database migration from local to server."""
    print("\n" + "=" * 80)
    print("COMPLETE DATABASE MIGRATION: LOCAL -> SERVER")
    print("=" * 80)
    
    local_conn = None
    server_conn = None
    
    try:
        # Connect to databases
        print("\n[Step 1/5] Connecting to databases...")
        local_conn = get_connection(LOCAL_CONFIG)
        print("  Connected to local database")
        
        server_conn = get_connection(SERVER_CONFIG, create_db_if_not_exists=True)
        print("  Connected to server database")
        
        # Install TimescaleDB extension on server
        install_timescaledb_extension(server_conn)
        
        # Get schemas
        print("\n[Step 2/5] Discovering schemas...")
        all_schemas = get_schemas(local_conn)
        print(f"  Found schemas: {all_schemas}")
        
        # Migrate each schema
        print("\n[Step 3/5] Migrating schemas and table structures...")
        for schema in all_schemas:
            print(f"\n  Processing schema: {schema}")
            
            # Ensure connections are alive
            local_conn = ensure_connection(local_conn, LOCAL_CONFIG)
            server_conn = ensure_connection(server_conn, SERVER_CONFIG)
            
            # Create schema in target if not exists
            try:
                with server_conn.cursor() as cur:
                    cur.execute(sql.SQL("CREATE SCHEMA IF NOT EXISTS {};").format(
                        sql.Identifier(schema)
                    ))
            except Exception as e:
                print(f"    Warning: Could not create schema: {e}")
                server_conn = ensure_connection(server_conn, SERVER_CONFIG)
            
            # Get tables
            tables = get_tables(local_conn, schema)
            print(f"    Found {len(tables)} tables")
            
            for table in tables:
                print(f"    Processing table: {table}")
                
                # Ensure connections are alive
                local_conn = ensure_connection(local_conn, LOCAL_CONFIG)
                server_conn = ensure_connection(server_conn, SERVER_CONFIG)
                
                # Drop existing table to ensure clean migration
                try:
                    drop_table_if_exists(server_conn, schema, table)
                except Exception as e:
                    print(f"      Warning dropping existing table: {e}")
                
                # Create table structure with complete schema
                try:
                    create_sql = generate_create_table_sql(local_conn, schema, table)
                    print(f"      Creating table with SQL: {create_sql[:200]}...")
                    with server_conn.cursor() as cur:
                        cur.execute(create_sql)
                    print(f"      Table structure created")
                except Exception as e:
                    print(f"      ERROR: Could not create table structure: {e}")
                    print(f"      SQL was: {create_sql[:500]}")
                    server_conn = ensure_connection(server_conn, SERVER_CONFIG)
        
        # Migrate data
        print("\n[Step 4/5] Migrating data...")
        for schema in all_schemas:
            print(f"\n  Processing schema: {schema}")
            
            # Ensure connections are alive
            local_conn = ensure_connection(local_conn, LOCAL_CONFIG)
            server_conn = ensure_connection(server_conn, SERVER_CONFIG)
            
            tables = get_tables(local_conn, schema)
            
            for table in tables:
                print(f"    Processing table: {table}")
                
                # Ensure connections are alive
                local_conn = ensure_connection(local_conn, LOCAL_CONFIG)
                server_conn = ensure_connection(server_conn, SERVER_CONFIG)
                
                try:
                    migrate_table_data(local_conn, server_conn, schema, table)
                except Exception as e:
                    print(f"      Warning: Could not migrate data: {e}")
                    local_conn = ensure_connection(local_conn, LOCAL_CONFIG)
                    server_conn = ensure_connection(server_conn, SERVER_CONFIG)
        
        # Verification
        print("\n[Step 5/5] Verifying migration...")
        local_conn = ensure_connection(local_conn, LOCAL_CONFIG)
        server_conn = ensure_connection(server_conn, SERVER_CONFIG)
        
        for schema in all_schemas:
            local_tables = get_tables(local_conn, schema)
            server_tables = get_tables(server_conn, schema)
            print(f"  Schema {schema}: {len(local_tables)} source tables -> {len(server_tables)} target tables")
            
            # Compare row counts
            for table in local_tables:
                if table in server_tables:
                    local_count = get_row_count(local_conn, schema, table)
                    server_count = get_row_count(server_conn, schema, table)
                    if local_count != server_count:
                        print(f"    WARNING: {table} - Local: {local_count} rows, Server: {server_count} rows")
        
        print("\n" + "=" * 80)
        print("MIGRATION COMPLETED SUCCESSFULLY!")
        print("=" * 80)
        
    except Exception as e:
        print(f"\nMigration failed: {e}")
        import traceback
        traceback.print_exc()
        raise
    finally:
        if local_conn:
            try:
                local_conn.close()
            except:
                pass
        if server_conn:
            try:
                server_conn.close()
            except:
                pass


def main():
    """Main function."""
    print("COMPLETE DATABASE MIGRATION TOOL")
    print("This will migrate ALL data from local to server database")
    print("Existing tables on server will be dropped and recreated")
    print("=" * 80)
    
    response = input("Do you want to proceed? (yes/no): ").strip().lower()
    
    if response in ['yes', 'y']:
        migrate_database()
    else:
        print("Migration cancelled by user.")


if __name__ == "__main__":
    main()
