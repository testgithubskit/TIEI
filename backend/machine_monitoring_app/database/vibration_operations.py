#!/usr/bin/python
# -*- coding: utf-8 -*-
"""Vibration monitoring CRUD helpers (TNGA)."""

from __future__ import annotations

import logging
import math
from datetime import datetime, timedelta, date
from typing import List, Optional

from pony.orm import db_session, select, commit, desc
import pytz

from machine_monitoring_app.database.db_utils import PONY_DATABASE
from machine_monitoring_app.database.pony_models import (
    VibrationMachine,
    VibrationMachineLog,
    schema_name,
)

LOGGER = logging.getLogger(__name__)

VIBRATION_PARAMETER_GROUP = "VIBRATION"
VIBRATION_PARAMETER_NAME = "VIBRATION"
VIBRATION_MAX_CHART_POINTS = 3000
VIBRATION_MAX_LOG_SELECTIONS = 5
VIBRATION_DB_TIMEZONE = pytz.timezone("Asia/Kolkata")
VIBRATION_PARAMETERS = (
    "contact_temperature",
    "v_peak_x",
    "v_peak_y",
    "v_peak_z",
    "v_rms_x",
    "v_rms_y",
    "v_rms_z",
)
VIBRATION_PARAMETER_LABELS = {
    "contact_temperature": "Contact Temperature",
    "v_peak_x": "V Peak X",
    "v_peak_y": "V Peak Y",
    "v_peak_z": "V Peak Z",
    "v_rms_x": "V RMS X",
    "v_rms_y": "V RMS Y",
    "v_rms_z": "V RMS Z",
}
VIBRATION_PARAMETER_UNITS = {
    "contact_temperature": "°C",
    "v_peak_x": "mm/s",
    "v_peak_y": "mm/s",
    "v_peak_z": "mm/s",
    "v_rms_x": "mm/s",
    "v_rms_y": "mm/s",
    "v_rms_z": "mm/s",
}


def _execute_raw_sql(query, params=None):
    connection = PONY_DATABASE.get_connection()
    cursor = connection.cursor()
    try:
        if params:
            cursor.execute(query, params)
        else:
            cursor.execute(query)
        return cursor.fetchall()
    finally:
        cursor.close()


def _vibration_dt_to_epoch_ms(reading_dt):
    if reading_dt is None:
        return 0
    reading_dt = _as_aware_ist(reading_dt)
    return int(reading_dt.timestamp() * 1000)


def _as_aware_ist(dt):
    """Normalize DB timestamps (aware or naive) to Asia/Kolkata-aware."""
    if dt is None:
        return None
    if getattr(dt, "tzinfo", None) is None:
        return VIBRATION_DB_TIMEZONE.localize(dt)
    return dt.astimezone(VIBRATION_DB_TIMEZONE)


def _format_vibration_ist_datetime_seconds(dt):
    """
    Display wall-clock IST time as stored.
    Example DB value 2026-03-01 08:22:21.882892+05:30 → 2026-03-01 08:22:21
    (no extra +5:30 applied on top).
    """
    if dt is None:
        return None
    ist = _as_aware_ist(dt)
    return ist.replace(tzinfo=None).strftime("%Y-%m-%d %H:%M:%S")


