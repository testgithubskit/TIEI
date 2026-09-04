<template>
  <div ref="chartContainer" style="width: 100%; height: 400px;"></div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue';
import Plotly from 'plotly.js-dist';
import { useSpecialPurposeMachinePositionStore } from '@/stores/SpecialPurposeMachinePositionStore';

const chartContainer = ref(null);
const specialPurposeMachinePositionStore = useSpecialPurposeMachinePositionStore();

onMounted(() => {
  if (chartContainer.value) {
    updateChart();
  }
});

watch(
  () => specialPurposeMachinePositionStore.chartData,
  () => {
    if (chartContainer.value) {
      updateChart();
    }
  },
  { deep: true }
);

function updateChart() {
  if (chartContainer.value) {
    const traces = specialPurposeMachinePositionStore.chartData.map((dataset) => {
      // Handle potential undefined or empty arrays
      const xValues = dataset.data.data || [];
      const yValues = dataset.data.position || [];

      return {
        x: xValues,
        y: yValues,
        type: 'scatter',
        mode: 'lines+markers',
        name: dataset.parameter || '', // Use part number as legend name, handle undefined case
        hovertemplate: `<b>${dataset.parameter}</b><br>PartNo: ${dataset.part} <br>Position: %{x}<br>Data: %{y}`,
        marker: {
          size: 2 // Set the size of the markers (dots)
        }
      };
    });

    const layout = {
      title: 'Stepline Chart',
      xaxis: {
        title: 'Position' // Update x-axis title to reflect position
      },
      yaxis: {
        title: 'Data' // Update y-axis title to reflect data
      },
      legend: {
        orientation: 'h'
      }
    };

    console.log('Traces:', traces); // Log the traces data for debugging
    Plotly.newPlot(chartContainer.value, traces, layout);
  }


}
</script>
@/stores/SpecialPurposeMachine