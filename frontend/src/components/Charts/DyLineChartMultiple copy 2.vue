<template>
  <div ref="chartContainer"></div>
</template>

<script setup>
import { ref, watchEffect, onMounted, defineProps, computed, defineEmits } from 'vue';
import dygraph from 'dygraphs';

const chartContainer = ref(null);
const chart = ref(null);

const emit = defineEmits(['data-hovered']);

const props = defineProps({
  data: {
    type: Array,
    default: () => [
      [1685162998000, 50, 55], // Epoch timestamp and value for series 1
      [1685162998000 + 86400000, 75, 80],
      [1685162998000 + 2 * 86400000, 100, 105]
    ],
  }
});

// Additional data series
const additionalSeries = [
  [1685162998000, 60], // Epoch timestamp and value for series 2
  [1685162998000 + 86400000, 80],
  [1685162998000 + 2 * 86400000, 110],
  [1685162998000 + 2 * 86400000, 110],
];

const computedData = computed(() => {
  let graphData = props.data.map(([epoch, value1, value2]) => {
    const date = new Date(epoch);
    return [date, value1, value2];
  });

  // Merge additional series with existing data
  return graphData
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

function handleHover(event, x, points, row, seriesName) {
  emit('data-hovered', points);
}

function createChart() {
  let options = {
    labels: ['Date', 'Value'],
    strokeWidth: 3,
    // fillGraph: true,
    fillAlpha: 0.3,
    drawPoints: false,
    drawGrid: false,
    animatedZooms: true,
    highlightCircleSize: 4,
    axisLineWidth: 4,
    axisLineColor: 'black',
    stepPlot: true, // Added color for additional series
    showLabelsOnHighlight: false,
    highlightCallback: handleHover 
  };

  if (chartContainer.value && Array.isArray(computedData.value)) {
    chart.value = new dygraph(chartContainer.value, computedData.value, options);
  }
}
</script>
