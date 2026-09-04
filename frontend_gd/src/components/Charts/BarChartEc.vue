<script setup>
import { use } from 'echarts/core';
import { TooltipComponent, GridComponent, DatasetComponent } from 'echarts/components';
import { BarChart } from 'echarts/charts';
import { CanvasRenderer } from 'echarts/renderers';
import { provide ,watchEffect} from 'vue';

use([TooltipComponent, GridComponent, DatasetComponent, BarChart, CanvasRenderer]);



// Define option property
const option = {
  // Initial options, will be populated with actual data later
  xAxis: { type: 'category', data: [] },
  yAxis: { type: 'value' },
  series: [{ type: 'bar', data: [] }]
};

// Format machineData into the required format for the chart
const formatChartData = (machineData) => {
  const xAxisData = machineData.map(item => item.parameter_group_name);
  const seriesData = machineData.map(item => item.total_abnormality);

  return {
    xAxis: { data: xAxisData },
    series: [{ data: seriesData }]
  };
};

// import { useBarChart } from '@/stores/BarGraph';

// Access machineData from Vuex store
// const BarchartStore = useBarChart();

// Update chart options when machineData changes
watchEffect(() => {
  const formattedData = formatChartData(BarchartStore.machineData);
  option.xAxis = formattedData.xAxis;
  option.series = formattedData.series;
});
</script>

<template>
  <v-chart class="chart" :option="option" autoresize />
</template>
