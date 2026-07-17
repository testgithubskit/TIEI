<script setup>
import { computed, ref, onBeforeMount, onMounted } from "vue";

import axios from 'axios';
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

// ECharts registration (cycle time bar chart only — pressure uses DyLineChartWithLimits)
use([GridComponent, TooltipComponent, BarChart, CanvasRenderer]);

import Toastify from 'toastify-js';
import 'toastify-js/src/toastify.css';


import CardBoxWidgetPlainWrap from "@/components/CardBoxWidgetPlainWrap.vue";
import { useNavigationHistoryStore } from '@/stores/navigationHistoryStore';


//Importing Store Statements

import {
  useMachineSamplingWithLimitsStore,
  PRESSURE_DEFAULT_RANGE_SECONDS,
  PRESSURE_FALLBACK_MIN_SECONDS,
  PRESSURE_FALLBACK_MAX_SECONDS,
} from '@/stores/MachineSamplingWithLimitsStore'; 
// import { useMachineSamplingWithLimitsStore } from '@/stores/MachineSamplingWithLimitsStore';

import { useActivityStore } from '@/stores/ActivityStore.js'; 
import { useRouter } from 'vue-router';

const router = useRouter();

const machineSamplingWithLimitsStore = useMachineSamplingWithLimitsStore();
const ActivityStore = useActivityStore();

// Cycle time specific state
const isCycleTimeSelected = ref(false);
const isPressureSelected = computed(() => machineSamplingWithLimitsStore.isPressureContext);
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

function resolveIsPressure() {
  const group = (machineSamplingWithLimitsStore.parameterGroup || '').toUpperCase();
  const param = (machineSamplingWithLimitsStore.actualParameterName || '').toUpperCase();
  return (
    machineSamplingWithLimitsStore.isPressureContext
    || group === 'AIR_PRESSURE'
    || param === 'AIR_PRESSURE'
    || machineSamplingWithLimitsStore.lastSelectedParameter?.is_pressure_machine === true
  );
}

function initializePressureDates({ forceRefreshDates = false } = {}) {
  machineSamplingWithLimitsStore.isPressureMachine = true;
  if (machineSamplingWithLimitsStore.lastSelectedParameter) {
    machineSamplingWithLimitsStore.setMachineDetails({
      ...machineSamplingWithLimitsStore.lastSelectedParameter,
      // Do not wipe From/To the user (or session) already chose
      initializePressureDates: forceRefreshDates,
    });
  } else if (forceRefreshDates) {
    machineSamplingWithLimitsStore.refreshPressureTimestamp(PRESSURE_DEFAULT_RANGE_SECONDS);
  }
}

function formatPressureMaxHint() {
  const maxSeconds = machineSamplingWithLimitsStore.pressureRangeLimits.max ?? PRESSURE_FALLBACK_MAX_SECONDS;
  return `${Math.round(maxSeconds / 86400)} day(s)`;
}

const fromPickerRef = ref(null);
const toPickerRef = ref(null);

const fromPickerDatetime = computed(() => {
  if (resolveIsPressure()) {
    return new Date(machineSamplingWithLimitsStore.selectedDates.from);
  }
  return subtractHours(new Date(), 1);
});

