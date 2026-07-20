#!/usr/bin/env python3
"""
Migration script: 
1. Add metrics columns to pressure_log_file table.
2. Seed 20 sequential run sessions with realistic high-frequency sensor readings into pressure_sensor_data.
3. Calculate and update all metrics (mean_pressure, peak_pressure, start_time, end_time, cycle_duration_seconds, pressure_ripple) in pressure_log_file.

Columns added:
- mean_pressure (DOUBLE PRECISION)
- peak_pressure (DOUBLE PRECISION)
- start_time (TIMESTAMP)
- end_time (TIMESTAMP)
- cycle_duration_seconds (DOUBLE PRECISION)
- pressure_ripple (DOUBLE PRECISION - standard deviation of pressure)
"""

import sys
import os
import random
import math
from datetime import datetime, timedelta
import psycopg2

# Add current directory to python path for imports
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from machine_monitoring_app.utils.global_variables import get_settings


def seed_20_sequential_log_runs(cursor, sch, machine_id=1):
    """
    Seed 20 sequential run sessions for machine_id across different dates.
    Generates high-frequency sensor data (~300 points per run) for each session.
    """
    print(f"\n--- Seeding 20 sequential log runs in schema '{sch}' for machine_id={machine_id} ---")
    
    # Starting date for 20 sequential daily runs
    base_date = datetime(2026, 5, 25, 10, 0, 0)
    
    inserted_log_ids = []
    
    for i in range(1, 21):
        run_date = base_date + timedelta(days=i-1, minutes=random.randint(0, 30))
        file_name = f"025_324_JP0160101200001_B1519002RHM_log{i:03d}_2STR_B.H.{run_date.strftime('%y%m%d%H%M%S')}.CSV"
        
        # Check if log file with same name already exists
        cursor.execute(f"""
            SELECT id FROM "{sch}".pressure_log_file 
            WHERE file_name = %s;
        """, (file_name,))
        existing = cursor.fetchone()
        
        if existing:
            log_file_id = existing[0]
            print(f"Run {i}/20: Already exists (log_file_id={log_file_id}, date={run_date.strftime('%Y-%m-%d %H:%M:%S')})")
        else:
            cursor.execute(f"""
                INSERT INTO "{sch}".pressure_log_file (machine_id, file_name, time_stamp, baseline)
                VALUES (%s, %s, %s, FALSE)
                RETURNING id;
            """, (machine_id, file_name, run_date))
            log_file_id = cursor.fetchone()[0]
            print(f"Run {i}/20: Created log_file_id={log_file_id} for date={run_date.strftime('%Y-%m-%d %H:%M:%S')}")
            
            # Generate ~300 sensor reading points over ~9 seconds
            points = []
            num_points = 300
            run_start_time = run_date - timedelta(seconds=9)
            base_pressure = 1600.0 + random.uniform(-30, 30)
            amplitude = random.uniform(120, 160)

            for p in range(num_points):
                t_offset_sec = (p / num_points) * 9.0
                reading_time = run_start_time + timedelta(seconds=t_offset_sec)
                
                # Realistic pneumatic pressure wave: rise, main ripple, drop
                normalized_t = t_offset_sec / 9.0
                wave = math.sin(normalized_t * math.pi) * amplitude
                ripple_noise = random.gauss(0, 35.0)
                val = base_pressure + wave + ripple_noise
                val = round(max(1100.0, min(1800.0, val)), 1)
                
                points.append((reading_time, val, datetime.now(), machine_id, log_file_id))

            # Bulk insert sensor data
            insert_sensor_sql = f"""
                INSERT INTO "{sch}".pressure_sensor_data ("timestamp", pressure_value, created_at, machine_id, log_file_id)
                VALUES (%s, %s, %s, %s, %s);
            """
            cursor.executemany(insert_sensor_sql, points)
            
        inserted_log_ids.append(log_file_id)

    print(f"Seeded 20 log run sessions for schema '{sch}'.")
    return inserted_log_ids


