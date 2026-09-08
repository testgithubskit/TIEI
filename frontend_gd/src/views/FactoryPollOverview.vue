<script setup>
import { backendApi } from '@/services/apiServices';
import { computed, ref, onMounted, onBeforeMount, watch, onBeforeUnmount } from "vue";
import { useRoute } from 'vue-router';
import {
  mdiChartTimelineVariant,
  mdiGithub,
} from "@mdi/js";


import SectionMain from "@/components/SectionMain.vue";
import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";
import SectionTitleLineWithButton from "@/components/SectionTitleLineWithButton.vue";
import BaseButton from "@/components/BaseButton.vue";
import BlurryHorizontalDivider from "@/components/BlurryHorizontalDivider.vue";
import ProductionLine from "@/components/ProductionLine.vue";
import ParameterWithDropDown from "@/components/ParameterWithDropDown.vue";
import StatefulDropdownSingleSelect from "@/components/StatefulDropdownSingleSelect.vue";
import AbnormalitySummary from "@/components/AbnormalitySummary.vue";
import MachineWithCycleTime from "@/components/MachineWithCycleTime.vue";

import Toastify from 'toastify-js';
import 'toastify-js/src/toastify.css';

//Importing Store Statements

import { useFactoryPollOverviewStore } from '@/stores/FactoryPollGridStore'; 
import { useMachineSamplingWithLimitsStore, pressureTimeToEpoch } from '@/stores/MachineSamplingWithLimitsStore'; 
import { useNavigationHistoryStore } from '@/stores/navigationHistoryStore';

import { useRouter } from 'vue-router';

import { Tooltip } from 'ant-design-vue';
import { RightCircleOutlined } from '@ant-design/icons-vue'; // Change this line
import { useDatabaseName } from '@/stores/DatabaseName';
import { combineAirHoningSignals, recountMachineStates } from '@/services/airHoningUtils';

const router = useRouter();
const route = useRoute();
const factoryPollOverviewGridStore = useFactoryPollOverviewStore();
const machineSamplingWithLimitsStore = useMachineSamplingWithLimitsStore();
const navigationHistoryStore = useNavigationHistoryStore();
const DatabaseName = useDatabaseName();
const isPageLoading = ref(true);

// Cycle time specific state
const isCycleTimeSelected = ref(false);
const cycleTimeData = ref(null);

let initialSelectedParameter = ref(null);

let groupDataIndex = computed(() => {
  return factoryPollOverviewGridStore.groupData.findIndex(group => group.group_name === factoryPollOverviewGridStore.SelectedParmeter.item_name);
});

let isLoading = ref(false);

let selectedParameterGroupInfo = computed(() => {
  const group = factoryPollOverviewGridStore.groupData[groupDataIndex.value];
  if (!group) {
    return group;
  }

  const groupDetails = (group.group_details || []).map((line) => {
    const machines = combineAirHoningSignals(line.machines || []);
    return {
      ...line,
      machines,
      count: recountMachineStates(machines),
    };
  });

  return {
    ...group,
    group_details: groupDetails,
    count: groupDetails.reduce((totals, line) => {
      totals.OK += line.count.OK || 0;
      totals.WARNING += line.count.WARNING || 0;
      totals.CRITICAL += line.count.CRITICAL || 0;
      totals.DISCONNECTED += line.count.DISCONNECTED || 0;
      return totals;
    }, { OK: 0, WARNING: 0, CRITICAL: 0, DISCONNECTED: 0 }),
  };
});

const groupCount = computed(() => {
  // If CYCLE_TIME is selected, calculate counts from cycleTimeData
  if (factoryPollOverviewGridStore.SelectedParmeter.item_name === 'CYCLE_TIME' && cycleTimeData.value) {
    let okCount = 0;
    let warningCount = 0;
    let criticalCount = 0;
    let disconnectedCount = 0;

    cycleTimeData.value.lines.forEach(line => {
      okCount += line.count.OK || 0;
      warningCount += line.count.WARNING || 0;
      criticalCount += line.count.CRITICAL || 0;
      disconnectedCount += line.count.DISCONNECTED || 0;
    });

    return {
      OK: okCount,
      WARNING: warningCount,
      CRITICAL: criticalCount,
      DISCONNECTED: disconnectedCount,
    };
  }

  // For other parameters, use the combined Air Honing–aware group data
  if (selectedParameterGroupInfo.value?.count) {
    return selectedParameterGroupInfo.value.count;
  }

  // Default count if the group is not found
  return {
    OK: 0,
    WARNING: 0,
    CRITICAL: 0,
    DISCONNECTED: 0,
  };
});

