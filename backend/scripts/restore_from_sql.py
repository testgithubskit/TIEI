#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
RESTORE DATABASE FROM SQL FILE
===============================

This script restores a database from a SQL file to the server.
It reads the SQL file and executes the statements using psycopg2.

Usage:
    python restore_from_sql.py <sql_file_path>
"""

import os
import sys
from datetime import datetime

# Add backend directory to Python path
backend_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, backend_dir)

try:
    import psycopg2
    from psycopg2 import sql
except ImportError:
    print("Error: psycopg2 not installed. Install it with: pip install psycopg2-binary")
    sys.exit(1)


SERVER_CONFIG = {
    "host": "172.18.7.91",
    "port": "5432",
    "user": "postgres",
    "password": "postgres",
    "database": "Toyota_Demo"
}


def get_connection(config: dict, create_db_if_not_exists: bool = False, clean_database: bool = False):
    """Create database connection."""
    if create_db_if_not_exists or clean_database:
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
            admin_conn.set_isolation_level(0)
            
            with admin_conn.cursor() as cur:
                if clean_database:
                    # Drop existing database
                    cur.execute("SELECT 1 FROM pg_database WHERE datname = %s", (config['database'],))
                    if cur.fetchone():
                        print(f"Dropping existing database: {config['database']}")
                        cur.execute(f"DROP DATABASE {config['database']};")
                        print("Database dropped")
                
                # Create database
                cur.execute("SELECT 1 FROM pg_database WHERE datname = %s", (config['database'],))
                if not cur.fetchone():
                    cur.execute(sql.SQL("CREATE DATABASE {};").format(
                        sql.Identifier(config['database'])
                    ))
                    print(f"Created database: {config['database']}")
            
            admin_conn.close()
        except Exception as e:
            print(f"Warning: Could not manage database: {e}")
    
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


def execute_sql_file(sql_file_path: str):
    """Execute SQL file against server database."""
    print("=" * 80)
    print("RESTORING DATABASE FROM SQL FILE")
    print("=" * 80)
    
    conn = None
    
    try:
        # Connect to server (clean database first to fix TimescaleDB issues)
        print("\nConnecting to server database...")
        print("Note: Dropping and recreating database to fix TimescaleDB extension issues")
        conn = get_connection(SERVER_CONFIG, create_db_if_not_exists=True, clean_database=True)
        print("Connected")
        
        # Read SQL file
        print(f"\nReading SQL file: {sql_file_path}")
        with open(sql_file_path, 'r', encoding='utf-8') as f:
            sql_content = f.read()
        
        print(f"File size: {len(sql_content)} characters")
        
        # Split into individual statements
        print("\nParsing SQL statements...")
        statements = []
        current_statement = []
        
        for line in sql_content.split('\n'):
            line = line.strip()
            
            # Skip comments and empty lines
            if not line or line.startswith('--'):
                continue
            
            current_statement.append(line)
            
            # Check if statement ends with semicolon
            if line.endswith(';'):
                statement = ' '.join(current_statement)
                statements.append(statement)
                current_statement = []
        
        print(f"Found {len(statements)} SQL statements")
        
        # Execute statements
        print("\nExecuting statements...")
        executed = 0
        errors = 0
        
        for i, statement in enumerate(statements, 1):
            try:
                with conn.cursor() as cur:
                    cur.execute(statement)
                
                executed += 1
                if executed % 100 == 0 or i == len(statements):
                    print(f"  Progress: {executed}/{len(statements)} statements executed")
                    
            except Exception as e:
                errors += 1
                if errors <= 10:  # Show first 10 errors
                    print(f"  ERROR at statement {i}: {e}")
                    print(f"  Statement: {statement[:100]}...")
        
        print(f"\n" + "=" * 80)
        print(f"RESTORE COMPLETED")
        print(f"  Executed: {executed} statements")
        print(f"  Errors: {errors}")
        print("=" * 80)
        
    except Exception as e:
        print(f"\nRestore failed: {e}")
        import traceback
        traceback.print_exc()
        raise
    finally:
        if conn:
            conn.close()


def main():
    """Main function."""
    if len(sys.argv) < 2:
        print("Usage: python restore_from_sql.py <sql_file_path>")
        print("\nAvailable SQL files in backend directory:")
        backend_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        for f in os.listdir(backend_dir):
            if f.endswith('.sql'):
                print(f"  {f}")
        sys.exit(1)
    
    sql_file_path = sys.argv[1]
    
    if not os.path.exists(sql_file_path):
        print(f"Error: SQL file not found: {sql_file_path}")
        sys.exit(1)
    
    print("DATABASE RESTORE TOOL")
    print(f"This will restore the SQL file to server: {SERVER_CONFIG['host']}")
    print("=" * 80)
    
    response = input("Do you want to proceed? (yes/no): ").strip().lower()
    
    if response in ['yes', 'y']:
        execute_sql_file(sql_file_path)
    else:
        print("Restore cancelled by user.")


if __name__ == "__main__":
    main()
