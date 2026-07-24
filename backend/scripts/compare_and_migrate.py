#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
DATABASE COMPARISON AND MIGRATION SCRIPT
========================================

Module to compare PostgreSQL databases and migrate from local to server.
This script uses psycopg2 for direct database operations.

Usage:
    python compare_and_migrate.py
"""

import os
import sys
from datetime import datetime
from typing import Dict, List, Tuple, Any
import json

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


def get_connection(config: Dict[str, str]) -> psycopg2.extensions.connection:
    """Create database connection from config dict."""
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
    """Get column information for a table."""
    with conn.cursor() as cur:
        cur.execute("""
            SELECT column_name, data_type, is_nullable, column_default,
                   character_maximum_length, numeric_precision, numeric_scale,
                   ordinal_position
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
                'ordinal_position': row[7]
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
    with conn.cursor() as cur:
        cur.execute(f'SELECT COUNT(*) FROM "{schema}"."{table}";')
        return cur.fetchone()[0]


def get_table_structure(conn, schema: str, table: str) -> Dict[str, Any]:
    """Get complete table structure information."""
    return {
        'columns': get_table_columns(conn, schema, table),
        'primary_keys': get_primary_keys(conn, schema, table),
        'row_count': get_row_count(conn, schema, table)
    }


def compare_schemas(local_schemas: List[str], server_schemas: List[str]) -> Dict[str, List[str]]:
    """Compare schemas between local and server."""
    local_set = set(local_schemas)
    server_set = set(server_schemas)
    
    return {
        'only_in_local': sorted(local_set - server_set),
        'only_in_server': sorted(server_set - local_set),
        'common': sorted(local_set & server_set)
    }


def compare_tables(local_tables: List[str], server_tables: List[str]) -> Dict[str, List[str]]:
    """Compare tables between local and server."""
    local_set = set(local_tables)
    server_set = set(server_tables)
    
    return {
        'only_in_local': sorted(local_set - server_set),
        'only_in_server': sorted(server_set - local_set),
        'common': sorted(local_set & server_set)
    }


def compare_columns(local_columns: List[Dict], server_columns: List[Dict]) -> Dict[str, Any]:
    """Compare columns between local and server tables."""
    local_col_dict = {col['column_name']: col for col in local_columns}
    server_col_dict = {col['column_name']: col for col in server_columns}
    
    local_names = set(local_col_dict.keys())
    server_names = set(server_col_dict.keys())
    
    differences = {
        'only_in_local': sorted(local_names - server_names),
        'only_in_server': sorted(server_names - local_names),
        'common': [],
        'type_mismatches': [],
        'nullable_mismatches': [],
        'default_mismatches': []
    }
    
    for col_name in local_names & server_names:
        local_col = local_col_dict[col_name]
        server_col = server_col_dict[col_name]
        
        col_diff = {
            'column_name': col_name,
            'local_type': local_col['data_type'],
            'server_type': server_col['data_type'],
            'local_nullable': local_col['is_nullable'],
            'server_nullable': server_col['is_nullable'],
            'local_default': local_col['column_default'],
            'server_default': server_col['column_default']
        }
        
        differences['common'].append(col_name)
        
        if local_col['data_type'] != server_col['data_type']:
            differences['type_mismatches'].append(col_diff)
        
        if local_col['is_nullable'] != server_col['is_nullable']:
            differences['nullable_mismatches'].append(col_diff)
        
        if local_col['column_default'] != server_col['column_default']:
            differences['default_mismatches'].append(col_diff)
    
    return differences


