<script setup>
import { computed } from "vue";

const props = defineProps({
  machineState: {
    type: String,
    default: null,
  },
  machineName: {
    type: String,
    default: null,
  },
  cycleTime: {
    type: Number,
    default: null,
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

const emit = defineEmits(['machine-clicked']);

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
  return `rounded-lg shadow-lg hover:shadow-md transition-shadow duration-10 cursor-pointer`;
});

const borderColor = computed(() => {
  return {
    OK: "emerald-600",
    WARNING: "yellow-600",
    CRITICAL: "red-600",
    DISCONNECTED: "bg-slate-500",
  }[props.machineState];
});

const cycleTimeDisplay = computed(() => {
  if (props.cycleTime === null || props.cycleTime === undefined) {
    return "N/A";
  }
  return `${props.cycleTime.toFixed(2)}s`;
});

const handleMachineClick = () => {
  emit('machine-clicked', {
    machineName: props.machineName,
    actualParameterName: 'CYCLE_TIME',
    internalParameterName: 'CYCLE_TIME'
  });
};
</script>

<template>
  <div :class="['w-24', borderClass]" class="flex flex-col mx-0" @click="handleMachineClick">
    <div class="p-4 rounded-t-lg text-white text-center h-5 flex items-center justify-center" :class="machineBgColor">{{ props.machineName }}</div>
    <div class="p-4 text-center font-medium font-sans flex-grow flex items-center justify-center">
      <div>
        <div class="text-xs text-gray-500 mb-1">Cycle Time</div>
        <div class="text-lg font-bold">{{ cycleTimeDisplay }}</div>
      </div>
    </div>
  </div>
</template>
