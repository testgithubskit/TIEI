"""Quick test for pressure raw SQL via Pony connection."""
import sys
sys.path.insert(0, r"d:\Sushmitha\Toyota\backend")

from pony.orm import db_session
from machine_monitoring_app.database.db_utils import initialize_pony, PONY_DATABASE
from machine_monitoring_app.database.pony_models import schema_name

initialize_pony(debug=False)

query = f"""
    SELECT DISTINCT ON (pmm.id)
           pmm.id, pmm.machine_name, pmm.warning_limit, pmm.critical_limit,
           psd.pressure_value, psd.created_at
    FROM {schema_name}.pressure_monitoring_machine pmm
    LEFT JOIN {schema_name}.pressure_sensor_data psd ON psd.machine_id = pmm.id
    ORDER BY pmm.id, psd.created_at DESC NULLS LAST
"""

with db_session:
    conn = PONY_DATABASE.get_connection()
    cur = conn.cursor()
    cur.execute(query)
    rows = cur.fetchall()
    cur.close()
    print("rows:", rows)
