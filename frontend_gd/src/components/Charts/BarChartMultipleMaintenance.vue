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
        "operator_name": "operator_01",
        "operator_company_id": 456123,
        "total_abnormality": 16
      },
      {
        "operator_name": "operator_02",
        "operator_company_id": 453423,
        "total_abnormality": 14
      },
      {
        "operator_name": "operator_03",
        "operator_company_id": 455623,
        "total_abnormality": 18
      },
      {
        "operator_name": "operator_04",
        "operator_company_id": 457823,
        "total_abnormality": 89
      }
    ],
  },
});

const option = computed(() => {
  let optionData = {
    legend: {},
    tooltip: {
      trigger: 'axis', // Set the trigger type to 'axis' for displaying tooltips for each series item
      axisPointer: {
        type: 'shadow' // Display tooltip shadow for better visibility
      },
      formatter: function(params) {
        // Customize the tooltip content
        return `
          Operator Name: ${params[0].data.operator_name} <br/>
          Company ID: ${params[0].data.operator_company_id} <br/>
          Total Abnormality: ${params[0].data.total_abnormality}
        `;
      }
    },
      grid: {
        top: '12%',
        left: '1%',
        right: '10%',
        containLabel: true
      },
    dataset: {
      dimensions: ['operator_name', 'total_abnormality'],
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
        start: 94,
        end: 100
      }
    ],
    series: [{ type: 'bar'
      }]
  };
  return optionData;
});

</script>

<template>
  <v-chart class="chart" :option="option" autoresize />
</template>
