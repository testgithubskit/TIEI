<script setup>
import { ref, watchEffect, onMounted} from 'vue';
import dygraph from 'dygraphs';



const chartContainer = ref(null);
const chart = ref(null);

const props = defineProps({
  data: {
    type: Array,
    default: () => [
      [new Date(1685162998000), 100],
      [new Date(1685162998000 +  86400000), 150],
      [new Date(1685162998000 +  86400000 +  86400000) , 250]
    ],
  },
});

onMounted(() => {
  // Create the initial chart
  createChart();

  // Watch for changes in the data property and update the chart
  watchEffect(() => {
    if (chart.value) {
      // Destroy the existing chart
      chart.value.destroy();
      // Create the updated chart
      createChart();
    }
  });
});

function createChart() {
  const options = {
    labels: ['Date', 'Value'],
    strokeWidth: 3,
    fillGraph: true,
    fillAlpha: 0.3,
    drawPoints: false,
    drawGrid: false,
    animatedZooms: true,
    highlightCircleSize: 4,
    axisLineWidth: 4,
    axisLineColor: 'black',
    stepPlot: true,
    colors: ['rgb(5, 150, 105)', 'rgb(35, 140, 105)'],
  };

  if (chartContainer.value && Array.isArray(props.data)) {
    chart.value = new dygraph(chartContainer.value, props.data, options);
  }
}
</script>

<template>
  <div ref="chartContainer"></div>
</template>
