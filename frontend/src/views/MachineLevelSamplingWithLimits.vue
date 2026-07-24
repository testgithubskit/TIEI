<script setup>
import { computed, ref, onBeforeMount, onMounted } from "vue";

import flatPickr from 'vue-flatpickr-component';
import 'flatpickr/dist/flatpickr.css';

import DyLineChartWithLimits from "@/components/Charts/DyLineChartWithLimits.vue";
import TimePickerFlatEmitter from "@/components/TimePickerFlatEmitter.vue";
import SectionMain from "@/components/SectionMain.vue";
import CardBox from "@/components/CardBox.vue";
import BaseButton from "@/components/BaseButton.vue";
import GraphLegend from "@/components/GraphLegend.vue";
import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";
import BlurryHorizontalDivider from "@/components/BlurryHorizontalDivider.vue";
import { use } from 'echarts/core';
import { BarChart } from 'echarts/charts';
import { GridComponent, TooltipComponent } from 'echarts/components';
import { CanvasRenderer } from 'echarts/renderers';
import VChart from 'vue-echarts';

// ECharts registration (cycle time bar chart)
use([GridComponent, TooltipComponent, BarChart, CanvasRenderer]);

import Toastify from 'toastify-js';
import 'toastify-js/src/toastify.css';

import CardBoxWidgetPlainWrap from "@/components/CardBoxWidgetPlainWrap.vue";
import { useNavigationHistoryStore } from '@/stores/navigationHistoryStore';

import { backendApi } from '@/services/apiServices';
import { useMachineSamplingWithLimitsStore } from '@/stores/MachineSamplingWithLimitsStore';
import { useActivityStore } from '@/stores/ActivityStore.js'; 
import { useRouter } from 'vue-router';

const router = useRouter();
const machineSamplingWithLimitsStore = useMachineSamplingWithLimitsStore();
const ActivityStore = useActivityStore();

// Cycle time specific state
const isCycleTimeSelected = ref(false);
const cycleTimeData = ref(null);
const cycleTimeChartData = ref([]);
const cycleTimeLimits = ref({ warning: null, critical: null });
const isCycleTimeLoading = ref(false);
const cycleTimeError = ref(null);
const cycleTimeWarningInput = ref(null);
const cycleTimeCriticalInput = ref(null);

const warningInput = ref(machineSamplingWithLimitsStore.warningLimit);
const criticalInput = ref(machineSamplingWithLimitsStore.criticalLimit);

const updateWarning = () => {
  const warningLimit = parseFloat(warningInput.value);
  if (!isNaN(warningLimit)) {
    machineSamplingWithLimitsStore.updateLimits("warning_limit", warningLimit);
  }
};

const updateCritical = () => {
  const criticalLimit = parseFloat(criticalInput.value);
  if (!isNaN(criticalLimit)) {
    machineSamplingWithLimitsStore.updateLimits("critical_limit", criticalLimit);
  }
};

