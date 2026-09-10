<script setup>
import { computed, ref, onBeforeMount, onBeforeUnmount, watch } from "vue";

import SteplineChart from "@/components/Charts/SteplineChart.vue";
import TimePickerFlatEmitter from "@/components/TimePickerFlatEmitter.vue";
import BaseButton from "@/components/BaseButton.vue";
import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";
import CardBoxWidgetPlainWrap from "@/components/CardBoxWidgetPlainWrap.vue";

//Importing Store Statements

import { useSpecialPurposeMachineDetailStore } from '@/stores/SpecialPurposeMachineDetailStore'; 
import { useRouter, useRoute } from 'vue-router';
import { useNavigationHistoryStore } from '@/stores/navigationHistoryStore';

const router = useRouter();
const route = useRoute();
const navigationHistoryStore = useNavigationHistoryStore();

const selectedParameters = ref([]);

const specialPurposeMachineDetailStore = useSpecialPurposeMachineDetailStore();
const chartData = specialPurposeMachineDetailStore.chartData

const warningInput = ref(specialPurposeMachineDetailStore.warningLimit);
const criticalInput = ref(specialPurposeMachineDetailStore.criticalLimit);

const updateWarning = () => {
  const warningLimit = parseFloat(warningInput.value);
  if (!isNaN(warningLimit)) {
    specialPurposeMachineDetailStore.updateLimits("warning_limit", warningLimit);
  }
};

const updateCritical = () => {
  const criticalLimit = parseFloat(criticalInput.value);
  if (!isNaN(criticalLimit)) {
    specialPurposeMachineDetailStore.updateLimits("critical_limit", criticalLimit);
  }
};


let seriesData = computed(() => {
  return specialPurposeMachineDetailStore.seriesData;
});

const seriesArray = [seriesData];
console.log("first series")
console.log(seriesArray)

let availableParameters = computed(() => {
  console.log("computing");
  return specialPurposeMachineDetailStore.availableParameters;
});

let warningLimit = computed(() => {
  return specialPurposeMachineDetailStore.warningLimit;
});

let criticalLimit = computed(() => {
  return specialPurposeMachineDetailStore.criticalLimit;
});

let hoverData = computed(() => {
  return specialPurposeMachineDetailStore.hoverData;
});

function subtractHours(date, hours) {
  date.setHours(date.getHours() - hours);

  return date;
}

let currentDate = new Date();

specialPurposeMachineDetailStore.selectedDates.to = currentDate.getTime();

let oneHourEarlier = subtractHours(currentDate, 1);
let formattedDateOneHourEarlier = oneHourEarlier.getTime();

specialPurposeMachineDetailStore.selectedDates.from = formattedDateOneHourEarlier;

const handleQuerySubmit = async () => {
  // Getting the Initial Latest Data from the backend - Start
  specialPurposeMachineDetailStore.setSelectedParameters(selectedParameters.value);
  console.log("Selected Parameters:", specialPurposeMachineDetailStore.selectedParameters);
 
  await specialPurposeMachineDetailStore.fetchMachineParameterData(true);
  console.log("updateedddddddddd")
  console.log(specialPurposeMachineDetailStore.chartData)
   
};

// const handleBack = async () => {
//   const routeObject = { name: 'Factory Level Polling Parameter Overview Grid',
//    params: { groupName: specialPurposeMachineDetailStore.parameterGroup } };
//   router.push(routeObject);
// };

function applyRouteMachine() {
  const queryMachine = route.query.machine;
  if (queryMachine) {
    specialPurposeMachineDetailStore.setSelectedMachine(String(queryMachine));
  }
  const queryParam = route.query.param;
  if (queryParam) {
    specialPurposeMachineDetailStore.setPendingParameter(String(queryParam));
  }
}

const handleBack = async () => {
  const historyEntry = navigationHistoryStore.history.length
    ? navigationHistoryStore.history[navigationHistoryStore.history.length - 1]
    : null;
  const fromHistory = historyEntry?.fullPath || historyEntry?.path || '';
  const candidate = fromHistory && !String(fromHistory).includes('spm-detail')
    ? fromHistory
    : specialPurposeMachineDetailStore.resolveBackPath();

  if (fromHistory && !String(fromHistory).includes('spm-detail')) {
    navigationHistoryStore.removeLastRoute();
  }
  router.push(candidate || '/spm-overview');
};


