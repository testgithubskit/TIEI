<script setup>
import { computed } from "vue";
import MachineParameter from "@/components/MachineParameter.vue";

const PRESSURE_MACHINE_NAMES = new Set(['2nd Rough', '4th Finish']);

const props = defineProps({
  machineState: {
    type: String,
    default: null,
  },
  machineName: {
    type: String,
    default: null,
  },
  parameters: {
    type: Array,
    default: () => [],
  },
  isPressureMachine: {
    type: Boolean,
    default: false,
  },
  isCombinedAirHoning: {
    type: Boolean,
    default: false,
  },
  borderSide: {
    type: String,
    default: "s",
  },
  borderThickness: {
    type: String,
    default: "4",
  },
});

function isPressureParameter(parameter) {
  return parameter?.is_pressure_machine === true
    || parameter?.actual_parameter_name === 'AIR_PRESSURE';
}

const isPressureMachineCard = computed(() => {
  if (props.isCombinedAirHoning === true) {
    return false;
  }
  if (props.isPressureMachine === true) {
    return true;
  }
  if (PRESSURE_MACHINE_NAMES.has(props.machineName)) {
    return true;
  }
  return props.parameters?.some((parameter) => isPressureParameter(parameter));
});

const airHoningSignals = computed(() => {
  if (!props.isCombinedAirHoning) {
    return [];
  }

  const seen = new Set();
  return (props.parameters || []).filter((parameter) => {
    const signalName = parameter.signal_name || parameter.source_machine_name || parameter.display_name;
    if (!signalName || seen.has(signalName)) {
      return false;
    }
    seen.add(signalName);
    return true;
  });
});

const pressureParameter = computed(() => {
  return props.parameters?.find((parameter) => isPressureParameter(parameter))
    || props.parameters?.[0]
    || null;
});

const machineBgColor = computed(() => {
  return {
    OK: "bg-emerald-600",
    WARNING: "bg-yellow-600",
    CRITICAL: "bg-red-600",
    DISCONNECTED: "bg-slate-500",
    info: null,
  }[props.machineState];
});

const borderClass = computed(() => {
  return 'rounded-lg shadow-lg hover:shadow-md transition-shadow duration-10';
});

const machineWidth = computed(() => {
  if (props.isCombinedAirHoning) {
    return 'air-honing-machine-card';
  }
  if (isPressureMachineCard.value) {
    return 'pressure-machine-card';
  }

  const baseWidth = 16;
  const incrementalWidth = 8;
  const maxParameters = 6;
  const maxWidth = baseWidth + incrementalWidth * maxParameters;
  const currentWidth = baseWidth + incrementalWidth * props.parameters.length;
  const appropriateWidth = Math.min(maxWidth, currentWidth);
  return `w-${appropriateWidth}`;
});

const emit = defineEmits(['machine-parameter-clicked']);

const handleMachineParameterClick = (clickedParameter) => {
  const matchedParameter = props.parameters.find(
    (parameter) => parameter.actual_parameter_name === clickedParameter.actualParameterName
      || parameter.signal_name === clickedParameter.actualParameterName
      || parameter.source_machine_name === clickedParameter.actualParameterName
  );
  const sourceMachineName = matchedParameter?.source_machine_name
    || matchedParameter?.signal_name
    || props.machineName;

  emit('machine-parameter-clicked', {
    ...clickedParameter,
    machineName: sourceMachineName,
    displayName: matchedParameter?.display_name || matchedParameter?.signal_name || '',
    latest_update_time: matchedParameter?.latest_update_time,
    latest_update_time_ms: matchedParameter?.latest_update_time_ms,
    is_pressure_machine: props.isCombinedAirHoning || isPressureParameter(matchedParameter),
  });
};

