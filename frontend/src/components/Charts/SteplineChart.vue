<template>
  <div ref="chartContainer" style="width: 100%; height: 400px;"></div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue';
import Plotly from 'plotly.js-dist';
import { useSpecialPurposeMachineDetailStore } from '../../stores/SpecialPurposeMachineDetailStore'; // Adjust the import path as per your project structure

const chartContainer = ref(null);
const specialPurposeMachineDetailStore = useSpecialPurposeMachineDetailStore();

onMounted(() => {
  if (chartContainer.value) {
    updateChart();
  }
});

watch(
  () => specialPurposeMachineDetailStore.chartData,
  () => {
    if (chartContainer.value) {
      updateChart();
    }
  },
  { deep: true }
);

function updateChart() {
  if (chartContainer.value) {
    const traces = specialPurposeMachineDetailStore.chartData.map((dataset) => ({
      x: dataset.timestamps.map(timestampToDatetime), // Convert timestamps to date and time format
      y: dataset.data,
      type: 'scatter',
      mode: 'lines+markers',
      name: dataset.machine,
      hovertemplate: `<b>${dataset.machine}</b><br>Date: %{x}<br>Value: %{y}`
    }));

    const layout = {
      title: 'Stepline Chart',
      xaxis: {
        title: 'Timestamp',
        tickformat: '%Y-%m-%d %H:%M:%S' // Format x-axis ticks as date and time
      },
      yaxis: {
        title: 'Value'
      },
      legend: {
        orientation: 'h'
      }
    };

    Plotly.newPlot(chartContainer.value, traces, layout);
  }
}

// Function to convert epoch timestamp to date and time format
function timestampToDatetime(timestamp) {
  const date = new Date(timestamp);
  return date.toISOString(); // You can adjust the date format as per your preference
}
</script>
