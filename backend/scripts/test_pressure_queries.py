import psycopg2
from datetime import datetime, timedelta, timezone

conn = psycopg2.connect(host='localhost', user='postgres', password='1234', dbname='Toyota_Demo')
cur = conn.cursor()

query = """
    SELECT pmm.id, pmm.machine_name, pmm.warning_limit, pmm.critical_limit,
           latest.pressure_value, latest.created_at
    FROM tiei_sample_5.pressure_monitoring_machine pmm
    LEFT JOIN LATERAL (
        SELECT psd.pressure_value, psd.created_at
        FROM tiei_sample_5.pressure_sensor_data psd
        WHERE psd.machine_id = pmm.id
        ORDER BY psd.created_at DESC
        LIMIT 1
    ) latest ON true
    ORDER BY pmm.id
"""
cur.execute(query)
print('Realtime rows:', cur.fetchall())

machine_name = '2nd Rough'
cur.execute(
    "SELECT id FROM tiei_sample_5.pressure_monitoring_machine WHERE machine_name = %s",
    (machine_name,),
)
machine_id = cur.fetchone()[0]
end_dt = datetime(2026, 6, 30, 15, 8, 16, 622192)
start_dt = end_dt - timedelta(seconds=10)
cur.execute(
    """
    SELECT created_at, pressure_value
    FROM tiei_sample_5.pressure_sensor_data
    WHERE machine_id = %s AND created_at >= %s AND created_at <= %s
    ORDER BY created_at ASC
    LIMIT 5
    """,
    (machine_id, start_dt, end_dt),
)
print('Timeline sample count (first 5):', cur.fetchall())

conn.close()
print('OK')
