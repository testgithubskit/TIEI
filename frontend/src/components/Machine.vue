<script setup>
import { computed } from "vue";
import { mdiTrendingDown, mdiTrendingUp, mdiTrendingNeutral } from "@mdi/js";
import BaseIcon from "@/components/BaseIcon.vue";

const props = defineProps({
  machineState: {
    type: String,
    default: null,
  },
  label: {
    type: String,
    default: null,
  },
  parameterValue: {
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

const bgColor = computed(() => {
  return {
    normal: "bg-emerald-600",
    warning: "bg-yellow-600",
    critical: "bg-red-600",
    info: null,
  }[props.machineState];
});

const borderClass = computed(() => {
  return `rounded-lg shadow-lg  hover:shadow-md transition-shadow duration-10`;
});

const borderColor = computed(() => {
  return {
    normal: "emerald-600",
    warning: "yellow-600",
    critical: "red-600",
    info: null,
  }[props.machineState];
});
</script>

<template>
  <div :class="borderClass" class="flex flex-col">
    <div class="p-4 rounded-t-lg text-white text-center h-30 flex items-center justify-center" :class="bgColor">{{ props.label }}</div>
    <div class="p-4 text-center font-medium font-sans flex-grow">{{ props.parameterValue }}</div>
  </div>
</template>