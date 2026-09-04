<template>
    <div class="chart-container" style="position: relative; height:300px; width:100%">
      <Line :data="chartData" :options="chartOptions" />
    </div>
  </template>
  
  <script>
  import { Line } from 'vue-chartjs'
  import {
    Chart as ChartJS,
    CategoryScale,
    LinearScale,
    PointElement,
    LineElement,
    Title,
    Tooltip,
    Legend
  } from 'chart.js'
  
  ChartJS.register(
    CategoryScale,
    LinearScale,
    PointElement,
    LineElement,
    Title,
    Tooltip,
    Legend
  )
  
  export default {
    name: 'LinePerformanceGraph',
    components: { Line },
    props: {
      lineData: {
        type: Object,
        required: true
      }
    },
    computed: {
      chartData() {
        // This is a placeholder. You should replace this with actual performance data.
        const labels = ['January', 'February', 'March', 'April', 'May', 'June', 'July'];
        return {
          labels,
          datasets: [
            {
              label: 'Performance',
              backgroundColor: 'rgba(75, 192, 192, 0.2)',
              borderColor: 'rgb(75, 192, 192)',
              data: labels.map(() => Math.random() * 100),
            }
          ]
        }
      },
      chartOptions() {
        return {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: {
              position: 'top',
            },
            title: {
              display: true,
              text: `${this.lineData.lineName} Performance`
            }
          }
        }
      }
    }
  }
  </script>