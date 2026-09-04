<template>
  <div ref="chartContainer" style="width: 100%; height: 400px;"></div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue';
import * as echarts from 'echarts';

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
  const chart = echarts.init(chartContainer.value);

  const option = {
    title: {
      text: 'Stepline Chart'
    },
    tooltip: {
      trigger: 'axis'
    },
    legend: {
      data: props.data.map((dataset) => dataset.machine)
    },
    xAxis: {
      type: 'category',
      data: props.data[0].timestamps // Assuming timestamps are the same for all datasets
    },
    yAxis: {
      type: 'value'
    },
    series: props.data.map((dataset) => ({
      name: dataset.machine,
      type: 'line',
      step: 'start',
      data: dataset.data
    }))
  };

  chart.setOption(option);
}
</script>
