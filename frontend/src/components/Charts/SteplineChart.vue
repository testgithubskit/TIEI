<template>
  <div ref="chartContainer" class="spm-step-chart"></div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount, watch } from 'vue';
import Plotly from 'plotly.js-dist';
import { useSpecialPurposeMachineDetailStore } from '../../stores/SpecialPurposeMachineDetailStore';

const chartContainer = ref(null);
const specialPurposeMachineDetailStore = useSpecialPurposeMachineDetailStore();
let resizeObserver = null;

onMounted(() => {
  updateChart();
  if (typeof ResizeObserver !== 'undefined' && chartContainer.value) {
    resizeObserver = new ResizeObserver(() => {
      if (chartContainer.value) {
        Plotly.Plots.resize(chartContainer.value);
      }
    });
    resizeObserver.observe(chartContainer.value);
  }
});

onBeforeUnmount(() => {
  if (resizeObserver) {
    resizeObserver.disconnect();
    resizeObserver = null;
  }
});

watch(
  () => specialPurposeMachineDetailStore.chartData,
  () => {
    updateChart();
  },
  { deep: true }
);

function updateChart() {
  if (!chartContainer.value) return;

  const datasets = specialPurposeMachineDetailStore.chartData || [];
  const traces = datasets.map((dataset) => ({
    x: (dataset.timestamps || []).map(timestampToDatetime),
    y: dataset.data || [],
    type: 'scatter',
    mode: 'lines+markers',
    name: dataset.axis || dataset.machine,
    hovertemplate: `<b>${dataset.axis || dataset.machine}</b><br>Date: %{x}<br>Value: %{y}<extra></extra>`,
  }));

  const layout = {
    title: 'Stepline Chart',
    xaxis: {
      title: 'Timestamp',
      tickformat: '%Y-%m-%d %H:%M:%S',
    },
    yaxis: {
      title: 'Value',
    },
    legend: {
      orientation: 'h',
    },
    autosize: true,
  };

  Plotly.react(chartContainer.value, traces, layout, {
    responsive: true,
    displayModeBar: false,
  });
}

function timestampToDatetime(timestamp) {
  const date = new Date(timestamp);
  return date.toISOString();
}
</script>

<style scoped>
.spm-step-chart {
  width: 100%;
  height: 400px;
}
</style>