def _lttb_downsample(points, max_points):
    if not points or max_points is None or len(points) <= max_points:
        return points
    if max_points <= 2:
        return [points[0], points[-1]] if len(points) >= 2 else points

    sampled = [points[0]]
    bucket_size = (len(points) - 2) / (max_points - 2)
    a = 0
    for i in range(0, max_points - 2):
        avg_range_start = int(math.floor((i + 1) * bucket_size)) + 1
        avg_range_end = int(math.floor((i + 2) * bucket_size)) + 1
        avg_range_end = min(avg_range_end, len(points))
        avg_range_start = min(avg_range_start, len(points) - 1)

        avg_x = 0.0
        avg_y = 0.0
        avg_range_length = max(1, avg_range_end - avg_range_start)
        for j in range(avg_range_start, avg_range_end):
            avg_x += points[j][0]
            avg_y += points[j][1]
        avg_x /= avg_range_length
        avg_y /= avg_range_length

        range_offs = int(math.floor(i * bucket_size)) + 1
        range_to = int(math.floor((i + 1) * bucket_size)) + 1
        range_to = min(range_to, len(points) - 1)

        point_a_x = points[a][0]
        point_a_y = points[a][1]
        max_area = -1.0
        next_a = range_offs
        for j in range(range_offs, range_to):
            area = abs(
                (point_a_x - avg_x) * (points[j][1] - point_a_y)
                - (point_a_x - points[j][0]) * (avg_y - point_a_y)
            ) * 0.5
            if area > max_area:
                max_area = area
                next_a = j
        sampled.append(points[next_a])
        a = next_a

    sampled.append(points[-1])
    return sampled


def parse_vibration_date_param(value, field_name):
    if value in (None, ""):
        return None
    if isinstance(value, datetime):
        return value.date()
    if isinstance(value, date):
        return value
    text = str(value).strip()
    if not text:
        return None
    for fmt in ("%Y-%m-%d", "%d-%m-%Y", "%Y/%m/%d"):
        try:
            return datetime.strptime(text, fmt).date()
        except ValueError:
            continue
    raise ValueError(f"Invalid {field_name}. Use YYYY-MM-DD, for example: 2026-06-30")


def _normalize_vibration_parameter(parameter: Optional[str]) -> str:
    key = str(parameter or "").strip().lower()
    if key not in VIBRATION_PARAMETERS:
        raise ValueError(
            f"Invalid vibration parameter '{parameter}'. "
            f"Allowed: {', '.join(VIBRATION_PARAMETERS)}"
        )
    return key


def _clamp_vibration_max_points(max_points=None):
    try:
        value = int(max_points) if max_points is not None else VIBRATION_MAX_CHART_POINTS
    except (TypeError, ValueError):
        value = VIBRATION_MAX_CHART_POINTS
    return max(50, min(value, VIBRATION_MAX_CHART_POINTS))


def _vibration_ports_for_machine(machine: VibrationMachine) -> List[str]:
    ports = []
    for port in (machine.port1, machine.port2):
        text = str(port or "").strip()
        if text and text not in ports:
            ports.append(text)
    return ports


def _get_vibration_machine_meta(machine_name: str) -> VibrationMachine:
    machine = VibrationMachine.get(machine_name=machine_name)
    if not machine:
        raise ValueError(f"Vibration machine '{machine_name}' not found")
    return machine


def _build_vibration_port_parameter(machine: VibrationMachine, port: str):
    return {
        "actual_parameter_name": VIBRATION_PARAMETER_NAME,
        "display_name": port,
        "internal_parameter_name": f"vibration_{machine.id}_{port}".replace(" ", "_"),
        "latest_update_time": None,
        "latest_update_time_ms": None,
        "parameter_value": None,
        "parameter_state": "OK",
        "warning_limit": machine.warning,
        "critical_limit": machine.critical,
        "parameter_group": VIBRATION_PARAMETER_GROUP,
        "parameter_type": "increasing",
        "unit_name": None,
        "unit_short_name": None,
        "is_vibration_machine": True,
        "port_name": port,
        "signal_name": port,
        "source_machine_name": machine.machine_name,
    }


def _build_vibration_machine_json(machine: VibrationMachine):
    ports = _vibration_ports_for_machine(machine)
    parameters = [_build_vibration_port_parameter(machine, port) for port in ports]
    line_name = (machine.location or "CRANK").strip().upper() or "CRANK"
    return {
        "machine_name": machine.machine_name,
        "machine_state": "OK",
        "count": {"OK": 1, "WARNING": 0, "CRITICAL": 0, "DISCONNECTED": 0},
        "parameters": parameters,
        "is_vibration_machine": True,
        "is_combined_vibration": True,
        "line_name": line_name,
        "warning_limit": machine.warning,
        "critical_limit": machine.critical,
        "ports": ports,
    }


