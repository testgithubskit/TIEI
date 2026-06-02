<template>
  <v-chart class="chart" :option="option" autoresize />
</template>

<script setup>
import { useBarChart } from '@/stores/Barchart'; // Import the useBarChart store

const { machineData, fetchMachineData } = useBarChart(); // Destructure machineData and fetchMachineData from the store

// Fetch machine data when the component is mounted
onMounted(() => {
  fetchMachineData('machineName', selectedDates.from, selectedDates.to)
    .then((data) => {
      console.log('Machine data fetched:', data);
    })
    .catch((error) => {
      console.error('Error fetching machine data:', error);
    });
});

// Watch for changes in machineData and update the chart
watch(machineData, (newValue) => {
  // Update the chart options using the fetched data
  option.value.dataset.source = newValue.map(item => ({
    parameter_group_name: item.parameter_group_name,
    'Abnormality Total': item.total_abnormality,
    'Warning': item.warning,
    'Critical': item.critical
  }));
});

const option = ref({
  legend: {},
  tooltip: {},
  dataset: {
    dimensions: ['parameter_group_name', 'Abnormality Total', 'Warning', 'Critical'],
    source: []
  },
  xAxis: { type: 'category' },
  yAxis: {},
  series: [
    { type: 'bar' },
    { type: 'bar' },
    { type: 'bar' }
  ]
});
</script>

<style scoped>
/* Add your custom styles here */
</style>
