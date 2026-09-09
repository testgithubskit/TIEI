-- Migrate cycle-time FKs from machines(id) to cycle_time_machines(id)
-- Schema: tiei_sample_5

BEGIN;

-- 1) Drop existing FKs that point at machines
ALTER TABLE tiei_sample_5.sql_server_mct_data
    DROP CONSTRAINT IF EXISTS fk_machine;

ALTER TABLE tiei_sample_5.sql_server_mct_data
    DROP CONSTRAINT IF EXISTS fk_sql_server_mct_data__machine_id;

ALTER TABLE tiei_sample_5.cycle_time_limits
    DROP CONSTRAINT IF EXISTS fk_cycle_time_limits__machine_id;

-- 2) Remap machine_id by matching name (machines.name -> cycle_time_machines.id)
--    Needed if ids ever diverged; no-op when ids already match.
UPDATE tiei_sample_5.sql_server_mct_data d
SET machine_id = ctm.id
FROM tiei_sample_5.machines m
JOIN tiei_sample_5.cycle_time_machines ctm ON ctm.name = m.name
WHERE d.machine_id = m.id
  AND d.machine_id IS DISTINCT FROM ctm.id;

UPDATE tiei_sample_5.cycle_time_limits ctl
SET machine_id = ctm.id
FROM tiei_sample_5.machines m
JOIN tiei_sample_5.cycle_time_machines ctm ON ctm.name = m.name
WHERE ctl.machine_id = m.id
  AND ctl.machine_id IS DISTINCT FROM ctm.id;

-- 3) Create missing limits for every cycle_time_machines row
INSERT INTO tiei_sample_5.cycle_time_limits (machine_id, warning_limit, critical_limit, status)
SELECT ctm.id, 60.0, 90.0, 'ACTIVE'
FROM tiei_sample_5.cycle_time_machines ctm
WHERE NOT EXISTS (
    SELECT 1
    FROM tiei_sample_5.cycle_time_limits ctl
    WHERE ctl.machine_id = ctm.id
);

-- 4) Point FKs at cycle_time_machines(id)
ALTER TABLE tiei_sample_5.sql_server_mct_data
    ADD CONSTRAINT fk_sql_server_mct_data__cycle_time_machine_id
    FOREIGN KEY (machine_id)
    REFERENCES tiei_sample_5.cycle_time_machines(id)
    ON DELETE RESTRICT;

ALTER TABLE tiei_sample_5.cycle_time_limits
    ADD CONSTRAINT fk_cycle_time_limits__cycle_time_machine_id
    FOREIGN KEY (machine_id)
    REFERENCES tiei_sample_5.cycle_time_machines(id)
    ON DELETE RESTRICT;

COMMIT;
