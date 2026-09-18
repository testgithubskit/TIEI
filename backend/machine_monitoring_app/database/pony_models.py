#!/usr/bin/python
# -*- coding: utf-8 -*-
"""

PONY ORM MODELS
======================

Module that contains the models for object relational mapping for database operations.

This script requires the following modules be installed in the python environment

    Standard Library
    ======================
    * logging - to perform logging operations
    * datetime - to perform datetime operations

    Related 3rd Party Library
    =============================
    * pony - to perform database operations using orm

This script contains the following function
    * main - main function to call appropriate functions to find the contours in the video

"""

# Standard library imports
import logging
from datetime import datetime, timedelta, date

# Related third party imports
from typing import List

from pony.orm import PrimaryKey, Required, Optional, Set, FloatArray, \
    select, db_session, commit, LongStr

# Local application/library specific imports
from machine_monitoring_app.database.db_utils import PONY_DATABASE, initialize_pony

__author__ = "smt18m005@iiitdm.ac.in"

LOGGER = logging.getLogger(__name__)


@db_session
def get_schema_name() -> List[str]:
    """Function to retrieve schema names from Pony ORM entities."""
    schema_names = set()
    # Check any one entity for the schema name
    entity = next(iter(PONY_DATABASE.entities.values()), None)
    if entity:
        schema_names.add(entity._table_[0])
    return list(schema_names)

schema_name = "tiei_sample_5" #TNGA Database Client
#schema_name = "tiei_gd_plant_1" #GD Database Client
# schema_name = "tiei_sample_4" #Local DataBase TNGA


class Machine(PONY_DATABASE.Entity):
    """Represents a physical machine."""

    _table_ = (schema_name, "machines")
    id = PrimaryKey(int, auto=True)
    name = Required(str)
    location = Required(str, default='HEAD')
    machine_number = Optional(str)
    short_name = Optional(str)
    description = Optional(str)
    enabled = Required(bool, default='true')
    parameters = Optional(int)

    # Relationships - Many Side Of Relationship
    machine_parameters = Set('MachineParameter')
    machine_event_timelines = Set('MachineEventTimeline')
    machine_production_timelines = Set('MachineProductionTimeline')
    spare_parts = Set('SparePart')
    spare_part_activities = Set('SparePartActivity')
    spare_part_activity_histories = Set('SparePartActivityHistory')
    machine_part_count = Optional('MachinePartCount')
    machine_comparisons = Set('ParameterComparison')
    disconnection_histories = Set('DisconnectionHistory')
    disconnection_history_intervals = Set('DisconnectionHistoryInterval')


class SparePart(PONY_DATABASE.Entity):
    """Represents a spare part."""

    _table_ = (schema_name, "spare_part")

    id = PrimaryKey(int, auto=True)
    part_name = Required(str)
    reference_part_number = Required(int)
    warning_limit = Required(int)
    critical_limit = Required(int)

    # Relationships - One Side Of Relationship
    machine = Required(Machine, column="machine_id")
    activities = Set('SparePartActivity')
    activity_histories = Set('SparePartActivityHistory')


class ParameterGroup(PONY_DATABASE.Entity):
    """Represents a parameter group."""

    _table_ = (schema_name, "parameters_group")
    id = PrimaryKey(int, auto=True)
    group_name = Required(str)
    mongodb_query = Required(str)
    latest_update_time = Optional(datetime)
    warning_limit = Optional(float)
    critical_limit = Optional(float)
    parameter_type = Optional(str)

    # Relationships - Many Side Of Relationship
    machine_parameters = Set('MachineParameter')
    machine_comparisons = Set('ParameterComparison')


class Unit(PONY_DATABASE.Entity):
    """Represents a physical unit."""

    _table_ = (schema_name, "units")
    id = PrimaryKey(int, auto=True)
    name = Required(str, 80)
    short_name = Required(str, 30)
    description = Optional(str)
    type = Required(str, 50)

    # Relationships - Many Side Of Relationship
    machine_parameters = Set('MachineParameter')