const handleFromDateChange = (dateValue) => {
  // Handle the "from" date change event here
  // Perform any additional actions as needed
  specialPurposeMachineDetailStore.selectedDates.from = dateValue.value;
};

const handleToDateChange = (dateValue) => {
  // Handle the "to" date change event here
  // Perform any additional actions as needed
  specialPurposeMachineDetailStore.selectedDates.to = dateValue.value;
};

const isParamDropdownOpen = ref(false);
const paramSearch = ref('');

const filteredParameters = computed(() => {
  const list = availableParameters.value || [];
  const query = paramSearch.value.trim().toLowerCase();
  if (!query) return list;
  return list.filter((parameter) => {
    const label = formatGrindingParamLabel(parameter.name).toLowerCase();
    return label.includes(query) || String(parameter.name || '').toLowerCase().includes(query);
  });
});

function paramStateDot(state) {
  return {
    OK: 'bg-emerald-600',
    WARNING: 'bg-yellow-600',
    CRITICAL: 'bg-red-600',
  }[state] || 'bg-slate-400';
}

function toggleParamDropdown() {
  isParamDropdownOpen.value = !isParamDropdownOpen.value;
  if (!isParamDropdownOpen.value) paramSearch.value = '';
}

function closeParamDropdown(event) {
  const root = event.target.closest?.('.spm-param-dropdown');
  if (!root) isParamDropdownOpen.value = false;
}

onBeforeMount(async () => {
  applyRouteMachine();
  await specialPurposeMachineDetailStore.fetchMachineParameterList();
  await initializeParameterSelection();
});

onBeforeUnmount(() => {
  document.removeEventListener('click', closeParamDropdown);
});

watch(isParamDropdownOpen, (open) => {
  if (open) {
    setTimeout(() => document.addEventListener('click', closeParamDropdown), 0);
  } else {
    document.removeEventListener('click', closeParamDropdown);
  }
});

watch(
  () => route.query.machine,
  async (queryMachine, prevQuery) => {
    if (!queryMachine || String(queryMachine) === String(prevQuery || '')) return;
    applyRouteMachine();
    await specialPurposeMachineDetailStore.fetchMachineParameterList();
    await initializeParameterSelection();
  }
);

function convertEpochToLocal(epochTimestamp) {
  // Create a Date object from the epoch timestamp
  const date = new Date(epochTimestamp);

  // Get the local date and time components in user-friendly format
  const options = {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    timeZoneName: 'short', // Include time zone abbreviation for clarity
  };

  // Format the local datetime string
  const localDateTimeString = date.toLocaleString('en-IN', options);

  return localDateTimeString;
}


function OnHoverCallBack(hoverData){
  console.log("hover parent");
  console.log(hoverData);
  let dateTime = convertEpochToLocal(hoverData[0]["xval"]);
  let newHoverData = {
      "xAxisValue": dateTime,
      "yAxisValue": hoverData[0]["yval"],
      "xAxisLabel": specialPurposeMachineDetailStore.hoverData.xAxisLabel,
      "yAxisLabel": specialPurposeMachineDetailStore.hoverData.yAxisLabel,
      "xAxisUnits": specialPurposeMachineDetailStore.hoverData.xAxisUnits,
      "yAxisUnits": specialPurposeMachineDetailStore.hoverData.yAxisUnits
    }
  specialPurposeMachineDetailStore.hoverData = newHoverData;
}

// Define redirectToPosition method to handle the "Position" button click
const redirectToPosition = () => {
  router.push({
    path: '/spm-detail-position',
    query: specialPurposeMachineDetailStore.machine
      ? { machine: specialPurposeMachineDetailStore.machine }
      : {},
  });
};


const isGrindingMachine = computed(() => {
  const name = String(specialPurposeMachineDetailStore.machine || '').toUpperCase();
  return (name.includes('JOURNAL') && name.includes('GRINDING'))
    || /JOP[_\s-]*(105|130|140)/.test(name);
});

const activeGrindingParameter = computed(() => {
  if (!isGrindingMachine.value) return '';
  const values = selectedParameters.value || [];
  return values[values.length - 1] || '';
});

function formatGrindingParamLabel(name) {
  const match = String(name || '').match(/^(MeasurementData\([^)]+\))/i);
  return match ? match[1] : (name || '');
}

