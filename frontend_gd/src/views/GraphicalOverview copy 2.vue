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
        
        <div v-else class="grid grid-cols-1 lg:grid-cols-3 gap-8">
          <!-- Plant Summary -->
          <div class="col-span-1 lg:col-span-3">
            <PlantSummary :data="factoryStore.formattedOverviewData" />
          </div>

          <!-- Line Overviews -->
          <div v-for="line in factoryStore.formattedOverviewData.lines" :key="line.lineName" class="bg-white rounded-xl shadow-lg p-6">
            <h2 class="text-2xl font-bold mb-4 text-emerald-600">{{ line.lineName }} Line</h2>
            <div class="flex items-center justify-between mb-4">
              <div>
                <p class="text-lg">Total Machines: {{ line.totalMachines }}</p>
                <p class="text-lg">
                  Abnormal Machines: 
                  <span :class="{'text-yellow-600': line.abnormalMachines > 0, 'text-green-600': line.abnormalMachines === 0}">
                    {{ line.abnormalMachines }}
                  </span>
                </p>
              </div>
              <PieChart 
                :data="[
                  { name: 'Normal', value: line.totalMachines - line.abnormalMachines, color: '#10B981' },
                  { name: 'Abnormal', value: line.abnormalMachines, color: '#F59E0B' }
                ]"
                @slice-click="showMachineList(line.lineName, $event)"
              />
            </div>
            <LinePerformanceGraph :line-data="line" />
          </div>
        </div>

        <!-- Machine List Modal2 -->
        <Modal2 v-if="showMachineListModal2" @close="showMachineListModal2 = false">
          <h2 class="text-2xl font-bold mb-4">{{ selectedLine }} - {{ selectedMachineType }} Machines</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            <div v-for="machine in filteredMachines" :key="machine.machineName"
                 class="machine-card bg-white rounded-xl shadow-lg p-4 cursor-pointer"
                 :class="getStatusBorderClass(machine.machineState)"
                 @click="showMachineDetails(machine)">
              <h3 class="text-lg font-semibold mb-2">{{ machine.machineName }}</h3>
              <p>Status: <span :class="getStatusTextClass(machine.machineState)">{{ machine.machineState }}</span></p>
              <p>Abnormal Parameters: {{ machine.abnormalParameters.length }}</p>
            </div>
          </div>
        </Modal2>

        <!-- Machine Details Modal2 -->
        <Modal2 v-if="selectedMachine" @close="selectedMachine = null">
          <h2 class="text-3xl font-bold mb-6 text-emerald-600">{{ selectedMachine.machineName }} Details</h2>
          <div v-for="param in selectedMachine.abnormalParameters" :key="param.paramName" 
               class="parameter-card bg-white rounded-xl shadow-lg p-4 mb-4 hover:shadow-xl transition-all duration-300"
               :class="getStatusBorderClass(param.paramState)"
               @click="logParameterDetails(param)">
            <h3 class="text-lg font-semibold mb-2 text-gray-800">{{ param.paramName }}</h3>
            <p>Value: {{ param.paramValue }}</p>
            <p>Status: <span :class="getStatusTextClass(param.paramState)">{{ param.paramState }}</span></p>
            <p class="text-sm text-gray-600">Last Updated: {{ param.lastUpdated }}</p>
          </div>
        </Modal2>
      </div>
    </SectionMain>
  </LayoutAuthenticatedSimple>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useFactoryOverviewStore } from '../stores/FactoryOverviewStore';
import SectionMain from "@/components/SectionMain.vue";
import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";
import ToggleButton from "@/components/ToggleButton.vue";
import PieChart from "@/components/PieChart.vue";
import LinePerformanceGraph from "@/components/LinePerformanceGraph.vue";
import PlantSummary from "@/components/PlantSummary.vue";
import Modal2 from "@/components/Modal2.vue";

const factoryStore = useFactoryOverviewStore();
const selectedMachine = ref(null);
const showMachineListModal2 = ref(false);
const selectedLine = ref('');
const selectedMachineType = ref('');

onMounted(async () => {
  await factoryStore.fetchAndFormatData();
});

const filteredMachines = computed(() => {
  if (!selectedLine.value) return [];
  const line = factoryStore.formattedOverviewData.lines.find(l => l.lineName === selectedLine.value);
  return line.machines.filter(m => 
    (selectedMachineType.value === 'Abnormal' && m.abnormalParameters.length > 0) ||
    (selectedMachineType.value === 'Normal' && m.abnormalParameters.length === 0)
  );
});

function showMachineList(lineName, sliceData) {
  selectedLine.value = lineName;
  selectedMachineType.value = sliceData.name;
  showMachineListModal2.value = true;
}

function showMachineDetails(machine) {
  selectedMachine.value = machine;
}

function logParameterDetails(param) {
  console.log(`Parameter Details:`, param);
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

.machine-card, .parameter-card {
  @apply transform hover:scale-105 transition-all duration-300;
}
</style>