def run_migration():
    settings = get_settings()
    print(f"Connecting to database {settings.timescaledb_database} at {settings.timescaledb_host}:{settings.timescaledb_port} as {settings.timescaledb_user}...")
    
    conn = psycopg2.connect(
        host=settings.timescaledb_host,
        port=settings.timescaledb_port,
        dbname=settings.timescaledb_database,
        user=settings.timescaledb_user,
        password=settings.timescaledb_password,
    )
    conn.autocommit = False
    cursor = conn.cursor()

    try:
        # Find all schemas containing pressure_log_file table
        cursor.execute("""
            SELECT table_schema 
            FROM information_schema.tables 
            WHERE table_name = 'pressure_log_file';
        """)
        schemas = [row[0] for row in cursor.fetchall()]
        print(f"Found pressure_log_file table in schema(s): {schemas}")

        for sch in schemas:
            print(f"\n=== Processing schema: {sch} ===")
            
            # 1. Add missing metric columns
            columns_to_add = [
                ("mean_pressure", "DOUBLE PRECISION"),
                ("peak_pressure", "DOUBLE PRECISION"),
                ("start_time", "TIMESTAMP"),
                ("end_time", "TIMESTAMP"),
                ("cycle_duration_seconds", "DOUBLE PRECISION"),
                ("pressure_ripple", "DOUBLE PRECISION"),
            ]

            for col_name, col_type in columns_to_add:
                cursor.execute("""
                    SELECT column_name 
                    FROM information_schema.columns 
                    WHERE table_schema = %s 
                      AND table_name = 'pressure_log_file' 
                      AND column_name = %s;
                """, (sch, col_name))
                if not cursor.fetchone():
                    print(f"Adding column '{col_name}' ({col_type}) to {sch}.pressure_log_file...")
                    cursor.execute(f'ALTER TABLE "{sch}".pressure_log_file ADD COLUMN "{col_name}" {col_type};')
                else:
                    print(f"Column '{col_name}' already exists in {sch}.pressure_log_file.")

            # 2. Seed 20 sequential log run sessions for machine_id = 1 ('2nd Rough')
            seed_20_sequential_log_runs(cursor, sch, machine_id=1)

            # 3. Calculate metrics from pressure_sensor_data and update pressure_log_file
            print(f"\nCalculating metrics from {sch}.pressure_sensor_data and updating {sch}.pressure_log_file...")
            update_sql = f"""
                UPDATE "{sch}".pressure_log_file plf
                SET 
                    mean_pressure = ROUND(CAST(stats.mean_pressure AS numeric), 2),
                    peak_pressure = ROUND(CAST(stats.peak_pressure AS numeric), 2),
                    start_time = stats.start_time,
                    end_time = stats.end_time,
                    cycle_duration_seconds = ROUND(CAST(stats.cycle_duration_seconds AS numeric), 2),
                    pressure_ripple = ROUND(CAST(stats.pressure_ripple AS numeric), 4)
                FROM (
                    SELECT 
                        log_file_id,
                        AVG(pressure_value) AS mean_pressure,
                        MAX(pressure_value) AS peak_pressure,
                        MIN("timestamp") AS start_time,
                        MAX("timestamp") AS end_time,
                        EXTRACT(EPOCH FROM (MAX("timestamp") - MIN("timestamp"))) AS cycle_duration_seconds,
                        COALESCE(STDDEV_SAMP(pressure_value), 0.0) AS pressure_ripple
                    FROM "{sch}".pressure_sensor_data
                    WHERE log_file_id IS NOT NULL
                    GROUP BY log_file_id
                ) stats
                WHERE plf.id = stats.log_file_id;
            """
            cursor.execute(update_sql)
            updated_count = cursor.rowcount
            print(f"Updated metrics for {updated_count} pressure_log_file row(s) in schema '{sch}'.")

        conn.commit()
        print("\n[SUCCESS] Migration and seeding completed successfully!")
    except Exception as e:
        conn.rollback()
        print(f"\n[ERROR] Migration failed: {e}")
        raise
    finally:
        cursor.close()
        conn.close()


if __name__ == "__main__":
    run_migration()
