<template>
    <button @click="toggleRoute" class="px-4 py-2 flex items-center justify-center gap-2 bg-emerald-500 text-white rounded hover:bg-emerald-700 transition-all hover:scale-105">
      {{ buttonText }}
      <CircleArrowRight />
    </button>
  </template>
  
  <script setup>
  import { useRoute, useRouter } from 'vue-router';
  import { computed } from 'vue';
  import { CircleArrowRight } from 'lucide-vue-next';
  const route = useRoute();
  const router = useRouter();
  
  const buttonText = computed(() => {
    return route.path === '/managerialOverview' ? 'Go to Graphical Overview' : 'Go to Managerial Overview';
  });
  
  const toggleRoute = () => {
    if (route.path === '/managerialOverview') {
      router.push('/graphicalOverview');
    } else {
      router.push('/managerialOverview');
    }
  };
  </script>
  
  <style scoped>
  /* Add any additional styles here */
  </style>
  