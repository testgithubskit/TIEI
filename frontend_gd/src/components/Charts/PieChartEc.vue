<script setup>
import { use } from 'echarts/core';
import { CanvasRenderer } from 'echarts/renderers';
import { PieChart } from 'echarts/charts';
import {
  TitleComponent,
  TooltipComponent,
  LegendComponent,
} from 'echarts/components';
import VChart, { THEME_KEY } from 'vue-echarts';
import { ref, provide } from 'vue';

use([
  CanvasRenderer,
  PieChart,
  TitleComponent,
  TooltipComponent,
  LegendComponent,
]);

provide(THEME_KEY, 'light');

const option = ref({
  title: {
    text: 'Machine Status Distribution',
    
    right: 10,
  },
  tooltip: {
    trigger: 'item',
    formatter: '{a} <br/>{b} : {c} ({d}%)',
  },
  legend: {
    orient: 'vertical',
    right: 5, // Align to the right
    top: 'middle', // Align to the middle vertically
    data: ['Production', 'Idle', 'Off'],
  },
  color: ['#009688', '#FF3D00', '#FFC107'], // Emerald green as primary color
  series: [
    {
      name: 'Machine Status Distribution',
      type: 'pie',
      radius: '85%',
      center: ['25%', '50%'], // Move the pie chart to the left
      data: [
        { value: 335, name: 'Production' },
        { value: 310, name: 'Idle' },
        { value: 234, name: 'Off' },
      ],
      emphasis: {
        itemStyle: {
          shadowBlur: 10,
          shadowOffsetX: 0,
          shadowColor: 'rgba(0, 0, 0, 0.5)',
        },
      },
    },
  ],
});
</script>

<template>
  <v-chart class="chart" :option="option" autoresize />
</template>