class MachineParameter(PONY_DATABASE.Entity):
    """Represents a machine parameter."""

    _table_ = (schema_name, "machine_parameters")
    id = PrimaryKey(int, auto=True)
    name = Required(str, 80)
    warning_limit = Optional(float, volatile=True)
    critical_limit = Optional(float, volatile=True)
    reference_signal = Optional(FloatArray)
    parameter_type = Optional(str)
    internal_parameter_name = Optional(str)
    display_name = Optional(str)

    # Relationships - One Side Of Relationship
    unit = Required(Unit, column="unit_id")
    parameter_group = Optional(ParameterGroup, column="parameter_group_id")
    machine = Required(Machine, column="machine_id")

    # Relationships - Many Side Of Relationship
    real_time_parameters = Set('RealTimeParameter')
    event_static_machine_parameters = Set('EventStaticMachineParameter')
    activities_history = Set('ActivityHistory')

    # Relationships - One Side Of Relationship (one to one relationship)
    real_time_parameter_active = Optional('RealTimeParameterActive')
    corrective_activity = Optional('CorrectiveActivity')
    ignored_parameter = Optional('IgnoredParameter')
    machine_comparisons1 = Set('ParameterComparison', reverse='machine_parameter1')
    machine_comparisons2 = Set('ParameterComparison', reverse='machine_parameter2')


class ParameterCondition(PONY_DATABASE.Entity):
    """Represents a Parameter condition."""

    _table_ = (schema_name, "parameter_conditions")
    id = PrimaryKey(int, auto=True)
    name = Required(str, 30)

    # Relationships - Many Side Of Relationship
    real_time_parameters = Set('RealTimeParameter')
    real_time_parameter_actives = Set('RealTimeParameterActive')

    corrective_activities = Set('CorrectiveActivity')
    activities_history = Set('ActivityHistory')
    machine_comparisons = Set('ParameterComparison')


class RealTimeParameter(PONY_DATABASE.Entity):
    """Represents a real time machine parameter."""

    _table_ = (schema_name, "real_time_machine_parameters")
    time = Required(datetime, auto=False)

    # This needs to be made volatile so that we can ignore the
    # UnrepeatableReadError: Object was updated outside of current transaction error
    value = Required(float, volatile=True)

    # Relationships - One Side Of Relationship
    # This needs to be made volatile so that we can ignore the
    # UnrepeatableReadError: Object was updated outside of current transaction error
    parameter_condition = Optional(ParameterCondition, column="condition_id", volatile=True)

    # This needs to be made volatile so that we can ignore the
    # UnrepeatableReadError: Object was updated outside of current transaction error
    machine_parameter = Required(MachineParameter, column="machine_parameters_id", auto=False)

    PrimaryKey(time, machine_parameter)


class Event(PONY_DATABASE.Entity):
    """Represents an event."""

    _table_ = (schema_name, "events")
    id = PrimaryKey(int, auto=True)
    name = Required(str, 50)
    description = Required(str)

    # Relationships - Many Side Of Relationship
    machine_event_timelines = Set('MachineEventTimeline')


class MachineEventTimeline(PONY_DATABASE.Entity):
    """Represents a machine event timeline."""

    _table_ = (schema_name, "machine_event_timeline")
    id = PrimaryKey(int, auto=True)
    start_time = Required(datetime)
    end_time = Optional(datetime)
    duration = Optional(timedelta)

    # Relationships - One Side Of Relationship
    event = Required(Event, column="events_id")
    machine = Required(Machine, column="machine_id")

    # Relationships - Many Side Of Relationship
    event_static_machine_parameters = Set('EventStaticMachineParameter')
    machine_production_timelines = Set('MachineProductionTimeline')


class EventStaticMachineParameter(PONY_DATABASE.Entity):
    """Represents a static machine parameter during an event."""

    _table_ = (schema_name, "event_static_machine_parameters")
    id = PrimaryKey(int, auto=True)
    value = Required(float)

    # Relationships - One Side Of Relationship
    machine_event_timeline = Required(MachineEventTimeline, column="machine_event_timeline_id")
    machine_parameter = Required(MachineParameter, column="machine_parameters_id")


class MachineProductionTimeline(PONY_DATABASE.Entity):
    """Represents a machine production timeline"""

    _table_ = (schema_name, "machine_production_timeline")
    id = PrimaryKey(int, auto=True)
    start_time = Required(datetime)
    end_time = Optional(datetime)
    part_number = Required(str, 50)
    duration = Optional(timedelta)

    # Relationships - One Side Of Relationship
    machine = Required(Machine, column="machine_id")
    machine_event_timeline = Required(MachineEventTimeline, column="machine_event_timeline_id")


