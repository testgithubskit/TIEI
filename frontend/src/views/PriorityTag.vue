<template>
    <span
      :class="[
        'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium',
        priorityClasses[priority.toLowerCase()]
      ]"
    >
      {{ priority }}
    </span>
  </template>
  
  <script setup>
  const props = defineProps({
    priority: {
      type: String,
      required: true
    }
  });
  
  const priorityClasses = {
    critical: 'bg-pink-100 text-pink-800',
    high: 'bg-red-100 text-red-800',
    medium: 'bg-yellow-100 text-yellow-800',
    low: 'bg-green-100 text-green-800'
  };
  </script>