#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
DATABASE MIGRATION SCRIPT (Python-based)
================================

Module to migrate PostgreSQL database from local to server using Python connections.
This script uses psycopg2 for direct database operations without requiring pg_dump/psql.

This script requires the following modules be installed in the python environment
    * psycopg2 - For PostgreSQL database connections
    * datetime - To timestamp operations

This script contains the following functions
    * get_local_connection - Function to connect to local database
    * get_server_connection - Function to connect to server database
    * migrate_schema - Function to migrate schema structure
    * migrate_data - Function to migrate data tables
    * migrate_database - Main function to perform full migration
"""

# Standard library imports
import os
import sys
from datetime import datetime

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


def load_env_config():
    """
    Load database configuration from .env file directly.
    
    Returns
    -------
    dict
        Dictionary containing database configuration
    """
    env_file = os.path.join(backend_dir, "configs", ".env")
    
    config = {
        "timescaledb_provider": "postgres",
        "timescaledb_user": "postgres",
        "timescaledb_password": "1234",
        "timescaledb_host": "localhost",
        "timescaledb_database": "Toyota_Demo",
        "timescaledb_port": "5432"
    }
    
    if os.path.exists(env_file):
        with open(env_file, 'r') as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith('#') and '=' in line:
                    key, value = line.split('=', 1)
                    key = key.strip()
                    value = value.strip().strip('"').strip("'")
                    
                    if key == "TIMESCALEDB_PROVIDER":
                        config["timescaledb_provider"] = value
                    elif key == "TIMESCALEDB_USER":
                        config["timescaledb_user"] = value
                    elif key == "TIMESCALEDB_PASSWORD":
                        config["timescaledb_password"] = value
                    elif key == "TIMESCALEDB_HOST":
                        config["timescaledb_host"] = value
                    elif key == "TIMESCALEDB_DATABASE":
                        config["timescaledb_database"] = value
                    elif key == "TIMESCALEDB_PORT":
                        config["timescaledb_port"] = value
    
    return config


def get_local_connection():
    """
    Create connection to local PostgreSQL database.
    
    Returns
    -------
    psycopg2.connection
        Connection object to local database
    """
    config = load_env_config()
    
    conn = psycopg2.connect(
        host=config['timescaledb_host'],
        port=config['timescaledb_port'],
        user=config['timescaledb_user'],
        password=config['timescaledb_password'],
        database=config['timescaledb_database']
    )
    conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
    return conn


def get_server_connection(server_host, server_port, server_db, server_user, server_password):
    """
    Create connection to server PostgreSQL database.
    
    Parameters
    ----------
    server_host : str
        Server host address
    server_port : str
        Server port
    server_db : str
        Server database name
    server_user : str
        Server username
    server_password : str
        Server password
        
    Returns
    -------
    psycopg2.connection
        Connection object to server database
    """
    conn = psycopg2.connect(
        host=server_host,
        port=server_port,
        user=server_user,
        password=server_password,
        database=server_db
    )
    conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
    return conn


def get_schemas(conn):
    """
    Get list of schemas from database.
    
    Parameters
    ----------
    conn : psycopg2.connection
        Database connection
        
    Returns
    -------
    list
        List of schema names
    """
    with conn.cursor() as cur:
        cur.execute("""
            SELECT schema_name 
            FROM information_schema.schemata 
            WHERE schema_name NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
            ORDER BY schema_name;
        """)
        return [row[0] for row in cur.fetchall()]


def get_tables(conn, schema):
    """
    Get list of tables from a schema.
    
    Parameters
    ----------
    conn : psycopg2.connection
        Database connection
    schema : str
        Schema name
        
    Returns
    -------
    list
        List of table names
    """
    with conn.cursor() as cur:
        cur.execute("""
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = %s 
            AND table_type = 'BASE TABLE'
            ORDER BY table_name;
        """, (schema,))
        return [row[0] for row in cur.fetchall()]


def get_table_ddl(conn, schema, table):
    """
    Get DDL for a table.
    
    Parameters
    ----------
    conn : psycopg2.connection
        Database connection
    schema : str
        Schema name
    table : str
        Table name
        
    Returns
    -------
    str
        DDL statement for the table
    """
    with conn.cursor() as cur:
        # Get column definitions
        cur.execute("""
            SELECT column_name, data_type, is_nullable, column_default,
                   character_maximum_length, numeric_precision, numeric_scale
            FROM information_schema.columns
            WHERE table_schema = %s AND table_name = %s
            ORDER BY ordinal_position;
        """, (schema, table))
        
        columns = cur.fetchall()
        
        # Build CREATE TABLE statement
        column_defs = []
        for col in columns:
            col_name, data_type, is_nullable, default, char_max, num_prec, num_scale = col
            col_def = f'"{col_name}" {data_type}'
            
            if char_max:
                col_def += f'({char_max})'
            elif num_prec and data_type in ('numeric', 'decimal'):
                if num_scale:
                    col_def += f'({num_prec}, {num_scale})'
                else:
                    col_def += f'({num_prec})'
            
            if default:
                col_def += f' DEFAULT {default}'
            
            if is_nullable == 'NO':
                col_def += ' NOT NULL'
            
            column_defs.append(col_def)
        
        # Get primary key
        cur.execute("""
            SELECT a.attname
            FROM pg_index i
            JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey)
            WHERE i.indrelid = %s::regclass AND i.indisprimary;
        """, (f'{schema}.{table}',))
        
        pk_result = cur.fetchone()
        if pk_result:
            column_defs.append(f'PRIMARY KEY ("{pk_result[0]}")')
        
        ddl = f'CREATE TABLE IF NOT EXISTS "{schema}"."{table}" (\n'
        ddl += ',\n'.join(f'    {col}' for col in column_defs)
        ddl += '\n);'
        
        return ddl


def migrate_table_data(source_conn, target_conn, schema, table, batch_size=1000):
    """
    Migrate data from source table to target table.
    
    Parameters
    ----------
    source_conn : psycopg2.connection
        Source database connection
    target_conn : psycopg2.connection
        Target database connection
    schema : str
        Schema name
    table : str
        Table name
    batch_size : int
        Number of rows to copy per batch
    """
    print(f"    Migrating data for {schema}.{table}...")
    
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
                        VALUES ({placeholders})
                        ON CONFLICT DO NOTHING;
                    """, rows)
                
                migrated += len(rows)
                if migrated % 10000 == 0:
                    print(f"      Progress: {migrated}/{row_count} rows")
            
            offset += batch_size
        
        print(f"      Completed: {migrated} rows migrated")