// Computed property for cycle time bar chart option
const cycleTimeChartOption = computed(() => {
  if (!cycleTimeChartData.value || cycleTimeChartData.value.length === 0) {
    return {};
  }

  const times = cycleTimeChartData.value.map(item => item.time);
  const cycleTimes = cycleTimeChartData.value.map(item => item.cycle_time);
  const pointCount = times.length;
  const selectedDurationMs = Math.max(
    0,
    Number(machineSamplingWithLimitsStore.selectedDates.to || 0)
      - Number(machineSamplingWithLimitsStore.selectedDates.from || 0),
  );
  const tenHoursMs = 10 * 60 * 60 * 1000;
  // Long ranges: keep all bars, but thin x-axis labels to ~10–15 readable ticks
  let axisLabelInterval = 0;
  if (selectedDurationMs > tenHoursMs && pointCount > 15) {
    const targetLabels = 12;
    axisLabelInterval = Math.max(0, Math.ceil(pointCount / targetLabels) - 1);
  }

  return {
    tooltip: {
      trigger: 'axis',
      axisPointer: {
        type: 'shadow'
      },
      formatter: function(params) {
        return `${params[0].axisValue}<br/>Cycle Time: ${params[0].value}s`;
      }
    },
    grid: {
      top: '10%',
      left: '3%',
      right: '4%',
      bottom: '15%',
      containLabel: true
    },
    xAxis: {
      type: 'category',
      data: times,
      axisLabel: {
        rotate: 45,
        interval: axisLabelInterval,
        hideOverlap: true,
        textStyle: {
          fontSize: 10
        }
      }
    },
    yAxis: {
      type: 'value',
      name: 'Cycle Time (seconds)'
    },
    series: [{
      name: 'Cycle Time',
      type: 'bar',
      data: cycleTimes,
      itemStyle: {
        color: function(params) {
          if (params.value >= cycleTimeLimits.value.critical) {
            return '#ef4444';
          } else if (params.value >= cycleTimeLimits.value.warning) {
            return '#f59e0b';
          } else {
            return '#22c55e';
          }
        }
      },
      markLine: {
        data: [
          {
            yAxis: cycleTimeLimits.value.warning,
            label: {
              formatter: 'Warning Limit'
            },
            lineStyle: {
              color: '#f59e0b',
              type: 'dashed'
            }
          },
          {
            yAxis: cycleTimeLimits.value.critical,
            label: {
              formatter: 'Critical Limit'
            },
            lineStyle: {
              color: '#ef4444',
              type: 'dashed'
            }
          }
        ]
      }
    }]
  };
});

let chartData = computed(() => {
  return machineSamplingWithLimitsStore.chartData;
});

const hasChartData = computed(() => {
  const data = machineSamplingWithLimitsStore.chartData;
  if (!Array.isArray(data) || data.length === 0) {
    return false;
  }
  // Store uses [[0, 0]] as an error placeholder
  if (data.length === 1 && Number(data[0]?.[0]) === 0 && Number(data[0]?.[1]) === 0) {
    return false;
  }
  return true;
});

let warningLimit = computed(() => {
  return machineSamplingWithLimitsStore.warningLimit;
});

let criticalLimit = computed(() => {
  return machineSamplingWithLimitsStore.criticalLimit;
});

let hoverData = computed(() => {
  return machineSamplingWithLimitsStore.hoverData;
});

function subtractHours(date, hours) {
  date.setHours(date.getHours() - hours);
  return date;
}

const fromPickerRef = ref(null);
const toPickerRef = ref(null);

const fromPickerDatetime = computed(() => {
  return subtractHours(new Date(), 1);
});

const toPickerDatetime = computed(() => {
  return new Date();
});

/** Always sync store From/To from the visible pickers before API call */
function syncDatesFromPickers() {
  const fromEpoch = fromPickerRef.value?.getEpoch?.();
  const toEpoch = toPickerRef.value?.getEpoch?.();
  if (Number.isFinite(fromEpoch)) {
    machineSamplingWithLimitsStore.selectedDates.from = fromEpoch;
  }
  if (Number.isFinite(toEpoch)) {
    machineSamplingWithLimitsStore.selectedDates.to = toEpoch;
  }
  machineSamplingWithLimitsStore.normalizeInvertedPressureTimeRange();
}

const handleQuerySubmit = async () => {
  if (isCycleTimeSelected.value) {
    await handleCycleTimeSubmit();
    return;
  }

  syncDatesFromPickers();
  const sixHoursInMillis = 6 * 60 * 60 * 1000;
  const timeDifference = machineSamplingWithLimitsStore.selectedDates.to - machineSamplingWithLimitsStore.selectedDates.from;

  if (machineSamplingWithLimitsStore.parameterGroup === 'DYNAMIC_PARAMETERS' && timeDifference > sixHoursInMillis) {
    Toastify({
      text: 'For DYNAMIC_PARAMETERS, please select a time range less than 6 hours',
      duration: 5000,
      close: true,
      gravity: 'top',
      position: 'right',
      backgroundColor: 'red',
    }).showToast();
    return;
  }

  await machineSamplingWithLimitsStore.fetchMachineParameterData();
};

const handleQuerySubmitActivity = async () => {
  await ActivityStore.fetchActivityDataParameter(machineSamplingWithLimitsStore.actualParameterName);
  router.push("/corrective-activity");
};

