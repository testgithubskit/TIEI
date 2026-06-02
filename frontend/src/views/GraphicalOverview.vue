<template>
  <LayoutAuthenticatedSimple>
    <SectionMain>
      <div class="plant-overview p-8 bg-gradient-to-br from-green-50 to-emerald-50 rounded-lg min-h-screen">
        <span><ToggleButton/></span>
        <h1 class="plant-title text-4xl font-bold text-center mb-12 text-emerald-600">Graphical Plant Overview</h1>

        <div v-if="factoryStore.isLoading" class="flex flex-col items-center justify-center h-[60vh]">
          <div class="text-8xl text-emerald-500 mb-8 animate-pulse">
            <font-awesome-icon :icon="['fas', 'industry']" />
          </div>
          <div class="text-3xl text-gray-700 font-semibold mb-6">Loading Plant Data...</div>
          <div class="flex space-x-8">
            <div class="flex flex-col items-center">
              <font-awesome-icon :icon="['fas', 'cogs']" spin class="text-4xl text-emerald-500 mb-2" />
              <span class="text-sm text-gray-600">Processing</span>
            </div>
            <div class="flex flex-col items-center">
              <font-awesome-icon :icon="['fas', 'database']" class="text-4xl text-emerald-500 mb-2 animate-bounce" />
              <span class="text-sm text-gray-600">Fetching Data</span>
            </div>
            <div class="flex flex-col items-center">
              <font-awesome-icon :icon="['fas', 'chart-line']" class="text-4xl text-emerald-500 mb-2 animate-pulse" />
              <span class="text-sm text-gray-600">Analyzing</span>
            </div>
          </div>
          <div class="mt-8 w-64 h-2 bg-emerald-200 rounded-full overflow-hidden">
            <div class="h-full bg-emerald-500 animate-progress"></div>
          </div>
        </div>

        <div v-else-if="factoryStore.error" class="text-center text-2xl text-red-500">
          {{ factoryStore.error }}
        </div>

        <div v-else class="grid grid-cols-1 gap-8">
          <!-- Plant Summary -->
          <div>
            <PlantSummary :data="factoryStore.formattedOverviewData" />
          </div>

          <!-- Line Overviews -->
          <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            <div v-for="line in factoryStore.formattedOverviewData.lines" :key="line.line_name" class="bg-white rounded-xl shadow-lg p-6">
              <h2 class="text-2xl font-bold mb-4 text-emerald-600">{{ line.line_name }}</h2>
              <div class="flex items-center justify-between mb-4">
                <div>
                  <p class="text-lg">Total Machines: {{ line.machines.length }}</p>
                  <p class="text-lg">
                    Status: 
                    <span :class="getStatusTextClass(line.line_state)">{{ line.line_state }}</span>
                  </p>
                </div>
                <PieChart 
                  :data="line.count"
                  @slice-click="showMachineList(line.line_name, $event)"
                />
              </div>
              <LinePerformanceGraph :line-data="line" />
            </div>
          </div>
        </div>

        <!-- Machine List Modal2 -->
        <Modal2 v-if="showMachineListModal2" @close="showMachineListModal2 = false">
          <h2 class="text-2xl font-bold mb-4">{{ selectedLine }} - {{ selectedMachineType }} Machines</h2>
          <div v-if="filteredMachines.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            <div v-for="machine in filteredMachines" :key="machine.machine_name"
                 class="machine-card bg-white rounded-xl shadow-lg p-4 cursor-pointer"
                 :class="getStatusBorderClass(machine.machine_state)"
                 @click="showMachineDetails(machine)">
              <h3 class="text-lg font-semibold mb-2">{{ machine.machine_name }}</h3>
              <p>Status: <span :class="getStatusTextClass(machine.machine_state)">{{ machine.machine_state }}</span></p>
              <p>Abnormal Parameters: {{ machine.count.WARNING + machine.count.CRITICAL }}</p>
            </div>
          </div>
          <div v-else class="text-center text-xl text-gray-600">
            No machines found for the selected state.
          </div>
        </Modal2>

        <!-- Machine Details Modal2 -->
  <Modal2 v-if="selectedMachine" @close="selectedMachine = null">
    <h2 class="text-3xl font-bold mb-6 text-emerald-600">{{ selectedMachine.machine_name }} Details</h2>
    <div v-if="abnormalParameters.length > 0" v-for="param in abnormalParameters" :key="param.internal_parameter_name" 
         class="parameter-card bg-white rounded-xl shadow-lg p-4 mb-4 hover:shadow-xl transition-all duration-300"
         :class="getStatusBorderClass(param.parameter_state)"
         @click="logParameterDetails(param, selectedMachine.machine_name, getParameterGroup(selectedMachine.machine_name, param.internal_parameter_name))">
      <h3 class="text-lg font-semibold mb-2 text-gray-800">{{ param.actual_parameter_name }}</h3>
      <p>Value: {{ param.parameter_value }}</p>
      <p>Status: <span :class="getStatusTextClass(param.parameter_state)">{{ param.parameter_state }}</span></p>
      <p>Group: {{ getParameterGroup(selectedMachine.machine_name, param.internal_parameter_name) }}</p>
      <p class="text-sm text-gray-600">Last Updated: {{ formatDate(param.latest_update_time) }}</p>
    </div>
    <div v-else class="text-center text-xl text-gray-600">
      No abnormal parameters for this machine.
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
// import { useFactoryOverviewStore } from '../stores/FactoryOverviewStore';
import { useFactoryPollOverviewStore } from '../stores/FactoryPollGridStore';
import { useNavigationHistoryStore } from '../stores/navigationHistoryStore';