class User(PONY_DATABASE.Entity):
    """Represents a User object."""

    _table_ = (schema_name, "user")
    id = PrimaryKey(int, auto=True)
    username = Required(str)
    email = Optional(str)
    full_name = Optional(str)
    disabled = Optional(bool)
    hashed_password = Required(str)
    role = Optional(str)
    company_id = Optional(int, size=64, index='idx_user_company_id')

    # One Side of the Relationship
    corrective_activities = Set('CorrectiveActivity')
    activities_history = Set('ActivityHistory')
    user_access_log = Set('UserAccessLog')
    spare_part_activities = Set('SparePartActivity')
    spare_part_activity_histories = Set('SparePartActivityHistory')


class EmailUser(PONY_DATABASE.Entity):
    """Represents the Email Id of users"""

    _table_ = (schema_name, "emailuser")

    id = PrimaryKey(int, auto=True)
    user_name = Required(str, 30)
    email_id = Required(str, 40)


class MachinePartCount(PONY_DATABASE.Entity):
    """Represents the Part Count Table of machines"""

    _table_ = (schema_name, "machinepartcount")

    id = PrimaryKey(int, auto=True)
    part_signal_name = Required(str)
    current_part_count = Required(int, size=64)
    last_reset_count = Required(int, size=64)
    latest_update_time = Optional(datetime)

    machine = Required(Machine, column="machine_id")


class RealTimeParameterActive(PONY_DATABASE.Entity):
    """Represents the Real Time Parameter Active table in the database"""

    _table_ = (schema_name, "real_time_machine_parameters_active")

    id = PrimaryKey(int, auto=True)
    time = Required(datetime, volatile=True)

    value = Required(float)

    parameter_condition = Required(ParameterCondition, column="condition_id", volatile=True)
    machine_parameter = Required(MachineParameter, column="machine_parameters_id", volatile=True)


class CorrectiveActivity(PONY_DATABASE.Entity):
    """Represents the Corrective Activity table in the database"""

    _table_ = (schema_name, "corrective_activity")

    id = PrimaryKey(int, auto=True)
    machine_parameter = Required(MachineParameter, column='machine_parameters_id', volatile=True,
                                 index='idx_machine_parameter_id')
    date_of_identification = Required(datetime, index='idx_date_of_identification')
    latest_occurrence = Required(datetime)
    target_date_of_completion = Optional(date)
    number_of_occurrences = Required(int)
    corrective_measurement = Optional(LongStr)
    spare_required = Optional(LongStr)
    support_needed = Optional(str)
    priority = Optional(str)
    recent_value = Optional(float, volatile=True)
    parameter_condition = Optional(ParameterCondition, column='parameter_condition_id')

    responsible_person = Optional(User, column='responsible_person_id')


class ActivityHistory(PONY_DATABASE.Entity):
    """Represents the Activity History table in the database"""

    _table_ = (schema_name, "activities_history")

    date_of_identification = Required(datetime)
    machine_parameter = Required(MachineParameter, column='machine_parameters_id', auto=False)
    latest_occurrence = Optional(datetime)
    target_date_of_completion = Optional(date)
    number_of_occurrences = Required(int)
    corrective_measurement = Required(LongStr)
    spare_required = Optional(LongStr)
    support_needed = Optional(str)
    responsible_person = Optional(User, column='responsible_person_id')
    actual_date_of_completion = Optional(date)
    priority = Optional(str)
    recent_value = Optional(float, volatile=True)
    parameter_condition = Optional(ParameterCondition, column='parameter_condition_id')

    PrimaryKey(date_of_identification, machine_parameter)


class IgnoredParameter(PONY_DATABASE.Entity):
    _table_ = (schema_name, "ignored_parameter")

    id = PrimaryKey(int, auto=True)
    machine_parameter = Required(MachineParameter, column='machine_parameter_id')


class UpdateLog(PONY_DATABASE.Entity):
    _table_ = (schema_name, "UpdateLog")

    user = Required(str)
    parameter_name = Required(str)
    previous_limit = Optional(float)
    limit_value = Optional(float)
    reference_signal = Optional(FloatArray)
    set_type = Required(str)
    date_changed = Required(datetime)