@db_session(optimistic=False)
def _fetch_vibration_machine_rows():
    return list(select(m for m in VibrationMachine).order_by(VibrationMachine.id))


def _merge_vibration_machines_into_lines(lines):
    """
    Attach vibration machines/ports to factory lines.
    - New machines (e.g. T_C_OP200) are appended to their location line.
    - Existing machines (e.g. T_H_OP280) get vibration ports merged onto them.
    """
    machines = _fetch_vibration_machine_rows()
    if not machines:
        return lines, []

    added_or_touched = []
    for machine in machines:
        machine_json = _build_vibration_machine_json(machine)
        line_name = machine_json["line_name"]
        target_line = next(
            (line for line in lines if str(line.get("line_name") or "").upper() == line_name),
            None,
        )
        if target_line is None:
            target_line = {
                "line_name": line_name,
                "machines": [],
                "line_state": "OK",
                "count": {"OK": 0, "WARNING": 0, "CRITICAL": 0, "DISCONNECTED": 0},
            }
            lines.append(target_line)

        existing = next(
            (
                item
                for item in target_line.get("machines", [])
                if item.get("machine_name") == machine.machine_name
            ),
            None,
        )
        if existing is None:
            target_line.setdefault("machines", []).append(machine_json)
            state = machine_json["machine_state"]
            if state in target_line["count"]:
                target_line["count"][state] += 1
            added_or_touched.append(machine_json)
            continue

        existing.setdefault("parameters", [])
        existing_ports = {
            (param.get("port_name") or param.get("display_name") or "").strip()
            for param in existing["parameters"]
            if param.get("is_vibration_machine")
            or param.get("parameter_group") == VIBRATION_PARAMETER_GROUP
        }
        for port_param in machine_json["parameters"]:
            port_name = (port_param.get("port_name") or "").strip()
            if port_name and port_name not in existing_ports:
                existing["parameters"].append(port_param)
        existing["is_vibration_machine"] = True
        existing["is_combined_vibration"] = True
        existing["ports"] = machine_json["ports"]
        if existing.get("warning_limit") is None:
            existing["warning_limit"] = machine.warning
        if existing.get("critical_limit") is None:
            existing["critical_limit"] = machine.critical
        added_or_touched.append(existing)

    for line in lines:
        counts = line.get("count") or {}
        if counts.get("CRITICAL", 0) > 0:
            line["line_state"] = "CRITICAL"
        elif counts.get("WARNING", 0) > 0:
            line["line_state"] = "WARNING"

    return lines, added_or_touched


def _merge_vibration_into_group_json(group_json):
    if group_json.get("group_name") == VIBRATION_PARAMETER_GROUP:
        return group_json
    group_json["group_details"], _touched = _merge_vibration_machines_into_lines(
        group_json.get("group_details", [])
    )
    return group_json


@db_session(optimistic=False)
def get_vibration_monitoring_group_details():
    machines = _fetch_vibration_machine_rows()
    group_json = {
        "group_name": VIBRATION_PARAMETER_GROUP,
        "group_details": [],
        "group_state": "OK",
        "count": {"OK": 0, "WARNING": 0, "CRITICAL": 0, "DISCONNECTED": 0},
    }
    if not machines:
        return group_json

    by_line = {}
    for machine in machines:
        machine_json = _build_vibration_machine_json(machine)
        line_name = machine_json["line_name"]
        line = by_line.get(line_name)
        if line is None:
            line = {
                "line_name": line_name,
                "machines": [],
                "line_state": "OK",
                "count": {"OK": 0, "WARNING": 0, "CRITICAL": 0, "DISCONNECTED": 0},
            }
            by_line[line_name] = line
        line["machines"].append(machine_json)
        state = machine_json["machine_state"]
        if state in line["count"]:
            line["count"][state] += 1

    for line in by_line.values():
        if line["count"]["CRITICAL"] > 0:
            line["line_state"] = "CRITICAL"
        elif line["count"]["WARNING"] > 0:
            line["line_state"] = "WARNING"
        group_json["group_details"].append(line)
        for key in group_json["count"]:
            group_json["count"][key] += line["count"].get(key, 0)

    if group_json["count"]["CRITICAL"] > 0:
        group_json["group_state"] = "CRITICAL"
    elif group_json["count"]["WARNING"] > 0:
        group_json["group_state"] = "WARNING"
    return group_json