const handleAirHoningSignalClick = (parameter) => {
  emit('machine-parameter-clicked', {
    actualParameterName: 'AIR_PRESSURE',
    internalParameterName: parameter?.internal_parameter_name,
    machineName: parameter?.source_machine_name || parameter?.signal_name || props.machineName,
    displayName: parameter?.signal_name || parameter?.display_name || '',
    latest_update_time: parameter?.latest_update_time,
    latest_update_time_ms: parameter?.latest_update_time_ms,
    is_pressure_machine: true,
  });
};

const handlePressureMachineClick = () => {
  const parameter = pressureParameter.value;

  emit('machine-parameter-clicked', {
    actualParameterName: 'AIR_PRESSURE',
    internalParameterName: parameter?.internal_parameter_name,
    machineName: props.machineName,
    displayName: '',
    latest_update_time: parameter?.latest_update_time,
    latest_update_time_ms: parameter?.latest_update_time_ms,
    is_pressure_machine: true,
  });
};

const handleCardClick = () => {
  if (props.isCombinedAirHoning) {
    const preferred = airHoningSignals.value.find((parameter) => (
      parameter.parameter_state === 'CRITICAL' || parameter.parameter_state === 'WARNING'
    )) || airHoningSignals.value[0] || pressureParameter.value;
    if (preferred) {
      handleAirHoningSignalClick(preferred);
    }
    return;
  }
  if (isPressureMachineCard.value) {
    handlePressureMachineClick();
  }
};

</script>

<template>
  <div
    :class="[machineWidth, borderClass, 'flex flex-col mx-0', { 'cursor-pointer': isPressureMachineCard || isCombinedAirHoning }]"
    @click="handleCardClick"
  >
    <div
      class="p-4 rounded-t-lg text-white text-center h-5 flex items-center justify-center"
      :class="machineBgColor"
    >
      {{ props.machineName }}
    </div>
    <div v-if="isCombinedAirHoning" class="grid grid-cols-2 gap-1 p-1" @click.stop>
      <button
        v-for="parameter in airHoningSignals"
        :key="parameter.signal_name || parameter.internal_parameter_name"
        type="button"
        class="air-honing-signal-chip text-white text-[11px] font-semibold px-2 rounded"
        :class="{
          'bg-emerald-600': (parameter.parameter_state || machineState) === 'OK',
          'bg-yellow-600': (parameter.parameter_state || machineState) === 'WARNING',
          'bg-red-600': (parameter.parameter_state || machineState) === 'CRITICAL',
          'bg-slate-500': (parameter.parameter_state || machineState) === 'DISCONNECTED',
        }"
        :title="parameter.signal_name || parameter.display_name"
        @click="handleAirHoningSignalClick(parameter)"
      >
        {{ parameter.signal_name || parameter.display_name }}
      </button>
    </div>
    <div v-else-if="!isPressureMachineCard" class="flex flex-wrap justify-start">
      <MachineParameter
        v-for="parameter in props.parameters"
        :key="parameter.internal_parameter_name"
        :parameterState="parameter.parameter_state"
        :parameterValue="parameter.parameter_value"
        :actualParameterName="parameter.actual_parameter_name"
        :internalParameterName="parameter.internal_parameter_name"
        :displayName="parameter.display_name"
        :lastestUpdateTime="parameter.latest_update_time"
        @machine-parameter-clicked="handleMachineParameterClick"
      />
    </div>
    <div v-else class="flex flex-wrap justify-start min-h-[2.5rem] pressure-machine-card__body" />
  </div>
</template>

<style scoped>
/* Match width of a typical 5-axis machine card (e.g. T_B_OP160) */
.pressure-machine-card {
  width: 14rem;
  min-width: 14rem;
}

.air-honing-machine-card {
  width: 16rem;
  min-width: 16rem;
}

.pressure-machine-card__body {
  min-height: 2.5rem;
}

.air-honing-signal-chip {
  width: 100%;
  min-width: 0;
  height: 2rem;
  line-height: 1.1;
  white-space: nowrap;
}
</style>