const totalMachines = computed(() => { 
  return groupCount.value.OK + groupCount.value.WARNING + groupCount.value.CRITICAL + groupCount.value.DISCONNECTED;
});

const getGridColumnsClass = computed(() => {
  return (length) => {
    return `grid grid-cols-3 gap-6 lg:grid-cols-${length} mb-6`;
  };
});

let availableParameters = ref(factoryPollOverviewGridStore.availableParameters);

let abnormalParameters =  computed(() => {
  let params = availableParameters.value.filter(parameter => parameter.item_state !== "OK");
  
  // Add CYCLE_TIME to abnormal parameters if it has WARNING or CRITICAL machines (only when CYCLE_TIME is selected)
  if (factoryPollOverviewGridStore.SelectedParmeter.item_name === 'CYCLE_TIME' && cycleTimeData.value) {
    let totalWarning = 0;
    let totalCritical = 0;
    
    cycleTimeData.value.lines.forEach(line => {
      totalWarning += line.count.WARNING || 0;
      totalCritical += line.count.CRITICAL || 0;
    });
    
    // Determine cycle time state based on counts
    let cycleTimeState = 'OK';
    if (totalCritical > 0) {
      cycleTimeState = 'CRITICAL';
    } else if (totalWarning > 0) {
      cycleTimeState = 'WARNING';
    }
    
    // Add to abnormal parameters if not OK
    if (cycleTimeState !== 'OK') {
      // Remove existing CYCLE_TIME if present
      params = params.filter(p => p.item_name !== 'CYCLE_TIME');
      // Add CYCLE_TIME with current state
      params.push({ item_name: 'CYCLE_TIME', item_state: cycleTimeState });
    }
  }
  
  return params;
});


const combinedLabel = (subSectionName) => {
  return `${subSectionName} : ${totalMachines.value}`;
};

const borderClass = computed(() => {
  return `rounded-lg shadow-lg  hover:shadow-md transition-shadow duration-10`;
});

const getLineBgColor = (lineState) => {
  return {
    OK: "bg-emerald-600",
    WARNING: "bg-yellow-600",
    CRITICAL: "bg-red-600",
    DISCONNECTED: "bg-slate-500"
  }[lineState];
};

const getLineCount = (line, state) => {
  return line.machines.filter(m => m.machine_state === state).length;
};


// Shared init promise so onMounted can wait for the real group selection.
// Without this, onMounted fires the first fetch while SelectedParmeter is still
// the store placeholder, causing a spurious request for a non-existent group.
let pageInitPromise = null;

const initializePage = async () => {
  isPageLoading.value = true;
  let groupNameFromRoute = router.currentRoute.value.params.groupName || null;
  await factoryPollOverviewGridStore.fetchInitialPageData();
  await DatabaseName.fetchSchemaName();
  if (groupNameFromRoute !== null) {
    factoryPollOverviewGridStore.setSelectedGroup(groupNameFromRoute);
    let groupDetails = factoryPollOverviewGridStore.getGroupDetail(groupNameFromRoute);
    let informalGroupName = groupNameFromRoute.split('_').map(part => part.charAt(0).toUpperCase() + part.slice(1)).join(' ');
    let selectedGroupDetails = {"label": informalGroupName, "state": groupDetails.groupState, "value": groupNameFromRoute};
    initialSelectedParameter.value = selectedGroupDetails;
  } else {
    const defaultGroupName = "APC_BATTERY";
    factoryPollOverviewGridStore.setSelectedGroup(defaultGroupName);
    let groupDetails = factoryPollOverviewGridStore.getGroupDetail(defaultGroupName);
    let informalGroupName = defaultGroupName.split('_').map(part => part.charAt(0).toUpperCase() + part.slice(1)).join(' ');
    let selectedGroupDetails = {"label": informalGroupName, "state": groupDetails.groupState, "value": defaultGroupName};
    initialSelectedParameter.value = selectedGroupDetails;
  }
};

