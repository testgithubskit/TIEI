<!-- src/components/MachineCard.vue -->

<template>
    <div
      class="p-4 rounded-lg shadow-lg transform transition-transform duration-300 hover:scale-105 relative overflow-hidden"
      :class="bgColor"
    >
      <Tooltip :title="`Last updated: ${machine.updatedate}`">
        <div class="flex flex-col items-center">
          <p class="text-lg font-semibold text-white">{{ category }}: {{ machine.L1Name }}</p>
          <p class="text-sm text-white mt-1">Status: Disconnected</p>
        </div>
      </Tooltip>
      <!-- Optional: Add an icon or indicator for better UI -->
      <div class="absolute top-2 right-2">
        <span
          :class="indicatorColor"
          class="inline-block w-3 h-3 rounded-full"
        ></span>
      </div>
    </div>
  </template>
  
  <script setup>
  import { computed } from 'vue';
  import { Tooltip } from 'ant-design-vue';
  import 'ant-design-vue/es/tooltip/style'; // Corrected import
  
  const props = defineProps({
    category: {
      type: String,
      required: true,
    },
    machine: {
      type: Object,
      required: true,
    },
  });
  
  // Determine background color based on machine status
  const bgColor = computed(() => {
    return machine.value === 'true' ? 'bg-red-500' : 'bg-green-500';
  });
  
  // Indicator color for status
  const indicatorColor = computed(() => {
    return machine.value === 'true' ? 'bg-red-400' : 'bg-green-400';
  });
  </script>
  
  <style scoped>
  /* Add any additional styles or animations if needed */
  </style>
  