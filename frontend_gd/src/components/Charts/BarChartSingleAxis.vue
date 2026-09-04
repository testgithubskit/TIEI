<template>
  <div>
    <canvas ref="mixedChart"></canvas>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { Chart, registerables } from 'chart.js';

Chart.register(...registerables);

const mixedChart = ref(null);

onMounted(() => {
  const ctx = mixedChart.value.getContext('2d');

  const data = {
    labels: ['Alarm 1', 'Alarm 2', 'Alarm 3', 'Alarm 4', 'Alarm 5','Alarm 6','Alarm 7'],
    datasets: [
      {
        label: 'Data 1',
        type: 'bar',
        data: generateRandomData(3),
        backgroundColor: 'rgba(54, 162, 235, 0.2)',
        borderColor: 'rgba(54, 162, 235, 1)',
        borderWidth: 1
      },
      {
        label: 'Data 2',
        type: 'bar',
        data: generateRandomData(3),
        backgroundColor: 'rgba(255, 99, 132, 0.2)',
        borderColor: 'rgba(255, 99, 132, 1)',
        borderWidth: 1
      },
      // Add more datasets as needed
    ]
  };

  const options = {
    scales: {
      y: {
        type: 'linear',
        display: true,
        position: 'left',
        title: {
          display: true,
          text: 'Values',
          color: 'rgba(54, 162, 235, 1)'
        }
      },
      x: {
        display: true,
        title: {
          display: true,
          text: 'Alarm Names'
        }
      }
    }
  };

  new Chart(ctx, {
    type: 'bar',
    data: data,
    options: options
  });
});

function generateRandomData(count) {
  return Array.from({ length: 7 }, () => Array.from({ length: count }, () => Math.floor(Math.random() * 10) + 1));
}
</script>

<style scoped>

</style>
