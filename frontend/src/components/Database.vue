<template>
    <div class=" ">
      <div class="flex justify-center items-center p-4 rounded-lg shadow-lg h-fit w-fit bg-emerald-500">
        <p class="text-2xl font-semibold text-center text-white">{{ displaySchemaName }}</p>
      </div>
    </div>
  </template>
  
  <script setup>
  import { onMounted, computed } from 'vue';
  import { useDatabaseName } from '@/stores/DatabaseName';
  
  const DatabaseName = useDatabaseName();
  
  onMounted(async () => {
    await DatabaseName.fetchSchemaName();
  });
  
  // Computed property to display different text based on schemaName
  const displaySchemaName = computed(() => {
    const schemaName = DatabaseName.schemaName;
    if (schemaName === 'tiei_sample_4') {
      return 'TNGA PLANT';
    } else if (schemaName === 'tiei_gd_plant_1') {
      return 'GD PLANT';
    } else {
      return schemaName; // Fallback to display the original schemaName if not matching the conditions
    }
  });
  </script>
  
  <style>
  /* Add any custom styles here */
  </style>
  