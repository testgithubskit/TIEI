<template>
  <v-chart class="chart" :option="option" autoresize @click="handleChartClick" />
</template>

<script setup>
import { use } from 'echarts/core';
import { CanvasRenderer } from 'echarts/renderers';
import { GridComponent, GraphicComponent} from 'echarts/components';
import { BarChart } from 'echarts/charts';
import { UniversalTransition } from 'echarts/features';
import VChart, { THEME_KEY } from 'vue-echarts';
import { ref, provide } from 'vue';

use([
  CanvasRenderer,
  GridComponent,
  GraphicComponent,
  BarChart,
  UniversalTransition
]);

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
  xAxis: {
    data: ['Monday', 'Tuesday', 'Wednesday']
  },
  yAxis: {},
  dataGroupId: '',
  animationDurationUpdate: 500,
  series: [{
    type: 'bar',
    id: 'sales',
    data: [
      {
        value: 74.6,
        groupId: 'monday'
      },
      {
        value: 84.6,
        groupId: 'tuesday'
      },
      {
        value: 94.6,
        groupId: 'wednesday'
      }
    ],
    universalTransition: {
      enabled: true,
      divideShape: 'clone'
    },
    itemStyle: {
      color: 'rgb(5, 150, 105)', // Set the bar color
      shadowColor: 'rgba(5, 150, 105, 0.5)', // Set the shadow color
      shadowBlur: 10, // Adjust the shadow blur
      shadowOffsetX: 0, // Adjust the shadow offset in the x-axis
      shadowOffsetY: 0 // Adjust the shadow offset in the y-axis
    },
    barWidth: 60 // Set the bar width to 100px
  }]
});


const drilldownData = [
  {
    dataGroupId: 'monday',
    data: [
      ['Availability', 85.4],
      ['Performance', 98.9],
      ['Quality', 99]
    ]
  },
  {
    dataGroupId: 'tuesday',
    data: [
      ['Availability', 95.4],
      ['Performance', 78.9],
      ['Quality', 69]
    ]
  },
  {
    dataGroupId: 'wednesday',
    data: [
      ['Availability', 75.4],
      ['Performance', 94.9],
      ['Quality', 96]
    ]
  }
];

function handleChartClick(event) {
  if (event.data) {
    const subData = drilldownData.find(data => data.dataGroupId === event.data.groupId);
    if (!subData) {
      return;
    }

    option.value.xAxis.data = subData.data.map(item => item[0]);
    option.value.series.dataGroupId = subData.dataGroupId;
    option.value.series.data = subData.data.map(item => item[1]);
    option.value.graphic = [
      {
        type: 'text',
        left: 50,
        top: 20,
        style: {
          text: 'Back',
          fontSize: 18
        },
        onclick: function () {
          option.value.xAxis.data = ['Monday', 'Tuesday', 'Wednesday'];
          option.value.yAxis = {};
          option.value.dataGroupId = '';
          option.value.series = {
            type: 'bar',
            id: 'sales',
            data:[
      {
        value: 74.6,
        groupId: 'monday'
      },
      {
        value: 84.6,
        groupId: 'tuesday'
      },
      {
        value: 94.6,
        groupId: 'wednesday'
      }
    ],
            universalTransition: {
              enabled: true,
              divideShape: 'clone'
            },
            itemStyle: {
              color: 'rgb(5, 150, 105)', // Set the bar color
              shadowColor: 'rgba(5, 150, 105, 0.5)', // Set the shadow color
              shadowBlur: 10, // Adjust the shadow blur
              shadowOffsetX: 0, // Adjust the shadow offset in the x-axis
              shadowOffsetY: 0, // Adjust the shadow offset in the y-axis
            }
          };
        }
      }
    ];
  }
}

</script>
