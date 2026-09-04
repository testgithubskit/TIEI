<template>
  <div>
    <canvas ref="mixedChartCanvas" width="400" height="100"></canvas>
  </div>
</template>

<script setup>
import { ref, onMounted, defineProps, watch } from 'vue';
import { Chart, registerables } from 'chart.js';

Chart.register(...registerables);

const mixedChartCanvas = ref(null);
let chartInstance = null;

const props = defineProps({
  data: {
    type: Array,
    default: () =>  [
      {
        "message": "PATH01 FILE ALREADY EXIST",
        "total_count": 1
      },
      {
        "message": "PATH01 ACCESS ERROR (MEMORY CARD)",
        "total_count": 1
      },
      {
        "message": "PATH01 NO DECIMAL POINT",
        "total_count": 1
      },
      {
        "message": "PATH01 NOT MOUNTED (MEMORY CARD)",
        "total_count": 1
      },
      {
        "message": "PATH01 (Y)- OVERTRAVEL ( SOFT 1 )",
        "total_count": 1
      },
      {
        "message": "PATH01 FILE NOT FOUND (MEMORY CARD)",
        "total_count": 1
      },
      {
        "message": "PATH01 (YS)- OVERTRAVEL ( SOFT 1 )",
        "total_count": 1
      }
    ],
  },
});

onMounted(() => {
  const ctx = mixedChartCanvas.value.getContext('2d');
  const initialChartData = generateChartData(props.data);
  renderChart(ctx, initialChartData);

  watch(() => props.data, (newData) => {
    const updatedChartData = generateChartData(newData);
    updateChart(updatedChartData);
  });
});

function generateChartData(data) {
  const labels = data.map(entry => entry.message);
  const counts = data.map(entry => entry.total_count);

  return {
    labels: labels,
    datasets: [
      {
        label: 'Alarm Count',
        type: 'bar',
        data: counts,
        backgroundColor: 'rgba(54, 162, 235, 0.2)',
        borderColor: 'rgba(54, 162, 235, 1)',
        borderWidth: 1
      }
    ]
  };
}

function renderChart(ctx, data) {
  const options = {
    // Your options here
  };

  chartInstance = new Chart(ctx, {
    type: 'bar',
    data: data,
    options: options
  });
}

function updateChart(newData) {
  if (chartInstance) {
    chartInstance.destroy();
  }
  const ctx = mixedChartCanvas.value.getContext('2d');
  renderChart(ctx, newData);
}
</script>

<style scoped>
/* Your styles here */
</style>
