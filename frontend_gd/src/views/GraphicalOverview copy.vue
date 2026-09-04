<template>
  <LayoutAuthenticatedSimple>
    <SectionMain>
      <div class="plant-overview p-8">
        <span><ToggleButton/></span>
        
        <h1 class="plant-title text-4xl font-bold text-center mb-12 text-emerald-600">Plant Overview</h1>
      
        <div v-if="factoryStore.isLoading" class="text-center text-2xl text-gray-600">
          Loading...
        </div>
        
        <div v-else-if="factoryStore.error" class="text-center text-2xl text-red-500">
          {{ factoryStore.error }}
        </div>
        
        <div v-else>
          <!-- Lines Overview -->
          <div class="lines-overview mb-12">
            <h2 class="text-3xl font-bold mb-6 text-emerald-600">Lines Overview</h2>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div v-for="line in factoryStore.formattedOverviewData.lines" :key="line.lineName"
                   class="line-card bg-white rounded-xl shadow-lg p-6 hover:shadow-2xl transition-all duration-300">
                <h3 class="text-2xl font-semibold mb-4 text-gray-800">{{ line.lineName }}</h3>
                <p class="text-lg">Total Machines: {{ line.totalMachines }}</p>
                <p class="text-lg">
                  Abnormal Machines: 
                  <span :class="{'text-yellow-600': line.abnormalMachines > 0, 'text-green-600': line.abnormalMachines === 0}">
                    {{ line.abnormalMachines }}
                  </span>
                </p>
              </div>
            </div>
          </div>

          <!-- Machines Overview -->
          <div class="machines-overview">
            <h2 class="text-xl font-bold mb-6 text-emerald-600">Machines Overview</h2>
            <div class="grid grid-cols-1 md:grid-cols-10 gap-6">
              <div v-for="machine in factoryStore.formattedOverviewData.machines" :key="machine.machineName"
                   class="machine-card text-sm bg-white rounded-xl shadow-lg p-6 hover:shadow-2xl cursor-pointer transition-all duration-300"
                   :class="getStatusBorderClass(machine.machineState)"
                   @click="showMachineDetails(machine)">
                <h3 class="text-xl font-semibold mb-4 text-gray-800">{{ machine.machineName }}</h3>
                <p class="mb-2">Status: <span :class="getStatusTextClass(machine.machineState)">{{ machine.machineState }}</span></p>
                <p>Abnormal Parameters: {{ machine.abnormalParameters.length }}</p>
              </div>
            </div>
          </div>

          <!-- Machine Details Modal -->
          <div v-if="selectedMachine" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center">
            <div class="bg-white rounded-xl p-8 max-w-3xl w-full max-h-[80vh] overflow-y-auto">
              <h2 class="text-3xl font-bold mb-6 text-emerald-600">{{ selectedMachine.machineName }} Details</h2>
              <div v-for="param in selectedMachine.abnormalParameters" :key="param.paramName" 
                   class="parameter-card bg-white rounded-xl shadow-lg p-4 mb-4 hover:shadow-xl transition-all duration-300"
                   :class="getStatusBorderClass(param.paramState)"
                   @click="logParameterName(param)">
                <h3 class="text-lg font-semibold mb-2 text-gray-800">{{ param.paramName }}</h3>
                <p>Value: {{ param.paramValue }}</p>
                <p>Status: <span :class="getStatusTextClass(param.paramState)">{{ param.paramState }}</span></p>
                <p class="text-sm text-gray-600">Last Updated: {{ param.lastUpdated }}</p>
              </div>
              <button @click="selectedMachine = null" class="mt-6 bg-emerald-600 text-white px-4 py-2 rounded-lg hover:bg-emerald-700">Close</button>
            </div>
          </div>
        </div>
      </div>
    </SectionMain>
  </LayoutAuthenticatedSimple>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useFactoryOverviewStore } from '../stores/FactoryOverviewStore';
import SectionMain from "@/components/SectionMain.vue";
import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";
import ToggleButton from "@/components/ToggleButton.vue"

const factoryStore = useFactoryOverviewStore();
const selectedMachine = ref(null);

onMounted(async () => {
  await factoryStore.fetchAndFormatData();
});

function showMachineDetails(machine) {
  selectedMachine.value = machine;
}

function logParameterName(param) {
  console.log(`Parameter Name: ${param.paramName}, Actual Parameter Name: ${param.actualParamName}`);
}

function getStatusBorderClass(status) {
  return {
    'border-l-4 border-green-500': status === 'OK',
    'border-l-4 border-yellow-500': status === 'WARNING',
    'border-l-4 border-red-500': status === 'CRITICAL'
  };
}

function getStatusTextClass(status) {
  return {
    'text-green-600 font-semibold': status === 'OK',
    'text-yellow-600 font-semibold': status === 'WARNING',
    'text-red-600 font-semibold': status === 'CRITICAL'
  };
}
</script>

<style scoped>
.plant-overview {
  @apply min-h-screen bg-gray-100;
}

.line-card, .machine-card, .parameter-card {
  @apply transform hover:scale-105 transition-all duration-300;
}
</style>