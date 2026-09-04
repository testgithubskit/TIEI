<template>
    <div class="bg-white rounded-xl shadow-lg p-6 mb-8">
      <h2 class="text-2xl font-bold mb-4 text-emerald-600">Plant Summary</h2>
      <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div class="stat-card">
          <h3 class="text-lg font-semibold">Total Machines</h3>
          <p class="text-3xl font-bold">{{ totalMachines }}</p>
        </div>
        <div class="stat-card">
          <h3 class="text-lg font-semibold">Abnormal Machines</h3>
          <p class="text-3xl font-bold" :class="{'text-yellow-600': abnormalMachines > 0, 'text-green-600': abnormalMachines === 0}">
            {{ abnormalMachines }}
          </p>
        </div>
        <div class="stat-card">
          <h3 class="text-lg font-semibold">Overall Health</h3>
          <p class="text-3xl font-bold" :class="healthColor">{{ healthStatus }}</p>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    name: 'PlantSummary',
    props: {
      data: {
        type: Object,
        required: true
      }
    },
    computed: {
      totalMachines() {
        return this.data.lines.reduce((total, line) => total + line.totalMachines, 0);
      },
      abnormalMachines() {
        return this.data.lines.reduce((total, line) => total + line.abnormalMachines, 0);
      },
      healthStatus() {
        const healthPercentage = ((this.totalMachines - this.abnormalMachines) / this.totalMachines) * 100;
        if (healthPercentage > 90) return 'Excellent';
        if (healthPercentage > 70) return 'Good';
        if (healthPercentage > 50) return 'Fair';
        return 'Poor';
      },
      healthColor() {
        if (this.healthStatus === 'Excellent') return 'text-green-600';
        if (this.healthStatus === 'Good') return 'text-blue-600';
        if (this.healthStatus === 'Fair') return 'text-yellow-600';
        return 'text-red-600';
      }
    }
  }
  </script>
  
  <style scoped>
  .stat-card {
    @apply bg-gray-100 rounded-lg p-4 text-center;
  }
  </style>