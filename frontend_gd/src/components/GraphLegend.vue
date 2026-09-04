<script setup>
import { defineProps } from 'vue';

const props = defineProps({
  data:{
    type: Object,
    default: {
      "xAxisLabel": "Timestamp",
      "xAxisValue": "2024-01-02",
      "yAxisLabel": "Temperature",
      "yAxisValue": 60,
      "xAxisUnits": "DateTime",
      "yAxisUnits": "'c"
    }
  }
});
</script>

<template>
  <div class="bg-white rounded-lg shadow-md p-6 grid grid-cols-2 gap-4 mb-4">
    <div v-for="([key, value]) in Object.entries(data)" :key="key" class="flex flex-row">
      <div class="font-semibold">{{ key }}  :  </div>
      <div> {{ value }}</div>
    </div>
  </div>
</template>
