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
    return "-";
  }
  return `${props.cycleTime.toFixed(2)}s`;
});

const cardMinWidth = computed(() => {
  const nameLength = (props.machineName || "").length;
  const widthPx = Math.max(112, Math.min(nameLength * 9 + 40, 320));
  return `${widthPx}px`;
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
  <div :class="borderClass" class="flex flex-col mx-0" :style="{ minWidth: cardMinWidth, width: cardMinWidth }" @click="handleMachineClick">
    <div class="px-3 py-2 rounded-t-lg text-white text-center flex items-center justify-center font-semibold text-sm whitespace-nowrap" :class="machineBgColor">{{ props.machineName }}</div>
    <div class="p-3 text-center font-medium font-sans flex-grow flex items-center justify-center">
      <div>
        <div class="text-xs text-gray-500 mb-1">Cycle Time</div>
        <div class="text-lg font-bold">{{ cycleTimeDisplay }}</div>
      </div>
    </div>
  </div>
</template>
