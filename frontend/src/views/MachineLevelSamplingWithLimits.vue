<script setup>
import { backendApi } from '@/services/apiServices';
import { computed, ref, onMounted } from "vue";

import DyLineChartWithLimits from "@/components/Charts/DyLineChartWithLimits.vue";
import TimePickerFlatEmitter from "@/components/TimePickerFlatEmitter.vue";
import SectionMain from "@/components/SectionMain.vue";
import GraphLegend from "@/components/GraphLegend.vue";
import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";
import AirPressureSamplingView from "@/views/AirPressureSamplingView.vue";

import { use } from 'echarts/core';
import { BarChart } from 'echarts/charts';
import { GridComponent, TooltipComponent } from 'echarts/components';
import { CanvasRenderer } from 'echarts/renderers';
import VChart from 'vue-echarts';

// ECharts registration (cycle time bar chart)
use([GridComponent, TooltipComponent, BarChart, CanvasRenderer]);

import Toastify from 'toastify-js';
import 'toastify-js/src/toastify.css';

import { useNavigationHistoryStore } from '@/stores/navigationHistoryStore';
import { useMachineSamplingWithLimitsStore } from '@/stores/MachineSamplingWithLimitsStore'; 
import { useActivityStore } from '@/stores/ActivityStore.js'; 
import { useRouter } from 'vue-router';

const router = useRouter();
const machineSamplingWithLimitsStore = useMachineSamplingWithLimitsStore();
const ActivityStore = useActivityStore();
const navigationHistoryStore = useNavigationHistoryStore();

// Check if pressure context is active
const isPressureSelected = computed(() => machineSamplingWithLimitsStore.isPressureContext);

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
        interval: 0,
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