function findDefaultAeParameter(params, machineName) {
  const names = (params || []).map((p) => p.name).filter(Boolean);
  const aeMatch = names.find((name) => /AE_GRAPH_SCAL_DP/i.test(name));
  if (aeMatch) return aeMatch;
  const jop = String(machineName || '').match(/JOP[_\s-]*(\d+)/i);
  if (jop) {
    const suffix = names.find((name) => name.includes(jop[1]) && /AE_GRAPH/i.test(name));
    if (suffix) return suffix;
  }
  return names[0] || '';
}

function applyLimitsForParameter(parameterName) {
  const param = (specialPurposeMachineDetailStore.availableParameters || [])
    .find((item) => item.name === parameterName);
  const warning = param?.warning_limit;
  const critical = param?.critical_limit;
  warningInput.value = warning ?? '';
  criticalInput.value = critical ?? '';
  specialPurposeMachineDetailStore.warningLimit = warning ?? 0;
  specialPurposeMachineDetailStore.criticalLimit = critical ?? 0;
  specialPurposeMachineDetailStore.actualParameterName = parameterName;
}

function matchPendingParameter(pending, names) {
  if (!pending) return '';
  if (names.includes(pending)) return pending;
  const pendingUpper = String(pending).toUpperCase();
  return names.find((name) => {
    const upper = String(name).toUpperCase();
    return upper.includes(pendingUpper) || pendingUpper.includes(upper);
  }) || '';
}

function initializeGrindingSelection() {
  return initializeParameterSelection();
}

async function initializeParameterSelection() {
  const params = specialPurposeMachineDetailStore.availableParameters || [];
  const names = params.map((p) => p.name).filter(Boolean);
  const pendingMatch = matchPendingParameter(
    specialPurposeMachineDetailStore.pendingParameter || route.query.param,
    names
  );
  const initial = pendingMatch
    || (isGrindingMachine.value
      ? findDefaultAeParameter(params, specialPurposeMachineDetailStore.machine)
      : (names[0] || ''));

  selectedParameters.value = initial ? [initial] : [];
  specialPurposeMachineDetailStore.setSelectedParameters(selectedParameters.value);
  if (initial) applyLimitsForParameter(initial);
  specialPurposeMachineDetailStore.setPendingParameter('');

  if (initial) {
    await specialPurposeMachineDetailStore.fetchMachineParameterData(false);
  }
}

watch(selectedParameters, (values) => {
  if (!isGrindingMachine.value || !values.length) return;
  applyLimitsForParameter(values[values.length - 1]);
});

const isPositionButtonDisabled = computed(() => {
  const machineName = specialPurposeMachineDetailStore.machine;

  if (
    machineName === "JOURNAL FINISH-GRINDING_JOP_105" ||
    machineName === "JOURNAL FINISH-GRINDING_JOP_140" ||
    machineName === "JOURNAL FINISH-GRINDING_JOP_130"
  ) {
    return true;
  }

  return false;
});

</script>

