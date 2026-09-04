<template>
    <div class="chart-container" style="position: relative; height:200px; width:200px">
      <Pie :data="chartData" :options="chartOptions" />
    </div>
  </template>
  
  <script>
  import { Pie } from 'vue-chartjs'
  import { Chart as ChartJS, ArcElement, Tooltip, Legend } from 'chart.js'
  
  ChartJS.register(ArcElement, Tooltip, Legend)
  
  export default {
    name: 'PieChart',
    components: { Pie },
    props: {
      data: {
        type: Array,
        required: true
      }
    },
    computed: {
      chartData() {
        return {
          labels: this.data.map(item => item.name),
          datasets: [{
            backgroundColor: this.data.map(item => item.color),
            data: this.data.map(item => item.value)
          }]
        }
      },
      chartOptions() {
        return {
          responsive: true,
          maintainAspectRatio: false,
          onClick: (event, elements) => {
            if (elements.length > 0) {
              const index = elements[0].index;
              this.$emit('slice-click', this.data[index]);
            }
          }
        }
      }
    }
  }
  </script>