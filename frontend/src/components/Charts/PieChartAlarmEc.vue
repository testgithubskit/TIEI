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
import { ref, provide, watch } from 'vue';

use([
  CanvasRenderer,
  PieChart,
  TitleComponent,
  TooltipComponent,
  LegendComponent,
]);

provide(THEME_KEY, 'light');


const props = defineProps({
  data: {
    type: Array,
    default: () =>  [
    {
        "message": "abc 1",
        "total_time": 5
    },{
        "message": "abc 2",
        "total_time": 4
    },{
        "message": "abc 3",
        "total_time": 3
    },
    ],
  },
});


const options = ref({
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
    top: 'middle', // Align to the middle vertically,
    data: ['Production', 'Idle', 'Off'],
  },
  color: ['#009688', '#FF3D00', '#FFC107'], // Emerald green as primary color
  series: [
    {
      name: 'Alarm Timespan Distribution',
      type: 'pie',
      radius: ['40%', '70%'],
      center: ['35%', '50%'], // Move the pie chart to the left
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
        
      label: {
        show: true,
        fontSize: '30',
        fontWeight: 'bold'
      }
      },
    },
  ],
});

watch(() => props.data, (newValue, oldValue) => {
  console.log("change");
  let chartData = newValue.map((item)=> {
    let currentData = {name: item.message, value: item.total_time};
    return currentData;
  });
  let legendData = newValue.map((item)=> item.message);
  
  let newOptions = {
  title: {
    text: 'Alarm Timespan Distribution',
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
    data: legendData,
  },
  emphasis: {
    itemStyle: {
          shadowBlur: 10,
          shadowOffsetX: 0,
          shadowColor: 'rgba(0, 0, 0, 0.5)',
        },
    label: {
      show: true,
      fontSize: '30',
      fontWeight: 'bold'
    }
  },
  series: [
    {
      name: 'Alarm Timespan Distribution',
      type: 'pie',
      radius: ['40%', '70%'],
      center: ['35%', '50%'], // Move the pie chart to the left
      data: chartData,
      emphasis: {
        itemStyle: {
          shadowBlur: 10,
          shadowOffsetX: 0,
          shadowColor: 'rgba(0, 0, 0, 0.5)',
        },
      },
    },
  ],
}
options.value = newOptions;
});

</script>

<template>
  <v-chart class="chart" :option="options" autoresize />
</template>
