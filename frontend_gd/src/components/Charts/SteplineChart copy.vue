<template>
  <div ref="chartContainer" style="width: 100%; height: 400px;"></div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue';
import Plotly from 'plotly.js-dist';

const chartContainer = ref(null);
const props = defineProps(['data']);

onMounted(() => {
  if (chartContainer.value) {
    updateChart();
  }
});

watch(
  () => props.data,
  () => {
    if (chartContainer.value) {
      updateChart();
    }
  },
  { deep: true }
);

function updateChart() {
  if (chartContainer.value) {
    const traces = props.data.map((dataset) => ({
      x: dataset.timestamps,
      y: dataset.data,
      type: 'scatter',
      mode: 'lines+markers',
      name: dataset.machine
    }));

    const layout = {
      title: 'Stepline Chart',
      xaxis: {
        title: 'Timestamp'
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
</script>