const navigationHistoryStore = useNavigationHistoryStore();

const handleBack = () => {
  const previous = navigationHistoryStore.history.length
    ? navigationHistoryStore.history[navigationHistoryStore.history.length - 1]
    : null;

  const candidate = previous?.fullPath || previous?.path || '';
  const isLoginLike = (
    !candidate
    || candidate === '/'
    || candidate === '/#/'
    || String(candidate).toLowerCase().includes('login')
  );
  const isSelf = candidate.includes('machine-level-sampling');

  if (!isLoginLike && !isSelf) {
    navigationHistoryStore.removeLastRoute();
    router.push(candidate);
    return;
  }

  router.push('/factory-level-polling/parameter-overview/grid');
};

const handleFromDateChange = (dateValue) => {
  machineSamplingWithLimitsStore.selectedDates.from = dateValue.value;
  machineSamplingWithLimitsStore.persistSamplingSession();
};

const handleToDateChange = (dateValue) => {
  machineSamplingWithLimitsStore.selectedDates.to = dateValue.value;
  machineSamplingWithLimitsStore.persistSamplingSession();
};

onBeforeMount(() => {
  if (!machineSamplingWithLimitsStore.lastSelectedParameter) {
    machineSamplingWithLimitsStore.restoreSamplingSession();
  }
});

function convertEpochToLocal(epochTimestamp) {
  const date = new Date(epochTimestamp);
  const options = {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    timeZoneName: 'short',
  };
  return date.toLocaleString('en-IN', options);
}

onMounted(async () => {
  if (!machineSamplingWithLimitsStore.lastSelectedParameter) {
    machineSamplingWithLimitsStore.restoreSamplingSession();
  }

  const isCycleTimeFromStorage = localStorage.getItem('isCycleTimeSelected') === 'true';

  if (machineSamplingWithLimitsStore.parameterGroup === 'CYCLE_TIME' || isCycleTimeFromStorage) {
    isCycleTimeSelected.value = true;
    localStorage.setItem('isCycleTimeSelected', 'true');
    const currentDate = new Date();
    machineSamplingWithLimitsStore.selectedDates.to = currentDate.getTime();
    const oneHourEarlier = subtractHours(currentDate, 1);
    machineSamplingWithLimitsStore.selectedDates.from = oneHourEarlier.getTime();
    await fetchCycleTimeData();
  } else {
    isCycleTimeSelected.value = false;
    localStorage.setItem('isCycleTimeSelected', 'false');
    const currentDate = new Date();
    machineSamplingWithLimitsStore.selectedDates.to = currentDate.getTime();
    const oneHourEarlier = subtractHours(new Date(currentDate), 1);
    machineSamplingWithLimitsStore.selectedDates.from = oneHourEarlier.getTime();
    if (machineSamplingWithLimitsStore.lastSelectedParameter && machineSamplingWithLimitsStore.machine) {
      machineSamplingWithLimitsStore.setMachineDetails(machineSamplingWithLimitsStore.lastSelectedParameter);
      await machineSamplingWithLimitsStore.fetchMachineParameterData();
    }
  }
});

const fetchCycleTimeData = async () => {
  isCycleTimeLoading.value = true;
  cycleTimeError.value = null;
  try {
    const machineName = machineSamplingWithLimitsStore.machine;
    const fromTime = new Date(machineSamplingWithLimitsStore.selectedDates.from);
    const toTime = new Date(machineSamplingWithLimitsStore.selectedDates.to);

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

    const url = `/cycle-time/machine/${encodeURIComponent(machineName)}?fromTime=${encodeURIComponent(fromTimeStr)}&toTime=${encodeURIComponent(toTimeStr)}`;

    const response = await backendApi.get(url);
    cycleTimeData.value = response.data;
    
    if (response.data.warning_limit !== null && response.data.critical_limit !== null) {
      cycleTimeLimits.value = {
        warning: response.data.warning_limit,
        critical: response.data.critical_limit
      };
      
      cycleTimeWarningInput.value = response.data.warning_limit;
      cycleTimeCriticalInput.value = response.data.critical_limit;
    }

    cycleTimeChartData.value = response.data.cycle_time_data.map(item => ({
      time: new Date(item.time).toLocaleString(),
      cycle_time: item.cycle_time
    }));
  } catch (error) {
    console.error('Error fetching cycle time data:', error);
    cycleTimeError.value = error.response?.data?.detail || 'Failed to fetch cycle time data. Please try again.';
    Toastify({
      text: cycleTimeError.value,
      duration: 5000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: 'red',
    }).showToast();
  } finally {
    isCycleTimeLoading.value = false;
  }
};

