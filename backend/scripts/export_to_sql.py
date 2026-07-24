#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
EXPORT LOCAL DATABASE TO SQL FILE
==================================

This script exports the local PostgreSQL database to a plain SQL file
that can be manually restored to the server.

Usage:
    python export_to_sql.py
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
except ImportError:
    print("Error: psycopg2 not installed. Install it with: pip install psycopg2-binary")
    sys.exit(1)


LOCAL_CONFIG = {
    "host": "localhost",
    "port": "5432",
    "user": "postgres",
    "password": "1234",
    "database": "Toyota_Demo"
}


def get_connection(config: Dict[str, str]) -> psycopg2.extensions.connection:
    """Create database connection."""
    conn = psycopg2.connect(
        host=config['host'],
        port=config['port'],
        user=config['user'],
        password=config['password'],
        database=config['database'],
        connect_timeout=30
    )
    conn.set_isolation_level(0)  # AUTOCOMMIT
    return conn


def get_schemas(conn) -> List[str]:
    """Get list of schemas."""
    with conn.cursor() as cur:
        cur.execute("""
            SELECT schema_name 
            FROM information_schema.schemata 
            WHERE schema_name NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
            ORDER BY schema_name;
        """)
        return [row[0] for row in cur.fetchall()]


def get_tables(conn, schema: str) -> List[str]:
    """Get list of tables."""
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
    """Get column information."""
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
    """Get primary key columns."""
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


def export_table_data(conn, schema: str, table: str, output_file) -> int:
    """Export table data to INSERT statements."""
    with conn.cursor() as cur:
        # Get row count
        cur.execute(f'SELECT COUNT(*) FROM "{schema}"."{table}";')
        row_count = cur.fetchone()[0]
        
        if row_count == 0:
            return 0
        
        # Get column names
        cur.execute("""
            SELECT column_name 
            FROM information_schema.columns 
            WHERE table_schema = %s AND table_name = %s
            ORDER BY ordinal_position;
        """, (schema, table))
        columns = [row[0] for row in cur.fetchall()]
        column_list = ', '.join(f'"{col}"' for col in columns)
        
        # Export data in batches
        batch_size = 1000
        offset = 0
        exported = 0
        
        while offset < row_count:
            cur.execute(f"""
                SELECT {column_list} 
                FROM "{schema}"."{table}" 
                ORDER BY 1 
                LIMIT %s OFFSET %s;
            """, (batch_size, offset))
            
            rows = cur.fetchall()
            
            if rows:
                for row in rows:
                    # Escape values
                    values = []
                    for val in row:
                        if val is None:
                            values.append('NULL')
                        elif isinstance(val, str):
                            # Escape single quotes
                            escaped = val.replace("'", "''")
                            values.append(f"'{escaped}'")
                        elif isinstance(val, (int, float)):
                            values.append(str(val))
                        elif isinstance(val, bool):
                            values.append('TRUE' if val else 'FALSE')
                        else:
                            # Convert to string and escape
                            str_val = str(val).replace("'", "''")
                            values.append(f"'{str_val}'")
                    
                    insert_sql = f'INSERT INTO "{schema}"."{table}" ({column_list}) VALUES ({", ".join(values)});\n'
                    output_file.write(insert_sql)
                
                exported += len(rows)
                if exported % 10000 == 0:
                    print(f"      Exported {exported}/{row_count} rows")
            
            offset += batch_size
        
        return exported


def generate_create_table_sql(conn, schema: str, table: str) -> str:
    """Generate CREATE TABLE SQL."""
    columns = get_table_columns(conn, schema, table)
    primary_keys = get_primary_keys(conn, schema, table)
    
    column_defs = []
    for col in columns:
        col_name = col['column_name']
        data_type = col['data_type']
        udt_name = col['udt_name']
        
        # Handle special data types
        if udt_name in ('_varchar', '_text', '_int4', '_int8', '_float4', '_float8'):
            base_type = udt_name[1:]
            col_def = f'"{col_name}" {base_type}[]'
        elif data_type == 'ARRAY':
            col_def = f'"{col_name}" {udt_name}'
        elif data_type == 'USER-DEFINED':
            col_def = f'"{col_name}" TEXT'
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
    sql += '\n);\n\n'
    
    return sql


def export_database():
    """Export entire database to SQL file."""
    print("=" * 80)
    print("EXPORTING LOCAL DATABASE TO SQL FILE")
    print("=" * 80)
    
    conn = None
    output_file = None
    
    try:
        # Connect to local database
        print("\nConnecting to local database...")
        conn = get_connection(LOCAL_CONFIG)
        print("Connected")
        
        # Create output file
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        output_path = os.path.join(backend_dir, f"toyota_export_{timestamp}.sql")
        output_file = open(output_path, 'w', encoding='utf-8')
        
        # Write header
        output_file.write("-- Toyota Database Export\n")
        output_file.write(f"-- Generated: {datetime.now().isoformat()}\n")
        output_file.write(f"-- Source: {LOCAL_CONFIG['host']}:{LOCAL_CONFIG['port']}/{LOCAL_CONFIG['database']}\n\n")
        
        # Get schemas
        print("\nGetting schemas...")
        schemas = get_schemas(conn)
        print(f"Found schemas: {schemas}")
        
        # Export each schema
        for schema in schemas:
            print(f"\nProcessing schema: {schema}")
            
            # Skip TimescaleDB internal schemas
            if schema.startswith('_timescaledb'):
                print(f"  Skipping TimescaleDB internal schema")
                continue
            
            # Write schema creation
            output_file.write(f"-- Schema: {schema}\n")
            output_file.write(f"CREATE SCHEMA IF NOT EXISTS \"{schema}\";\n\n")
            
            # Get tables
            tables = get_tables(conn, schema)
            print(f"  Found {len(tables)} tables")
            
            # Skip TimescaleDB chunk tables
            tables_to_export = [t for t in tables if not t.startswith('_hyper_') and 'chunk' not in t.lower()]
            print(f"  Exporting {len(tables_to_export)} tables (skipping TimescaleDB chunks)")
            
            for table in tables_to_export:
                print(f"  Processing table: {table}")
                
                # Write CREATE TABLE
                create_sql = generate_create_table_sql(conn, schema, table)
                output_file.write(create_sql)
                
                # Export data
                print(f"    Exporting data...")
                row_count = export_table_data(conn, schema, table, output_file)
                print(f"    Exported {row_count} rows")
                output_file.write("\n")
        
        output_file.close()
        
        print("\n" + "=" * 80)
        print(f"EXPORT COMPLETED: {output_path}")
        print("=" * 80)
        print(f"\nTo restore to server, run:")
        print(f"psql -h 172.18.7.91 -p 5432 -U postgres -d Toyota_Demo -f {output_path}")
        
    except Exception as e:
        print(f"\nExport failed: {e}")
        import traceback
        traceback.print_exc()
        if output_file:
            output_file.close()
        raise
    finally:
        if conn:
            conn.close()


def main():
    """Main function."""
    print("DATABASE EXPORT TOOL")
    print("This will export the local database to a SQL file")
    print("=" * 80)
    
    response = input("Do you want to proceed? (yes/no): ").strip().lower()
    
    if response in ['yes', 'y']:
        export_database()
    else:
        print("Export cancelled by user.")


if __name__ == "__main__":
    main()