class ParameterComparison(PONY_DATABASE.Entity):
    _table_ = (schema_name, "parameter_comparison")

    id = PrimaryKey(int, auto=True)

    time = Required(datetime, auto=False)

    line = Required(str, 80)

    machine = Optional(Machine, column="machine_id")

    parameter_group = Optional(ParameterGroup, column="parameter_group_id")

    machine_parameter1 = Optional(MachineParameter, column="machine_parameter1_id", reverse='machine_comparisons1')

    machine_parameter2 = Optional(MachineParameter, column="machine_parameter2_id", reverse='machine_comparisons2')

    warning_limit = Optional(float, volatile=True)

    critical_limit = Optional(float, volatile=True)

    time_1 = Optional(datetime, auto=False)

    time_2 = Optional(datetime, auto=False)

    value_1 = Required(float, volatile=True)

    value_2 = Required(float, volatile=True)

    difference = Required(float, volatile=True)

    parameter_condition = Optional(ParameterCondition, column="condition_id", volatile=True)

class UserAccessLog(PONY_DATABASE.Entity):
    _table_ = (schema_name, "user_access_log")

    id = PrimaryKey(int, auto=True)
    username = Required(User, column="user_id")
    timestamp = Required(datetime)


class CycleTimeMachine(PONY_DATABASE.Entity):
    """Master list of cycle-time machines (not the MT-Linki machines table)."""

    _table_ = (schema_name, "cycle_time_machines")

    id = PrimaryKey(int)
    machine_name = Optional(str)
    line = Optional(str)

    cycle_times = Set('CycleTime')
    cycle_time_limits = Optional('CycleTimeLimits')


class CycleTime(PONY_DATABASE.Entity):
    """Represents the cycle time data for machines"""

    _table_ = (schema_name, "sql_server_mct_data")

    time = Required(datetime)
    cycle_time = Optional(float)
    machine_number = Optional(str)
    model = Optional(int)
    counter = Optional(int)
    created_at = Optional(datetime)

    machine = Required(CycleTimeMachine, column="machine_id")

    PrimaryKey(time, machine)


class CycleTimeLimits(PONY_DATABASE.Entity):
    """Represents the warning and critical limits for cycle time per machine"""

    _table_ = (schema_name, "cycle_time_limits")

    id = PrimaryKey(int, auto=True)
    machine = Required(CycleTimeMachine, column="machine_id")
    warning_limit = Required(float)
    critical_limit = Required(float)
    status = Optional(str)


class PressureMonitoringMachine(PONY_DATABASE.Entity):
    """Air-pressure machines and RMSE limits."""

    _table_ = (schema_name, "pressure_monitoring_machine")

    id = PrimaryKey(int, auto=True)
    machine_name = Required(str)
    warning_limit = Optional(float)
    critical_limit = Optional(float)
    status = Optional(str)

    log_files = Set('PressureLogFile')
    sensor_data = Set('PressureSensorData')


class PressureLogFile(PONY_DATABASE.Entity):
    """One processed pressure log file / run."""

    _table_ = (schema_name, "pressure_log_file")

    id = PrimaryKey(int, auto=True)
    file_name = Required(str)
    processed_time = Optional(datetime)
    baseline = Required(bool, default=False)
    time_stamp = Optional(datetime)
    mean_pressure = Optional(float)
    peak_pressure = Optional(float)
    start_time = Optional(datetime)
    end_time = Optional(datetime)
    cycle_duration_seconds = Optional(float)
    pressure_ripple = Optional(float)
    rmse = Optional(float)
    status = Optional(str)

    machine = Required(PressureMonitoringMachine, column="machine_id")
    sensor_data = Set('PressureSensorData')


class PressureSensorData(PONY_DATABASE.Entity):
    """Raw pressure samples. Table has no unique key; identity is approximate."""

    _table_ = (schema_name, "pressure_sensor_data")

    reading_time = Required(datetime, column="timestamp")
    pressure_value = Optional(float)
    created_at = Optional(datetime)
    machine = Required(PressureMonitoringMachine, column="machine_id")
    log_file = Required(PressureLogFile, column="log_file_id")

    PrimaryKey(reading_time, machine, log_file)


