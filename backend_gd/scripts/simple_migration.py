#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
SIMPLE DATABASE MIGRATION (USER DATA ONLY)
==========================================

This script migrates only the user data schema (tiei_sample_4) from local to server.
It handles TimescaleDB issues by skipping hypertable creation and focusing on data migration.

Usage:
    python simple_migration.py
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
                cur.execute("SELECT 1 FROM pg_database WHERE datname = %s", (config['database'],))
                if not cur.fetchone():
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


def get_row_count(conn, schema: str, table: str) -> int:
    """Get row count for a table."""
    try:
        with conn.cursor() as cur:
            cur.execute(f'SELECT COUNT(*) FROM "{schema}"."{table}";')
            return cur.fetchone()[0]
    except:
        return 0


def generate_simple_create_table_sql(conn, schema: str, table: str) -> str:
    """Generate simple CREATE TABLE SQL statement (no foreign keys, no complex types)."""
    columns = get_table_columns(conn, schema, table)
    primary_keys = get_primary_keys(conn, schema, table)
    
    column_defs = []
    for col in columns:
        col_name = col['column_name']
        data_type = col['data_type']
        udt_name = col['udt_name']
        
        # Handle special data types - simplify for compatibility
        if udt_name in ('_varchar', '_text', '_int4', '_int8', '_float4', '_float8'):
            base_type = udt_name[1:]
            col_def = f'"{col_name}" {base_type}[]'
        elif data_type == 'ARRAY':
            col_def = f'"{col_name}" {udt_name}'
        elif data_type == 'USER-DEFINED':
            col_def = f'"{col_name}" TEXT'  # Fallback to TEXT for user-defined types
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
        
        # Add default value (simplified)
        if col['column_default'] and not col['column_default'].startswith('nextval'):
            col_def += f' DEFAULT {col["column_default"]}'
        
        # Add nullable constraint
        if col['is_nullable'] == 'NO':
            col_def += ' NOT NULL'
        
        column_defs.append(col_def)
    
    # Add primary key
    if primary_keys:
        pk_cols = ', '.join(f'"{pk}"' for pk in primary_keys)
        column_defs.append(f'PRIMARY KEY ({pk_cols})')
    
    sql = f'CREATE TABLE IF NOT EXISTS "{schema}"."{table}" (\n'
    sql += ',\n'.join(f'    {col}' for col in column_defs)
    sql += '\n);'
    
    return sql


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