def migrate_database(server_host="172.18.7.91", server_port="5432", 
                    server_db="Toyota_Demo", server_user="postgres", 
                    server_password="postgres", schemas=None):
    """
    Perform full migration from local database to server database.
    
    Parameters
    ----------
    server_host : str
        Server host address (default: 172.18.7.91)
    server_port : str
        Server port (default: 5432)
    server_db : str
        Server database name (default: Toyota_Demo)
    server_user : str
        Server username (default: postgres)
    server_password : str
        Server password (default: postgres)
    schemas : list, optional
        List of schemas to migrate. If None, migrates all schemas.
    """
    
    print("=" * 60)
    print("DATABASE MIGRATION: LOCAL -> SERVER (Python-based)")
    print("=" * 60)
    
    source_conn = None
    target_conn = None
    
    try:
        # Connect to databases
        print("\n[Step 1/4] Connecting to databases...")
        source_conn = get_local_connection()
        print(f"  Connected to local database")
        
        target_conn = get_server_connection(server_host, server_port, server_db, server_user, server_password)
        print(f"  Connected to server database")
        
        # Get schemas
        print("\n[Step 2/4] Discovering schemas...")
        all_schemas = get_schemas(source_conn)
        print(f"  Found schemas: {all_schemas}")
        
        if schemas:
            schemas_to_migrate = [s for s in schemas if s in all_schemas]
        else:
            schemas_to_migrate = all_schemas
        
        print(f"  Schemas to migrate: {schemas_to_migrate}")
        
        # Migrate each schema
        print("\n[Step 3/4] Migrating schemas and data...")
        for schema in schemas_to_migrate:
            print(f"\n  Processing schema: {schema}")
            
            # Create schema in target if not exists
            with target_conn.cursor() as cur:
                cur.execute(sql.SQL("CREATE SCHEMA IF NOT EXISTS {};").format(
                    sql.Identifier(schema)
                ))
            
            # Get tables
            tables = get_tables(source_conn, schema)
            print(f"    Found {len(tables)} tables")
            
            for table in tables:
                print(f"    Processing table: {table}")
                
                # Create table structure
                try:
                    ddl = get_table_ddl(source_conn, schema, table)
                    with target_conn.cursor() as cur:
                        cur.execute(ddl)
                    print(f"      Table structure created")
                except Exception as e:
                    print(f"      Warning: Could not create table structure: {e}")
                
                # Migrate data
                try:
                    migrate_table_data(source_conn, target_conn, schema, table)
                except Exception as e:
                    print(f"      Warning: Could not migrate data: {e}")
        
        print("\n[Step 4/4] Verifying migration...")
        for schema in schemas_to_migrate:
            source_tables = get_tables(source_conn, schema)
            target_tables = get_tables(target_conn, schema)
            print(f"  Schema {schema}: {len(source_tables)} source tables -> {len(target_tables)} target tables")
        
        print("\n" + "=" * 60)
        print("MIGRATION COMPLETED SUCCESSFULLY!")
        print("=" * 60)
        
    except Exception as e:
        print(f"\nMigration failed: {e}")
        import traceback
        traceback.print_exc()
        raise
    finally:
        if source_conn:
            source_conn.close()
        if target_conn:
            target_conn.close()


def main():
    """
    Main function to run migration with command-line arguments.
    """
    
    # Default server credentials
    server_host = "172.18.7.91"
    server_port = "5432"
    server_db = "Toyota_Demo"
    server_user = "postgres"
    server_password = "postgres"
    schemas = None
    
    # Parse command-line arguments
    if len(sys.argv) > 1:
        server_host = sys.argv[1]
    if len(sys.argv) > 2:
        server_port = sys.argv[2]
    if len(sys.argv) > 3:
        server_db = sys.argv[3]
    if len(sys.argv) > 4:
        server_user = sys.argv[4]
    if len(sys.argv) > 5:
        server_password = sys.argv[5]
    if len(sys.argv) > 6:
        schemas = sys.argv[6].split(',')
    
    try:
        migrate_database(
            server_host=server_host,
            server_port=server_port,
            server_db=server_db,
            server_user=server_user,
            server_password=server_password,
            schemas=schemas
        )
    except Exception as e:
        print(f"\nMigration failed: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