class SparePartActivity(PONY_DATABASE.Entity):
    _table_ = (schema_name, "spare_part_activity")

    id = PrimaryKey(int, auto=True)
    spare_part_name = Required(str)
    date_of_identification = Required(datetime)
    priority = Required(str)
    target_date_of_completion = Optional(date)
    corrective_measurement = Required(str)
    spare_required = Required(str)
    support_needed = Required(str)

    machine = Required(Machine, column="machine_id")
    spare_part = Required(SparePart, column="spare_part_id")
    responsible_person = Optional(User, column="responsible_person_id")


class SparePartActivityHistory(PONY_DATABASE.Entity):
    _table_ = (schema_name, "spare_part_activity_history")

    id = PrimaryKey(int, auto=True)
    spare_part_name = Required(str)
    date_of_identification = Required(datetime)
    priority = Required(str)
    target_date_of_completion = Optional(date)
    corrective_measurement = Required(str)
    spare_required = Required(str)
    support_needed = Required(str)
    date_of_completion = Optional(date)

    machine = Required(Machine, column="machine_id")
    spare_part = Required(SparePart, column="spare_part_id")
    responsible_person = Optional(User, column="responsible_person_id")


class DisconnectionHistory(PONY_DATABASE.Entity):
    _table_ = (schema_name, "disconnection_history")

    status = Required(str)
    time = Required(datetime)
    machine = Required(Machine, column="machine_id")

    PrimaryKey(machine, time)


class DisconnectionHistoryInterval(PONY_DATABASE.Entity):
    _table_ = (schema_name, "disconnection_history1")

    status = Required(str)
    start_time = Required(datetime)
    stop_time = Optional(datetime)
    machine = Required(Machine, column="machine_id")

    PrimaryKey(machine, start_time)


class VibrationMachine(PONY_DATABASE.Entity):
    _table_ = (schema_name, "vibration_machines")

    id = PrimaryKey(int, auto=True)
    machine_name = Required(str)
    location = Optional(str)
    port1 = Optional(str)
    port2 = Optional(str)
    warning = Optional(float)
    critical = Optional(float)

    logs = Set('VibrationMachineLog')
    readings = Set('VibrationData')


class VibrationMachineLog(PONY_DATABASE.Entity):
    _table_ = (schema_name, "vibration_machine_logs")

    id = PrimaryKey(int, auto=True)
    program_file_id = Optional(int)
    program_file_time = Optional(datetime)
    baseline = Required(bool, default=False)
    machine = Optional(VibrationMachine, column="machine_id")


class VibrationData(PONY_DATABASE.Entity):
    _table_ = (schema_name, "vibration_data")

    id = PrimaryKey(int, auto=True, size=64)
    timestamp = Required(datetime)
    program_file_id = Optional(int)
    port = Required(str)
    origin = Optional(str)
    created_at = Optional(datetime)
    contact_temperature = Optional(float)
    v_peak_x = Optional(float)
    v_peak_y = Optional(float)
    v_peak_z = Optional(float)
    v_rms_x = Optional(float)
    v_rms_y = Optional(float)
    v_rms_z = Optional(float)
    machine = Optional(VibrationMachine, column="machine_id")


def generate_pony_mapping(create_tables=True):
    """
    Generate Pony ORM Database Mapping to Entities.

    Parameters
    ----------
    create_tables : bool, optional
        Enable or disable creating table if it does not exist.

    Returns
    -------
    None

    """
    PONY_DATABASE.generate_mapping(create_tables=create_tables)
    LOGGER.info("Generated Mapping")


# PONY_DATABASE.bind(provider='postgres', user='postgres', password='password',
#                    host='localhost', database='postgres')
#
# PONY_DATABASE.generate_mapping(create_tables= True)

# set_sql_debug(True)


@db_session
def main():
    """

    Main Function
    ====================
    
    Main function to call appropriate functions to 

    """

    # initialize_pony()

    data = MachinePartCount(part_signal_name="PMC_D9388_D_path1_T_B_OP195A",
                            current_part_count=500,
                            last_reset_count=0,
                            latest_update_time=datetime.now(),
                            machine=Machine[2])
    commit()


if __name__ == '__main__':
    main()