def migrate_table_data(source_conn, target_conn, schema: str, table: str, batch_size: int = 1000):
    """Migrate data from source table to target table."""
    print(f"    Migrating data for {schema}.{table}...")
    
    if not table_exists(target_conn, schema, table):
        print(f"      ERROR: Table does not exist in target, skipping data migration")
        return
    
    with source_conn.cursor() as source_cur:
        try:
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
                            VALUES ({placeholders})
                            ON CONFLICT DO NOTHING;
                        """, rows)
                    
                    migrated += len(rows)
                    if migrated % 10000 == 0 or migrated == row_count:
                        print(f"      Progress: {migrated}/{row_count} rows")
                
                offset += batch_size
            
            print(f"      Completed: {migrated} rows migrated")
        except Exception as e:
            print(f"      Warning: Could not migrate data: {e}")


def migrate_user_schema():
    """Migrate only the tiei_sample_4 schema (user data)."""
    print("\n" + "=" * 80)
    print("SIMPLE DATABASE MIGRATION: USER DATA ONLY")
    print("=" * 80)
    
    local_conn = None
    server_conn = None
    
    try:
        # Connect to databases
        print("\n[Step 1/4] Connecting to databases...")
        local_conn = get_connection(LOCAL_CONFIG)
        print("  Connected to local database")
        
        server_conn = get_connection(SERVER_CONFIG, create_db_if_not_exists=True)
        print("  Connected to server database")
        
        # Create schema
        print("\n[Step 2/4] Creating schema...")
        try:
            with server_conn.cursor() as cur:
                cur.execute(sql.SQL("CREATE SCHEMA IF NOT EXISTS {};").format(
                    sql.Identifier("tiei_sample_4")
                ))
            print("  Schema tiei_sample_4 created/verified")
        except Exception as e:
            print(f"  Warning creating schema: {e}")
            # Try alternative approach
            try:
                with server_conn.cursor() as cur:
                    cur.execute("CREATE SCHEMA IF NOT EXISTS tiei_sample_4;")
                print("  Schema tiei_sample_4 created/verified (alternative)")
            except Exception as e2:
                print(f"  Error creating schema: {e2}")
        
        # Get tables from local
        print("\n[Step 3/4] Creating tables...")
        tables = get_tables(local_conn, "tiei_sample_4")
        print(f"  Found {len(tables)} tables in tiei_sample_4")
        
        # Skip TimescaleDB internal tables
        skip_tables = ['_hyper_%', 'chunk%', '%_chunk']
        tables_to_migrate = [t for t in tables if not any(t.startswith(s.replace('%', '')) or s.replace('%', '') in t for s in skip_tables)]
        
        print(f"  Migrating {len(tables_to_migrate)} tables (skipping TimescaleDB chunks)")
        
        for table in tables_to_migrate:
            print(f"  Processing table: {table}")
            
            # Ensure connections are alive
            local_conn = ensure_connection(local_conn, LOCAL_CONFIG)
            server_conn = ensure_connection(server_conn, SERVER_CONFIG)
            
            # Drop existing table
            try:
                with server_conn.cursor() as cur:
                    cur.execute(sql.SQL('DROP TABLE IF EXISTS {}.{} CASCADE;').format(
                        sql.Identifier("tiei_sample_4"),
                        sql.Identifier(table)
                    ))
            except Exception as e:
                print(f"    Warning dropping table: {e}")
            
            # Create table structure
            try:
                create_sql = generate_simple_create_table_sql(local_conn, "tiei_sample_4", table)
                with server_conn.cursor() as cur:
                    cur.execute(create_sql)
                print(f"    Table structure created")
            except Exception as e:
                print(f"    ERROR: Could not create table structure: {e}")
                continue
        
        # Migrate data
        print("\n[Step 4/4] Migrating data...")
        for table in tables_to_migrate:
            print(f"  Processing table: {table}")
            
            # Ensure connections are alive
            local_conn = ensure_connection(local_conn, LOCAL_CONFIG)
            server_conn = ensure_connection(server_conn, SERVER_CONFIG)
            
            migrate_table_data(local_conn, server_conn, "tiei_sample_4", table)
        
        # Verification
        print("\n[Verification]")
        local_tables = get_tables(local_conn, "tiei_sample_4")
        server_tables = get_tables(server_conn, "tiei_sample_4")
        print(f"  Local tables: {len(local_tables)}")
        print(f"  Server tables: {len(server_tables)}")
        
        # Compare row counts
        print("\n[Row count comparison]")
        for table in tables_to_migrate:
            local_count = get_row_count(local_conn, "tiei_sample_4", table)
            server_count = get_row_count(server_conn, "tiei_sample_4", table)
            if local_count != server_count:
                print(f"  WARNING: {table} - Local: {local_count}, Server: {server_count}")
            else:
                print(f"  OK: {table} - {local_count} rows")
        
        print("\n" + "=" * 80)
        print("MIGRATION COMPLETED!")
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
    print("SIMPLE DATABASE MIGRATION TOOL")
    print("This will migrate user data (tiei_sample_4 schema) from local to server")
    print("=" * 80)
    
    response = input("Do you want to proceed? (yes/no): ").strip().lower()
    
    if response in ['yes', 'y']:
        migrate_user_schema()
    else:
        print("Migration cancelled by user.")


if __name__ == "__main__":
    main()
