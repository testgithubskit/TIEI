<template>
  <v-chart class="chart" :option="option" autoresize />
</template>

<script setup>
import { use } from 'echarts/core';
import { TooltipComponent, GridComponent } from 'echarts/components';
import { BarChart } from 'echarts/charts';
import { CanvasRenderer } from 'echarts/renderers';
import VChart, { THEME_KEY } from 'vue-echarts';
import { ref, provide } from 'vue';

use([TooltipComponent, GridComponent, BarChart, CanvasRenderer]);

provide(THEME_KEY, 'light');

const option = ref({
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      type: 'shadow',
      shadowStyle: {
        color: 'rgba(5, 150, 105, 0.2)' // Set the shadow color to light green
      }
    }
  },
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true
  },
  xAxis: [
    {
      type: 'category',
      data: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
      axisTick: {
        alignWithLabel: true
      }
    }
  ],
  yAxis: [
    {
      type: 'value'
    }
  ],
  series: [
    {
      name: 'Direct',
      type: 'bar',
      barWidth: '40%',
      itemStyle: {
        color: 'rgb(5, 150, 105)', // Set the bar color
        shadowColor: 'rgba(5, 150, 105, 0.5)', // Set the shadow color
        shadowBlur: 10, // Adjust the shadow blur
        shadowOffsetX: 0, // Adjust the shadow offset in the x-axis
        shadowOffsetY: 0, // Adjust the shadow offset in the y-axis
      },
      data: [10, 52, 200, 334, 390, 330, 220]
    }
  ]
});
</script>