import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';
import { library } from '@fortawesome/fontawesome-svg-core';

import { faCogs, faDatabase, faChartLine, faIndustry } from '@fortawesome/free-solid-svg-icons';

library.add(faCogs, faDatabase, faChartLine, faIndustry);


import { useRouter } from 'vue-router';
const router = useRouter();

const factoryStore = useFactoryOverviewStore();
const factoryPollStore = useFactoryPollOverviewStore();



const navigationHistoryStore = useNavigationHistoryStore();


const selectedMachine = ref(null);
const showMachineListModal2 = ref(false);
const selectedLine = ref('');
const selectedMachineType = ref('');

import { useMachineSamplingWithLimitsStore } from '@/stores/MachineSamplingWithLimitsStore'; 
const machineSamplingWithLimitsStore = useMachineSamplingWithLimitsStore();

onMounted(async () => {
  await factoryStore.fetchAndFormatData();
  // await factoryStore.fetchAndFormatData();
  await factoryPollStore.fetchInitialPageData();
});

const filteredMachines = computed(() => {
  if (!selectedLine.value) return [];
  const line = factoryStore.formattedOverviewData.lines.find(l => l.line_name === selectedLine.value);
  return line.machines.filter(m => 
    (selectedMachineType.value === 'WARNING' && m.count.WARNING > 0) ||
    (selectedMachineType.value === 'CRITICAL' && m.count.CRITICAL > 0) ||
    (selectedMachineType.value === 'OK' && m.machine_state === 'OK')
  );
});

const abnormalParameters = computed(() => {
  if (!selectedMachine.value) return [];
  return selectedMachine.value.parameters.filter(param => 
    param.parameter_state === 'WARNING' || param.parameter_state === 'CRITICAL'
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

// function getParameterGroup(machineName, parameterName) {
//   const group = factoryPollStore.groupData.find(group => 
//     group.group_details.some(line => 
//       line.machines.some(machine => 
//         machine.machine_name === machineName && 
//         machine.parameters.some(param => param.internal_parameter_name === parameterName)
//       )
//     )
//   );
//   return group ? group.group_name : 'Unknown Group';
// }


// function logParameterDetails(param, machine, groupName) {
//   console.log(`Parameter Details:`, param);
//   console.log(`Machine Name:`, machine);
//   console.log(`Group Name:`, groupName);

//   machineSamplingWithLimitsStore.machine = machine
//   machineSamplingWithLimitsStore.actualParameterName = param.actual_parameter_name;

//   machineSamplingWithLimitsStore.parameterGroup = groupName;
//       router.push('/machine-level-sampling');
// }


// Working code/function for the click routing to graph page


// function logParameterDetails(param, machineName, parameterGroup) {
//   console.log(`Parameter Details:`, param);
//   console.log(`Machine Name:`, machineName);
//   console.log(`Parameter Group:`, parameterGroup);

//   machineSamplingWithLimitsStore.machine = machineName
//   machineSamplingWithLimitsStore.actualParameterName = param.actual_parameter_name;

//   machineSamplingWithLimitsStore.parameterGroup = parameterGroup;
//       router.push('/machine-level-sampling');
// }


function logParameterDetails(param, machineName, parameterGroup) {
  console.log(`Parameter Details:`, param);
  console.log(`Machine Name:`, machineName);
  console.log(`Parameter Group:`, parameterGroup);

  const details = {
    machine: machineName,
    actualParameterName: param.actual_parameter_name,
    parameterGroup: parameterGroup
  };

  machineSamplingWithLimitsStore.setMachineDetails(details);
  machineSamplingWithLimitsStore.setLastSelectedParameter(details);
  navigationHistoryStore.addToHistory(router.currentRoute.value);
  router.push('/machine-level-sampling');
}



function getParameterGroup(machineName, parameterName) {
  const group = factoryPollStore.groupData.find(group => 
    group.group_details.some(line => 
      line.machines.some(machine => 
        machine.machine_name === machineName && 
        machine.parameters.some(param => param.internal_parameter_name === parameterName)
      )
    )
  );
  console.log("Found group:", group ? group.group_name : 'Unknown Group');
  return group ? group.group_name : 'Unknown Group';
}


// function showRoutingPopup(e, cell) {
//   if (cell && typeof cell.getValue === 'function') {
//     const value = cell.getValue();
//     if (confirm(`Are you sure you want to route to the parameter: ${value}?`)) {
//       console.log(`Routing to parameter: ${value}`);
//       // Add your routing logic here

//       machineSamplingWithLimitsStore.machine = cell.getData().name
//   machineSamplingWithLimitsStore.actualParameterName = cell.getData().parameter_name;

//   machineSamplingWithLimitsStore.parameterGroup = cell.getData().group_name;
//       router.push('/machine-level-sampling');
//     }
//   } else {
//     console.error("Invalid cell object passed to showRoutingPopup");
//   }
//   // console.log(cell.getData().parameter_name)
//   // console.log(cell.getData().name)
//   // console.log(cell.getData().group_name)
// }


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

function formatDate(timestamp) {
  return new Date(timestamp).toLocaleString();
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