const toPickerDatetime = computed(() => {
  if (resolveIsPressure()) {
    return new Date(machineSamplingWithLimitsStore.selectedDates.to);
  }
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

  if (isPressureSelected.value || (machineSamplingWithLimitsStore.actualParameterName || '').toUpperCase() === 'AIR_PRESSURE') {
    syncDatesFromPickers();
    const timeDifferenceSeconds = machineSamplingWithLimitsStore.pressureRangeSeconds;
    const minSeconds = machineSamplingWithLimitsStore.pressureRangeLimits.min ?? PRESSURE_FALLBACK_MIN_SECONDS;
    const maxSeconds = machineSamplingWithLimitsStore.pressureRangeLimits.max ?? PRESSURE_FALLBACK_MAX_SECONDS;

    if (timeDifferenceSeconds == null || timeDifferenceSeconds < minSeconds || timeDifferenceSeconds > maxSeconds) {
      Toastify({
        text: `For Air Pressure, select a time range between ${minSeconds} second(s) and ${formatPressureMaxHint()}.`,
        duration: 5000,
        close: true,
        gravity: 'top',
        position: 'right',
        backgroundColor: 'red',
      }).showToast();
      return;
    }

    machineSamplingWithLimitsStore.persistSamplingSession();
    await machineSamplingWithLimitsStore.fetchPressureMachineData();
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
  // Getting the Initial Latest Data from the backend - Start
  // await machineSamplingWithLimitsStore.fetchMachineParameterData();
  await ActivityStore.fetchActivityDataParameter(machineSamplingWithLimitsStore.actualParameterName);
  router.push("/corrective-activity");
};


// Previsoly Working handle back function

// const handleBack = async () => {
//   const routeObject = { name: 'Factory Level Polling Parameter Overview Grid',
//    params: { groupName: machineSamplingWithLimitsStore.parameterGroup } };
//   router.push(routeObject);
// };

// const router = useRouter();
const navigationHistoryStore = useNavigationHistoryStore()

const handleBack = () => {
  // Prefer the page we came from (managerial overview OR factory grid).
  // Never go to login ("/") — that feels like a logout.
  const previous = navigationHistoryStore.history.length
    ? navigationHistoryStore.history[navigationHistoryStore.history.length - 1]
    : null;

  const candidate = previous?.fullPath || previous?.path || '';
  const isLoginLike = (
    !candidate
    || candidate === '/'
    || candidate === '/#/'
    || candidate === '/#/'
    || String(candidate).toLowerCase().includes('login')
  );
  const isSelf = candidate.includes('machine-level-sampling');

  if (!isLoginLike && !isSelf) {
    navigationHistoryStore.removeLastRoute();
    router.push(candidate);
    return;
  }

  // Safe fallbacks (never "/")
  if (resolveIsPressure()) {
    router.push('/managerialOverview');
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
  if (resolveIsPressure()) {
    // Only set default window if we don't already have a valid saved From/To
    const hasDates = Number.isFinite(Number(machineSamplingWithLimitsStore.selectedDates.from))
      && Number.isFinite(Number(machineSamplingWithLimitsStore.selectedDates.to))
      && Number(machineSamplingWithLimitsStore.selectedDates.to)
        > Number(machineSamplingWithLimitsStore.selectedDates.from);
    initializePressureDates({ forceRefreshDates: !hasDates });
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

const currentParameter = ref(null);
const isPressureLogListLoading = ref(false);
const isPressureGraphLoading = ref(false);
const isUpdatingPressureBaseline = ref(false);
const pressureDateRange = ref({
  startDate: '',
  endDate: '',
});
const pressureMaxSelectableDate = computed(() => {
  const now = new Date();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, '0');
  const day = String(now.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
});

const pressureFromDateConfig = computed(() => ({
  dateFormat: 'Y-m-d',
  altInput: true,
  altFormat: 'd-m-Y',
  allowInput: false,
  disableMobile: true,
  maxDate: pressureDateRange.value.endDate || pressureMaxSelectableDate.value,
  onReady: (_dates, _str, instance) => {
    instance.calendarContainer.classList.add('pressure-fp-calendar');
  },
}));

const pressureToDateConfig = computed(() => ({
  dateFormat: 'Y-m-d',
  altInput: true,
  altFormat: 'd-m-Y',
  allowInput: false,
  disableMobile: true,
  minDate: pressureDateRange.value.startDate || undefined,
  maxDate: pressureMaxSelectableDate.value,
  onReady: (_dates, _str, instance) => {
    instance.calendarContainer.classList.add('pressure-fp-calendar');
  },
}));

const pressureLogFiles = computed(() => machineSamplingWithLimitsStore.pressureLogFiles || []);
const pressureComparisonSeries = computed(() => machineSamplingWithLimitsStore.pressureComparisonSeries || []);
const selectedPressureLogFileIds = computed(() => machineSamplingWithLimitsStore.selectedPressureLogFileIds || []);
const baselineLogFileId = computed(() => machineSamplingWithLimitsStore.baselineLogFileId);
const pressureHasChartSeries = computed(() => pressureComparisonSeries.value.some((series) => Array.isArray(series.chart_data) && series.chart_data.length > 0));
const baselineLogFileLabel = computed(() => {
  const baselineRow = pressureLogFiles.value.find((item) => item.log_file_id === baselineLogFileId.value);
  const raw = baselineRow?.time_stamp || baselineRow?.processed_time;
  if (!raw) {
    return 'Not selected';
  }
  const datePart = formatProcessedDateOnly(raw);
  const timePart = formatProcessedTimeOnly(raw);
  return [datePart, timePart].filter(Boolean).join(' ');
});
const canUpdateBaseline = computed(() => selectedPressureLogFileIds.value.length === 1);
const hasBaseline = computed(() => baselineLogFileId.value != null);
const hasPressureSelections = computed(() => selectedPressureLogFileIds.value.length > 0);

function formatProcessedDateOnly(value) {
  if (value == null || value === '') {
    return '';
  }
  const text = String(value).trim();
  const iso = text.match(/^(\d{4}-\d{2}-\d{2})/);
  if (iso) {
    return iso[1];
  }
  const dmy = text.match(/^(\d{1,2}\/\d{1,2}\/\d{2,4})/);
  if (dmy) {
    return dmy[1];
  }
  if (text.includes(',')) {
    return text.split(',')[0].trim();
  }
  return text.split(/\s+/)[0] || text;
}

function formatProcessedTimeOnly(value) {
  if (value == null || value === '') {
    return '';
  }
  const text = String(value).trim();
  let timePart = '';
  if (text.includes(',')) {
    timePart = text.split(',').slice(1).join(',').trim();
  } else {
    const isoSplit = text.match(/^\d{4}-\d{2}-\d{2}[ T](.+)$/);
    if (isoSplit) {
      timePart = isoSplit[1].trim();
    } else {
      const parts = text.split(/\s+/);
      timePart = parts.length > 1 ? parts.slice(1).join(' ') : '';
    }
  }
  // Show HH:MM:SS only — drop fractional milliseconds.
  const hhmmss = timePart.match(/^(\d{1,2}:\d{2}:\d{2})/);
  return hhmmss ? hhmmss[1] : timePart.replace(/\.\d+.*$/, '');
}

const pressureSeriesLegend = computed(() => {
  let colorIdx = 0;
  return pressureComparisonSeries.value
    .filter((series) => Array.isArray(series.chart_data) && series.chart_data.length > 0)
    .map((series) => {
      const isBaseline = !!series.baseline;
      const dateOnly = formatProcessedDateOnly(series.processed_time || series.label || '');
      const color = isBaseline
        ? 'rgb(185, 28, 28)'
        : ['rgb(37, 99, 235)', 'rgb(147, 51, 234)', 'rgb(219, 39, 119)'][colorIdx++ % 3];
      return {
        label: isBaseline
          ? (dateOnly ? `Baseline — ${dateOnly}` : 'Baseline')
          : dateOnly,
        shortLabel: isBaseline
          ? (dateOnly ? `Baseline — ${dateOnly}` : 'Baseline')
          : dateOnly,
        baseline: isBaseline,
        color,
      };
    });
});
const pressureChartLegendItems = computed(() => pressureSeriesLegend.value.map((item) => ({
  label: item.label,
  color: item.color,
  dashed: false,
})));
const isPressureCompareMode = computed(() => {
  const activeSeries = pressureComparisonSeries.value.filter(
    (series) => Array.isArray(series.chart_data) && series.chart_data.length > 0,
  );
  return activeSeries.length > 1;
});

function resetPressureHoverData() {
  machineSamplingWithLimitsStore.hoverData = {
    xAxisLabel: 'Timestamp',
    xAxisValue: '',
    yAxisLabel: 'Air Pressure',
    yAxisValue: '',
    xAxisUnits: 'DateTime',
    yAxisUnits: 'Pa',
  };
}

function formatDateForInput(dateObj) {
  const year = dateObj.getFullYear();
  const month = String(dateObj.getMonth() + 1).padStart(2, '0');
  const day = String(dateObj.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
}

function initializePressureLogDateRange() {
  pressureDateRange.value = {
    startDate: '',
    endDate: '',
  };
}

async function refreshPressureComparisonGraph() {
  if (!isPressureSelected.value) {
    return;
  }

  const selectedIds = [...selectedPressureLogFileIds.value];
  if (selectedIds.length === 0 && !baselineLogFileId.value) {
    machineSamplingWithLimitsStore.pressureComparisonSeries = [];
    machineSamplingWithLimitsStore.chartData = [[0, 0]];
    machineSamplingWithLimitsStore.chartFetchMessage = 'Choose one or more timestamps to view the graph.';
    resetPressureHoverData();
    return;
  }

  isPressureGraphLoading.value = true;
  try {
    await machineSamplingWithLimitsStore.fetchPressureComparisonData(selectedIds, true);
  } catch (error) {
    Toastify({
      text: error.response?.data?.detail || 'Failed to load pressure comparison graph.',
      duration: 5000,
      close: true,
      gravity: 'top',
      position: 'right',
      backgroundColor: 'red',
    }).showToast();
  } finally {
    isPressureGraphLoading.value = false;
  }
}

async function loadPressureLogFiles({ refreshGraph = true } = {}) {
  isPressureLogListLoading.value = true;
  try {
    const response = await machineSamplingWithLimitsStore.fetchPressureLogFiles(
      pressureDateRange.value.startDate,
      pressureDateRange.value.endDate,
    );
    const validIds = new Set((response.log_files || []).map((item) => item.log_file_id));
    machineSamplingWithLimitsStore.selectedPressureLogFileIds = selectedPressureLogFileIds.value
      .filter((id) => validIds.has(id))
      .slice(0, 3);
    if (refreshGraph) {
      await refreshPressureComparisonGraph();
    }
  } catch (error) {
    resetPressureHoverData();
    Toastify({
      text: error.response?.data?.detail || 'Failed to load pressure timestamps.',
      duration: 5000,
      close: true,
      gravity: 'top',
      position: 'right',
      backgroundColor: 'red',
    }).showToast();
  } finally {
    isPressureLogListLoading.value = false;
  }
}

async function handlePressureLogSelection(logFileId, checked) {
  const currentIds = [...selectedPressureLogFileIds.value];
  if (checked) {
    if (currentIds.includes(logFileId)) {
      return;
    }
    if (currentIds.length >= 3) {
      Toastify({
        text: 'You can select a maximum of 3 timestamps.',
        duration: 4000,
        close: true,
        gravity: 'top',
        position: 'right',
        backgroundColor: 'red',
      }).showToast();
      return;
    }
    currentIds.push(logFileId);
  } else {
    const nextIds = currentIds.filter((id) => id !== logFileId);
    currentIds.splice(0, currentIds.length, ...nextIds);
  }

  machineSamplingWithLimitsStore.selectedPressureLogFileIds = currentIds;
  await refreshPressureComparisonGraph();
}

async function clearAllPressureSelections() {
  if (!selectedPressureLogFileIds.value.length) {
    return;
  }
  machineSamplingWithLimitsStore.selectedPressureLogFileIds = [];
  await refreshPressureComparisonGraph();
}

async function handlePressureBaselineUpdate() {
  if (!canUpdateBaseline.value) {
    return;
  }

  isUpdatingPressureBaseline.value = true;
  try {
    await machineSamplingWithLimitsStore.updatePressureBaseline(selectedPressureLogFileIds.value[0]);
    await loadPressureLogFiles({ refreshGraph: false });
    await refreshPressureComparisonGraph();
    Toastify({
      text: 'Baseline updated successfully.',
      duration: 3000,
      close: true,
      gravity: 'top',
      position: 'right',
      backgroundColor: 'green',
    }).showToast();
  } catch (error) {
    Toastify({
      text: error.response?.data?.detail || 'Failed to update baseline.',
      duration: 5000,
      close: true,
      gravity: 'top',
      position: 'right',
      backgroundColor: 'red',
    }).showToast();
  } finally {
    isUpdatingPressureBaseline.value = false;
  }
}

async function handlePressureBaselineClear() {
  if (!hasBaseline.value) {
    return;
  }

  isUpdatingPressureBaseline.value = true;
  try {
    await machineSamplingWithLimitsStore.clearPressureBaseline();
    await loadPressureLogFiles({ refreshGraph: false });
    await refreshPressureComparisonGraph();
    Toastify({
      text: 'Baseline cleared.',
      duration: 3000,
      close: true,
      gravity: 'top',
      position: 'right',
      backgroundColor: 'green',
    }).showToast();
  } catch (error) {
    Toastify({
      text: error.response?.data?.detail || 'Failed to clear baseline.',
      duration: 5000,
      close: true,
      gravity: 'top',
      position: 'right',
      backgroundColor: 'red',
    }).showToast();
  } finally {
    isUpdatingPressureBaseline.value = false;
  }
}

onMounted(async () => {
  // Restore last machine/parameter if page was refreshed (otherwise defaults to T_H_OP150)
  if (!machineSamplingWithLimitsStore.lastSelectedParameter) {
    machineSamplingWithLimitsStore.restoreSamplingSession();
  }

  const isCycleTimeFromStorage = localStorage.getItem('isCycleTimeSelected') === 'true';
  const isPressure = resolveIsPressure();

  if (machineSamplingWithLimitsStore.parameterGroup === 'CYCLE_TIME' || isCycleTimeFromStorage) {
    isCycleTimeSelected.value = true;
    localStorage.setItem('isCycleTimeSelected', 'true');
    const currentDate = new Date();
    machineSamplingWithLimitsStore.selectedDates.to = currentDate.getTime();
    const oneHourEarlier = subtractHours(currentDate, 1);
    machineSamplingWithLimitsStore.selectedDates.from = oneHourEarlier.getTime();
    await fetchCycleTimeData();
  } else if (isPressure) {
    isCycleTimeSelected.value = false;
    localStorage.setItem('isCycleTimeSelected', 'false');
    initializePressureDates();
    initializePressureLogDateRange();
    resetPressureHoverData();
    await loadPressureLogFiles({ refreshGraph: true });
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

    // Format dates as YYYY-MM-DD HH:MM:SS (without timezone)
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

    const url = `http://172.18.100.87:8000/api/v1/cycle-time/machine/${encodeURIComponent(machineName)}?fromTime=${encodeURIComponent(fromTimeStr)}&toTime=${encodeURIComponent(toTimeStr)}`;

    const response = await axios.get(url);
    cycleTimeData.value = response.data;
    
    // Only set limits if they exist in database
    if (response.data.warning_limit !== null && response.data.critical_limit !== null) {
      cycleTimeLimits.value = {
        warning: response.data.warning_limit,
        critical: response.data.critical_limit
      };
      
      // Set input values from database
      cycleTimeWarningInput.value = response.data.warning_limit;
      cycleTimeCriticalInput.value = response.data.critical_limit;
    }

    // Convert cycle time data to chart format
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
    
    console.log('Updating cycle time limits:', { warningLimit, criticalLimit });
    
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
    console.log('Machine name:', machineName);
    
    const url = `http://172.18.100.87:8000/api/v1/cycle-time/limits/${encodeURIComponent(machineName)}?warning_limit=${warningLimit}&critical_limit=${criticalLimit}`;
    console.log('API URL:', url);
    
    const response = await axios.put(url);
    console.log('API response:', response.data);
    
    // Update local state
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
    
    // Refresh data with new limits
    await fetchCycleTimeData();
  } catch (error) {
    console.error('Error updating cycle time limits:', error);
    console.error('Error response:', error.response?.data);
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


function formatElapsedHover(ms) {
  const COMPARE_EPOCH_BASE = new Date(2000, 0, 1).getTime();
  const elapsedMs = ms - COMPARE_EPOCH_BASE;
  if (!Number.isFinite(elapsedMs)) {
    return '';
  }
  if (elapsedMs >= 60000) {
    return `${(elapsedMs / 60000).toFixed(2)} min`;
  }
  if (elapsedMs >= 1000) {
    return `${(elapsedMs / 1000).toFixed(2)} s`;
  }
  return `${Math.round(elapsedMs)} ms`;
}

function OnHoverCallBack(hoverData){
  if (!hoverData?.length) return;
  const preferredPoint = hoverData.find((point) => point?.name && !String(point.name).includes('Limit') && point.yval != null) || hoverData[0];
  const xval = preferredPoint.xval;
  const isCompare = isPressureCompareMode.value;
  const dateTime = isCompare
    ? formatElapsedHover(xval)
    : (typeof xval === 'number'
      ? convertEpochToLocal(xval)
      : String(xval));
  const isPressure = isPressureSelected.value;
  machineSamplingWithLimitsStore.hoverData = {
    xAxisValue: dateTime,
    yAxisValue: preferredPoint.yval,
    xAxisLabel: isCompare ? 'Elapsed Time' : (isPressure ? 'Timestamp' : (machineSamplingWithLimitsStore.hoverData.xAxisLabel || 'Time')),
    yAxisLabel: isPressure ? 'Air Pressure' : (machineSamplingWithLimitsStore.hoverData.yAxisLabel || 'Value'),
    xAxisUnits: isCompare ? 'From log start' : (isPressure ? 'DateTime (IST)' : (machineSamplingWithLimitsStore.hoverData.xAxisUnits || 'IST')),
    yAxisUnits: isPressure ? 'Pa' : (machineSamplingWithLimitsStore.hoverData.yAxisUnits || ''),
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
        <template v-if="isPressureSelected">
          <div class="pressure-top-grid">
            <div class="pressure-baseline-card">
              <span class="pressure-card-label">Baseline</span>
              <span class="pressure-vdivider" />
              <span class="pressure-baseline-value">{{ baselineLogFileLabel }}</span>
              <span class="pressure-vdivider" />
              <button
                type="button"
                class="pressure-btn pressure-btn--primary"
                :disabled="!canUpdateBaseline || isUpdatingPressureBaseline"
                @click="handlePressureBaselineUpdate"
              >
                Update
              </button>
              <button
                type="button"
                class="pressure-btn pressure-btn--ghost"
                :disabled="!hasBaseline || isUpdatingPressureBaseline"
                @click="handlePressureBaselineClear"
              >
                Clear
              </button>
            </div>

            <div class="pressure-kpi-row">
              <div class="pressure-kpi-card pressure-kpi-card--machine">
                <span class="pressure-kpi-label">Machine</span>
                <span class="pressure-kpi-value">{{ machineSamplingWithLimitsStore.machine }}</span>
              </div>
              <div class="pressure-kpi-card pressure-kpi-card--param">
                <span class="pressure-kpi-label">Parameter</span>
                <span class="pressure-kpi-value">Air Pressure</span>
              </div>
              <div class="pressure-kpi-card pressure-kpi-card--warn">
                <span class="pressure-kpi-label">Warning</span>
                <span class="pressure-kpi-value">{{ warningLimit }}</span>
              </div>
              <div class="pressure-kpi-card pressure-kpi-card--crit">
                <span class="pressure-kpi-label">Critical</span>
                <span class="pressure-kpi-value">{{ criticalLimit }}</span>
              </div>
            </div>
          </div>

          <div class="pressure-main-grid">
            <div class="pressure-side-panel">
              <div class="pressure-search-row">
                <div class="pressure-date-field">
                  <span class="pressure-date-field__prefix">From</span>
                  <span class="pressure-date-field__divider" />
                  <flat-pickr
                    v-model="pressureDateRange.startDate"
                    :config="pressureFromDateConfig"
                    class="pressure-date-input"
                    placeholder="dd-mm-yyyy"
                    title="From date"
                  />
                  <button
                    v-if="pressureDateRange.startDate"
                    type="button"
                    class="pressure-date-clear"
                    title="Clear from date"
                    @click="pressureDateRange.startDate = ''"
                  >
                    ×
                  </button>
                </div>
                <span class="pressure-search-divider" />
                <div class="pressure-date-field">
                  <span class="pressure-date-field__prefix">To</span>
                  <span class="pressure-date-field__divider" />
                  <flat-pickr
                    v-model="pressureDateRange.endDate"
                    :config="pressureToDateConfig"
                    class="pressure-date-input"
                    placeholder="dd-mm-yyyy"
                    title="To date"
                  />
                  <button
                    v-if="pressureDateRange.endDate"
                    type="button"
                    class="pressure-date-clear"
                    title="Clear to date"
                    @click="pressureDateRange.endDate = ''"
                  >
                    ×
                  </button>
                </div>
                <span class="pressure-search-divider" />
                <button type="button" class="pressure-btn pressure-btn--primary" @click="loadPressureLogFiles()">
                  Search
                </button>
              </div>

              <div class="pressure-list-head">
                <span class="pressure-list-head__check" />
                <span class="pressure-list-head__time">Processed Time</span>
                <button
                  type="button"
                  class="pressure-clear-all"
                  :disabled="!hasPressureSelections"
                  title="Clear all selected timestamps"
                  @click="clearAllPressureSelections"
                >
                  Clear all
                </button>
              </div>

              <div class="pressure-scroll-list">
                <div v-if="isPressureLogListLoading" class="pressure-empty-msg">Loading timestamps...</div>
                <div v-else-if="pressureLogFiles.length === 0" class="pressure-empty-msg">No timestamps found.</div>
                <div
                  v-for="row in pressureLogFiles"
                  v-else
                  :key="row.log_file_id"
                  class="pressure-list-row pressure-list-row--normal"
                >
                  <span class="pressure-list-row__check">
                    <input
                      :checked="selectedPressureLogFileIds.includes(row.log_file_id)"
                      type="checkbox"
                      class="pressure-checkbox"
                      @change="handlePressureLogSelection(row.log_file_id, $event.target.checked)"
                    />
                  </span>
                  <span class="pressure-list-row__divider" />
                  <span class="pressure-list-row__date">{{ formatProcessedDateOnly(row.time_stamp || row.processed_time) }}</span>
                  <span class="pressure-list-row__divider" />
                  <span class="pressure-list-row__clock">{{ formatProcessedTimeOnly(row.time_stamp || row.processed_time) }}</span>
                </div>
              </div>
            </div>

            <div class="pressure-graph-panel">
              <div class="pressure-graph-head">
                <h3 class="pressure-graph-title">Air Pressure Comparison</h3>
                <div class="pressure-graph-hints">
                  <span class="pressure-hint-chip">Scroll — zoom in / out</span>
                  <span class="pressure-hint-chip">Drag — select range</span>
                  <span class="pressure-hint-chip">Double-click / Reset — full view</span>
                </div>
              </div>

              <div class="pressure-graph-body">
                <div v-if="isPressureGraphLoading" class="pressure-graph-placeholder">
                  Loading pressure graph...
                </div>

                <div v-else-if="!pressureHasChartSeries" class="pressure-graph-placeholder pressure-graph-placeholder--empty">
                  {{ machineSamplingWithLimitsStore.chartFetchMessage || 'Select timestamps from the left panel to view the graph.' }}
                </div>

                <div v-else class="pressure-graph-canvas-wrap">
                  <DyLineChartWithLimits
                    :data="chartData"
                    :series-data="pressureComparisonSeries"
                    :external-legend="pressureChartLegendItems"
                    :warningLimit="warningLimit"
                    :criticalLimit="criticalLimit"
                    :step-plot="false"
                    :hide-hints="true"
                    :borderless="true"
                    :show-limits="false"
                    @data-hovered="OnHoverCallBack"
                  />
                </div>
              </div>
            </div>
          </div>
        </template>

        <template v-else>
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
          :parameter-value="isPressureSelected ? 'Air Pressure' : machineSamplingWithLimitsStore.actualParameterName">
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
          v-if="!isCycleTimeSelected && !isPressureSelected"
          label="Warning Limit:">
            <div class="flex flex-row">
              <div class="relative mt-2">
                <input v-model="warningInput" type="number" class="w-full h-8 p-2 border-2 border-black rounded-lg" />
              </div>
              <button @click="updateWarning" class="text-blue-500  mx-2 mt-2">
                <img class="w-12" src="@/assets/icons/update.svg " alt="">
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
          v-if="isPressureSelected"
          label="Warning Limit"
          :parameter-value="warningLimit">
          </CardBoxWidgetPlainWrap>
          <CardBoxWidgetPlainWrap 
          v-if="isPressureSelected"
          label="Critical Limit"
          :parameter-value="criticalLimit">
          </CardBoxWidgetPlainWrap>
          <CardBoxWidgetPlainWrap 
          v-if="!isCycleTimeSelected && !isPressureSelected"
          label="Critical Limit:">
            <div class="flex flex-row">
              <div class="relative mt-2">
                <input v-model="criticalInput" type="number" class="w-full h-8 p-2 border-2 border-black rounded-lg" />
              </div>
              <button @click="updateCritical" class="text-blue-500 mx-2 mt-2">
                <img class="w-12" src="@/assets/icons/update.svg " alt="">
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

          <div v-if="isPressureSelected" class="ml-8 flex flex-col justify-center max-w-md">
            <p class="text-sm text-amber-700">
              Choose any From / To (1s–{{ formatPressureMaxHint() }}), then Submit.
              Graph shows only data that exists in that range (demo DB ≈ 9s for 2nd Rough).
              Scroll or drag on the chart to zoom the loaded points.
            </p>
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

          <div v-if="!isCycleTimeSelected && !isPressureSelected" class="flex flex-col items-center justify-end ml-8">
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
              {{ machineSamplingWithLimitsStore.chartFetchMessage || 'No air pressure data available for the selected time range.' }}
            </p>
            <p v-if="isPressureSelected" class="text-sm text-yellow-700">
              Try a different From / To window where sensor data exists in the database.
            </p>
          </div>
          <div v-else class="min-h-[440px]">
            <DyLineChartWithLimits
              :data="chartData"
              :warningLimit="warningLimit"
              :criticalLimit="criticalLimit"
              :step-plot="!isPressureSelected"
              @data-hovered="OnHoverCallBack"
            />
          </div>
        </CardBox>      

        <BlurryHorizontalDivider />
        <GraphLegend v-if="!isCycleTimeSelected" :data="hoverData"></GraphLegend>
        </template>
      </div>

    </SectionMain>
  </LayoutAuthenticatedSimple>
</template>

<style scoped>
.pressure-top-grid,
.pressure-main-grid {
  display: grid;
  grid-template-columns: minmax(280px, 32%) minmax(0, 68%);
  gap: 12px;
  align-items: stretch;
}

.pressure-top-grid {
  align-items: stretch;
}

/* shadcn/ui Card–style surfaces */
.pressure-baseline-card,
.pressure-kpi-card {
  display: flex;
  align-items: center;
  gap: 10px;
  min-height: 56px;
  padding: 0 16px;
  border: 2.5px solid #000;
  border-radius: 0.75rem;
  background: #fff;
  box-shadow: 0 1px 2px 0 rgb(0 0 0 / 0.05);
}

.pressure-kpi-row {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 8px;
  min-width: 0;
}

.pressure-card-label,
.pressure-kpi-label {
  font-size: 14px;
  font-weight: 800;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  color: rgb(71, 85, 105);
  white-space: nowrap;
}

.pressure-baseline-value,
.pressure-kpi-value {
  font-size: 15px;
  font-weight: 700;
  color: rgb(15, 23, 42);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.pressure-baseline-value {
  flex: 1;
  min-width: 0;
}

.pressure-kpi-card {
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  gap: 8px;
  min-width: 0;
}

.pressure-kpi-label {
  flex-shrink: 0;
}

.pressure-kpi-value {
  text-align: right;
  margin-left: auto;
  min-width: 0;
}

/* Bold colored borders — KPI cards only */
.pressure-kpi-card--machine {
  border: 3px solid rgb(59, 130, 246);
  border-left-width: 6px;
  background: rgb(239, 246, 255);
}
.pressure-kpi-card--param {
  border: 3px solid rgb(16, 185, 129);
  border-left-width: 6px;
  background: rgb(236, 253, 245);
}
.pressure-kpi-card--warn {
  border: 3px solid rgb(245, 158, 11);
  border-left-width: 6px;
  background: rgb(255, 251, 235);
}
.pressure-kpi-card--crit {
  border: 3px solid rgb(239, 68, 68);
  border-left-width: 6px;
  background: rgb(254, 242, 242);
}

.pressure-vdivider {
  width: 1px;
  align-self: stretch;
  background: rgb(203, 213, 225);
  margin: 6px 0;
}

.pressure-btn {
  font-size: 11px;
  font-weight: 700;
  padding: 4px 10px;
  border: 1px solid transparent;
  cursor: pointer;
  flex-shrink: 0;
}

.pressure-btn:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

.pressure-btn--primary {
  background: rgb(2, 132, 199);
  border-color: rgb(2, 132, 199);
  color: #fff;
  border-radius: 0.5rem;
}

.pressure-btn--ghost {
  background: #fff;
  border-color: #000;
  color: rgb(51, 65, 85);
  border-radius: 0.5rem;
  box-shadow: 0 1px 2px 0 rgb(0 0 0 / 0.04);
}

.pressure-main-grid {
  height: min(84vh, 880px);
}

.pressure-side-panel,
.pressure-graph-panel {
  display: flex;
  flex-direction: column;
  min-height: 0;
  border: 2.5px solid #000;
  border-radius: 0.75rem;
  background: #fff;
  box-shadow: 0 1px 2px 0 rgb(0 0 0 / 0.05);
  overflow: hidden;
}

.pressure-search-row {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 6px 8px;
  border-bottom: 1px solid rgb(226, 232, 240);
  background: rgb(248, 250, 252);
}

.pressure-search-divider {
  width: 1px;
  align-self: stretch;
  background: rgb(203, 213, 225);
  margin: 2px 2px;
  flex-shrink: 0;
}

.pressure-date-field {
  position: relative;
  flex: 1;
  min-width: 0;
  display: flex;
  align-items: center;
  border: 2.5px solid #000;
  border-radius: 0.5rem;
  background: #fff;
  box-shadow: 0 1px 2px 0 rgb(0 0 0 / 0.04);
  padding-left: 6px;
}

.pressure-date-field__prefix {
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.03em;
  text-transform: uppercase;
  color: rgb(100, 116, 139);
  flex-shrink: 0;
}

.pressure-date-field__divider {
  width: 1px;
  align-self: stretch;
  background: rgb(203, 213, 225);
  margin: 3px 6px;
  flex-shrink: 0;
}

.pressure-date-input {
  flex: 1;
  min-width: 0;
  border: none !important;
  outline: none;
  background: transparent !important;
  padding: 6px 22px 6px 2px;
  font-size: 13px;
  font-weight: 700;
  color: rgb(15, 23, 42);
  box-shadow: none !important;
}

.pressure-date-field :deep(.flatpickr-input),
.pressure-date-field :deep(.form-control) {
  flex: 1;
  min-width: 0;
  width: 100%;
  border: none !important;
  outline: none !important;
  background: transparent !important;
  box-shadow: none !important;
  padding: 6px 22px 6px 2px;
  font-size: 13px;
  font-weight: 700;
  color: rgb(15, 23, 42);
}

.pressure-date-clear {
  position: absolute;
  right: 22px;
  top: 50%;
  transform: translateY(-50%);
  width: 14px;
  height: 14px;
  border: none;
  background: rgb(226, 232, 240);
  color: rgb(71, 85, 105);
  font-size: 11px;
  font-weight: 800;
  line-height: 1;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0;
}

.pressure-date-clear:hover {
  background: rgb(248, 113, 113);
  color: #fff;
}

.pressure-list-head {
  display: grid;
  grid-template-columns: 28px 1fr auto;
  align-items: center;
  gap: 0;
  padding: 6px 8px;
  border-bottom: 1px solid rgb(203, 213, 225);
  background: rgb(241, 245, 249);
  font-size: 12px;
  font-weight: 800;
  letter-spacing: 0.05em;
  text-transform: uppercase;
  color: rgb(71, 85, 105);
}

.pressure-list-head__check {
  text-align: center;
}

.pressure-clear-all {
  border: 2.5px solid #000;
  border-radius: 0.5rem;
  background: #fff;
  color: rgb(71, 85, 105);
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.03em;
  text-transform: uppercase;
  padding: 3px 8px;
  cursor: pointer;
  box-shadow: 0 1px 2px 0 rgb(0 0 0 / 0.04);
}

.pressure-clear-all:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

.pressure-clear-all:not(:disabled):hover {
  border-color: rgb(245, 158, 11);
  color: rgb(180, 83, 9);
  background: rgb(255, 251, 235);
}

.pressure-scroll-list {
  flex: 1;
  min-height: 0;
  overflow-y: auto;
}

.pressure-scroll-list::-webkit-scrollbar {
  width: 4px;
}

.pressure-scroll-list::-webkit-scrollbar-thumb {
  background: rgb(51, 65, 85);
}

.pressure-list-row {
  display: flex;
  align-items: center;
  min-height: 38px;
  padding: 0 8px;
  border-bottom: 1px solid rgb(226, 232, 240);
  font-size: 13px;
  font-weight: 600;
  color: rgb(30, 41, 59);
}

.pressure-list-row:hover {
  background: rgb(248, 250, 252);
}

.pressure-list-row--baseline {
  background: rgb(236, 253, 245);
  border-left: 3px solid rgb(16, 185, 129);
}

.pressure-list-row--normal {
  background: rgb(255, 251, 235);
  border-left: 3px solid rgb(245, 158, 11);
}

.pressure-list-row__check {
  width: 28px;
  flex-shrink: 0;
  display: flex;
  justify-content: center;
}

.pressure-list-row__divider {
  width: 1px;
  align-self: stretch;
  background: rgb(203, 213, 225);
  margin: 6px 8px;
}

.pressure-list-row__date {
  flex-shrink: 0;
  font-weight: 700;
  white-space: nowrap;
}

.pressure-list-row__clock {
  flex: 1;
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  font-weight: 600;
}

.pressure-list-row__time {
  flex: 1;
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.pressure-list-row__badge {
  font-size: 10px;
  font-weight: 800;
  text-transform: uppercase;
  color: rgb(4, 120, 87);
  white-space: nowrap;
}

.pressure-checkbox {
  width: 14px;
  height: 14px;
}

.pressure-empty-msg {
  padding: 12px 10px;
  font-size: 11px;
  color: rgb(100, 116, 139);
}

.pressure-graph-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  min-height: 48px;
  padding: 10px 14px;
  border-bottom: 1px solid rgb(226, 232, 240);
  background: rgb(248, 250, 252);
}

.pressure-graph-title {
  font-size: 16px;
  font-weight: 800;
  letter-spacing: 0.02em;
  color: rgb(15, 23, 42);
  white-space: nowrap;
  margin: 0;
}

.pressure-graph-hints {
  display: flex;
  flex-wrap: wrap;
  justify-content: flex-end;
  gap: 6px;
  margin-left: auto;
}

.pressure-hint-chip {
  font-size: 10px;
  font-weight: 600;
  color: rgb(51, 65, 85);
  background: rgb(255, 255, 255);
  border: 2.5px solid #000;
  border-radius: 0.5rem;
  padding: 3px 8px;
  white-space: nowrap;
  box-shadow: 0 1px 2px 0 rgb(0 0 0 / 0.04);
}

.pressure-graph-body {
  flex: 1;
  min-height: 0;
  overflow: hidden;
  background: rgb(248, 250, 252);
  display: flex;
  flex-direction: column;
}

.pressure-graph-canvas-wrap,
.pressure-graph-placeholder {
  height: 100%;
  min-height: 0;
  display: flex;
  flex-direction: column;
}

.pressure-graph-canvas-wrap :deep(.dygraph-chart-panel) {
  flex: 1;
  min-height: 0;
  height: 100%;
}

.pressure-graph-canvas-wrap :deep(.dygraph-chart-body) {
  flex: 1;
  min-height: 0;
  height: auto;
  max-height: none;
}

.pressure-graph-canvas-wrap :deep(.dygraph-chart-plot-area) {
  overflow: visible;
  min-height: 560px;
}

.pressure-graph-canvas-wrap :deep(.dygraph-chart-plot-area),
.pressure-graph-canvas-wrap :deep(.dygraph-chart-canvas) {
  flex: 1 1 auto;
  min-height: 0;
  height: 100%;
  max-height: none;
}

.pressure-graph-placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 16px;
  font-size: 12px;
  color: rgb(100, 116, 139);
}

.pressure-graph-placeholder--empty {
  border: 2.5px dashed #000;
  border-radius: 0.75rem;
  margin: 8px;
  background: rgb(248, 250, 252);
}

@media (max-width: 1280px) {
  .pressure-top-grid,
  .pressure-main-grid {
    grid-template-columns: 1fr;
  }

  .pressure-kpi-row {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .pressure-main-grid {
    height: auto;
  }

  .pressure-side-panel {
    height: 360px;
  }

  .pressure-graph-panel {
    height: min(70vh, 640px);
  }
}

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

<style>
/* Flatpickr calendar is appended to body — keep styles global but namespaced */
.pressure-fp-calendar.flatpickr-calendar {
  border: 2.5px solid #000;
  border-radius: 0.75rem;
  box-shadow: 0 12px 28px rgba(15, 23, 42, 0.18);
  padding: 10px 10px 8px;
  width: 308px;
  font-family: inherit;
}

.pressure-fp-calendar .flatpickr-months {
  align-items: center;
  margin-bottom: 6px;
}

.pressure-fp-calendar .flatpickr-month {
  color: #0f172a;
  fill: #0f172a;
  height: 36px;
}

.pressure-fp-calendar .flatpickr-current-month {
  font-size: 14px;
  font-weight: 800;
  padding-top: 4px;
}

.pressure-fp-calendar .flatpickr-prev-month,
.pressure-fp-calendar .flatpickr-next-month {
  padding: 6px;
  border-radius: 0.5rem;
}

.pressure-fp-calendar .flatpickr-prev-month:hover,
.pressure-fp-calendar .flatpickr-next-month:hover {
  background: #f1f5f9;
}

.pressure-fp-calendar .flatpickr-prev-month svg,
.pressure-fp-calendar .flatpickr-next-month svg {
  width: 14px;
  height: 14px;
  fill: #0f172a;
}

.pressure-fp-calendar .flatpickr-weekdays {
  height: 28px;
  margin-top: 2px;
}

.pressure-fp-calendar .flatpickr-weekday {
  color: #64748b;
  font-size: 11px;
  font-weight: 800;
  text-transform: uppercase;
}

.pressure-fp-calendar .flatpickr-days {
  width: 100%;
}

.pressure-fp-calendar .dayContainer {
  width: 100%;
  min-width: 100%;
  max-width: 100%;
}

.pressure-fp-calendar .flatpickr-day {
  max-width: 38px;
  height: 38px;
  line-height: 38px;
  margin: 1px 0;
  border-radius: 0.5rem;
  border: none;
  font-size: 13px;
  font-weight: 700;
  color: #0f172a;
}

.pressure-fp-calendar .flatpickr-day:hover {
  background: #e2e8f0;
  border-color: transparent;
}

.pressure-fp-calendar .flatpickr-day.today {
  border: 2px solid #0ea5e9;
  background: transparent;
  color: #0369a1;
}

.pressure-fp-calendar .flatpickr-day.selected,
.pressure-fp-calendar .flatpickr-day.startRange,
.pressure-fp-calendar .flatpickr-day.endRange {
  background: #0f172a !important;
  border-color: #0f172a !important;
  color: #fff !important;
  box-shadow: none;
}

.pressure-fp-calendar .flatpickr-day.flatpickr-disabled,
.pressure-fp-calendar .flatpickr-day.prevMonthDay,
.pressure-fp-calendar .flatpickr-day.nextMonthDay {
  color: #94a3b8;
  font-weight: 600;
}

.pressure-fp-calendar .flatpickr-day.inRange {
  background: #e2e8f0;
  box-shadow: none;
  border-color: transparent;
}
</style>