function syncDatesFromPickers() {
  const fromEpoch = fromPickerRef.value?.getEpoch?.();
  const toEpoch = toPickerRef.value?.getEpoch?.();
  if (Number.isFinite(fromEpoch)) {
    machineSamplingWithLimitsStore.selectedDates.from = fromEpoch;
  }
  if (Number.isFinite(toEpoch)) {
    machineSamplingWithLimitsStore.selectedDates.to = toEpoch;
  }
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
    ? new Date(xval).toLocaleString('en-IN')
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

onMounted(async () => {
  if (isPressureSelected.value) {
    return;
  }
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
</script>

<template>
  <AirPressureSamplingView v-if="isPressureSelected" />
  <LayoutAuthenticatedSimple v-else>
    <SectionMain class="mls-section-main">

      <!-- Alert Toast -->
      <div v-if="machineSamplingWithLimitsStore.alertMessage"
        :class="['mls-alert', machineSamplingWithLimitsStore.isSuccessMessage ? 'mls-alert--ok' : 'mls-alert--error']">
        {{ machineSamplingWithLimitsStore.alertMessage }}
      </div>

      <!-- Back button + KPI strip -->
      <div class="mls-nonpressure-header">
        <button @click="handleBack" class="mls-back-btn" title="Back">
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" class="mls-back-icon">
            <path stroke-linecap="round" stroke-linejoin="round" d="M10.5 19.5L3 12m0 0l7.5-7.5M3 12h18" />
          </svg>
          BACK
        </button>

        <!-- KPI info bar -->
        <div class="mls-np-kpi-bar">
          <div class="mls-np-kpi-item mls-np-kpi--machine">
            <span class="mls-np-kpi-tag">MACHINE</span>
            <span class="mls-np-kpi-val">{{ machineSamplingWithLimitsStore.machine }}</span>
          </div>
          <div class="mls-np-kpi-item mls-np-kpi--param">
            <span class="mls-np-kpi-tag">PARAMETER GROUP</span>
            <span class="mls-np-kpi-val">{{ machineSamplingWithLimitsStore.parameterGroup }}</span>
          </div>
          <div v-if="!isCycleTimeSelected" class="mls-np-kpi-item">
            <span class="mls-np-kpi-tag">PARAMETER NAME</span>
            <span class="mls-np-kpi-val">{{ machineSamplingWithLimitsStore.actualParameterName }}</span>
          </div>
          <div v-if="isCycleTimeSelected" class="mls-np-kpi-item">
            <span class="mls-np-kpi-tag">CYCLE TIME</span>
            <span class="mls-np-kpi-val">{{ isCycleTimeLoading ? 'Loading...' : (cycleTimeData ? cycleTimeData.cycle_time_value + 's' : 'N/A') }}</span>
          </div>
          <div v-if="isCycleTimeSelected && cycleTimeData" class="mls-np-kpi-item"
            :class="{
              'mls-np-kpi--crit': cycleTimeData.machine_state === 'CRITICAL',
              'mls-np-kpi--warn': cycleTimeData.machine_state === 'WARNING',
              'mls-np-kpi--ok': cycleTimeData.machine_state === 'OK'
            }">
            <span class="mls-np-kpi-tag">STATE</span>
            <span class="mls-np-kpi-val">{{ cycleTimeData.machine_state }}</span>
          </div>

          <div v-if="isCycleTimeSelected" class="mls-np-kpi-item mls-np-kpi--warn">
            <span class="mls-np-kpi-tag">WARNING LIMIT</span>
            <div class="mls-limit-edit-row">
              <input v-model="cycleTimeWarningInput" type="number" class="mls-limit-input" />
              <button @click="updateCycleTimeLimits" class="mls-limit-update-btn">UPDATE</button>
            </div>
          </div>
          <div v-if="isCycleTimeSelected" class="mls-np-kpi-item mls-np-kpi--crit">
            <span class="mls-np-kpi-tag">CRITICAL LIMIT</span>
            <div class="mls-limit-edit-row">
              <input v-model="cycleTimeCriticalInput" type="number" class="mls-limit-input" />
              <button @click="updateCycleTimeLimits" class="mls-limit-update-btn">UPDATE</button>
            </div>
          </div>

          <div v-if="!isCycleTimeSelected" class="mls-np-kpi-item mls-np-kpi--warn">
            <span class="mls-np-kpi-tag">WARNING LIMIT</span>
            <div class="mls-limit-edit-row">
              <input v-model="warningInput" type="number" class="mls-limit-input" />
              <button @click="updateWarning" class="mls-limit-update-btn">SET</button>
            </div>
          </div>
          <div v-if="!isCycleTimeSelected" class="mls-np-kpi-item mls-np-kpi--crit">
            <span class="mls-np-kpi-tag">CRITICAL LIMIT</span>
            <div class="mls-limit-edit-row">
              <input v-model="criticalInput" type="number" class="mls-limit-input" />
              <button @click="updateCritical" class="mls-limit-update-btn">SET</button>
            </div>
          </div>
        </div>
      </div>

      <!-- Time picker row -->
      <div class="mls-np-time-row">
        <div class="mls-np-time-label">FROM</div>
        <TimePickerFlatEmitter
          ref="fromPickerRef"
          :defaultDatetime="fromPickerDatetime"
          type="from"
          @date-change="handleFromDateChange"
        />
        <div class="mls-np-time-sep" />
        <div class="mls-np-time-label">TO</div>
        <TimePickerFlatEmitter
          ref="toPickerRef"
          :defaultDatetime="toPickerDatetime"
          type="to"
          @date-change="handleToDateChange"
        />
        <button type="submit" class="mls-btn mls-btn--sky mls-np-submit-btn"
          @click="isCycleTimeSelected ? handleCycleTimeSubmit() : handleQuerySubmit()">
          SUBMIT
        </button>
        <button v-if="!isCycleTimeSelected" type="button"
          class="mls-btn mls-btn--ghost mls-np-submit-btn"
          @click="handleQuerySubmitActivity()">VIEW ACTIVITY</button>
      </div>

      <!-- Cycle Time Bar Chart -->
      <div v-if="isCycleTimeSelected" class="mls-np-chart-card">
        <div class="mls-np-chart-head">
          <span class="mls-np-chart-title">CYCLE TIME vs TIME</span>
          <div v-if="isCycleTimeLoading" class="mls-loading-badge">
            <span class="mls-loading-dot" /> Loading...
          </div>
        </div>
        <div v-if="cycleTimeError" class="mls-error-banner">{{ cycleTimeError }}</div>
        <div v-if="cycleTimeData && cycleTimeData.message" class="mls-info-banner">{{ cycleTimeData.message }}</div>
        <div v-if="cycleTimeData && cycleTimeData.cycle_time_data && cycleTimeData.cycle_time_data.length > 0" class="mls-np-chart-body">
          <v-chart class="h-full" :option="cycleTimeChartOption" autoresize />
        </div>
        <div v-else-if="!isCycleTimeLoading && !cycleTimeError && !cycleTimeData?.message" class="mls-empty-chart-msg">
          No cycle time data available for the selected time range.
        </div>
      </div>

      <!-- Regular Line Chart -->
      <div v-if="!isCycleTimeSelected" class="mls-np-chart-card">
        <div class="mls-np-chart-head">
          <span class="mls-np-chart-title">{{ machineSamplingWithLimitsStore.parameterGroup }} — {{ machineSamplingWithLimitsStore.actualParameterName }}</span>
        </div>
        <div v-if="!hasChartData" class="mls-empty-chart-msg">
          {{ machineSamplingWithLimitsStore.chartFetchMessage || 'No data available for the selected time range.' }}
        </div>
        <div v-else class="mls-np-chart-body">
          <DyLineChartWithLimits
            :data="chartData"
            :warningLimit="warningLimit"
            :criticalLimit="criticalLimit"
            :step-plot="true"
            @data-hovered="OnHoverCallBack"
          />
        </div>
      </div>

      <GraphLegend v-if="!isCycleTimeSelected" :data="hoverData" />

    </SectionMain>
  </LayoutAuthenticatedSimple>
</template>

<style scoped>
/* ── Section root ── */
.mls-section-main {
  padding: 0 !important;
  background: #080d16;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  font-family: 'Barlow Condensed', 'JetBrains Mono', monospace;
}

/* ── Alert Toast ── */
.mls-alert {
  position: fixed;
  top: 12px;
  left: 50%;
  transform: translateX(-50%);
  z-index: 100;
  padding: 6px 18px;
  font-size: 12px;
  font-weight: 800;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: #fff;
  border: 1px solid transparent;
}
.mls-alert--ok   { background: #166534; border-color: #22c55e; }
.mls-alert--error { background: #7f1d1d; border-color: #ef4444; }

/* ── Buttons ── */
.mls-btn {
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  padding: 5px 12px;
  border: 1px solid transparent;
  cursor: pointer;
  flex-shrink: 0;
  transition: opacity 0.15s;
}
.mls-btn:disabled { opacity: 0.35; cursor: not-allowed; }
.mls-btn--sky {
  background: #0284c7;
  border-color: #0284c7;
  color: #fff;
}
.mls-btn--sky:not(:disabled):hover { background: #0369a1; }
.mls-btn--ghost {
  background: transparent;
  border-color: #334155;
  color: #94a3b8;
}
.mls-btn--ghost:not(:disabled):hover { border-color: #475569; color: #cbd5e1; }

/* ════════════════════════════════════════
   NON-PRESSURE VIEW
════════════════════════════════════════ */
.mls-nonpressure-header {
  display: flex;
  align-items: stretch;
  gap: 0;
  border-bottom: 1px solid #1e293b;
  background: #0d1117;
  flex-shrink: 0;
}

.mls-back-btn {
  display: flex;
  align-items: center;
  gap: 5px;
  padding: 0 14px;
  background: transparent;
  border: none;
  border-right: 1px solid #1e293b;
  color: #64748b;
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  cursor: pointer;
  flex-shrink: 0;
  transition: color 0.15s;
  font-family: 'Barlow Condensed', monospace;
}
.mls-back-btn:hover { color: #38bdf8; }
.mls-back-icon { width: 14px; height: 14px; }

.mls-np-kpi-bar {
  display: flex;
  align-items: stretch;
  flex: 1;
  overflow-x: auto;
}

.mls-np-kpi-item {
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 8px 14px;
  border-right: 1px solid #1e293b;
  min-width: 110px;
  position: relative;
}
.mls-np-kpi-item::before {
  content: '';
  position: absolute;
  top: 0; left: 0; right: 0;
  height: 2px;
  background: #334155;
}
.mls-np-kpi--machine::before { background: #38bdf8; }
.mls-np-kpi--param::before   { background: #10b981; }
.mls-np-kpi--warn::before    { background: #f59e0b; }
.mls-np-kpi--crit::before    { background: #ef4444; }
.mls-np-kpi--ok::before      { background: #22c55e; }

.mls-np-kpi-tag {
  font-size: 9px;
  font-weight: 800;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: #475569;
  margin-bottom: 3px;
}

.mls-np-kpi-val {
  font-size: 13px;
  font-weight: 700;
  color: #e2e8f0;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  font-family: 'JetBrains Mono', monospace;
}
.mls-np-kpi--crit .mls-np-kpi-val { color: #f87171; }
.mls-np-kpi--warn .mls-np-kpi-val { color: #fbbf24; }
.mls-np-kpi--ok .mls-np-kpi-val   { color: #4ade80; }

/* Limit edit row */
.mls-limit-edit-row {
  display: flex;
  align-items: center;
  gap: 4px;
  margin-top: 4px;
}

.mls-limit-input {
  width: 72px;
  background: #0a0f16;
  border: 1px solid #334155;
  color: #e2e8f0;
  font-size: 12px;
  font-weight: 700;
  padding: 3px 6px;
  font-family: 'JetBrains Mono', monospace;
  outline: none;
}
.mls-limit-input:focus { border-color: #38bdf8; }

.mls-limit-update-btn {
  font-size: 9px;
  font-weight: 800;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  padding: 3px 8px;
  background: #0369a1;
  border: none;
  color: #fff;
  cursor: pointer;
}
.mls-limit-update-btn:hover { background: #0284c7; }

/* Time picker row */
.mls-np-time-row {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 6px 12px;
  border-bottom: 1px solid #1e293b;
  background: #0a0f16;
  flex-shrink: 0;
}

.mls-np-time-label {
  font-size: 9px;
  font-weight: 800;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: #475569;
  flex-shrink: 0;
}

.mls-np-time-sep {
  width: 1px;
  height: 24px;
  background: #1e293b;
  flex-shrink: 0;
  margin: 0 4px;
}

.mls-np-submit-btn {
  margin-left: 8px;
}

/* Chart card */
.mls-np-chart-card {
  display: flex;
  flex-direction: column;
  flex: 1;
  min-height: 0;
  border-top: 1px solid #1e293b;
  background: #0d1117;
}

.mls-np-chart-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 8px 14px;
  border-bottom: 1px solid #1e293b;
  background: #0a0f16;
  flex-shrink: 0;
}

.mls-np-chart-title {
  font-size: 12px;
  font-weight: 900;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: #94a3b8;
  font-family: 'Barlow Condensed', monospace;
}

.mls-np-chart-body {
  flex: 1;
  min-height: 500px;
  padding: 0;
}

.mls-empty-chart-msg {
  padding: 24px 16px;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  color: #334155;
  text-align: center;
}

.mls-error-banner {
  padding: 8px 14px;
  background: rgba(239, 68, 68, 0.1);
  border-bottom: 1px solid rgba(239, 68, 68, 0.3);
  font-size: 11px;
  font-weight: 700;
  color: #f87171;
  letter-spacing: 0.04em;
}

.mls-info-banner {
  padding: 8px 14px;
  background: rgba(56, 189, 248, 0.08);
  border-bottom: 1px solid rgba(56, 189, 248, 0.2);
  font-size: 11px;
  font-weight: 700;
  color: #38bdf8;
  letter-spacing: 0.04em;
}

.mls-loading-badge {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: #475569;
}

.mls-loading-dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: #38bdf8;
  animation: mls-pulse 1.5s ease-in-out infinite;
  flex-shrink: 0;
}

@keyframes mls-pulse {
  0%, 100% { opacity: 1; }
  50%       { opacity: 0.3; }
}

/* Scrollbar */
::-webkit-scrollbar { width: 4px; height: 4px; }
::-webkit-scrollbar-track { background: #0d1117; }
::-webkit-scrollbar-thumb { background: #1e293b; }
::-webkit-scrollbar-thumb:hover { background: #334155; }
</style>