@db_session(optimistic=False)
def get_vibration_log_file_listing(machine_name, start_date=None, end_date=None, port=None):
    """
    Timestamps list DATE/TIME + date filter use vibration_machine_logs.program_file_time.
    Selecting a file loads vibration_data by program_file_id (+ port) for the graph.
    Expand values = latest vibration_data row for that file+port.
    cycle_duration_seconds = MAX(timestamp)-MIN(timestamp) for that file+port.
    """
    machine = _get_vibration_machine_meta(machine_name)
    ports = _vibration_ports_for_machine(machine)
    port_name = str(port or "").strip()
    if not port_name and ports:
        port_name = ports[0]

    start_dt = None
    end_dt = None
    if start_date is not None:
        start_dt = VIBRATION_DB_TIMEZONE.localize(datetime.combine(start_date, datetime.min.time()))
    if end_date is not None:
        end_dt = VIBRATION_DB_TIMEZONE.localize(
            datetime.combine(end_date + timedelta(days=1), datetime.min.time())
        )

    data_meta = _fetch_vibration_data_meta_by_program(machine.id, port_name)

    query = select(log for log in VibrationMachineLog if log.machine.id == machine.id)
    query = query.order_by(desc(VibrationMachineLog.program_file_time), desc(VibrationMachineLog.id))

    baseline_log_file_id = None
    log_files = []
    for log in query:
        is_baseline = bool(log.baseline)
        if is_baseline and baseline_log_file_id is None:
            baseline_log_file_id = log.id

        file_ts = log.program_file_time
        if file_ts is None:
            continue
        file_ts_cmp = _as_aware_ist(file_ts)
        if start_dt is not None and file_ts_cmp < start_dt:
            continue
        if end_dt is not None and file_ts_cmp >= end_dt:
            continue

        program_file_id = log.program_file_id
        meta = data_meta.get(int(program_file_id)) if program_file_id is not None else None
        formatted = _format_vibration_ist_datetime_seconds(file_ts)
        log_files.append(
            {
                "log_file_id": log.id,
                "program_file_id": program_file_id,
                "file_name": formatted,
                "time_stamp": formatted,
                "processed_time": formatted,
                "program_file_time": formatted,
                "baseline": is_baseline,
                "param_summary": (meta or {}).get("param_values") or {},
                "cycle_duration_seconds": (meta or {}).get("cycle_duration_seconds"),
            }
        )

    return {
        "machine_name": machine.machine_name,
        "parameter_name": VIBRATION_PARAMETER_NAME,
        "ports": ports,
        "warning_limit": machine.warning,
        "critical_limit": machine.critical,
        "available_parameters": [
            {
                "key": key,
                "label": VIBRATION_PARAMETER_LABELS[key],
                "unit": VIBRATION_PARAMETER_UNITS[key],
            }
            for key in VIBRATION_PARAMETERS
        ],
        "baseline_log_file_id": baseline_log_file_id,
        "log_files": log_files,
        "timestamp_source": "vibration_machine_logs.program_file_time",
        "chart_timestamp_source": "vibration_data.timestamp",
    }


