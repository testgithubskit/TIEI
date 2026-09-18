<script setup>
import { computed } from 'vue';
import MachineWithParameters from "@/components/MachineWithParameters.vue";
import { combineAirHoningSignals, recountMachineStates } from '@/services/airHoningUtils';

const props = defineProps({
  lineName: {
    type: String,
    default: "Line A",
  },
  lineState: {
    type: String,
    default: "normal",
  },
  count: {
    type: Object,
    default: {
      "OK": 0,
      "WARNING": 0,
      "CRITICAL": 0,
      "DISCONNECTED": 0,
    },
  },
  machines: {
    type: Array,
    default: () => [],
  },
  highlightPressureMachines: {
    type: Boolean,
    default: false,
  },
});

const borderClass = 'rounded-lg shadow-lg  hover:shadow-md transition-shadow duration-10';

const bgColor = computed(() => {
  return {
    OK: "bg-emerald-600",
    WARNING: "bg-yellow-600",
    CRITICAL: "bg-red-600",
    DISCONNECTED:"bg-slate-500"
    
  }[props.lineState];
});

const displayMachines = computed(() => {
  const combined = combineAirHoningSignals(props.machines || []);
  const pressureMachines = combined.filter((machine) => machine.is_pressure_machine === true || machine.is_combined_air_honing === true);
  const otherMachines = combined.filter((machine) => !(machine.is_pressure_machine === true || machine.is_combined_air_honing === true));

  if (props.highlightPressureMachines && props.lineName === 'BLOCK') {
    return pressureMachines;
  }

  return [...pressureMachines, ...otherMachines];
});

const displayCount = computed(() => recountMachineStates(displayMachines.value));

const emit = defineEmits(['machine-parameter-clicked']);

const handleMachineParameterClick = (clickedParameter) => {
  emit('machine-parameter-clicked', clickedParameter);
};

</script>

<template>
  <div :class="borderClass" class="flex flex-col mb-4 pb-4">
    <div :class="[bgColor, 'p-4 rounded-t-lg text-white text-center h-30 flex items-center font-bold justify-center mb-4']">
      <span>LINE: {{ lineName }}</span>
      <span class="ml-2">Total: {{ displayCount.OK + displayCount.WARNING + displayCount.CRITICAL + displayCount.DISCONNECTED }}</span>
      <div class="flex items-center ml-4">
        <span class="mr-2">OK: {{ displayCount.OK }}</span>
        <span class="mr-2">WARNING: {{ displayCount.WARNING }}</span>
        <span class="mr-2">CRITICAL: {{ displayCount.CRITICAL }}</span>
        <span>DISCONNECTED: {{ displayCount.DISCONNECTED }}</span>
      </div>
    </div>
    <div class="flex flex-wrap justify-start gap-4 px-4">
      <MachineWithParameters
        v-for="machine in displayMachines"
        :key="machine.machine_name"
        :machineName="machine.machine_name"
        :machineState="machine.machine_state"
        :parameters="machine.parameters"
        :ports="machine.ports || []"
        :isPressureMachine="machine.is_pressure_machine === true || machine.is_combined_air_honing === true"
        :isCombinedAirHoning="machine.is_combined_air_honing === true"
        :isCombinedVibration="machine.is_combined_vibration === true || machine.is_vibration_machine === true"
        @machine-parameter-clicked="handleMachineParameterClick"
      />
    </div>
  </div>
</template>

<style scoped>
/* Add any additional styling here */
</style>
