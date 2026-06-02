<!-- PieChart.vue -->
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
      type: Object,
      required: true
    }
  },
  computed: {
    chartData() {
      return {
        labels: ['OK', 'WARNING', 'CRITICAL'],
        datasets: [{
          backgroundColor: ['#10B981', '#F59E0B', '#EF4444'],
          data: [this.data.OK, this.data.WARNING, this.data.CRITICAL]
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
    const status = ['OK', 'WARNING', 'CRITICAL'][index];
    this.$emit('slice-click', { name: status, value: this.data[status] });
  }
}
      }
    }
  }
}
</script>