const handleCycleTimeSubmit = async () => {
  await fetchCycleTimeData();
};

const updateCycleTimeLimits = async () => {
  try {
    const warningLimit = parseFloat(cycleTimeWarningInput.value);
    const criticalLimit = parseFloat(cycleTimeCriticalInput.value);
    
    if (isNaN(warningLimit) || isNaN(criticalLimit)) {
      Toastify({
        text: 'Please enter valid numeric values for limits',
        duration: 3000,
        close: true,
        gravity: 'bottom',
        position: 'right',
        backgroundColor: 'red',
      }).showToast();
      return;
    }
    
    if (warningLimit >= criticalLimit) {
      Toastify({
        text: 'Warning limit must be less than critical limit',
        duration: 3000,
        close: true,
        gravity: 'bottom',
        position: 'right',
        backgroundColor: 'red',
      }).showToast();
      return;
    }
    
    const machineName = machineSamplingWithLimitsStore.machine;
    const url = `/cycle-time/limits/${encodeURIComponent(machineName)}?warning_limit=${warningLimit}&critical_limit=${criticalLimit}`;
    
    const response = await backendApi.put(url);
    
    cycleTimeLimits.value = {
      warning: warningLimit,
      critical: criticalLimit
    };
    
    if (cycleTimeData.value) {
      cycleTimeData.value.warning_limit = warningLimit;
      cycleTimeData.value.critical_limit = criticalLimit;
    }
    
    Toastify({
      text: response.data.message || 'Cycle time limits updated successfully',
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: 'green',
    }).showToast();
    
    await fetchCycleTimeData();
  } catch (error) {
    console.error('Error updating cycle time limits:', error);
    Toastify({
      text: error.response?.data?.detail || 'Failed to update cycle time limits',
      duration: 5000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: 'red',
    }).showToast();
  }
};

function OnHoverCallBack(hoverData){
  if (!hoverData?.length) return;
  const preferredPoint = hoverData.find((point) => point?.name && !String(point.name).includes('Limit') && point.yval != null) || hoverData[0];
  const xval = preferredPoint.xval;
  const dateTime = typeof xval === 'number'
    ? convertEpochToLocal(xval)
    : String(xval);
  machineSamplingWithLimitsStore.hoverData = {
    xAxisValue: dateTime,
    yAxisValue: preferredPoint.yval,
    xAxisLabel: machineSamplingWithLimitsStore.hoverData.xAxisLabel || 'Time',
    yAxisLabel: machineSamplingWithLimitsStore.hoverData.yAxisLabel || 'Value',
    xAxisUnits: machineSamplingWithLimitsStore.hoverData.xAxisUnits || 'IST',
    yAxisUnits: machineSamplingWithLimitsStore.hoverData.yAxisUnits || '',
  };
}
</script>