def _fetch_vibration_data_meta_by_program(machine_id, port, start_dt=None, end_dt=None):
    """
    For each program_file_id + port:
    - param_values = latest vibration_data row
    - cycle_duration_seconds = MAX(timestamp) - MIN(timestamp)
    """
    if not port:
        return {}
    mid = int(machine_id)
    port_escaped = str(port).replace("'", "''")
    param_cols = ", ".join(f"vd.{col}" for col in VIBRATION_PARAMETERS)

    # Duration + bounds per program file
    duration_rows = _execute_raw_sql(
        f"""
        SELECT
            program_file_id,
            MIN(timestamp) AS first_ts,
            MAX(timestamp) AS last_ts,
            EXTRACT(EPOCH FROM (MAX(timestamp) - MIN(timestamp))) AS cycle_seconds
        FROM {schema_name}.vibration_data
        WHERE machine_id = {mid}
          AND port = '{port_escaped}'
          AND program_file_id IS NOT NULL
        GROUP BY program_file_id
        """
    )
    duration_by_pid = {}
    for row in duration_rows or []:
        if not row or row[0] is None:
            continue
        try:
            pid = int(row[0])
        except (TypeError, ValueError):
            continue
        cycle_seconds = None
        if row[3] is not None:
            try:
                cycle_seconds = round(float(row[3]), 3)
            except (TypeError, ValueError):
                cycle_seconds = None
        duration_by_pid[pid] = {
            "first_ts": row[1],
            "last_ts": row[2],
            "cycle_duration_seconds": cycle_seconds,
        }

    # Latest row values per program file (for expand panel)
    latest_rows = _execute_raw_sql(
        f"""
        SELECT DISTINCT ON (vd.program_file_id)
            vd.program_file_id,
            vd.timestamp,
            {param_cols}
        FROM {schema_name}.vibration_data vd
        WHERE vd.machine_id = {mid}
          AND vd.port = '{port_escaped}'
          AND vd.program_file_id IS NOT NULL
        ORDER BY vd.program_file_id, vd.timestamp DESC
        """
    )
    out = {}
    for row in latest_rows or []:
        if not row or row[0] is None:
            continue
        try:
            pid = int(row[0])
        except (TypeError, ValueError):
            continue
        param_values = {}
        for idx, key in enumerate(VIBRATION_PARAMETERS):
            value = row[idx + 2] if idx + 2 < len(row) else None
            if value is None:
                param_values[key] = None
            else:
                try:
                    param_values[key] = round(float(value), 3)
                except (TypeError, ValueError):
                    param_values[key] = None
        duration_meta = duration_by_pid.get(pid) or {}
        out[pid] = {
            "timestamp": duration_meta.get("first_ts") or row[1],
            "param_values": param_values,
            "cycle_duration_seconds": duration_meta.get("cycle_duration_seconds"),
        }

    for pid, duration_meta in duration_by_pid.items():
        if pid not in out:
            out[pid] = {
                "timestamp": duration_meta.get("first_ts"),
                "param_values": {},
                "cycle_duration_seconds": duration_meta.get("cycle_duration_seconds"),
            }
    return out


@db_session(optimistic=False)
def update_vibration_machine_limits(machine_name, warning_limit=None, critical_limit=None):
    machine = _get_vibration_machine_meta(machine_name)
    new_warning = float(warning_limit) if warning_limit is not None else machine.warning
    new_critical = float(critical_limit) if critical_limit is not None else machine.critical
    if new_warning is None or new_critical is None:
        raise ValueError("Both warning and critical limits must be set")
    if float(new_warning) < 0 or float(new_critical) < 0:
        raise ValueError("Limits must be non-negative")
    if float(new_warning) > float(new_critical):
        raise ValueError("warning cannot be greater than critical")
    machine.warning = float(new_warning)
    machine.critical = float(new_critical)
    commit()
    return {
        "machine_name": machine.machine_name,
        "warning_limit": float(new_warning),
        "critical_limit": float(new_critical),
        "message": "Vibration limits updated successfully",
    }


