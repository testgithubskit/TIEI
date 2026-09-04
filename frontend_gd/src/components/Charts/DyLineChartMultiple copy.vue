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
      [1685162998000, 50], // Epoch timestamp and value for series 1
      [1685162998000 + 86400000, 75],
      [1685162998000 + 2 * 86400000, 100]
    ],
  },
  warningLimit: {
    type: Number,
    default: 100,
  },
  criticalLimit: {
    type: Number,
    default: 250,
  },
});

// Additional data series
const additionalSeries = [
  [1685162998000, 60], // Epoch timestamp and value for series 2
  [1685162998000 + 86400000, 80],
  [1685162998000 + 2 * 86400000, 110],
  [1685162998000 + 2 * 86400000, 110],
];
// Additional data series
const additionalSeries2 = [
  [1685162998000, 60], // Epoch timestamp and value for series 2
  [1685162998000 + 76100000, 80],
  [1685162998000 + 2 * 76100000, 110],
  [1685162998000 + 7 * 76100000, 110],
];

const computedData = computed(() => {
  let graphDataWithLimits = props.data.map(([epoch, value]) => {
    const date = new Date(epoch);
    return [date, value, props.warningLimit, props.criticalLimit];
  });

  // Process additional data series
  let additionalDataWithLimits = additionalSeries.map(([epoch, value]) => {
    const date = new Date(epoch);
    return [date, value, props.warningLimit, props.criticalLimit];
  });
 

  // Merge additional series with existing data
  return [...graphDataWithLimits, ...additionalDataWithLimits];
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
    labels: ['Date', 'Value', "Warning Limit", "Critical Limit"],
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
    colors: ['rgb(5, 150, 105)', 'rgb(255, 153, 51)', 'rgb(255, 0, 0)', 'rgb(0, 0, 255)'], // Added color for additional series
    showLabelsOnHighlight: false,
    highlightCallback: handleHover 
  };

  if (chartContainer.value && Array.isArray(computedData.value)) {
    chart.value = new dygraph(chartContainer.value, computedData.value, options);
  }
}
</script>
