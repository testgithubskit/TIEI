<!-- PlantSummary.vue -->
<template>
  <div class="bg-white rounded-xl shadow-lg p-6 mb-8">
    <h2 class="text-2xl font-bold mb-4 text-emerald-600">Plant Summary</h2>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <div class="stat-card">
        <h3 class="text-lg font-semibold">Total Machines</h3>
        <p class="text-3xl font-bold">{{ totalMachines }}</p>
      </div>
      <div class="stat-card">
        <h3 class="text-lg font-semibold mb-2">Overall Plant Status</h3>
        <p class="text-xl flex justify-center gap-5">
          <span class="text-green-700 font-semibold bg-emerald-200 p-1 rounded-lg px-2"><span class="text-slate-600">OK:  </span>{{  machineStatus.OK }}</span> 
          <span class="text-yellow-600 font-semibold bg-yellow-200 p-1 rounded-lg px-2"><span class="text-slate-600">WARNING:  </span> {{ machineStatus.WARNING }}</span> 
          <span class="text-red-600 font-semibold bg-red-200 p-1 rounded-lg px-2"><span class="text-slate-600">CRITICAL:  </span> {{ machineStatus.CRITICAL }}</span>
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
      return this.data.lines.reduce((total, line) => total + line.machines.length, 0);
    },
    machineStatus() {
      return this.data.lines.reduce((status, line) => {
        status.OK += line.count.OK;
        status.WARNING += line.count.WARNING;
        status.CRITICAL += line.count.CRITICAL;
        return status;
      }, { OK: 0, WARNING: 0, CRITICAL: 0 });
    },
    healthStatus() {
      const total = this.totalMachines;
      const healthPercentage = (this.machineStatus.OK / total) * 100;
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
  @apply bg-gray-100 rounded-lg p-4 text-center shadow-lg border;
}
</style>