@db_session(optimistic=False)
def update_vibration_log_file_baseline(machine_name, log_file_id):
    machine = _get_vibration_machine_meta(machine_name)
    target = VibrationMachineLog.get(
        lambda log: log.id == int(log_file_id) and log.machine.id == machine.id
    )
    if not target:
        raise ValueError(
            f"Vibration log file '{log_file_id}' not found for machine '{machine.machine_name}'"
        )
    for log in select(item for item in VibrationMachineLog if item.machine.id == machine.id):
        log.baseline = False
    target.baseline = True
    commit()
    return {
        "machine_name": machine.machine_name,
        "baseline_log_file_id": int(log_file_id),
        "message": "Vibration baseline updated successfully",
    }


@db_session(optimistic=False)
def clear_vibration_log_file_baseline(machine_name):
    machine = _get_vibration_machine_meta(machine_name)
    for log in select(item for item in VibrationMachineLog if item.machine.id == machine.id):
        log.baseline = False
    commit()
    return {
        "machine_name": machine.machine_name,
        "baseline_log_file_id": None,
        "message": "Vibration baseline cleared successfully",
    }


def _fetch_vibration_points_for_log_file(machine_id, program_file_id, port, parameter, max_points):
    max_points = _clamp_vibration_max_points(max_points)
    param_col = _normalize_vibration_parameter(parameter)
    mid = int(machine_id)
    pid = int(program_file_id)
    port_escaped = str(port).replace("'", "''")

    count_rows = _execute_raw_sql(
        f"""
        SELECT COUNT(*)
        FROM {schema_name}.vibration_data
        WHERE machine_id = {mid}
          AND program_file_id = {pid}
          AND port = '{port_escaped}'
        """
    )
    raw_points = int(count_rows[0][0]) if count_rows else 0
    if raw_points <= 0:
        return [], 0, False

    use_bucket_avg = raw_points > min(400, max_points)
    if not use_bucket_avg:
        rows = _execute_raw_sql(
            f"""
            SELECT timestamp, {param_col}
            FROM {schema_name}.vibration_data
            WHERE machine_id = {mid}
              AND program_file_id = {pid}
              AND port = '{port_escaped}'
            ORDER BY timestamp ASC
            """
        )
        points = []
        for reading_ts, value in rows or []:
            if reading_ts is None or value is None:
                continue
            try:
                points.append([_vibration_dt_to_epoch_ms(reading_ts), float(value)])
            except (TypeError, ValueError):
                continue
        downsampled = len(points) > max_points
        return _lttb_downsample(points, max_points), raw_points, downsampled

    bucket_rows = _execute_raw_sql(
        f"""
        WITH filtered AS (
            SELECT timestamp AS reading_ts, {param_col} AS metric_value
            FROM {schema_name}.vibration_data
            WHERE machine_id = {mid}
              AND program_file_id = {pid}
              AND port = '{port_escaped}'
              AND {param_col} IS NOT NULL
        ),
        bounds AS (
            SELECT
                EXTRACT(EPOCH FROM MIN(reading_ts)) AS e0,
                EXTRACT(EPOCH FROM MAX(reading_ts)) AS e1
            FROM filtered
        )
        SELECT
            MIN(f.reading_ts) AS bucket_ts,
            AVG(f.metric_value) AS metric_value
        FROM filtered f
        CROSS JOIN bounds b
        WHERE b.e0 IS NOT NULL AND b.e1 IS NOT NULL
        GROUP BY width_bucket(
            EXTRACT(EPOCH FROM f.reading_ts),
            b.e0,
            b.e1 + 1e-6,
            {max_points}
        )
        ORDER BY 1
        """
    )
    points = []
    for bucket_ts, value in bucket_rows or []:
        if bucket_ts is None or value is None:
            continue
        try:
            points.append([_vibration_dt_to_epoch_ms(bucket_ts), float(value)])
        except (TypeError, ValueError):
            continue
    return _lttb_downsample(points, max_points), raw_points, True


