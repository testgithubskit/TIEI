<template>
    <div class="chart-container">
      <div class="pie-chart">
        <canvas ref="pieChart"></canvas>
      </div>
      <div class="legend">
        <ul>
          <li v-for="(label, index) in legendLabels" :key="index">
            <span :style="{ backgroundColor: legendColors[index] }"></span>
            {{ label }}
          </li>
        </ul>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted } from 'vue';
  import { Chart, registerables } from 'chart.js';
  
  Chart.register(...registerables);
  
  const pieChart = ref(null);
  
  onMounted(() => {
    const ctx = pieChart.value.getContext('2d');
  
    const data = {
      labels: ['Category 1', 'Category 2', 'Category 3', 'Category 4', 'Category 5'],
      datasets: [{
        label: 'Pie Chart',
        data: generateRandomData(),
        backgroundColor: [
          'rgba(255, 99, 132, 0.7)',
          'rgba(54, 162, 235, 0.7)',
          'rgba(255, 206, 86, 0.7)',
          'rgba(75, 192, 192, 0.7)',
          'rgba(153, 102, 255, 0.7)'
        ],
        borderColor: [
          'rgba(255, 99, 132, 1)',
          'rgba(54, 162, 235, 1)',
          'rgba(255, 206, 86, 1)',
          'rgba(75, 192, 192, 1)',
          'rgba(153, 102, 255, 1)'
        ],
        borderWidth: 1
      }]
    };
  
    new Chart(ctx, {
      type: 'pie',
      data: data
    });
  });
  
  function generateRandomData() {
    return Array.from({ length: 5 }, () => Math.floor(Math.random() * 100) + 1);
  }
  
  // Legends data
  const legendLabels = ref(['Label 1', 'Label 2', 'Label 3', 'Label 4', 'Label 5']);
  const legendColors = ref(['rgba(255, 99, 132, 0.7)', 'rgba(54, 162, 235, 0.7)', 'rgba(255, 206, 86, 0.7)', 'rgba(75, 192, 192, 0.7)', 'rgba(153, 102, 255, 0.7)']);
  </script>
  
  <style scoped>
  .chart-container {
    display: flex;
  }
  
  .pie-chart {
    flex: 1;
    padding-right: 20px; /* Adjust spacing between chart and legend */
  }
  
  .legend {
    display: flex;
    flex-direction: column;
  }
  
  .legend ul {
    list-style-type: none;
    padding: 0;
  }
  
  .legend li {
    display: flex;
    align-items: center;
    margin-bottom: 5px;
  }
  
  .legend span {
    display: inline-block;
    width: 20px; /* Adjust width of legend color indicator */
    height: 10px; /* Adjust height of legend color indicator */
    margin-right: 5px; /* Adjust spacing between color indicator and label */
  }
  </style>
  