onBeforeMount(() => {
  pageInitPromise = initializePage();
});

const isInitialLoading = ref(true);
const isParameterChanging = ref(false);

// Top-level poll handle + flag so cleanup always runs even though onMounted is
// async. Registering onBeforeUnmount after an await loses the component
// instance context, so the hook must be registered synchronously below.
let pollIntervalId = null;
let isUnmounted = false;

const stopPolling = () => {
  if (pollIntervalId !== null) {
    clearInterval(pollIntervalId);
    pollIntervalId = null;
  }
};

onMounted(async () => {
  setTimeout(() => {
    isInitialLoading.value = false;
  }, 5000);

  // Wait for the real group selection before the first fetch to avoid
  // requesting the placeholder group (e.g. Group-661).
  try {
    await pageInitPromise;
  } catch (error) {
    console.error('Page initialization failed:', error);
  }

  // Component may have been unmounted while awaiting; don't start polling.
  if (isUnmounted) {
    return;
  }

  if (factoryPollOverviewGridStore.SelectedParmeter && factoryPollOverviewGridStore.SelectedParmeter.item_name === 'CYCLE_TIME') {
    isCycleTimeSelected.value = true;
  }

  if (!isCycleTimeSelected.value) {
    factoryPollOverviewGridStore.updateGroupData();
  } else {
    fetchCycleTimeData();
  }

  // Set up the interval and store the ID at top level for reliable cleanup.
  stopPolling();
  pollIntervalId = setInterval(() => {
    isLoading.value = true; // Set loading to true before fetching data
    // Only update group data if not CYCLE_TIME
    if (!isCycleTimeSelected.value) {
      factoryPollOverviewGridStore.updateGroupData();
    } else {
      fetchCycleTimeData();
    }

    setTimeout(() => {
      isLoading.value = false; // Set loading to false after 1 second
    }, 1000);
  }, 5000);
});

// Registered synchronously so it always fires when leaving the grid page.
onBeforeUnmount(() => {
  isUnmounted = true;
  stopPolling();
});


const handleSelectedParameterUpdate = async (selectedItem) => {
  if (selectedItem && selectedItem.value !== undefined) {
    isParameterChanging.value = true;

    let newSelectedParameter = { item_name: selectedItem.value, item_state: selectedItem.state || '' };
    factoryPollOverviewGridStore.SelectedParmeter = newSelectedParameter;
    initialSelectedParameter.value = selectedItem;

    // Check if CYCLE_TIME is selected
    isCycleTimeSelected.value = selectedItem.value === 'CYCLE_TIME';

    // Clear localStorage cycle time flag when changing parameters
    localStorage.setItem('isCycleTimeSelected', 'false');

    if (isCycleTimeSelected.value) {
      await fetchCycleTimeData();
    } else {
      cycleTimeData.value = null;
    }

    // Show loading overlay for 3 seconds
    setTimeout(() => {
      isParameterChanging.value = false;
    }, 3000);

    Toastify({
        text: 'Loading Real Time Data.',
        duration: 5000,
        close: true,
        gravity: 'bottom',
        position: 'right',
        backgroundColor: 'green',
      }).showToast();
  }
};

const handleParameterClick = async (selectedItem) => {

if (selectedItem !== null){

  let newSelectedParameter = { item_name: selectedItem.value, item_state: selectedItem.state };

  factoryPollOverviewGridStore.SelectedParmeter = newSelectedParameter;
  initialSelectedParameter.value = selectedItem;
}
};
const handleSelectedParameterUpdate2 = async (selectedItem) => {

if (selectedItem !== null){
  let newSelectedParameter = { item_name: selectedItem, item_state: selectedItem.state };
  console.log(newSelectedParameter)
//await factoryPollOverviewGridStore.updateGroupData(selectedItem.value);
  factoryPollOverviewGridStore.SelectedParmeter = newSelectedParameter;
  initialSelectedParameter.value = selectedItem;

}
};

watch(() => factoryPollOverviewGridStore.availableParameters, (newAvailableParameters) => {
  availableParameters.value = newAvailableParameters;
});

