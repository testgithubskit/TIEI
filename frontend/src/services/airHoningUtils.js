const AIR_HONING_SIGNAL_NAMES = new Set(['2nd Rough', '4th Finish']);

const MACHINE_STATE_PRIORITY = {
  OK: 0,
  DISCONNECTED: 1,
  WARNING: 2,
  CRITICAL: 3,
};

export function isAirHoningSignalMachine(machine) {
  return machine?.is_pressure_machine === true
    || AIR_HONING_SIGNAL_NAMES.has(machine?.machine_name);
}

/**
 * Merge 2nd Rough / 4th Finish into a single Air Honing machine with two signals.
 */
export function combineAirHoningSignals(rawMachines = []) {
  const machines = Array.isArray(rawMachines) ? rawMachines : [];
  const signalMachines = machines.filter((machine) => isAirHoningSignalMachine(machine));

  if (signalMachines.length <= 1) {
    return machines.map((machine) => ({ ...machine }));
  }

  const firstSignalIndex = machines.findIndex((machine) => signalMachines.includes(machine));
  const parameters = signalMachines.flatMap((machine) => {
    const params = machine.parameters || [];
    if (params.length === 0) {
      return [{
        actual_parameter_name: 'AIR_PRESSURE',
        internal_parameter_name: machine.machine_name,
        display_name: machine.machine_name,
        parameter_state: machine.machine_state || 'OK',
        parameter_value: null,
        latest_update_time: machine.latest_update_time,
        latest_update_time_ms: machine.latest_update_time_ms,
        source_machine_name: machine.machine_name,
        signal_name: machine.machine_name,
        is_pressure_machine: true,
      }];
    }

    return params.map((parameter) => ({
      ...parameter,
      display_name: parameter.display_name || machine.machine_name,
      source_machine_name: machine.machine_name,
      signal_name: machine.machine_name,
      is_pressure_machine: true,
    }));
  });

  const machineState = signalMachines.reduce((highestState, machine) => {
    const candidate = machine.machine_state || 'OK';
    return (MACHINE_STATE_PRIORITY[candidate] || 0) > (MACHINE_STATE_PRIORITY[highestState] || 0)
      ? candidate
      : highestState;
  }, 'OK');

  const combinedMachine = {
    machine_name: 'Air Honing',
    machine_state: machineState,
    parameters,
    is_pressure_machine: true,
    is_combined_air_honing: true,
  };

  const physicalMachines = machines
    .filter((machine) => !signalMachines.includes(machine))
    .map((machine) => ({ ...machine }));
  physicalMachines.splice(Math.max(0, firstSignalIndex), 0, combinedMachine);
  return physicalMachines;
}

export function recountMachineStates(machines = []) {
  const counts = { OK: 0, WARNING: 0, CRITICAL: 0, DISCONNECTED: 0 };
  machines.forEach((machine) => {
    const state = machine.machine_state || 'OK';
    if (counts[state] !== undefined) {
      counts[state] += 1;
    }
  });
  return counts;
}
