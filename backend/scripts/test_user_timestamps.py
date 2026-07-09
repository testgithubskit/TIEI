import psycopg2
from datetime import datetime
import pytz

start_ms, end_ms = 1782812296000, 1782812306000
ist = pytz.timezone('Asia/Kolkata')
start_dt = datetime.fromtimestamp(start_ms / 1000, ist).replace(tzinfo=None)
end_dt = datetime.fromtimestamp(end_ms / 1000, ist).replace(tzinfo=None)
print('start_dt', start_dt, 'end_dt', end_dt, 'diff sec', (end_ms - start_ms) / 1000)

conn = psycopg2.connect(host='localhost', user='postgres', password='1234', dbname='Toyota_Demo')
cur = conn.cursor()
cur.execute(
    """
    SELECT created_at, pressure_value
    FROM tiei_sample_5.pressure_sensor_data
    WHERE machine_id = 2
      AND created_at >= %s
      AND created_at <= %s
    ORDER BY created_at ASC
    LIMIT 5
    """,
    (start_dt, end_dt),
)
print('sample rows:', cur.fetchall())
cur.execute(
    """
    SELECT COUNT(*)
    FROM tiei_sample_5.pressure_sensor_data
    WHERE machine_id = 2
      AND created_at >= %s
      AND created_at <= %s
    """,
    (start_dt, end_dt),
)
print('total count:', cur.fetchone()[0])
conn.close()