<template>
  <LayoutAuthenticatedSimple>
    <SectionMain>
      <div class="w-full px-3 md:px-4 xl:px-6 2xl:px-8 flex flex-col space-y-4">
        <div v-if="machineSamplingWithLimitsStore.alertMessage" 
          :class="{ 'alert': true, 'bg-emerald-500 border-black': machineSamplingWithLimitsStore.isSuccessMessage,
          'bg-red-600 border-black': !machineSamplingWithLimitsStore.isSuccessMessage }">
          {{ machineSamplingWithLimitsStore.alertMessage }}
        </div>

        <BlurryHorizontalDivider />

        <div class="w-8 h-8 mb-2">
          <button @click="handleBack" class="w-full h-full flex items-center justify-center border border-green-500 rounded hover:bg-green-50 transition-colors" title="Back">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-green-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
            </svg>
          </button>
        </div>

        <!-- Display machine information Start -->
        <div class="grid grid-cols-1 gap-6 lg:grid-cols-5 mb-6">
          <CardBoxWidgetPlainWrap 
            label="Machine Name"
            :parameter-value="machineSamplingWithLimitsStore.machine">
          </CardBoxWidgetPlainWrap>
          <CardBoxWidgetPlainWrap 
            label="Parameter Group"
            :parameter-value="machineSamplingWithLimitsStore.parameterGroup">
          </CardBoxWidgetPlainWrap>
          <CardBoxWidgetPlainWrap 
            v-if="!isCycleTimeSelected"
            label="Parameter Name"
            :parameter-value="machineSamplingWithLimitsStore.actualParameterName">
          </CardBoxWidgetPlainWrap>
          <CardBoxWidgetPlainWrap 
            v-if="isCycleTimeSelected"
            label="Current Cycle Time"
            :parameter-value="isCycleTimeLoading ? 'Loading...' : (cycleTimeData ? cycleTimeData.cycle_time_value + 's' : 'N/A')">
          </CardBoxWidgetPlainWrap>
          <CardBoxWidgetPlainWrap 
            v-if="isCycleTimeSelected"
            label="Warning Limit:">
            <div class="flex flex-row">
              <div class="relative mt-2">
                <input v-model="cycleTimeWarningInput" type="number" class="w-full h-8 p-2 border-2 border-black rounded-lg" />
              </div>
              <button @click="updateCycleTimeLimits" class="text-blue-500 mx-2 mt-2">
                <img class="w-12" src="@/assets/icons/update.svg" alt="">
              </button>
            </div>
          </CardBoxWidgetPlainWrap>
          <CardBoxWidgetPlainWrap 
            v-if="!isCycleTimeSelected"
            label="Warning Limit:">
            <div class="flex flex-row">
              <div class="relative mt-2">
                <input v-model="warningInput" type="number" class="w-full h-8 p-2 border-2 border-black rounded-lg" />
              </div>
              <button @click="updateWarning" class="text-blue-500 mx-2 mt-2">
                <img class="w-12" src="@/assets/icons/update.svg" alt="">
              </button>
            </div>
          </CardBoxWidgetPlainWrap>

          <CardBoxWidgetPlainWrap 
            v-if="isCycleTimeSelected"
            label="Critical Limit:">
            <div class="flex flex-row">
              <div class="relative mt-2">
                <input v-model="cycleTimeCriticalInput" type="number" class="w-full h-8 p-2 border-2 border-black rounded-lg" />
              </div>
              <button @click="updateCycleTimeLimits" class="text-blue-500 mx-2 mt-2">
                <img class="w-12" src="@/assets/icons/update.svg" alt="">
              </button>
            </div>
          </CardBoxWidgetPlainWrap>
          <CardBoxWidgetPlainWrap 
            v-if="!isCycleTimeSelected"
            label="Critical Limit:">
            <div class="flex flex-row">
              <div class="relative mt-2">
                <input v-model="criticalInput" type="number" class="w-full h-8 p-2 border-2 border-black rounded-lg" />
              </div>
              <button @click="updateCritical" class="text-blue-500 mx-2 mt-2">
                <img class="w-12" src="@/assets/icons/update.svg" alt="">
              </button>
            </div>
          </CardBoxWidgetPlainWrap>
        </div>

        <BlurryHorizontalDivider />

        <div class="flex justify-normal">
          <div>
            <label class="block mb-2 text-gray-700">From</label>
            <TimePickerFlatEmitter
              ref="fromPickerRef"
              :defaultDatetime="fromPickerDatetime"
              type="from"
              @date-change="handleFromDateChange"
            />
          </div>

          <div class="ml-8">
            <label class="block mb-2 text-gray-700">To</label>
            <TimePickerFlatEmitter
              ref="toPickerRef"
              :defaultDatetime="toPickerDatetime"
              type="to"
              @date-change="handleToDateChange"
            />
          </div>

          <div class="flex flex-col items-center justify-end ml-8">
            <BaseButton type="submit" color="info" label="Submit" @click="handleQuerySubmit" />
          </div>

          <div v-if="isCycleTimeSelected && cycleTimeData" class="ml-8 flex flex-col justify-center">
            <label class="block mb-2 text-gray-700">Machine State</label>
            <span
              :class="{
                'text-red-600 font-semibold': cycleTimeData.machine_state === 'CRITICAL',
                'text-yellow-600 font-semibold': cycleTimeData.machine_state === 'WARNING',
                'text-green-600 font-semibold': cycleTimeData.machine_state === 'OK'
              }"
            >
              {{ cycleTimeData.machine_state }}
            </span>
          </div>

          <div v-if="!isCycleTimeSelected" class="flex flex-col items-center justify-end ml-8">
            <BaseButton type="submit" color="info" label="View Activity" @click="handleQuerySubmitActivity()" />
          </div>
        </div>

        <BlurryHorizontalDivider />

        <!-- Cycle Time Bar Chart -->
        <CardBox v-if="isCycleTimeSelected" class="mb-6">
          <h3 class="text-lg font-semibold mb-4">Cycle Time vs Time</h3>
          
          <!-- Loading indicator -->
          <div v-if="isCycleTimeLoading" class="flex items-center justify-center p-8">
            <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
            <span class="ml-4 text-gray-600">Loading cycle time data...</span>
          </div>
          
          <!-- Error message -->
          <div v-if="cycleTimeError" class="p-4 bg-red-100 border border-red-400 rounded mb-4">
            <p class="font-semibold text-red-800">{{ cycleTimeError }}</p>
          </div>
          
          <!-- Show message from backend if available -->
          <div v-if="cycleTimeData && cycleTimeData.message" class="p-4 bg-blue-100 border border-blue-400 rounded mb-4">
            <p class="font-semibold text-blue-800">{{ cycleTimeData.message }}</p>
          </div>
          <div v-if="cycleTimeData && cycleTimeData.cycle_time_data && cycleTimeData.cycle_time_data.length > 0" class="h-[600px]">
            <v-chart class="h-full" :option="cycleTimeChartOption" autoresize />
          </div>
          <div v-else-if="!isCycleTimeLoading && !cycleTimeError && !cycleTimeData?.message" class="p-4 bg-yellow-100 border border-yellow-400 rounded">
            <p class="font-semibold text-yellow-800">No cycle time data available for this machine in the selected time range.</p>
            <p class="text-sm text-yellow-700">Please try a different time range or check if cycle time data is being collected for this machine.</p>
          </div>
        </CardBox>

        <!-- Regular Chart (hidden when CYCLE_TIME is selected) -->
        <CardBox v-if="!isCycleTimeSelected" class="mb-8">
          <div v-if="!hasChartData" class="p-4 bg-yellow-100 border border-yellow-400 rounded">
            <p class="font-semibold text-yellow-800">
              {{ machineSamplingWithLimitsStore.chartFetchMessage || 'No data available for the selected time range.' }}
            </p>
          </div>
          <div v-else class="min-h-[440px]">
            <DyLineChartWithLimits
              :data="chartData"
              :warningLimit="warningLimit"
              :criticalLimit="criticalLimit"
              :step-plot="true"
              @data-hovered="OnHoverCallBack"
            />
          </div>
        </CardBox>      

        <BlurryHorizontalDivider />
        <GraphLegend v-if="!isCycleTimeSelected" :data="hoverData"></GraphLegend>
      </div>
    </SectionMain>
  </LayoutAuthenticatedSimple>
</template>

<style scoped>
/* Tailwind CSS classes for animation */
@keyframes slideIn {
  from {
    transform: translateX(100%);
  }
  to {
    transform: translateX(0);
  }
}

/* Add your alert styles here */
.alert {
  @apply fixed top-10 left-1/2 transform -translate-x-1/2 text-white p-2 rounded-md border z-50;
  animation: slideIn 0.5s ease-out;
}
</style>