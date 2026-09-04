<template>
  <button @click="handleButtonClick" class="btn">
    Selected Machine: {{ homeStore.selectedMachine }}
  </button>
  <hr>
  <br>
  <hr>
  <button @click="handleButtonClick" class="btn">
    oee: {{ homeStore.sections[2].subSections[3].components[0] }}
  </button>
</template>

<script setup>
import { useHomeStore } from '@/stores/homeStore';

const homeStore = useHomeStore();

const handleButtonClick = () => {
  // Handle button click event
  // You can perform any desired actions here
  console.log('Calling randomize');
  homeStore.randomizeValues();
  console.log('Called randomize');
};
</script>

<style scoped>
.btn {
  background-color: #4a4a4a;
  color: white;
  padding: 8px 16px;
  border-radius: 4px;
  cursor: pointer;
}
</style>
