<script setup>
import * as echarts from 'echarts/core';
import {
  ToolboxComponent,
  TooltipComponent,
  GridComponent,
  LegendComponent
} from 'echarts/components';
import { LineChart } from 'echarts/charts';
import { UniversalTransition } from 'echarts/features';
import { CanvasRenderer } from 'echarts/renderers';
import { ref, onMounted, watch } from 'vue';

echarts.use([
  ToolboxComponent,
  TooltipComponent,
  GridComponent,
  LegendComponent,
  LineChart,
  CanvasRenderer,
  UniversalTransition
]);

const chartContainer = ref(null);
let myChart = null;

const generateRandomData = () => {
  const data = [];
  for (let i = 0; i < 10; i++) {
    data.push(Math.floor(Math.random() * 100)); // Generating random value
  }
  return data;
};

const props = defineProps();

const seriesData = ref([
  {
    param: 0,
    axis: 0,
    machine: "Machine 1",
    start_time: 0,
    stop_time: 0,
    data: generateRandomData(),
    timestamps: Array.from({ length: 10 }, (_, i) => Math.floor(Date.now() / 1000) - (i * 60)), // Sample timestamps in epoch
    critical_limit: 0,
    warning_limit: 0
  },
  {
    param: 0,
    axis: 0,
    machine: "Machine 2",
    start_time: 0,
    stop_time: 0,
    data: generateRandomData(),
    timestamps: Array.from({ length: 10 }, (_, i) => Math.floor(Date.now() / 1000) - (i * 60)), // Sample timestamps in epoch
    critical_limit: 0,
    warning_limit: 0
  },
  {
    param: 0,
    axis: 0,
    machine: "Machine 3",
    start_time: 0,
    stop_time: 0,
    data: generateRandomData(),
    timestamps: Array.from({ length: 10 }, (_, i) => Math.floor(Date.now() / 1000) - (i * 60)), // Sample timestamps in epoch
    critical_limit: 0,
    warning_limit: 0
  }
]);

const option = {
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      type: 'cross',
      crossStyle: {
        color: '#999'
      }
    }
  },
  toolbox: {
    feature: {
      dataView: { show: true, readOnly: false },
      magicType: { show: true, type: ['line', 'bar'] },
      restore: { show: true },
      saveAsImage: { show: true }
    }
  },
  legend: {
    data: seriesData.value.map(series => series.machine)
  },
  xAxis: {
    type: 'time',
    axisLabel: {
      formatter: (value) => {
        return new Date(value).toLocaleString(); // Formatting timestamp to human-readable format
      }
    }
  },
  yAxis: {
    type: 'value',
    name: 'Value',
    axisLabel: {
      formatter: '{value}'
    }
  },
  series: seriesData.value.map(series => ({
    name: series.machine,
    type: 'line',
    data: series.data.map((value, index) => [series.timestamps[index] * 1000, value]) // Converting timestamps to milliseconds
  }))
};

onMounted(() => {
  myChart = echarts.init(chartContainer.value);
  myChart.setOption(option);
});

watch(() => props.data, () => {
  seriesData.value.forEach(series => {
    series.data = generateRandomData(); // Update random data
    series.timestamps = Array.from({ length: 10 }, (_, i) => Math.floor(Date.now() / 1000) - (i * 60)); // Update random timestamps
  });
  option.legend.data = seriesData.value.map(series => series.machine);
  option.series = seriesData.value.map(series => ({
    name: series.machine,
    type: 'line',
    data: series.data.map((value, index) => [series.timestamps[index] * 1000, value]) // Converting timestamps to milliseconds
  }));
  myChart.setOption(option);
});

</script>

<template>
  <div id="main" ref="chartContainer"></div>
</template>