<template>
  <LayoutAuthenticatedSimple>
    <section class="spm-detail-page px-4 py-3 flex flex-col gap-3 overflow-hidden">
      <div
        v-if="specialPurposeMachineDetailStore.alertMessage"
        :class="{
          'alert': true,
          'bg-emerald-500 border-black': specialPurposeMachineDetailStore.isSuccessMessage,
          'bg-red-600 border-black': !specialPurposeMachineDetailStore.isSuccessMessage
        }"
      >
        {{ specialPurposeMachineDetailStore.alertMessage }}
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-5 gap-4 flex-shrink-0">
        <CardBoxWidgetPlainWrap
          label="Machine Name"
          :parameter-value="specialPurposeMachineDetailStore.machine"
          class="h-36"
        />
        <CardBoxWidgetPlainWrap label="Warning Limit" class="h-36">
          <div class="flex flex-row items-center">
            <div class="relative mt-2">
              <input v-model="warningInput" type="number" class="w-full h-8 p-2 border-2 border-black rounded-lg" />
            </div>
            <button type="button" @click="updateWarning" class="text-blue-500 mx-2 mt-2">
              <img class="w-12" src="@/assets/icons/update.svg" alt="Update warning">
            </button>
          </div>
        </CardBoxWidgetPlainWrap>
        <CardBoxWidgetPlainWrap label="Critical Limit" class="h-36">
          <div class="flex flex-row items-center">
            <div class="relative mt-2">
              <input v-model="criticalInput" type="number" class="w-full h-8 p-2 border-2 border-black rounded-lg" />
            </div>
            <button type="button" @click="updateCritical" class="text-blue-500 mx-2 mt-2">
              <img class="w-12" src="@/assets/icons/update.svg" alt="Update critical">
            </button>
          </div>
        </CardBoxWidgetPlainWrap>
        <CardBoxWidgetPlainWrap
          v-if="isGrindingMachine"
          label="Selected Parameter"
          :parameter-value="formatGrindingParamLabel(activeGrindingParameter)"
          class="h-36"
          :title="activeGrindingParameter"
        />
        <div class="relative h-36 spm-param-dropdown">
          <CardBoxWidgetPlainWrap label="Parameters" class="h-36">
            <div
              class="w-full mt-2 p-2 bg-slate-50 text-black border rounded-lg shadow cursor-pointer"
              :title="selectedParameters.length ? selectedParameters[selectedParameters.length - 1] : ''"
              @click.stop="toggleParamDropdown"
            >
              <div class="flex justify-between items-center gap-2">
                <span class="mr-2 truncate">
                  {{ selectedParameters.length ? formatGrindingParamLabel(selectedParameters[selectedParameters.length - 1]) : 'Select parameters' }}
                </span>
                <div class="flex items-center gap-1 flex-shrink-0">
                  <div
                    v-for="name in selectedParameters"
                    :key="name"
                    :class="[
                      paramStateDot((availableParameters || []).find((item) => item.name === name)?.item_state),
                      'w-4 h-4 rounded-full'
                    ]"
                  />
                </div>
              </div>
            </div>
          </CardBoxWidgetPlainWrap>
          <div
            v-if="isParamDropdownOpen"
            class="absolute top-full left-0 w-full border rounded shadow bg-white z-30 mt-1"
            @click.stop
          >
            <div class="p-2 max-h-48 overflow-y-auto m-1">
              <input
                type="text"
                v-model="paramSearch"
                placeholder="Search..."
                class="w-full border rounded p-2 mb-2"
              />
              <label
                v-for="(parameter, index) in filteredParameters"
                :key="parameter.name || index"
                class="flex items-center cursor-pointer p-2 hover:bg-gray-100"
                :class="{ 'opacity-50': selectedParameters.length >= 3 && !selectedParameters.includes(parameter.name) }"
                :title="parameter.name"
              >
                <input
                  type="checkbox"
                  class="mr-2"
                  :value="parameter.name"
                  v-model="selectedParameters"
                  :disabled="selectedParameters.length >= 3 && !selectedParameters.includes(parameter.name)"
                />
                <span class="truncate">{{ formatGrindingParamLabel(parameter.name) }}</span>
                <span
                  :class="[paramStateDot(parameter.item_state), 'w-4 h-4 rounded-full ml-auto flex-shrink-0']"
                />
              </label>
            </div>
          </div>
        </div>
      </div>

      <div class="flex flex-wrap items-end gap-6 flex-shrink-0">
        <div>
          <label class="block mb-2 text-gray-700 dark:text-slate-300">From</label>
          <TimePickerFlatEmitter :defaultDatetime="subtractHours(new Date(), 1)" type="from" @date-change="handleFromDateChange" />
        </div>
        <div>
          <label class="block mb-2 text-gray-700 dark:text-slate-300">To</label>
          <TimePickerFlatEmitter :defaultDatetime="new Date()" type="to" @date-change="handleToDateChange" />
        </div>
        <BaseButton type="submit" color="info" label="Submit" @click="handleQuerySubmit" />
        <BaseButton
          v-if="!isPositionButtonDisabled"
          type="button"
          color="info"
          label="POSITION"
          @click="redirectToPosition"
        />
      </div>

      <div class="flex-1 min-h-0 flex flex-col">
        <h1 class="text-lg font-semibold mb-1">Stepline Chart</h1>
        <p
          v-if="specialPurposeMachineDetailStore.chartEmptyMessage"
          class="text-sm text-slate-500 mb-1"
        >
          {{ specialPurposeMachineDetailStore.chartEmptyMessage }}
        </p>
        <SteplineChart :data="chartData" />
      </div>
    </section>
  </LayoutAuthenticatedSimple>
</template>

<style scoped>
.spm-detail-page {
  height: 100%;
  width: 100%;
  max-width: 100%;
  box-sizing: border-box;
}

.spm-param-dropdown {
  overflow: visible;
}

@keyframes slideIn {
  from { transform: translateX(100%); }
  to { transform: translateX(0); }
}
.alert {
  @apply fixed top-10 left-1/2 transform -translate-x-1/2 text-white p-2 rounded-md border z-50;
  animation: slideIn 0.5s ease-out;
}
</style>