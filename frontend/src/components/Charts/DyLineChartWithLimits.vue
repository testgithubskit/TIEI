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
      [1685162998000, 50],
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

function toChartDate(x) {
  if (typeof x === 'number') {
    return new Date(x);
  }
  const text = String(x).trim();
  if (!text) {
    return new Date(Number.NaN);
  }
  const isoLike = text.includes('T') ? text : text.replace(' ', 'T');
  return new Date(isoLike.includes('+') ? isoLike : `${isoLike}+05:30`);
}

const usesIstDateStrings = computed(() => (
  props.data?.length > 0 && typeof props.data[0][0] === 'string'
));

const computedData = computed(() => {
  if (!props.data?.length) {
    return [];
  }
  return props.data.map(([timeValue, value]) => {
    const date = toChartDate(timeValue);
    return [date, value, props.warningLimit, props.criticalLimit];
  });
});

function formatAxisTime(ms) {
  const d = new Date(ms);
  const pad = (n, len = 2) => String(n).padStart(len, '0');
  return `${pad(d.getHours())}:${pad(d.getMinutes())}:${pad(d.getSeconds())}`;
}

onMounted(() => {
  watchEffect(() => {
    computedData.value;
    usesIstDateStrings.value;
    props.warningLimit;
    props.criticalLimit;
    createChart();
  });
});

function handleHover(event, x, points, row, seriesName) {
  emit('data-hovered', points);
}

function createChart() {
  if (chart.value) {
    chart.value.destroy();
    chart.value = null;
  }

  if (!chartContainer.value || !computedData.value.length) {
    return;
  }

  const options = {
    labels: ['Date', 'Value', 'Warning Limit', 'Critical Limit'],
    strokeWidth: 3,
    strokeBorderWidth: 1,
    fillGraph: true,
    fillAlpha: 0.3,
    drawPoints: false,
    drawGrid: false,
    animatedZooms: true,
    highlightCircleSize: 4,
    axisLineWidth: 4,
    axisLineColor: 'black',
    stepPlot: true,
    colors: ['rgb(5, 150, 105)', 'rgb(255, 153, 51)', 'rgb(255, 0, 0)'],
    showLabelsOnHighlight: false,
    highlightCallback: handleHover,
    ...(usesIstDateStrings.value ? {
      axes: {
        x: {
          pixelsPerLabel: 55,
          axisLabelFormatter: (ms) => formatAxisTime(ms),
        },
        y: {
          axisLabelFormatter: (y) => String(Math.round(y)),
        },
      },
    } : {}),
  };

  chart.value = new dygraph(chartContainer.value, computedData.value, options);
}
</script>

<template>
  <div ref="chartContainer"></div>
</template>
