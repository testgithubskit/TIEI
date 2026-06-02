<script setup>
import { ref, computed } from 'vue';

const props = defineProps({
  machineName: String,
  machineColor: String,
  parameter: Number,
});
</script>

<template>
  <div :style="{ borderTopColor: machineColor }" class="border-t p-4">
    <h3>{{ machineName }}</h3>
    <p>Parameter: {{ parameter }}</p>
  </div>
</template>