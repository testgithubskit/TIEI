<script setup>
import { use } from 'echarts/core';
import { TooltipComponent, GridComponent, DatasetComponent, LegendComponent, DataZoomComponent, ToolboxComponent } from 'echarts/components';
import { BarChart } from 'echarts/charts';
import { CanvasRenderer } from 'echarts/renderers';
import VChart, { THEME_KEY } from 'vue-echarts';
import { provide, computed, ref, watch } from 'vue';
import { Spin } from 'ant-design-vue';

use([
  TooltipComponent,
  GridComponent,
  DatasetComponent,
  BarChart,
  CanvasRenderer,
  LegendComponent,
  DataZoomComponent,
  ToolboxComponent
]);

provide(THEME_KEY, 'light');

const props = defineProps({
  data: {
    type: Array,
    default: () => [],
  },
});

const loading = ref(true);

watch(() => props.data, (newData) => {
  loading.value = false;
}, { immediate: true });

const truncateLabel = (label, maxLength = 15) => {
  if (label.length <= maxLength) return label;
  return label.slice(0, maxLength) + '...';
};

const option = computed(() => ({
  backgroundColor: '#f8fafc',
  legend: {
    top: 'bottom',
  },
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      type: 'shadow'
    },
    formatter: function(params) {
      let tooltip = params[0].axisValue + '<br/>';
      params.forEach(param => {
        tooltip += param.marker + ' ' + param.seriesName + ': ' + param.value[param.seriesName] + '<br/>';
      });
      return tooltip;
    }
  },
  grid: {
    top: '10%',
    left: '3%',
    right: '4%',
    bottom: '15%',
    containLabel: true
  },
  dataset: {
    dimensions: ['parameter_group_name', 'total_abnormality', 'warning', 'critical'],
    source: props.data
  },
  xAxis: {
    type: 'category',
    axisLabel: {
      rotate: 45,
      interval: 0,
      formatter: function(value) {
        return truncateLabel(value);
      },
      textStyle: {
        fontSize: 10
      }
    }
  },
  yAxis: {
    name: 'Count',
    nameLocation: 'middle',
    nameGap: 50,
  },
  dataZoom: [
    {
      type: 'slider',
      show: true,
      start: 0,
      end: 100,
      bottom: 10
    },
    {
      type: 'inside',
      start: 0,
      end: 100
    }
  ],
  series: [
    {
      type: 'bar',
      name: 'Total Abnormality',
      itemStyle: {
        color: '#60a5fa'
      }
    },
    {
      type: 'bar',
      name: 'Warning',
      itemStyle: {
        color: '#fbbf24'
      }
    },
    {
      type: 'bar',
      name: 'Critical',
      itemStyle: {
        color: '#ef4444'
      }
    }
  ],
  toolbox: {
    feature: {
      saveAsImage: {},
      dataView: {},
      restore: {},
      dataZoom: {},
      magicType: {
        type: ['line', 'bar', 'stack']
      },
    }
  },
  animationDuration: 1000,
  animationEasing: 'cubicInOut',
}));

</script>

<template>
  <Spin :spinning="loading" tip="Loading chart...">
    <v-chart class="chart" :option="option" autoresize />
  </Spin>
</template>

<style scoped>
.chart {
  height: 400px;
}
</style>