@db_session(optimistic=False)
def get_vibration_machine_timeline_by_log_files(
    machine_name,
    port,
    parameter,
    log_file_ids,
    max_points=None,
    include_baseline=True,
):
    machine = _get_vibration_machine_meta(machine_name)
    ports = _vibration_ports_for_machine(machine)
    port_name = str(port or "").strip()
    if not port_name:
        raise ValueError("Port is required")
    if ports and port_name not in ports:
        raise ValueError(
            f"Port '{port_name}' is not configured for machine '{machine.machine_name}'. "
            f"Allowed: {', '.join(ports)}"
        )
    param_key = _normalize_vibration_parameter(parameter)
    max_points = _clamp_vibration_max_points(max_points)

    listing = get_vibration_log_file_listing(machine.machine_name, port=port_name)
    log_files_by_id = {item["log_file_id"]: item for item in listing["log_files"]}
    baseline_log_file_id = listing["baseline_log_file_id"]

    requested_ids = []
    for log_file_id in log_file_ids or []:
        try:
            requested_ids.append(int(log_file_id))
        except (TypeError, ValueError):
            continue
    if len(requested_ids) > VIBRATION_MAX_LOG_SELECTIONS:
        raise ValueError(
            f"A maximum of {VIBRATION_MAX_LOG_SELECTIONS} vibration log files can be selected at a time"
        )

    unique_ids = []
    if include_baseline and baseline_log_file_id is not None:
        unique_ids.append(int(baseline_log_file_id))
    for log_file_id in requested_ids:
        if log_file_id not in unique_ids:
            unique_ids.append(log_file_id)

    legend = {
        "x_axis_label": "Timestamp",
        "y_axis_label": VIBRATION_PARAMETER_LABELS[param_key],
        "x_axis_units": "DateTime",
        "y_axis_units": VIBRATION_PARAMETER_UNITS[param_key],
    }

    if not unique_ids:
        return {
            "parameter_name": VIBRATION_PARAMETER_NAME,
            "machine_name": machine.machine_name,
            "port": port_name,
            "selected_parameter": param_key,
            "warning_limit": machine.warning,
            "critical_limit": machine.critical,
            "baseline_log_file_id": baseline_log_file_id,
            "series": [],
            "legend_data": legend,
            "message": "Select at least one program file to view the graph",
            "available_parameters": listing["available_parameters"],
            "ports": ports,
        }

    series = []
    for log_file_id in unique_ids:
        meta = log_files_by_id.get(log_file_id)
        if not meta:
            continue
        program_file_id = meta.get("program_file_id") or log_file_id
        chart_data, raw_points, downsampled = _fetch_vibration_points_for_log_file(
            machine.id, program_file_id, port_name, param_key, max_points
        )
        is_baseline = bool(meta.get("baseline")) or log_file_id == baseline_log_file_id
        label = meta.get("program_file_time") or meta.get("time_stamp") or str(log_file_id)
        if is_baseline:
            label = f"Baseline ({label})"
        series.append(
            {
                "log_file_id": log_file_id,
                "program_file_id": program_file_id,
                "label": label,
                "baseline": is_baseline,
                "chart_data": chart_data,
                "raw_points": raw_points,
                "returned_points": len(chart_data),
                "downsampled": downsampled,
                "cycle_duration_seconds": meta.get("cycle_duration_seconds"),
                "time_stamp": meta.get("time_stamp") or meta.get("program_file_time"),
                "param_summary": meta.get("param_summary") or {},
            }
        )

    message = "Vibration comparison data loaded successfully"
    if not series:
        message = "No vibration data available for the selected program files"
    elif not any(item.get("chart_data") for item in series):
        message = f"No vibration data for port '{port_name}' and parameter '{param_key}'"

    return {
        "parameter_name": VIBRATION_PARAMETER_NAME,
        "machine_name": machine.machine_name,
        "port": port_name,
        "selected_parameter": param_key,
        "warning_limit": machine.warning,
        "critical_limit": machine.critical,
        "baseline_log_file_id": baseline_log_file_id,
        "series": series,
        "legend_data": legend,
        "message": message,
        "max_points": max_points,
        "available_parameters": listing["available_parameters"],
        "ports": ports,
    }