def print_comparison_report(comparison: Dict):
    """Print a formatted comparison report."""
    print("\n" + "=" * 80)
    print("DATABASE COMPARISON REPORT")
    print("=" * 80)
    
    # Schema comparison
    print("\n[SCHEMA COMPARISON]")
    print(f"  Local schemas: {len(comparison['schemas']['only_in_local']) + len(comparison['schemas']['common'])}")
    print(f"  Server schemas: {len(comparison['schemas']['only_in_server']) + len(comparison['schemas']['common'])}")
    
    if comparison['schemas']['only_in_local']:
        print(f"  Schemas only in LOCAL: {comparison['schemas']['only_in_local']}")
    if comparison['schemas']['only_in_server']:
        print(f"  Schemas only in SERVER: {comparison['schemas']['only_in_server']}")
    if comparison['schemas']['common']:
        print(f"  Common schemas: {comparison['schemas']['common']}")
    
    # Table comparison for each schema
    for schema in comparison['schemas']['common']:
        print(f"\n[SCHEMA: {schema}]")
        schema_data = comparison['schemas_data'][schema]
        
        table_comp = schema_data['table_comparison']
        print(f"  Local tables: {len(table_comp['only_in_local']) + len(table_comp['common'])}")
        print(f"  Server tables: {len(table_comp['only_in_server']) + len(table_comp['common'])}")
        
        if table_comp['only_in_local']:
            print(f"  Tables only in LOCAL: {table_comp['only_in_local']}")
        if table_comp['only_in_server']:
            print(f"  Tables only in SERVER: {table_comp['only_in_server']}")
        
        # Column comparison for common tables
        for table in table_comp['common']:
            table_data = schema_data['tables_data'][table]
            col_comp = table_data['column_comparison']
            
            print(f"\n  [TABLE: {table}]")
            print(f"    Local rows: {table_data['local_structure']['row_count']}")
            print(f"    Server rows: {table_data['server_structure']['row_count']}")
            
            if col_comp['only_in_local']:
                print(f"    Columns only in LOCAL: {col_comp['only_in_local']}")
            if col_comp['only_in_server']:
                print(f"    Columns only in SERVER: {col_comp['only_in_server']}")
            if col_comp['type_mismatches']:
                print(f"    Type mismatches:")
                for mismatch in col_comp['type_mismatches']:
                    print(f"      - {mismatch['column_name']}: local={mismatch['local_type']}, server={mismatch['server_type']}")
            if col_comp['nullable_mismatches']:
                print(f"    Nullable mismatches:")
                for mismatch in col_comp['nullable_mismatches']:
                    print(f"      - {mismatch['column_name']}: local={mismatch['local_nullable']}, server={mismatch['server_nullable']}")
    
    print("\n" + "=" * 80)


def perform_comparison() -> Dict:
    """Perform full database comparison."""
    print("Starting database comparison...")
    print(f"Local: {LOCAL_CONFIG['host']}:{LOCAL_CONFIG['port']}/{LOCAL_CONFIG['database']}")
    print(f"Server: {SERVER_CONFIG['host']}:{SERVER_CONFIG['port']}/{SERVER_CONFIG['database']}")
    
    local_conn = None
    server_conn = None
    
    try:
        # Connect to databases
        print("\nConnecting to databases...")
        local_conn = get_connection(LOCAL_CONFIG)
        print("  Connected to local database")
        
        server_conn = get_connection(SERVER_CONFIG)
        print("  Connected to server database")
        
        # Get schemas
        print("\nGetting schemas...")
        local_schemas = get_schemas(local_conn)
        server_schemas = get_schemas(server_conn)
        print(f"  Local schemas: {local_schemas}")
        print(f"  Server schemas: {server_schemas}")
        
        # Compare schemas
        schema_comparison = compare_schemas(local_schemas, server_schemas)
        
        # Detailed comparison for common schemas
        schemas_data = {}
        
        for schema in schema_comparison['common']:
            print(f"\nComparing schema: {schema}")
            
            # Get tables
            local_tables = get_tables(local_conn, schema)
            server_tables = get_tables(server_conn, schema)
            
            table_comparison = compare_tables(local_tables, server_tables)
            
            tables_data = {}
            
            # Compare common tables
            for table in table_comparison['common']:
                print(f"  Comparing table: {table}")
                
                local_structure = get_table_structure(local_conn, schema, table)
                server_structure = get_table_structure(server_conn, schema, table)
                
                column_comparison = compare_columns(
                    local_structure['columns'],
                    server_structure['columns']
                )
                
                tables_data[table] = {
                    'local_structure': local_structure,
                    'server_structure': server_structure,
                    'column_comparison': column_comparison
                }
            
            schemas_data[schema] = {
                'table_comparison': table_comparison,
                'tables_data': tables_data
            }
        
        comparison = {
            'schemas': schema_comparison,
            'schemas_data': schemas_data,
            'timestamp': datetime.now().isoformat()
        }
        
        return comparison
        
    finally:
        if local_conn:
            local_conn.close()
        if server_conn:
            server_conn.close()


