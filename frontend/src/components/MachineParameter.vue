<script setup>
import { computed, ref } from "vue";

const props = defineProps({
  parameterState: {
    type: String,
    default: null,
  },
  parameterValue: {
    type: Number,
    default: null,
  },
  actualParameterName: {
    type: String,
    default: "s",
  },
  internalParameterName: {
    type: String,
    default: "4",
  },
  displayName: {
    type: String,
    default: "X",
  },
  lastestUpdateTime: {
    type: Number,
    default: 1702356875000, //in epoch time stamp in milli seconds
  },
});

const bgColor = computed(() => {
  return {
    OK: "bg-emerald-600",
    WARNING: "bg-yellow-600",
    CRITICAL: "bg-red-600",
    DISCONNECTED:"bg-slate-500"
  }[props.parameterState];
});

const borderClass = computed(() => {
  return `rounded-lg`;
});

const emit = defineEmits(['machine-parameter-clicked']);

let showHoverDetails = ref(false);

let spanText = `Parameter: ${props.actualParameterName} Value: ${props.parameterValue} Latest UpdateTime: ${new Date(props.lastestUpdateTime).toLocaleString()}`;

const handleClick = () => {
  emit('machine-parameter-clicked', { actualParameterName: props.actualParameterName });
};

</script>

<template>
  <div class="relative">
    <div
      class="p-4 rounded-lg text-white text-center text-xs h-8 w-8 m-1 flex items-center justify-center"
      :class="bgColor"
      @mouseenter="showHoverDetails = true"
      @mouseleave="showHoverDetails = false"
      @click="handleClick"
    >
      {{ props.displayName }}
      <div
      v-if="showHoverDetails"
      class="absolute z-50 bg-black text-white text-center rounded w-80 py-5 px-0 flex flex-col items-center justify-center"
      :style="{ top: 'calc(100% + 10px)', left: '50%', transform: 'translateX(-50%)' }"
    >
      <div >{{ props.actualParameterName }}</div>
      <div>Value: {{ props.parameterValue }}</div>
      <div>Updated Time: {{ new Date(props.lastestUpdateTime).toLocaleString() }}</div>
    </div>
    </div>
    
  </div>
</template>
