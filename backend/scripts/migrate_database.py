#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
DATABASE MIGRATION SCRIPT
================================

Module to migrate PostgreSQL database from local to server.

This script requires the following modules be installed in the python environment
    * subprocess - To run pg_dump and psql commands
    * datetime - To timestamp the backup files
    * os - For file path operations

This script contains the following functions
    * dump_local_database - Function to dump local database to SQL file
    * restore_to_server - Function to restore SQL file to server database
    * migrate_database - Main function to perform full migration
"""

# Standard library imports
import subprocess
import os
from datetime import datetime
import sys
from pathlib import Path

# Add backend directory to Python path
backend_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, backend_dir)


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


def dump_local_database(output_file=None):
    """
    Dump local PostgreSQL database to SQL file using pg_dump.
    
    Parameters
    ----------
    output_file : str, optional
        Path to output SQL file. If None, generates timestamped filename.
        
    Returns
    -------
    str
        Path to the generated SQL file
    """
    
    setting = load_env_config()
    
    # Generate output filename if not provided
    if output_file is None:
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        output_file = f"database_backup_{timestamp}.sql"
    
    # Get the backend directory to store the backup
    backend_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    output_path = os.path.join(backend_dir, output_file)
    
    # Build pg_dump command
    pg_dump_cmd = [
        "pg_dump",
        f"--host={setting['timescaledb_host']}",
        f"--port={setting['timescaledb_port']}",
        f"--username={setting['timescaledb_user']}",
        f"--dbname={setting['timescaledb_database']}",
        "--no-password",
        "--format=plain",
        "--no-owner",
        "--no-acl",
        "--verbose",
        f"--file={output_path}"
    ]
    
    # Set PGPASSWORD environment variable to avoid password prompt
    env = os.environ.copy()
    env["PGPASSWORD"] = setting['timescaledb_password']
    
    print(f"Dumping local database from {setting['timescaledb_host']}...")
    print(f"Output file: {output_path}")
    
    try:
        result = subprocess.run(
            pg_dump_cmd,
            env=env,
            capture_output=True,
            text=True,
            check=True
        )
        print("Database dump completed successfully!")
        print(result.stdout)
        return output_path
    except subprocess.CalledProcessError as e:
        print(f"Error dumping database: {e}")
        print(f"stderr: {e.stderr}")
        raise
    except FileNotFoundError:
        print("Error: pg_dump not found. Please ensure PostgreSQL is installed and pg_dump is in PATH.")
        raise


def restore_to_server(sql_file, server_host, server_port, server_db, 
                     server_user, server_password):
    """
    Restore SQL file to server PostgreSQL database using psql.
    
    Parameters
    ----------
    sql_file : str
        Path to the SQL file to restore
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
    """
    
    if not os.path.exists(sql_file):
        raise FileNotFoundError(f"SQL file not found: {sql_file}")
    
    # Build psql command
    psql_cmd = [
        "psql",
        f"--host={server_host}",
        f"--port={server_port}",
        f"--username={server_user}",
        f"--dbname={server_db}",
        "--no-password",
        "--file={sql_file}",
        "--verbose"
    ]
    
    # Set PGPASSWORD environment variable to avoid password prompt
    env = os.environ.copy()
    env["PGPASSWORD"] = server_password
    
    print(f"Restoring database to server {server_host}...")
    print(f"Database: {server_db}")
    print(f"SQL file: {sql_file}")
    
    try:
        result = subprocess.run(
            psql_cmd,
            env=env,
            capture_output=True,
            text=True,
            check=True
        )
        print("Database restore completed successfully!")
        print(result.stdout)
    except subprocess.CalledProcessError as e:
        print(f"Error restoring database: {e}")
        print(f"stderr: {e.stderr}")
        raise
    except FileNotFoundError:
        print("Error: psql not found. Please ensure PostgreSQL is installed and psql is in PATH.")
        raise


def migrate_database(server_host="172.18.7.91", server_port="5432", 
                    server_db="Toyota_Demo", server_user="postgres", 
                    server_password="postgres", output_file=None, skip_dump=False):
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
    output_file : str, optional
        Path to output SQL file. If None, generates timestamped filename.
        If provided and skip_dump=True, uses this file for restore.
    skip_dump : bool, optional
        If True, skips the dump step and uses existing output_file (default: False)
        
    Returns
    -------
    str
        Path to the SQL file used for restore
    """
    
    print("=" * 60)
    print("DATABASE MIGRATION: LOCAL -> SERVER")
    print("=" * 60)
    
    if skip_dump:
        if not output_file or not os.path.exists(output_file):
            raise FileNotFoundError(f"SQL file not found: {output_file}")
        sql_file = output_file
        print(f"\n[Step 1/2] Using existing backup file: {sql_file}")
    else:
        # Step 1: Dump local database
        print("\n[Step 1/2] Dumping local database...")
        sql_file = dump_local_database(output_file)
    
    # Step 2: Restore to server
    print("\n[Step 2/2] Restoring to server database...")
    restore_to_server(
        sql_file=sql_file,
        server_host=server_host,
        server_port=server_port,
        server_db=server_db,
        server_user=server_user,
        server_password=server_password
    )
    
    print("\n" + "=" * 60)
    print("MIGRATION COMPLETED SUCCESSFULLY!")
    print("=" * 60)
    
    return sql_file


def main():
    """
    Main function to run migration with command-line arguments.
    
    Usage:
        python migrate_database.py [host] [port] [database] [user] [password] [sql_file] [--skip-dump]
    
    Examples:
        python migrate_database.py                                    # Use defaults with dump
        python migrate_database.py --skip-dump C:\path\to\backup.sql  # Use existing backup
        python migrate_database.py 172.18.7.91 5432 Toyota_Demo postgres postgres
    """
    
    # Default server credentials (can be overridden by command-line args)
    server_host = "172.18.7.91"
    server_port = "5432"
    server_db = "Toyota_Demo"
    server_user = "postgres"
    server_password = "postgres"
    output_file = None
    skip_dump = False
    
    # Parse command-line arguments
    args = sys.argv[1:]
    i = 0
    while i < len(args):
        if args[i] == "--skip-dump":
            skip_dump = True
            i += 1
            if i < len(args) and not args[i].startswith("--"):
                output_file = args[i]
                i += 1
        elif args[i].startswith("--"):
            i += 1
        else:
            # Positional arguments
            if len(args) >= i + 1:
                server_host = args[i]
            if len(args) >= i + 2:
                server_port = args[i + 1]
            if len(args) >= i + 3:
                server_db = args[i + 2]
            if len(args) >= i + 4:
                server_user = args[i + 3]
            if len(args) >= i + 5:
                server_password = args[i + 4]
            break
    
    try:
        migrate_database(
            server_host=server_host,
            server_port=server_port,
            server_db=server_db,
            server_user=server_user,
            server_password=server_password,
            output_file=output_file,
            skip_dump=skip_dump
        )
    except Exception as e:
        print(f"\nMigration failed: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
