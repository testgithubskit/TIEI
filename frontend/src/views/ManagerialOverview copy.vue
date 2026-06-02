<template>
  <LayoutAuthenticatedSimple>
    <SectionMain>
      <div class="plant-overview  p-8">
        <h1 class="plant-title text-4xl font-bold text-center mb-12 text-emerald-600">Plant Overview</h1>
        
        <div v-if="factoryStore.isLoading" class="text-center text-2xl text-gray-600">
          Loading...
        </div>
        
        <div v-else-if="factoryStore.error" class="text-center text-2xl text-red-500">
          {{ factoryStore.error }}
        </div>
        
        <div v-else>
          <!-- Lines Overview -->
          <div v-if="!selectedLine" class="lines-container grid grid-cols-1 md:grid-cols-3 gap-8">
            <div 
              v-for="line in factoryStore.formattedOverviewData" 
              :key="line.lineName" 
              class="line-card bg-white rounded-xl shadow-lg p-8 hover:shadow-2xl cursor-pointer border-2 transform hover:scale-105 transition-all duration-300"
              @click="selectLine(line)"
            >
              <h2 class="text-2xl font-semibold mb-6 text-gray-800 capitalize">{{ line.lineName }} Line</h2>
              <div class="text-lg text-gray-600">
                Total Machines: {{ line.machines.length }}
              </div>
              <div class="mt-4 flex justify-between items-center">
                <span class="status-item" v-for="status in ['OK', 'WARNING', 'CRITICAL']" :key="status">
                  <span class="status-dot" :class="getStatusDotClass(status)"></span>
                  {{ countMachinesByStatus(line, status) }}
                </span>
              </div>
            </div>
          </div>

          <!-- Machines in Selected Line -->
          <div v-else-if="!selectedMachine" class="machines-container">
            <!-- <button @click="goBack" class="back-button mb-8">
              ← Back to Lines
            </button> -->
            <h2 class="text-3xl font-bold mb-8 text-center text-emerald-600 capitalize">{{ selectedLine.lineName }} Line - Machines</h2>
            <div class="machines-grid grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
              <div 
                v-for="machine in selectedLine.machines" 
                :key="machine.machineName" 
                class="machine-card bg-white rounded-xl shadow-lg p-6 hover:shadow-2xl cursor-pointer transform hover:scale-105 transition-all duration-300"
                :class="getStatusBorderClass(machine.machineState)"
                @click="selectMachine(machine)"
              >
                <h3 class="text-xl font-semibold mb-4 text-gray-800">{{ machine.machineName }}</h3>
                <p class="mb-4">Status: <span :class="getStatusTextClass(machine.machineState)">{{ machine.machineState }}</span></p>
                <p class="mb-2">Parameter Groups: {{ Object.keys(machine.parameterGroups).length }}</p>
                <div v-if="getAbnormalGroups(machine.parameterGroups).length > 0">
                  <h4 class="font-medium text-gray-700 mb-2">Abnormal Groups:</h4>
                  <ul class="list-disc list-inside">
                    <li v-for="group in getAbnormalGroups(machine.parameterGroups)" :key="group.groupName" class="text-sm">
                      {{ group.groupName }} ({{ group.abnormalParams.length }} issues)
                    </li>
                  </ul>
                </div>
              </div>
            </div>
          </div>

          <!-- Parameter Groups in Selected Machine -->
          <div v-else-if="!selectedGroup" class="parameter-groups-container">
            <button @click="goBack" class="back-button mb-8">
              ← Back to Machines
            </button>
            <h2 class="text-3xl font-bold mb-8 text-center text-emerald-600">{{ selectedMachine.machineName }} - Parameter Groups</h2>
            <div class="parameter-groups-grid grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
              <div 
                v-for="(params, groupName) in selectedMachine.parameterGroups" 
                :key="groupName" 
                class="group-card bg-white rounded-xl shadow-lg p-6 hover:shadow-2xl cursor-pointer transform hover:scale-105 transition-all duration-300"
                @click="selectGroup(groupName, params)"
              >
                <h3 class="text-xl font-semibold mb-4 text-gray-800">{{ groupName }}</h3>
                <p class="mb-2">Parameters: {{ params.length }}</p>
                <p class="text-sm">
                  <span :class="getStatusTextClass(getGroupStatus(params))">
                    {{ getGroupStatus(params) }}
                  </span>
                </p>
              </div>
            </div>
          </div>

          <!-- Parameters in Selected Group -->
          <div v-else class="parameters-container">
            <button @click="goBack" class="back-button mb-8">
              ← Back to Parameter Groups
            </button>
            <h2 class="text-3xl font-bold mb-8 text-center text-emerald-600">{{ selectedMachine.machineName }} - {{ selectedGroup.groupName }}</h2>
            <div class="parameters-grid grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
              <div 
                v-for="param in selectedGroup.params" 
                :key="param.paramName" 
                class="parameter-card bg-white rounded-xl shadow-lg p-6 hover:shadow-2xl transition-all duration-300"
                :class="getStatusBorderClass(param.paramState)"
              >
                <h3 class="text-lg font-semibold mb-3 text-gray-800">{{ param.paramName }}</h3>
                <p class="mb-2">Value: {{ param.paramValue }}</p>
                <p class="mb-2">Status: <span :class="getStatusTextClass(param.paramState)">{{ param.paramState }}</span></p>
                <p class="text-sm text-gray-600">Last Updated: {{ param.lastUpdated }}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </SectionMain>
  </LayoutAuthenticatedSimple>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useFactoryOverviewStore } from '@/stores/factoryOverviewStore';
import SectionMain from "@/components/SectionMain.vue";
import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";

const factoryStore = useFactoryOverviewStore();
const selectedLine = ref(null);
const selectedMachine = ref(null);
const selectedGroup = ref(null);

onMounted(async () => {
  await factoryStore.fetchAndFormatData();
});

function selectLine(line) {
  if (line.machines.length > 0) {
    selectedLine.value = line;
  } else {
    console.log(`No machines found for ${line.lineName} line`);
  }
}

function selectMachine(machine) {
  selectedMachine.value = machine;
}

function selectGroup(groupName, params) {
  selectedGroup.value = { groupName, params };
}

function goBack() {
  if (selectedGroup.value) {
    selectedGroup.value = null;
  } else if (selectedMachine.value) {
    selectedMachine.value = null;
  } else if (selectedLine.value) {
    selectedLine.value = null;
  }
}

function countMachinesByStatus(line, status) {
  return line.machines.filter(machine => machine.machineState === status).length;
}

function getGroupStatus(params) {
  if (params.some(p => p.paramState === 'CRITICAL')) return 'CRITICAL';
  if (params.some(p => p.paramState === 'WARNING')) return 'WARNING';
  return 'OK';
}

function getStatusDotClass(status) {
  return {
    'bg-green-500': status === 'OK',
    'bg-yellow-500': status === 'WARNING',
    'bg-red-500': status === 'CRITICAL'
  };
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

function getAbnormalGroups(parameterGroups) {
  return factoryStore.getAbnormalGroups(parameterGroups);
}
</script>

<style scoped>
.status-dot {
  display: inline-block;
  width: 12px;
  height: 12px;
  border-radius: 50%;
  margin-right: 6px;
}

.status-item {
  display: flex;
  align-items: center;
}

.back-button {
  @apply bg-blue-500 text-white px-6 py-3 rounded-lg hover:bg-blue-600 transition-colors text-lg font-medium;
}

.plant-overview {
  @apply min-h-screen;
}
</style>