const handleMachineParameterClick = async (clickedParameter) => {
  const selectedGroup = factoryPollOverviewGridStore.SelectedParmeter.item_name;
  const isPressureClick = (
    clickedParameter.is_pressure_machine === true
    || selectedGroup === 'AIR_PRESSURE'
    || clickedParameter.machineName === '2nd Rough'
    || clickedParameter.machineName === '4th Finish'
  );

  const machineDetails = {
    machine: clickedParameter.machineName,
    actualParameterName: isPressureClick ? 'AIR_PRESSURE' : clickedParameter.actualParameterName,
    parameterGroup: isPressureClick ? 'AIR_PRESSURE' : selectedGroup,
    displayName: isPressureClick
      ? (clickedParameter.displayName || clickedParameter.machineName || '')
      : (clickedParameter.displayName || ''),
    isPressureMachine: isPressureClick,
    is_pressure_machine: isPressureClick,
    latest_update_time: clickedParameter.latest_update_time,
    latest_update_time_ms: clickedParameter.latest_update_time_ms,
  };
  if (isPressureClick) {
    machineDetails.lineName = 'BLOCK';
    machineDetails.line_name = 'BLOCK';
    machineDetails.line = 'BLOCK';
  }

  machineSamplingWithLimitsStore.setMachineDetails(machineDetails);
  machineSamplingWithLimitsStore.setLastSelectedParameter(machineDetails);
  navigationHistoryStore.addToHistory(router.currentRoute.value);

  if (selectedGroup === 'CYCLE_TIME') {
    machineSamplingWithLimitsStore.parameterGroup = 'CYCLE_TIME';
    machineSamplingWithLimitsStore.actualParameterName = 'CYCLE_TIME';
    machineSamplingWithLimitsStore.isPressureMachine = false;
    router.push('/machine-level-sampling');
  } else if (isPressureClick) {
    const latest = pressureTimeToEpoch(clickedParameter.latest_update_time_ms)
      || pressureTimeToEpoch(clickedParameter.latest_update_time);
    if (latest) {
      machineSamplingWithLimitsStore.refreshPressureTimestampAround(latest, 60);
    } else {
      machineSamplingWithLimitsStore.refreshPressureTimestamp(60);
    }
    await machineSamplingWithLimitsStore.fetchPressureMachineData();
    router.push('/air-pressure-sampling');
  } else {
    machineSamplingWithLimitsStore.isPressureMachine = false;
    machineSamplingWithLimitsStore.refreshTimestamp();
    await machineSamplingWithLimitsStore.fetchMachineParameterData();
    router.push('/machine-level-sampling');
  }
};

const fetchCycleTimeData = async () => {
  try {
    // Get default time range (last 1 hour)
    const toTime = new Date();
    const fromTime = new Date(toTime.getTime() - 60 * 60 * 1000); // 1 hour ago

    // Format dates as YYYY-MM-DD HH:MM:SS
    const formatDate = (date) => {
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, '0');
      const day = String(date.getDate()).padStart(2, '0');
      const hours = String(date.getHours()).padStart(2, '0');
      const minutes = String(date.getMinutes()).padStart(2, '0');
      const seconds = String(date.getSeconds()).padStart(2, '0');
      return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
    };

    const fromTimeStr = formatDate(fromTime);
    const toTimeStr = formatDate(toTime);

    const url = `/cycle-time/factory-layout?fromTime=${encodeURIComponent(fromTimeStr)}&toTime=${encodeURIComponent(toTimeStr)}`;

    const response = await backendApi.get(url);
    cycleTimeData.value = response.data;
    
    // Update CYCLE_TIME state in availableParameters based on fetched data
    let totalWarning = 0;
    let totalCritical = 0;
    
    response.data.lines.forEach(line => {
      totalWarning += line.count.WARNING || 0;
      totalCritical += line.count.CRITICAL || 0;
    });
    
    let cycleTimeState = 'OK';
    if (totalCritical > 0) {
      cycleTimeState = 'CRITICAL';
    } else if (totalWarning > 0) {
      cycleTimeState = 'WARNING';
    }
    
    // Update the state in the store
    const cycleTimeParam = factoryPollOverviewGridStore.availableParameters.find(p => p.item_name === 'CYCLE_TIME');
    if (cycleTimeParam) {
      cycleTimeParam.item_state = cycleTimeState;
    }
  } catch (error) {
    console.error('Error fetching cycle time data:', error);
  }
};

