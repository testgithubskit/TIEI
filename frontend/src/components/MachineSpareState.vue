<script setup>
import { computed } from "vue";

const props = defineProps({
  machineState: {
    type: String,
    default: "OK",
  },
  machineName: {
    type: String,
    default: "Machine 1",
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
    OK: "bg-emerald-600",
    WARNING: "bg-yellow-600",
    CRITICAL: "bg-red-600",
  }[props.machineState];
});

const borderClass = computed(() => {
  return `rounded-lg shadow-lg  hover:shadow-md transition-shadow duration-10`;
});

function replaceUnderscoresWithSpaces(str) {
  return str.replace(/_/g, " ");
}

const emit = defineEmits(['machine-parameter-clicked']);

const handleMachineParameterClick = (clickedParameter) => {
  // Perform any necessary actions with the updated parameters
  emit('machine-parameter-clicked', clickedParameter);
};

</script>

<template>
  <div :class="borderClass" class="flex flex-col">
    <div class="p-4 rounded-lg text-white text-center h-30 flex items-center justify-center w-32" :class="bgColor" 
    @click="handleMachineParameterClick(props.machineName)">{{ replaceUnderscoresWithSpaces(props.machineName) }}</div>
  </div>
</template>
