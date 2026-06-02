<script setup>
import { use } from 'echarts/core';
import { TooltipComponent, GridComponent, DatasetComponent } from 'echarts/components';
import { BarChart } from 'echarts/charts';
import { CanvasRenderer } from 'echarts/renderers';
import VChart, { THEME_KEY } from 'vue-echarts';
import { provide, computed } from 'vue';
import { LegendComponent, DataZoomComponent } from 'echarts/components';

use([TooltipComponent, GridComponent, DatasetComponent, BarChart,
CanvasRenderer, LegendComponent, DataZoomComponent]);

provide(THEME_KEY, 'light');

const props = defineProps({
  data: {
    type: Array,
    default: () =>  [
      {
          "machine_name": "T_H_OP500",
          "total_abnormality": 37,
          "warning": 37,
          "critical": 0
      },
    ],
  },
});

const option = computed(() => {
  let optionData = {
    legend: {},
    tooltip: {},
      grid: {
        top: '12%',
        left: '1%',
        right: '10%',
        containLabel: true
      },
    dataset: {
      dimensions: ['machine_name', 'total_abnormality', 'warning', 'critical'],
      source: props.data
    },
    xAxis: {
      type: 'category'
    },
    yAxis: {},
    dataZoom: [
      {
        type: 'slider',
        show: true,
        start: 0,
        end: 100,
        handleSize: 8
      },
      {
        type: 'inside',
        start: 0,
        end: 100
      }
    ],
    series: [{ type: 'bar' }, { type: 'bar' }, { type: 'bar' }]
  };
  return optionData;
});

</script>

<template>
  <v-chart class="chart" :option="option" autoresize />
</template>