const handleMachineClick = (machineName) => {
  if (isCycleTimeSelected.value) {
    // Set the machine sampling store with cycle time parameters
    machineSamplingWithLimitsStore.machine = machineName;
    machineSamplingWithLimitsStore.parameterGroup = 'CYCLE_TIME';
    machineSamplingWithLimitsStore.actualParameterName = 'CYCLE_TIME';
    // Set localStorage flag to persist cycle time state on refresh
    localStorage.setItem('isCycleTimeSelected', 'true');
    router.push('/machine-level-sampling');
  }
};

// Watch for route changes to re-fetch cycle time data when navigating back
watch(() => route.fullPath, (newPath) => {
  if (newPath.includes('/factory-level-polling/parameter-overview/grid')) {
    // Check if CYCLE_TIME is selected from the store
    if (factoryPollOverviewGridStore.SelectedParmeter && factoryPollOverviewGridStore.SelectedParmeter.item_name === 'CYCLE_TIME') {
      isCycleTimeSelected.value = true;
      fetchCycleTimeData();
    }
  }
});

</script>

<template>
  <LayoutAuthenticatedSimple>
    <!-- Initial loading screen -->
    <div v-if="isInitialLoading" class="fixed inset-0 bg-gray-900 bg-opacity-50 flex items-center justify-center z-50">
      <div class="bg-white p-6 rounded-lg shadow-lg text-center">
        <img src="@/assets/gifs/Settings.gif" alt="Loading..." class="mx-auto mb-4 w-16 h-16">
        <p class="text-lg font-semibold">Loading Factory Data...</p>
      </div>
    </div>

    <!-- Parameter changing overlay -->
    <div v-if="isParameterChanging" class="fixed inset-0 bg-gray-900 bg-opacity-50 flex items-center justify-center z-50">
      <div class="bg-white p-6 rounded-lg shadow-lg text-center">
        <img src="@/assets/gifs/Settings.gif" alt="Loading..." class="mx-auto mb-4 w-16 h-16">
        <p class="text-lg font-semibold">Updating Parameter Data...</p>
      </div>
    </div>

    <SectionMain class="factory-poll-section">
      <div class="w-full flex flex-col space-y-1">
        <div class="w-8 h-8">
          <div v-if="isLoading" class="w-8 h-8 border-4 border-gray-200 border-t-blue-500 rounded-full animate-spin"></div>
        </div>

        <ParameterWithDropDown class="col-span-3" :icon="mdiChartTimelineVariant" title="Parameter:" main>
          <div class="flex items-center gap-3">
            <StatefulDropdownSingleSelect 
              @item-selected-update-parameter="handleSelectedParameterUpdate" 
              :items="availableParameters"
              :defaultSelectedItem="initialSelectedParameter" />
            <button
              type="button"
              @click="router.push('/managerialOverview')"
              class="inline-flex items-center px-4 py-2 text-sm font-medium rounded-md shadow-sm text-white bg-emerald-600 hover:bg-emerald-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-emerald-500 transition-all shrink-0"
            >
              Manager Dashboard
              <RightCircleOutlined class="ml-2" />
            </button>
          </div>
        </ParameterWithDropDown>

        <BlurryHorizontalDivider />
        
        <SectionTitleLineWithButton
            :icon="mdiChartTimelineVariant"
            title="Abnormality Summary"
            main
            >
        </SectionTitleLineWithButton>

        <AbnormalitySummary 
        :items="abnormalParameters"
        :cycleTimeData="cycleTimeData"
        @item-selected-update-parameter="handleParameterClick" />
        <BlurryHorizontalDivider />
        <div
          v-for="Section in factoryPollOverviewGridStore.sections"
          :key="Section.sectionName"
        >

          <div
            v-for="subSection in Section.subSections"
            :key="subSection.subSectionName"
          >
            <SectionTitleLineWithButton
            :icon="mdiChartTimelineVariant"
            :title="Section.sectionName"
            main
            >
              <BaseButton
                href="https://cmti.res.in/"
                target="_blank"
                :icon="mdiGithub"
                :label="combinedLabel(subSection.subSectionName)"
                color="contrast"
                rounded-full
                small
              />
            </SectionTitleLineWithButton>

            <div :class="getGridColumnsClass(subSection.components.length)">
              <component
                v-for="component in subSection.components"
                :is="component.type"
                :key="component.label"
                :label="component.label"
                :parameterValue="groupCount[component.label]"
                :icon="component.icon"
                :borderSide="component.borderSide"
                :borderThickness="component.borderThickness"
                :state="component.state"
              />
            </div>
          </div>
          <BlurryHorizontalDivider />
        </div>
      </div>
      
      <div class="w-full flex flex-col space-y-4">
        <!-- Cycle Time View -->
        <div v-if="isCycleTimeSelected" class="w-full flex flex-col space-y-4">
          <!-- Show message from backend if available -->
          <div v-if="cycleTimeData && cycleTimeData.message" class="p-4 bg-blue-100 border border-blue-400 rounded">
            <p class="font-semibold text-blue-800">{{ cycleTimeData.message }}</p>
          </div>

          <div v-if="cycleTimeData && cycleTimeData.lines && cycleTimeData.lines.length > 0">
            <div v-for="line in cycleTimeData.lines" :key="line.line_name" class="mb-4">
              <div :class="borderClass" class="flex flex-col mb-4 pb-4">
                <div :class="[getLineBgColor(line.line_state), 'p-4 rounded-t-lg text-white text-center h-30 flex items-center font-bold justify-center mb-4']">
                  <span>LINE: {{ line.line_name }}</span>
                  <span class="ml-2">Total: {{ line.machines.length }}</span>
                  <div class="flex items-center ml-4">
                    <span class="mr-2">OK: {{ getLineCount(line, 'OK') }}</span>
                    <span class="mr-2">WARNING: {{ getLineCount(line, 'WARNING') }}</span>
                    <span class="mr-2">CRITICAL: {{ getLineCount(line, 'CRITICAL') }}</span>
                    <span>DISCONNECTED: {{ getLineCount(line, 'DISCONNECTED') }}</span>
                  </div>
                </div>
                <div class="flex flex-wrap justify-start gap-4 px-4">
                  <MachineWithCycleTime
                    v-for="machine in line.machines"
                    :key="machine.machine_name"
                    :machineName="machine.machine_name"
                    :machineState="machine.machine_state"
                    :cycleTime="machine.parameter_value"
                    @machine-clicked="handleMachineParameterClick"
                  />
                </div>
              </div>
            </div>
          </div>
          <div v-else-if="cycleTimeData" class="p-4 bg-yellow-100 border border-yellow-400 rounded">
            <p class="font-semibold text-yellow-800">No cycle time data available in the selected time range.</p>
            <p class="text-sm text-yellow-700">Please try a different time range or check if cycle time data is being collected.</p>
          </div>
          <div v-else class="p-4 bg-red-100 border border-red-400 rounded">
            <p class="font-semibold text-red-800">Failed to load cycle time data.</p>
            <p class="text-sm text-red-700">Please check the console for errors and try again.</p>
          </div>
        </div>

        <!-- Regular Parameter View -->
        <ProductionLine
          v-if="!isCycleTimeSelected && selectedParameterGroupInfo && selectedParameterGroupInfo.group_details"
          v-for="line in selectedParameterGroupInfo.group_details"
          :key="line.line_name"
          :lineName="line.line_name"
          :lineState="line.line_state"
          :machines="line.machines"
          :count = "line.count"
          :highlightPressureMachines="factoryPollOverviewGridStore.SelectedParmeter.item_name === 'AIR_PRESSURE'"
          @machine-parameter-clicked="handleMachineParameterClick"
        >
        </ProductionLine>
      </div>
    </SectionMain>
  </LayoutAuthenticatedSimple>
</template>

<style scoped>
/* Use more of the horizontal viewport — less empty left/right margin */
:deep(.factory-poll-section),
.factory-poll-section {
  max-width: 100% !important;
  padding-left: 0.75rem;
  padding-right: 0.75rem;
}

@keyframes slideIn {
  from {
    transform: translateX(100%);
  }
  to {
    transform: translateX(0);
  }
}

.alert {
  @apply fixed top-10 left-1/2 transform -translate-x-1/2 text-white p-2 rounded-md border z-50;
  animation: slideIn 0.5s ease-out;
}
</style>