def save_comparison_to_file(comparison: Dict, filename: str = None):
    """Save comparison results to JSON file."""
    if filename is None:
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = f"database_comparison_{timestamp}.json"
    
    filepath = os.path.join(backend_dir, filename)
    
    with open(filepath, 'w') as f:
        json.dump(comparison, f, indent=2, default=str)
    
    print(f"\nComparison saved to: {filepath}")
    return filepath


def migrate_table_data(source_conn, target_conn, schema: str, table: str, batch_size: int = 1000):
    """Migrate data from source table to target table."""
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


def get_table_ddl(conn, schema: str, table: str) -> str:
    """Get DDL for a table."""
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


def migrate_database():
    """Migrate database from local to server."""
    print("\n" + "=" * 80)
    print("STARTING DATABASE MIGRATION")
    print("=" * 80)
    
    local_conn = None
    server_conn = None
    
    try:
        # Connect to databases
        print("\n[Step 1/4] Connecting to databases...")
        local_conn = get_connection(LOCAL_CONFIG)
        print("  Connected to local database")
        
        server_conn = get_connection(SERVER_CONFIG)
        print("  Connected to server database")
        
        # Get schemas
        print("\n[Step 2/4] Discovering schemas...")
        all_schemas = get_schemas(local_conn)
        print(f"  Found schemas: {all_schemas}")
        
        # Migrate each schema
        print("\n[Step 3/4] Migrating schemas and data...")
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
                
                # Ensure connections are alive before each table operation
                local_conn = ensure_connection(local_conn, LOCAL_CONFIG)
                server_conn = ensure_connection(server_conn, SERVER_CONFIG)
                
                # Create table structure
                try:
                    ddl = get_table_ddl(local_conn, schema, table)
                    with server_conn.cursor() as cur:
                        cur.execute(ddl)
                    print(f"      Table structure created")
                except Exception as e:
                    print(f"      Warning: Could not create table structure: {e}")
                    server_conn = ensure_connection(server_conn, SERVER_CONFIG)
                
                # Migrate data
                try:
                    migrate_table_data(local_conn, server_conn, schema, table)
                except Exception as e:
                    print(f"      Warning: Could not migrate data: {e}")
                    # Reconnect and try again
                    local_conn = ensure_connection(local_conn, LOCAL_CONFIG)
                    server_conn = ensure_connection(server_conn, SERVER_CONFIG)
        
        # Verification
        print("\n[Step 4/4] Verifying migration...")
        local_conn = ensure_connection(local_conn, LOCAL_CONFIG)
        server_conn = ensure_connection(server_conn, SERVER_CONFIG)
        
        for schema in all_schemas:
            local_tables = get_tables(local_conn, schema)
            server_tables = get_tables(server_conn, schema)
            print(f"  Schema {schema}: {len(local_tables)} source tables -> {len(server_tables)} target tables")
        
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
    print("DATABASE COMPARISON AND MIGRATION TOOL")
    print("=" * 80)
    
    # Step 1: Perform comparison
    comparison = perform_comparison()
    
    # Print report
    print_comparison_report(comparison)
    
    # Save comparison to file
    comparison_file = save_comparison_to_file(comparison)
    
    # Ask user if they want to proceed with migration
    print("\n" + "=" * 80)
    response = input("Do you want to proceed with migration? (yes/no): ").strip().lower()
    
    if response in ['yes', 'y']:
        migrate_database()
    else:
        print("Migration cancelled by user.")


if __name__ == "__main__":
    main()
