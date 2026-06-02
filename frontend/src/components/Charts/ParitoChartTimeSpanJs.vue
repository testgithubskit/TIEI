<script setup>
import * as echarts from 'echarts/core';
import {
  ToolboxComponent,
  TooltipComponent,
  GridComponent,
  LegendComponent
} from 'echarts/components';
import { BarChart, LineChart } from 'echarts/charts';
import { UniversalTransition } from 'echarts/features';
import { CanvasRenderer } from 'echarts/renderers';
import { ref, onMounted, computed, watch } from 'vue';

echarts.use([
  ToolboxComponent,
  TooltipComponent,
  GridComponent,
  LegendComponent,
  BarChart,
  LineChart,
  CanvasRenderer,
  UniversalTransition
]);

const chartContainer = ref(null);
let myChart = null;

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


const xAxisLabel = ref(null);

const yValue = ref([10, 5, 3]);

const cumulativeValue = computed(() => {
  let cumulativeSum = 0;
  return props.data.map(item => {
    cumulativeSum += item.total_time;
    return cumulativeSum;
  });
});


const cumulativePercentage = computed(() => {
  let maxValue = cumulativeValue.value[cumulativeValue.value.length - 1];
  let computedData = cumulativeValue.value.map(item => {
    return ((item / maxValue) * 100).toFixed(2);
  });
  return computedData
});


let yAxisMin = computed(() => {
  return Math.min(...yValue.value);
});

let yAxisMax = computed(() => {
  return Math.max(...yValue.value);
});


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
    data: ['Total Timespan', 'Cumulative Timespan Percentage']
  },
  xAxis: [
    {
      type: 'category',
      data: xAxisLabel.value,
      axisPointer: {
        type: 'shadow'
      },
      name: 'Alarm Message', 
    nameLocation: 'center', // Center right alignment
    nameGap: 25 // Adjust spacing (optional)
    }
  ],
  yAxis: [
    {
      type: 'value',
      name: 'Total Timespan',
      min: 0,
      max: yAxisMax.value,
      axisLabel: {
        formatter: '{value}'
      }
    },
    {
      type: 'value',
      name: 'Cumulative Timespan Percentage',
      min: 0,
      max: 100,
      axisLabel: {
        formatter: '{value} %'
      }
    }
  ],
  series: [
    {
      name: 'Total Timespan',
      type: 'bar',
      barWidth: 80,
      tooltip: {
        valueFormatter: function (value) {
          return value ;
        }
      },
      data: yValue.value
    },
    {
      name: 'Cumulative Timespan Percentage',
      type: 'line',
      yAxisIndex: 1,
      tooltip: {
        valueFormatter: function (value) {
          return value + ' %';
        }
      },
      data: cumulativePercentage.value
    }
  ]
};


onMounted(() => {
  myChart = echarts.init(chartContainer.value);
  myChart.setOption(option);
});

watch(() => props.data, (newData, oldData) => {
  let xaxisLabelData = newData.map(item => item.message);
  xAxisLabel.value = xaxisLabelData;

  let yValueData = newData.map(item => item.total_time);
  yValue.value = yValueData;

  console.log(yValue.value);
  let option = {
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
    data: ['Total Timespan', 'Cumulative Timespan Percentage']
  },
  xAxis: [
    {
      type: 'category',
      data: xAxisLabel.value,
      axisPointer: {
        type: 'shadow'
      },
      name: 'Alarm Message', 
    nameLocation: 'center', // Center right alignment
    nameGap: 25 // Adjust spacing (optional)
    }
  ],
  yAxis: [
    {
      type: 'value',
      name: 'Total Timespan',
      min: 0,
      max: yAxisMax.value,
      axisLabel: {
        formatter: '{value}'
      }
    },
    {
      type: 'value',
      name: 'Cumulative Timespan Percentage',
      min: 0,
      max: 100,
      axisLabel: {
        formatter: '{value} %'
      }
    }
  ],
  series: [
    {
      name: 'Total Timespan',
      type: 'bar',
      barWidth: 80,
      tooltip: {
        valueFormatter: function (value) {
          return value ;
        }
      },
      data: yValue.value
    },
    {
      name: 'Cumulative Timespan Percentage',
      type: 'line',
      yAxisIndex: 1,
      tooltip: {
        valueFormatter: function (value) {
          return value + ' %';
        }
      },
      data: cumulativePercentage.value
    }
  ]
};


myChart.setOption(option);

});

</script>

<template>
  <div  id="main" ref="chartContainer"></div>
</template>