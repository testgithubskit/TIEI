<script setup>
import { computed, ref, onBeforeMount, onMounted, watch } from "vue";
import flatPickr from 'vue-flatpickr-component';
import 'flatpickr/dist/flatpickr.css';

import DyLineChartWithLimits from "@/components/Charts/DyLineChartWithLimits.vue";
import SectionMain from "@/components/SectionMain.vue";
import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";
import Toastify from 'toastify-js';
import 'toastify-js/src/toastify.css';

import {
  useMachineSamplingWithLimitsStore,
  PRESSURE_DEFAULT_RANGE_SECONDS,
} from '@/stores/MachineSamplingWithLimitsStore';
import { useNavigationHistoryStore } from '@/stores/navigationHistoryStore';
import { useRouter } from 'vue-router';

const router = useRouter();
const navigationHistoryStore = useNavigationHistoryStore();
const machineSamplingWithLimitsStore = useMachineSamplingWithLimitsStore();

const warningLimit = computed(() => machineSamplingWithLimitsStore.warningLimit);
const criticalLimit = computed(() => machineSamplingWithLimitsStore.criticalLimit);
const chartData = computed(() => machineSamplingWithLimitsStore.chartData);
const lineName = computed(() => (
  machineSamplingWithLimitsStore.lineName
  || machineSamplingWithLimitsStore.line
  || machineSamplingWithLimitsStore.lastSelectedParameter?.lineName
  || machineSamplingWithLimitsStore.lastSelectedParameter?.line_name
  || machineSamplingWithLimitsStore.lastSelectedParameter?.line
  || '—'
));

const isPressureLogListLoading = ref(false);
const isPressureGraphLoading = ref(false);
const MAX_PRESSURE_LOG_SELECTIONS = 5;
const isUpdatingPressureBaseline = ref(false);

// Show/Hide baseline series on graph
const isBaselineVisible = ref(true);

// Header Table Sorting
const sortColumn = ref('date'); // 'date' | 'time'
const sortOrder = ref('desc');  // 'asc' | 'desc'

function toggleSort(col) {
  if (sortColumn.value === col) {
    sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc';
  } else {
    sortColumn.value = col;
    sortOrder.value = 'desc';
  }
}

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

// Filter baseline series out of graph when isBaselineVisible is false
const displayPressureComparisonSeries = computed(() => {
  const rawSeries = pressureComparisonSeries.value || [];
  if (isBaselineVisible.value) {
    return rawSeries;
  }
  return rawSeries.filter((series) => !series.baseline);
});

const pressureHasChartSeries = computed(() => displayPressureComparisonSeries.value.some((series) => Array.isArray(series.chart_data) && series.chart_data.length > 0));

// Exclude baseline timestamp from the table list & apply header sorting
const displayPressureLogFiles = computed(() => {
  let list = pressureLogFiles.value;
  if (baselineLogFileId.value != null) {
    list = list.filter((item) => item.log_file_id !== baselineLogFileId.value);
  }

  return [...list].sort((a, b) => {
    const rawA = a.time_stamp || a.processed_time || '';
    const rawB = b.time_stamp || b.processed_time || '';

    if (sortColumn.value === 'date') {
      const dateA = formatProcessedDateOnly(rawA);
      const dateB = formatProcessedDateOnly(rawB);
      const cmp = dateA.localeCompare(dateB);
      if (cmp !== 0) return sortOrder.value === 'asc' ? cmp : -cmp;

      const timeA = formatProcessedTimeOnly(rawA);
      const timeB = formatProcessedTimeOnly(rawB);
      return sortOrder.value === 'asc' ? timeA.localeCompare(timeB) : -timeA.localeCompare(timeB);
    } else if (sortColumn.value === 'time') {
      const timeA = formatProcessedTimeOnly(rawA);
      const timeB = formatProcessedTimeOnly(rawB);
      const cmp = timeA.localeCompare(timeB);
      if (cmp !== 0) return sortOrder.value === 'asc' ? cmp : -cmp;

      const dateA = formatProcessedDateOnly(rawA);
      const dateB = formatProcessedDateOnly(rawB);
      return sortOrder.value === 'asc' ? dateA.localeCompare(dateB) : -dateA.localeCompare(dateB);
    }
    return 0;
  });
});

const baselineLogFileLabel = computed(() => {
  if (!baselineLogFileId.value) return 'None Selected';

  const baselineRow = pressureLogFiles.value.find((item) => item.log_file_id === baselineLogFileId.value);
  const raw = baselineRow?.time_stamp || baselineRow?.processed_time;
  if (raw) {
    const datePart = formatProcessedDateOnly(raw);
    const timePart = formatProcessedTimeOnly(raw);
    return [datePart, timePart].filter(Boolean).join(' ');
  }

  const baselineSeries = pressureSeriesLegend.value?.find((s) => s.baseline);
  if (baselineSeries && baselineSeries.label) {
    return baselineSeries.label.replace('Baseline (', '').replace(')', '').trim() || 'Baseline Active';
  }

  return 'Baseline Active';
});

const baselineCycleDurationLabel = computed(() => {
  if (!baselineLogFileId.value) return null;
  const baselineRow = pressureLogFiles.value.find((item) => item.log_file_id === baselineLogFileId.value);
  if (baselineRow?.cycle_duration_seconds == null) return null;
  return formatOneDecimal(baselineRow.cycle_duration_seconds);
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
  const hhmmss = timePart.match(/^(\d{1,2}:\d{2}:\d{2})/);
  return hhmmss ? hhmmss[1] : timePart.replace(/\.\d+.*$/, '');
}

const pressureSeriesLegend = computed(() => {
  let colorIdx = 0;
  return displayPressureComparisonSeries.value
    .filter((series) => Array.isArray(series.chart_data) && series.chart_data.length > 0)
    .map((series) => {
      const isBaseline = !!series.baseline;
      const dateOnly = formatProcessedDateOnly(series.processed_time || series.label || '');
      const timeOnly = formatProcessedTimeOnly(series.processed_time || series.label || '');
      const fullLabel = [dateOnly, timeOnly].filter(Boolean).join(' ');
      const color = isBaseline
        ? 'rgb(185, 28, 28)'
        : ['rgb(37, 99, 235)', 'rgb(147, 51, 234)', 'rgb(219, 39, 119)'][colorIdx++ % 3];
      return {
        label: isBaseline
          ? (fullLabel ? `Baseline (${fullLabel})` : 'Baseline')
          : (fullLabel ? `Compare (${fullLabel})` : 'Compare'),
        shortLabel: isBaseline ? 'Baseline' : dateOnly,
        baseline: isBaseline,
        color,
      };
    });
});

const isPressureCompareMode = computed(() => {
  const activeSeries = displayPressureComparisonSeries.value.filter(
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
      initializePressureDates: forceRefreshDates,
    });
  } else if (forceRefreshDates) {
    machineSamplingWithLimitsStore.refreshPressureTimestamp(PRESSURE_DEFAULT_RANGE_SECONDS);
  }
}

function initializePressureLogDateRange() {
  pressureDateRange.value = {
    startDate: '',
    endDate: '',
  };
}

async function refreshPressureComparisonGraph() {
  const selectedIds = [...selectedPressureLogFileIds.value];
  if (selectedIds.length === 0 && !baselineLogFileId.value) {
    machineSamplingWithLimitsStore.pressureComparisonSeries = [];
    machineSamplingWithLimitsStore.chartData = [[0, 0]];
    machineSamplingWithLimitsStore.chartFetchMessage = 'Choose one or more timestamps from the left panel to view the graph.';
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
      backgroundColor: '#ef4444',
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
    const logFiles = response.log_files || [];
    const validIds = new Set(logFiles.map((item) => item.log_file_id));
    const baselineId = response.baseline_log_file_id ?? baselineLogFileId.value;
    let selected = selectedPressureLogFileIds.value
      .filter((id) => validIds.has(id) && id !== baselineId)
      .slice(0, MAX_PRESSURE_LOG_SELECTIONS);

    // Default graph: baseline + latest run (auto-select newest non-baseline file)
    if (selected.length === 0) {
      const latestRun = logFiles.find((item) => {
        const id = item.log_file_id;
        return id != null && id !== baselineId && !item.baseline;
      });
      if (latestRun) {
        selected = [latestRun.log_file_id];
      }
    }

    machineSamplingWithLimitsStore.selectedPressureLogFileIds = selected;
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
      backgroundColor: '#ef4444',
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
    if (currentIds.length >= MAX_PRESSURE_LOG_SELECTIONS) {
      Toastify({
        text: `Maximum of ${MAX_PRESSURE_LOG_SELECTIONS} runs can be selected for preview.`,
        duration: 3500,
        close: true,
        gravity: 'top',
        position: 'right',
        backgroundColor: '#ef4444',
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

function handleRowClick(logFileId) {
  const isSelected = selectedPressureLogFileIds.value.includes(logFileId);
  if (!isSelected && selectedPressureLogFileIds.value.length >= MAX_PRESSURE_LOG_SELECTIONS) {
    Toastify({
      text: `Maximum of ${MAX_PRESSURE_LOG_SELECTIONS} runs can be selected for preview.`,
      duration: 3500,
      close: true,
      gravity: 'top',
      position: 'right',
      backgroundColor: '#ef4444',
    }).showToast();
    return;
  }
  handlePressureLogSelection(logFileId, !isSelected);
}

function selectAllPressureSelections() {
  if (!displayPressureLogFiles.value.length) {
    return;
  }
  const maxToSelect = displayPressureLogFiles.value
    .slice(0, MAX_PRESSURE_LOG_SELECTIONS)
    .map((item) => item.log_file_id);
  machineSamplingWithLimitsStore.selectedPressureLogFileIds = maxToSelect;
  refreshPressureComparisonGraph();
}

async function clearAllPressureSelections() {
  if (!selectedPressureLogFileIds.value.length) {
    return;
  }
  machineSamplingWithLimitsStore.selectedPressureLogFileIds = [];
  await refreshPressureComparisonGraph();
}

async function resetPressureFilter() {
  pressureDateRange.value = {
    startDate: '',
    endDate: '',
  };
  await loadPressureLogFiles({ refreshGraph: true });
}

async function handlePressureBaselineUpdate() {
  if (!canUpdateBaseline.value) {
    return;
  }

  isUpdatingPressureBaseline.value = true;
  try {
    const result = await machineSamplingWithLimitsStore.updatePressureBaseline(
      selectedPressureLogFileIds.value[0],
    );
    await loadPressureLogFiles({ refreshGraph: false });
    await refreshPressureComparisonGraph();
    const recalc = result?.rmse_recalculation || {};
    const elapsedMs = recalc.elapsed_ms;
    const filesUpdated = recalc.files_updated;
    const timingPart = Number.isFinite(Number(elapsedMs))
      ? ` RMSE recalculated for ${filesUpdated ?? '—'} file(s) in ${Number(elapsedMs).toFixed(1)} ms.`
      : '';
    if (Number.isFinite(Number(elapsedMs))) {
      console.log(
        `[pressure RMSE] baseline update files_updated=${filesUpdated} elapsed_ms=${Number(elapsedMs).toFixed(1)}`,
      );
    }
    Toastify({
      text: (result?.message || 'Baseline updated successfully.') + (result?.message ? '' : timingPart),
      duration: 5000,
      close: true,
      gravity: 'top',
      position: 'right',
      backgroundColor: '#10b981',
    }).showToast();
  } catch (error) {
    Toastify({
      text: error.response?.data?.detail || 'Failed to update baseline.',
      duration: 5000,
      close: true,
      gravity: 'top',
      position: 'right',
      backgroundColor: '#ef4444',
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
      backgroundColor: '#10b981',
    }).showToast();
  } catch (error) {
    Toastify({
      text: error.response?.data?.detail || 'Failed to clear baseline.',
      duration: 5000,
      close: true,
      gravity: 'top',
      position: 'right',
      backgroundColor: '#ef4444',
    }).showToast();
  } finally {
    isUpdatingPressureBaseline.value = false;
  }
}

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
  machineSamplingWithLimitsStore.hoverData = {
    xAxisValue: dateTime,
    yAxisValue: preferredPoint.yval,
    xAxisLabel: isCompare ? 'Elapsed Time' : 'Timestamp',
    yAxisLabel: 'Air Pressure',
    xAxisUnits: isCompare ? 'From log start' : 'DateTime (IST)',
    yAxisUnits: 'Pa',
  };
}

// Collapsible left panels — collapsed by default
const isFilterCollapsed = ref(true);
const isLimitsCollapsed = ref(true);
const isSavingPressureLimits = ref(false);
const editableWarningLimit = ref(null);
const editableCriticalLimit = ref(null);

watch(
  [warningLimit, criticalLimit],
  ([warn, crit]) => {
    editableWarningLimit.value = warn;
    editableCriticalLimit.value = crit;
  },
  { immediate: true },
);

function getRmseAlertStatus(item) {
  if (!item || !item.active || item.isBaseline) {
    return 'normal';
  }
  const status = String(item.status || '').toUpperCase();
  if (status === 'CRITICAL') return 'critical';
  if (status === 'WARNING') return 'warning';
  if (status === 'OK') return 'normal';
  if (item.rmse == null || isNaN(Number(item.rmse))) return 'normal';

  const val = Number(item.rmse);
  const crit = Number(criticalLimit.value);
  const warn = Number(warningLimit.value);
  if (Number.isFinite(crit) && crit > 0 && val >= crit) return 'critical';
  if (Number.isFinite(warn) && warn > 0 && val >= warn) return 'warning';
  return 'normal';
}

function formatRunStatusLabel(status) {
  const normalized = String(status || '').toUpperCase();
  if (normalized === 'CRITICAL') return 'CRITICAL';
  if (normalized === 'WARNING') return 'WARNING';
  if (normalized === 'OK') return 'OK';
  return '—';
}

function getLogRowAlertStatus(row) {
  if (!row || row.baseline) return 'normal';
  const status = String(row.status || '').toUpperCase();
  if (status === 'CRITICAL') return 'critical';
  if (status === 'WARNING') return 'warning';
  return 'normal';
}

// Expand/collapse row metrics details in timestamps list table
const expandedRowId = ref(null);

function toggleRowExpand(id) {
  if (expandedRowId.value === id) {
    expandedRowId.value = null;
  } else {
    expandedRowId.value = id;
  }
}

function formatOneDecimal(val) {
  if (val == null || val === undefined || isNaN(Number(val))) return '—';
  return Number(val).toFixed(1);
}

async function savePressureLimits() {
  isSavingPressureLimits.value = true;
  try {
    await machineSamplingWithLimitsStore.updatePressureLimits(
      editableWarningLimit.value,
      editableCriticalLimit.value,
    );
    await loadPressureLogFiles({ refreshGraph: false });
    Toastify({
      text: 'RMSE limits updated from pressure_monitoring_machine.',
      duration: 3000,
      close: true,
      gravity: 'top',
      position: 'right',
      backgroundColor: '#10b981',
    }).showToast();
  } catch (error) {
    Toastify({
      text: error.response?.data?.detail || 'Failed to update limits.',
      duration: 5000,
      close: true,
      gravity: 'top',
      position: 'right',
      backgroundColor: '#ef4444',
    }).showToast();
  } finally {
    isSavingPressureLimits.value = false;
  }
}

// Active KPI cards only (max 6 slots: 1 baseline + 5 runs). Baseline: no RMSE/status.
const fourKpiSlots = computed(() => {
  const slots = [];

  const bId = baselineLogFileId.value;
  const bRow = (bId != null && isBaselineVisible.value)
    ? pressureLogFiles.value.find((r) => r.log_file_id === bId)
    : null;

  if (bRow) {
    slots.push({
      key: 'baseline',
      active: true,
      isBaseline: true,
      badgeText: 'BASELINE RUN',
      timestamp: [formatProcessedDateOnly(bRow.time_stamp), formatProcessedTimeOnly(bRow.time_stamp)].filter(Boolean).join(' '),
      duration: null,
      rmse: null,
      status: null,
      color: 'rgb(185, 28, 28)',
    });
  }

  const nonBaselineColors = [
    'rgb(37, 99, 235)',
    'rgb(147, 51, 234)',
    'rgb(219, 39, 119)',
    'rgb(5, 150, 105)',
    'rgb(234, 88, 12)',
  ];

  selectedPressureLogFileIds.value.forEach((selectedId, i) => {
    if (selectedId == null || selectedId === bId) return;
    const sRow = pressureLogFiles.value.find((r) => r.log_file_id === selectedId);
    if (!sRow) return;
    const color = nonBaselineColors[i % nonBaselineColors.length];
    slots.push({
      key: `run_${selectedId}`,
      active: true,
      isBaseline: false,
      badgeText: `RUN #${i + 1}`,
      timestamp: [formatProcessedDateOnly(sRow.time_stamp), formatProcessedTimeOnly(sRow.time_stamp)].filter(Boolean).join(' '),
      duration: sRow.cycle_duration_seconds != null ? formatOneDecimal(sRow.cycle_duration_seconds) : null,
      rmse: sRow.rmse != null ? formatOneDecimal(sRow.rmse) : null,
      status: sRow.status || 'OK',
      color,
    });
  });

  return slots;
});

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
  const isSelf = candidate.includes('machine-level-sampling') || candidate.includes('air-pressure-sampling');

  if (!isLoginLike && !isSelf) {
    navigationHistoryStore.removeLastRoute();
    router.push(candidate);
    return;
  }

  router.push('/managerialOverview');
};

onBeforeMount(() => {
  if (!machineSamplingWithLimitsStore.lastSelectedParameter) {
    machineSamplingWithLimitsStore.restoreSamplingSession();
  }
  if (resolveIsPressure()) {
    const hasDates = Number.isFinite(Number(machineSamplingWithLimitsStore.selectedDates.from))
      && Number.isFinite(Number(machineSamplingWithLimitsStore.selectedDates.to))
      && Number(machineSamplingWithLimitsStore.selectedDates.to) > Number(machineSamplingWithLimitsStore.selectedDates.from);
    initializePressureDates({ forceRefreshDates: !hasDates });
  }
});

onMounted(async () => {
  if (!machineSamplingWithLimitsStore.lastSelectedParameter) {
    machineSamplingWithLimitsStore.restoreSamplingSession();
  }
  initializePressureDates();
  initializePressureLogDateRange();
  resetPressureHoverData();
  await loadPressureLogFiles({ refreshGraph: true });
});
</script>

<template>
  <LayoutAuthenticatedSimple>
    <SectionMain class="mls-section-main">

      <!-- Alert Toast -->
      <div v-if="machineSamplingWithLimitsStore.alertMessage"
        :class="['mls-alert', machineSamplingWithLimitsStore.isSuccessMessage ? 'mls-alert--ok' : 'mls-alert--error']">
        {{ machineSamplingWithLimitsStore.alertMessage }}
      </div>

      <!-- ── TOP HEADER BANNER ── -->
      <div class="mls-top-banner">
        <button @click="handleBack" class="mls-back-button" title="Back to Overview">
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.2" stroke="currentColor" class="w-4 h-4 mr-1">
            <path stroke-linecap="round" stroke-linejoin="round" d="M10.5 19.5L3 12m0 0l7.5-7.5M3 12h18" />
          </svg>
          BACK
        </button>

        <!-- Location & Machine Card -->
        <div class="mls-top-card mls-top-card--location">
          <span class="mls-top-card-label">LOCATION & MACHINE</span>
          <div class="mls-breadcrumb-chips">
            <span class="mls-chip-line">LINE: BLOCK</span>
            <span class="mls-chip-sep">&rsaquo;</span>
            <span class="mls-chip-machine">MACHINE: {{ machineSamplingWithLimitsStore.machine }}</span>
          </div>
        </div>

        <!-- Parameter Card -->
        <div class="mls-top-card">
          <span class="mls-top-card-label">PARAMETER</span>
          <span class="mls-top-card-value">Air Pressure</span>
        </div>

        <!-- Warning Limit Card -->
        <div class="mls-top-card">
          <span class="mls-top-card-label">WARNING LIMIT (RMSE)</span>
          <span class="mls-top-card-value mls-text-warn">{{ warningLimit ?? '—' }}</span>
        </div>

        <!-- Critical Limit Card -->
        <div class="mls-top-card">
          <span class="mls-top-card-label">CRITICAL LIMIT (RMSE)</span>
          <span class="mls-top-card-value mls-text-crit">{{ criticalLimit ?? '—' }}</span>
        </div>
      </div>

      <!-- ── MAIN GRID: 380px SIDE PANEL + GRAPH PANEL (Full Height Fill) ── -->
      <div class="mls-main-grid">

        <!-- ── SIDE PANEL (380px) ── -->
        <div class="mls-side-panel">

          <!-- ── UNIFIED SIDE PANEL CONTROLS ── -->
          <div class="mls-side-controls">

            <!-- 1. BASELINE CONTROL CARD -->
            <div class="mls-control-card">
              <!-- Top Row: Badge + Timestamp + Eye Toggle -->
              <div class="mls-card-top-row">
                <div class="mls-baseline-badge-group">
                  <span class="mls-card-badge mls-card-badge--red">BASELINE</span>
                  <span class="mls-card-ts-val" :class="{ 'mls-card-ts-val--none': !hasBaseline }">
                    {{ baselineLogFileLabel }}
                  </span>
                  <span
                    v-if="baselineCycleDurationLabel != null"
                    class="mls-baseline-cycle-chip"
                    title="Baseline cycle duration"
                  >
                    {{ baselineCycleDurationLabel }}s
                  </span>
                </div>
                <button
                  v-if="hasBaseline"
                  type="button"
                  class="mls-eye-btn"
                  :class="{ 'mls-eye-btn--off': !isBaselineVisible }"
                  :title="isBaselineVisible ? 'Hide Baseline from Graph' : 'Show Baseline on Graph'"
                  @click="isBaselineVisible = !isBaselineVisible"
                >
                  <svg v-if="isBaselineVisible" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-4 h-4">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M2.036 12.322a1.012 1.012 0 010-.639C3.423 7.51 7.36 4.5 12 4.5c4.638 0 8.573 3.007 9.963 7.178.07.207.07.431 0 .639C20.577 16.49 16.64 19.5 12 19.5c-4.638 0-8.573-3.007-9.963-7.178z" />
                    <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                  </svg>
                  <svg v-else xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-4 h-4">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M3.98 8.223A10.477 10.477 0 001.934 12C3.226 16.338 7.244 19.5 12 19.5c.993 0 1.953-.138 2.863-.395M6.228 6.228A10.45 10.45 0 0112 4.5c4.756 0 8.773 3.162 10.065 7.498a10.523 10.523 0 01-4.293 5.774M6.228 6.228L3 3m3.228 3.228l3.65 3.65m7.894 7.894L21 21m-3.228-3.228l-3.65-3.65m0 0a3 3 0 10-4.243-4.243m4.242 4.242L9.88 9.88" />
                  </svg>
                </button>
              </div>

              <!-- Bottom Row: Action Buttons -->
              <div class="mls-card-actions-row">
                <button
                  type="button"
                  class="mls-ctrl-btn mls-ctrl-btn--primary"
                  :disabled="!canUpdateBaseline || isUpdatingPressureBaseline"
                  title="Select 1 timestamp in the table below to update the baseline"
                  @click="handlePressureBaselineUpdate"
                >
                  Set Selected as Baseline
                </button>
                <button
                  type="button"
                  class="mls-ctrl-btn mls-ctrl-btn--ghost"
                  :disabled="!hasBaseline || isUpdatingPressureBaseline"
                  @click="handlePressureBaselineClear"
                >
                  Clear
                </button>
              </div>
            </div>

            <!-- 2. RMSE ALERT LIMITS CARD (collapsed by default) -->
            <div class="mls-control-card">
              <div class="mls-card-title-bar mls-card-title-bar--clickable" @click="isLimitsCollapsed = !isLimitsCollapsed">
                <div class="mls-card-title-left">
                  <span class="mls-card-title-text">RMSE ALERT LIMITS</span>
                </div>
                <button type="button" class="mls-toggle-btn" title="Toggle Limits Panel">
                  <span>{{ isLimitsCollapsed ? 'Expand' : 'Collapse' }}</span>
                  <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3 ml-1 transition-transform" :class="{ 'rotate-180': isLimitsCollapsed }" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.2" d="M19 9l-7 7-7-7" />
                  </svg>
                </button>
              </div>
              <div v-show="!isLimitsCollapsed" class="mls-card-body-content">
                <div class="mls-rmse-two-col">
                  <div class="mls-rmse-box">
                    <span class="mls-rmse-box-label text-amber-600">WARNING LIMIT</span>
                    <input
                      v-model.number="editableWarningLimit"
                      type="number"
                      step="1"
                      min="0"
                      class="mls-rmse-box-input mls-rmse-box-input--warn"
                      placeholder="Warning"
                    />
                  </div>
                  <div class="mls-rmse-box">
                    <span class="mls-rmse-box-label text-red-600">CRITICAL LIMIT</span>
                    <input
                      v-model.number="editableCriticalLimit"
                      type="number"
                      step="1"
                      min="0"
                      class="mls-rmse-box-input mls-rmse-box-input--crit"
                      placeholder="Critical"
                    />
                  </div>
                </div>
                <div class="mls-card-actions-row" style="margin-top: 8px;">
                  <button
                    type="button"
                    class="mls-ctrl-btn mls-ctrl-btn--primary"
                    :disabled="isSavingPressureLimits"
                    @click="savePressureLimits"
                  >
                    {{ isSavingPressureLimits ? 'Saving...' : 'Save Limits' }}
                  </button>
                </div>
              </div>
            </div>

            <!-- 3. FILTER TIMESTAMPS CARD (Collapsible) -->
            <div class="mls-control-card">
              <div class="mls-card-title-bar mls-card-title-bar--clickable" @click="isFilterCollapsed = !isFilterCollapsed">
                <div class="mls-card-title-left">
                  <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-3.5 h-3.5 text-slate-500 mr-1.5">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 3c-4.97 0-9 4.03-9 9 0 2.12.74 4.07 1.97 5.61L4.35 20.35a1 1 0 001.3 1.3l2.74-6.38A8.96 8.96 0 0012 21c4.97 0 9-4.03 9-9s-4.03-9-9-9z" />
                  </svg>
                  <span class="mls-card-title-text">FILTER TIMESTAMPS</span>
                </div>
                <button type="button" class="mls-toggle-btn" title="Toggle Filter Panel">
                  <span>{{ isFilterCollapsed ? 'Expand' : 'Collapse' }}</span>
                  <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3 ml-1 transition-transform" :class="{ 'rotate-180': isFilterCollapsed }" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.2" d="M19 9l-7 7-7-7" />
                  </svg>
                </button>
              </div>

              <div v-show="!isFilterCollapsed" class="mls-card-body-content">
                <div class="mls-date-grid">
                  <div class="mls-date-field">
                    <span class="mls-date-prefix">FROM</span>
                    <span class="mls-field-divider" />
                    <flat-pickr
                      v-model="pressureDateRange.startDate"
                      :config="pressureFromDateConfig"
                      class="mls-date-input"
                      placeholder="dd-mm-yyyy"
                    />
                    <button v-if="pressureDateRange.startDate" type="button" class="mls-date-clear" @click="pressureDateRange.startDate = ''">×</button>
                  </div>
                  <div class="mls-date-field">
                    <span class="mls-date-prefix">TO</span>
                    <span class="mls-field-divider" />
                    <flat-pickr
                      v-model="pressureDateRange.endDate"
                      :config="pressureToDateConfig"
                      class="mls-date-input"
                      placeholder="dd-mm-yyyy"
                    />
                    <button v-if="pressureDateRange.endDate" type="button" class="mls-date-clear" @click="pressureDateRange.endDate = ''">×</button>
                  </div>
                </div>
                <div class="mls-search-btn-row">
                  <button type="button" class="mls-btn-filter" @click="loadPressureLogFiles()">Filter</button>
                  <button type="button" class="mls-btn-reset" @click="resetPressureFilter()">Reset</button>
                </div>
              </div>
            </div>

          </div>

          <!-- 3. TIMESTAMPS CONTROL BAR -->
          <div class="mls-table-control-bar">
            <span class="mls-table-control-title">
              TIMESTAMPS LIST
              <span class="mls-select-count-badge">({{ selectedPressureLogFileIds.length }}/{{ MAX_PRESSURE_LOG_SELECTIONS }})</span>
            </span>
            <div class="mls-table-control-actions">
              <button
                type="button"
                class="mls-link-action"
                :disabled="!hasPressureSelections"
                @click="clearAllPressureSelections"
              >
                Clear Selection
              </button>
            </div>
          </div>

          <!-- 4. SORTABLE TABLE COMPONENT WITH HEADER SORTING -->
          <div class="mls-table-header">
            <div class="mls-th mls-th-chk"></div>
            <div
              class="mls-th mls-th-sortable mls-th-date"
              :class="{ 'mls-th-active': sortColumn === 'date' }"
              @click="toggleSort('date')"
              title="Click to sort by Date"
            >
              <span>DATE</span>
              <span class="mls-sort-icon">
                <template v-if="sortColumn === 'date'">
                  <svg v-if="sortOrder === 'asc'" xmlns="http://www.w3.org/2000/svg" class="w-3 h-3 inline ml-1" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M14.707 12.707a1 1 0 01-1.414 0L10 9.414l-3.293 3.293a1 1 0 01-1.414-1.414l4-4a1 1 0 011.414 0l4 4a1 1 0 010 1.414z" clip-rule="evenodd" />
                  </svg>
                  <svg v-else xmlns="http://www.w3.org/2000/svg" class="w-3 h-3 inline ml-1" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
                  </svg>
                </template>
                <span v-else class="mls-sort-idle">↕</span>
              </span>
            </div>
            <div
              class="mls-th mls-th-sortable mls-th-time"
              :class="{ 'mls-th-active': sortColumn === 'time' }"
              @click="toggleSort('time')"
              title="Click to sort by Time"
            >
              <span>TIME</span>
              <span class="mls-sort-icon">
                <template v-if="sortColumn === 'time'">
                  <svg v-if="sortOrder === 'asc'" xmlns="http://www.w3.org/2000/svg" class="w-3 h-3 inline ml-1" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M14.707 12.707a1 1 0 01-1.414 0L10 9.414l-3.293 3.293a1 1 0 01-1.414-1.414l4-4a1 1 0 011.414 0l4 4a1 1 0 010 1.414z" clip-rule="evenodd" />
                  </svg>
                  <svg v-else xmlns="http://www.w3.org/2000/svg" class="w-3 h-3 inline ml-1" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
                  </svg>
                </template>
                <span v-else class="mls-sort-idle">↕</span>
              </span>
            </div>
            <div class="mls-th mls-th-metrics">
              <span>RMSE</span>
            </div>
          </div>

          <!-- Scrollable Table Body -->
          <div class="mls-table-body">
            <div v-if="isPressureLogListLoading" class="mls-empty-state">Loading timestamps...</div>
            <div v-else-if="displayPressureLogFiles.length === 0" class="mls-empty-state">No timestamps found for range.</div>
            <template v-else v-for="row in displayPressureLogFiles" :key="row.log_file_id">
              <div
                class="mls-tr"
                :class="{
                  'mls-tr--selected': selectedPressureLogFileIds.includes(row.log_file_id),
                  'mls-tr--expanded': expandedRowId === row.log_file_id
                }"
                @click="handleRowClick(row.log_file_id)"
              >
                <div class="mls-td mls-td-chk" @click.stop>
                  <input
                    :checked="selectedPressureLogFileIds.includes(row.log_file_id)"
                    :disabled="!selectedPressureLogFileIds.includes(row.log_file_id) && selectedPressureLogFileIds.length >= MAX_PRESSURE_LOG_SELECTIONS"
                    type="checkbox"
                    class="mls-checkbox"
                    @change="handlePressureLogSelection(row.log_file_id, $event.target.checked)"
                  />
                </div>
                <div class="mls-td mls-td-date">{{ formatProcessedDateOnly(row.time_stamp || row.processed_time) }}</div>
                <div class="mls-td mls-td-time">{{ formatProcessedTimeOnly(row.time_stamp || row.processed_time) }}</div>
                <div class="mls-td mls-td-metrics" @click.stop="toggleRowExpand(row.log_file_id)" title="Click to view run metrics">
                  <span
                    class="mls-metrics-val"
                    :class="{
                      'mls-rmse-val--crit': getLogRowAlertStatus(row) === 'critical',
                      'mls-rmse-val--warn': getLogRowAlertStatus(row) === 'warning',
                      'text-emerald-600': getLogRowAlertStatus(row) === 'normal' && row.rmse != null,
                    }"
                  >
                    {{ row.rmse != null ? formatOneDecimal(row.rmse) : '—' }}
                  </span>
                  <button type="button" class="mls-row-expand-btn" :class="{ 'mls-row-expand-btn--open': expandedRowId === row.log_file_id }" title="View Run Details">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-3.5 h-3.5 transition-transform" :class="{ 'rotate-180': expandedRowId === row.log_file_id }" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.2" d="M19 9l-7 7-7-7" />
                    </svg>
                  </button>
                </div>
              </div>

              <!-- Collapsible Row Metrics Drawer -->
              <div v-if="expandedRowId === row.log_file_id" class="mls-row-drawer" @click.stop>
                <div class="mls-drawer-grid">
                  <div class="mls-drawer-stat">
                    <span class="mls-drawer-label">Mean</span>
                    <span class="mls-drawer-val">{{ row.mean_pressure != null ? formatOneDecimal(row.mean_pressure) + ' Pa' : 'N/A' }}</span>
                  </div>
                  <div class="mls-drawer-stat">
                    <span class="mls-drawer-label">Peak</span>
                    <span class="mls-drawer-val text-amber-600">{{ row.peak_pressure != null ? formatOneDecimal(row.peak_pressure) + ' Pa' : 'N/A' }}</span>
                  </div>
                  <div class="mls-drawer-stat">
                    <span class="mls-drawer-label">Ripple</span>
                    <span class="mls-drawer-val text-purple-600">{{ row.pressure_ripple != null ? formatOneDecimal(row.pressure_ripple) + ' Pa' : 'N/A' }}</span>
                  </div>
                  <div class="mls-drawer-stat">
                    <span class="mls-drawer-label">Status</span>
                    <span class="mls-drawer-val" :class="{
                      'text-red-600': getLogRowAlertStatus(row) === 'critical',
                      'text-amber-600': getLogRowAlertStatus(row) === 'warning',
                      'text-emerald-600': getLogRowAlertStatus(row) === 'normal',
                    }">{{ formatRunStatusLabel(row.status) }}</span>
                  </div>
                  <div class="mls-drawer-stat">
                    <span class="mls-drawer-label">Cycle Duration</span>
                    <span class="mls-drawer-val text-blue-600">{{ row.cycle_duration_seconds != null ? formatOneDecimal(row.cycle_duration_seconds) + ' s' : 'N/A' }}</span>
                  </div>
                </div>
                <div class="mls-drawer-footer" v-if="row.start_time || row.end_time">
                  <span class="mls-drawer-time-range">
                    Run Window: <strong>{{ row.start_time || '—' }}</strong> &rarr; <strong>{{ row.end_time || '—' }}</strong>
                  </span>
                </div>
              </div>
            </template>
          </div>
        </div>

        <!-- ── REDESIGNED GRAPH PANEL ── -->
        <div class="mls-graph-panel">

          <!-- ── GRAPH HEADER BAR ── -->
          <div class="mls-graph-head">
            <div class="mls-graph-head-left">
              <h3 class="mls-graph-title">HONING MEASURING AIR PRESSURE</h3>
              <span class="mls-head-divider">|</span>
              <div class="mls-head-meta">
                <div class="mls-breadcrumb-chips">
                  <span class="mls-chip-line">LINE: BLOCK</span>
                  <span class="mls-chip-sep">&rsaquo;</span>
                  <span class="mls-chip-machine">MACHINE: {{ machineSamplingWithLimitsStore.machine }}</span>
                </div>
              </div>
            </div>

            <!-- Graph Controls & Toggles -->
            <div class="mls-graph-head-right">
            </div>
          </div>

          <!-- ── KPI row: fixed 6 columns (baseline + up to 5 runs); cards do not stretch ── -->
          <div v-if="fourKpiSlots.length" class="mls-metrics-summary-bar">
            <div
              v-for="item in fourKpiSlots"
              :key="item.key"
              class="mls-metric-card"
              :class="{
                'mls-metric-card--baseline': item.isBaseline,
                'mls-metric-card--rmse-warn': getRmseAlertStatus(item) === 'warning',
                'mls-metric-card--rmse-crit': getRmseAlertStatus(item) === 'critical',
              }"
              :style="{
                borderLeftColor: getRmseAlertStatus(item) === 'critical'
                  ? '#dc2626'
                  : (getRmseAlertStatus(item) === 'warning' ? '#d97706' : item.color)
              }"
            >
              <div class="mls-metric-card-header">
                <div class="mls-metric-title-group">
                  <span
                    class="mls-metric-indicator"
                    :style="{ background: getRmseAlertStatus(item) === 'critical' ? '#dc2626' : (getRmseAlertStatus(item) === 'warning' ? '#d97706' : item.color) }"
                  />
                  <span class="mls-metric-badge-text">{{ item.badgeText }}</span>
                  <span v-if="!item.isBaseline && item.duration != null" class="mls-metric-duration-chip">
                    {{ item.duration }}s
                  </span>
                </div>
                <span class="mls-metric-ts">{{ item.timestamp }}</span>
              </div>

              <!-- Baseline: no RMSE / status. Runs: RMSE + status from DB. -->
              <div v-if="!item.isBaseline" class="mls-metric-card-grid">
                <div
                  class="mls-metric-stat"
                  :class="{ 'mls-stat--rmse-alert': getRmseAlertStatus(item) !== 'normal' }"
                >
                  <span class="mls-metric-label" :class="{
                    'text-red-700 font-extrabold': getRmseAlertStatus(item) === 'critical',
                    'text-amber-700 font-extrabold': getRmseAlertStatus(item) === 'warning',
                  }">RMSE</span>
                  <span class="mls-metric-val" :class="{
                    'mls-rmse-val--crit': getRmseAlertStatus(item) === 'critical',
                    'mls-rmse-val--warn': getRmseAlertStatus(item) === 'warning',
                    'text-emerald-600': item.rmse != null && getRmseAlertStatus(item) === 'normal',
                  }">
                    {{ item.rmse != null ? item.rmse : '—' }}
                  </span>
                </div>
                <div class="mls-metric-stat">
                  <span class="mls-metric-label">STATUS</span>
                  <span class="mls-metric-val" :class="{
                    'mls-rmse-val--crit': getRmseAlertStatus(item) === 'critical',
                    'mls-rmse-val--warn': getRmseAlertStatus(item) === 'warning',
                    'text-emerald-600': item.status && getRmseAlertStatus(item) === 'normal',
                  }">
                    {{ formatRunStatusLabel(item.status) }}
                    <span v-if="getRmseAlertStatus(item) === 'critical'" class="mls-alert-pill mls-alert-pill--crit">CRIT</span>
                    <span v-else-if="getRmseAlertStatus(item) === 'warning'" class="mls-alert-pill mls-alert-pill--warn">WARN</span>
                  </span>
                </div>
              </div>
              <div v-else class="mls-metric-card-baseline-note">
                Reference waveform
              </div>
            </div>
          </div>
          <div v-else class="mls-metrics-summary-bar mls-metrics-summary-bar--empty">
            <span class="mls-kpi-empty-hint">Select a timestamp to compare against the baseline.</span>
          </div>

          <!-- ── GRAPH BODY CONTAINER ── -->
          <div class="mls-graph-body">
            <div v-if="isPressureGraphLoading" class="mls-graph-placeholder">
              <span class="mls-placeholder-dot" />
              Loading pressure comparison graph...
            </div>
            <div v-else-if="!pressureHasChartSeries" class="mls-graph-placeholder mls-graph-placeholder--empty">
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-10 h-10 text-slate-400 mb-2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M3 13.125C3 12.504 3.504 12 4.125 12h2.25c.621 0 1.125.504 1.125 1.125v6.75C7.5 20.496 6.996 21 6.375 21h-2.25A1.125 1.125 0 013 19.875v-6.75zM9.75 8.625c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125v11.25c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 01-1.125-1.125V8.625zM16.5 4.125c0-.621.504-1.125 1.125-1.125h2.25C20.496 3 21 3.504 21 4.125v15.75c0 .621-.504 1.125-1.125 1.125h-2.25A1.125 1.125 0 0116.5 19.875V4.125z" />
              </svg>
              <span>{{ machineSamplingWithLimitsStore.chartFetchMessage || 'Select timestamps from the left panel to view graph.' }}</span>
            </div>
            <div v-else class="mls-graph-canvas-box">
              <DyLineChartWithLimits
                :data="chartData"
                :series-data="displayPressureComparisonSeries"
                :external-legend="[]"
                :warningLimit="warningLimit"
                :criticalLimit="criticalLimit"
                :step-plot="false"
                :hide-hints="false"
                :borderless="true"
                :show-limits="false"
                @data-hovered="OnHoverCallBack"
              />
            </div>
          </div>
        </div>
      </div>

    </SectionMain>
  </LayoutAuthenticatedSimple>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600;700&display=swap');

/* ── Custom Light Scrollbar Theme ── */
:deep(*::-webkit-scrollbar) {
  width: 6px !important;
  height: 6px !important;
}
:deep(*::-webkit-scrollbar-track) {
  background: #f1f5f9 !important;
}
:deep(*::-webkit-scrollbar-thumb) {
  background: #94a3b8 !important;
  border-radius: 3px !important;
}
:deep(*::-webkit-scrollbar-thumb:hover) {
  background: #64748b !important;
}
:deep(*::-webkit-scrollbar-button) {
  display: none !important;
  width: 0 !important;
  height: 0 !important;
}

/* ── Section Root: Full Height Viewport Fill ── */
.mls-section-main {
  padding: 0 !important;
  background: #f8fafc;
  height: calc(100vh - 56px);
  min-height: calc(100vh - 56px);
  overflow: hidden;
  display: flex;
  flex-direction: column;
  font-family: 'Manrope', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
  color: #0f172a;
}

/* ── Alert Toast ── */
.mls-alert {
  position: fixed;
  top: 16px;
  left: 50%;
  transform: translateX(-50%);
  z-index: 100;
  padding: 8px 20px;
  font-size: 13px;
  font-weight: 700;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  color: #ffffff;
  border-radius: 3px;
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
}
.mls-alert--ok   { background: #15803d; }
.mls-alert--error { background: #b91c1c; }

/* ════════════════════════════════════════
   TOP BANNER / HEADER
════════════════════════════════════════ */
.mls-top-banner {
  display: flex;
  align-items: stretch;
  gap: 0;
  border-bottom: 1px solid #cbd5e1;
  background: #ffffff;
  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.04);
  flex-shrink: 0;
  height: 52px;
  min-height: 52px;
}

.mls-back-button {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 0 18px;
  background: transparent;
  border: none;
  border-right: 1px solid #cbd5e1;
  color: #475569;
  font-size: 13px;
  font-weight: 800;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  cursor: pointer;
  flex-shrink: 0;
  transition: all 0.15s ease;
  font-family: 'Manrope', sans-serif;
}
.mls-back-button:hover { color: #0284c7; background: #f1f5f9; }

/* Top Cards */
.mls-top-card {
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 6px 18px;
  border-right: 1px solid #cbd5e1;
  min-width: 140px;
}

.mls-top-card-label {
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: #64748b;
  white-space: nowrap;
}

.mls-top-card-value {
  font-size: 15px;
  font-weight: 800;
  color: #0f172a;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  font-family: 'JetBrains Mono', 'Roboto Mono', monospace;
  letter-spacing: -0.01em;
  margin-top: 1px;
}

/* ── Distinctive Location & Machine Breadcrumb Chips ── */
.mls-breadcrumb-chips {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  margin-top: 2px;
}

.mls-chip-line {
  font-size: 10.5px;
  font-weight: 800;
  letter-spacing: 0.05em;
  text-transform: uppercase;
  background: #f1f5f9;
  color: #334155;
  border: 1px solid #cbd5e1;
  padding: 2px 8px;
  border-radius: 4px;
  font-family: 'Manrope', sans-serif;
}

.mls-chip-sep {
  color: #0284c7;
  font-size: 15px;
  font-weight: 800;
  line-height: 1;
}

.mls-chip-machine {
  font-size: 10.5px;
  font-weight: 800;
  letter-spacing: 0.05em;
  text-transform: uppercase;
  background: #e0f2fe;
  color: #0369a1;
  border: 1px solid #7dd3fc;
  padding: 2px 8px;
  border-radius: 4px;
  font-family: 'Manrope', sans-serif;
  box-shadow: 0 1px 2px rgba(2, 132, 199, 0.08);
}

.mls-text-warn { color: #d97706 !important; }
.mls-text-crit { color: #dc2626 !important; }

/* ════════════════════════════════════════
   MAIN GRID: 380px SIDE PANEL + GRAPH PANEL (Full Height Fill)
════════════════════════════════════════ */
.mls-main-grid {
  display: grid;
  grid-template-columns: 380px minmax(0, 1fr);
  gap: 0;
  flex: 1;
  min-height: 0;
  height: calc(100vh - 108px);
  background: #f8fafc;
}

/* ── SIDE PANEL (380px) ── */
.mls-side-panel {
  display: flex;
  flex-direction: column;
  height: 100%;
  min-height: 0;
  border-right: 1px solid #cbd5e1;
  background: #ffffff;
  overflow: hidden;
  width: 380px;
}

/* ── UNIFIED SIDE PANEL CONTROLS ── */
.mls-side-controls {
  display: flex;
  flex-direction: column;
  gap: 8px;
  padding: 10px;
  background: #f8fafc;
  border-bottom: 1px solid #cbd5e1;
  flex-shrink: 0;
}

.mls-control-card {
  background: #ffffff;
  border: 1px solid #cbd5e1;
  border-radius: 6px;
  padding: 10px 12px;
  display: flex;
  flex-direction: column;
  gap: 8px;
  box-shadow: 0 1px 3px rgba(15, 23, 42, 0.03);
}

/* Card 1: Baseline Row */
.mls-card-top-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
}

.mls-baseline-badge-group {
  display: flex;
  align-items: center;
  gap: 8px;
  min-width: 0;
  flex: 1;
}

.mls-baseline-cycle-chip {
  flex-shrink: 0;
  font-size: 10px;
  font-weight: 800;
  font-family: 'JetBrains Mono', monospace;
  background: #fef2f2;
  color: #b91c1c;
  border: 1px solid #fecaca;
  padding: 1px 6px;
  border-radius: 3px;
  line-height: 1.3;
}

.mls-card-badge {
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  padding: 2px 6px;
  border-radius: 3px;
  flex-shrink: 0;
  font-family: 'Manrope', sans-serif;
}

.mls-card-badge--red {
  background: #fee2e2;
  color: #b91c1c;
  border: 1px solid #fca5a5;
}

.mls-card-ts-val {
  font-family: 'JetBrains Mono', 'Roboto Mono', monospace;
  font-size: 13px;
  font-weight: 700;
  color: #0f172a;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.mls-card-ts-val--none {
  color: #94a3b8;
  font-style: italic;
  font-weight: 500;
}

.mls-eye-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 26px;
  height: 26px;
  border-radius: 4px;
  border: 1px solid #ef4444;
  background: #fef2f2;
  color: #b91c1c;
  cursor: pointer;
  padding: 0;
  flex-shrink: 0;
  transition: all 0.15s ease;
}

.mls-eye-btn:hover { background: #fee2e2; }

.mls-eye-btn--off {
  background: #f1f5f9;
  border-color: #cbd5e1;
  color: #94a3b8;
}

.mls-card-actions-row {
  display: flex;
  align-items: center;
  gap: 8px;
}

.mls-ctrl-btn {
  font-size: 11px;
  font-weight: 800;
  letter-spacing: 0.03em;
  padding: 6px 12px;
  border-radius: 4px;
  cursor: pointer;
  font-family: 'Manrope', sans-serif;
  transition: all 0.15s ease;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

.mls-ctrl-btn--primary {
  background: #0284c7;
  border: 1px solid #0284c7;
  color: #ffffff;
  flex: 1;
}

.mls-ctrl-btn--primary:not(:disabled):hover {
  background: #0369a1;
  border-color: #0369a1;
}

.mls-ctrl-btn--ghost {
  background: #ffffff;
  border: 1px solid #cbd5e1;
  color: #334155;
}

.mls-ctrl-btn--ghost:not(:disabled):hover {
  background: #f8fafc;
  border-color: #94a3b8;
  color: #0f172a;
}

.mls-ctrl-btn:disabled {
  background: #f1f5f9 !important;
  border-color: #cbd5e1 !important;
  color: #94a3b8 !important;
  opacity: 0.7;
  cursor: not-allowed;
}

/* Card 2: RMSE Two Column */
.mls-card-title-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.mls-card-title-bar--clickable {
  cursor: pointer;
  user-select: none;
}

.mls-card-title-left {
  display: flex;
  align-items: center;
}

.mls-card-title-text {
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: #64748b;
  font-family: 'Manrope', sans-serif;
}

.mls-rmse-two-col {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 8px;
}

.mls-rmse-box {
  display: flex;
  flex-direction: column;
  gap: 3px;
}

.mls-rmse-box-label {
  font-size: 9px;
  font-weight: 800;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  font-family: 'Manrope', sans-serif;
}

.mls-rmse-box-input {
  width: 100%;
  padding: 5px 8px;
  font-size: 13px;
  font-weight: 700;
  font-family: 'JetBrains Mono', monospace;
  color: #0f172a;
  background: #ffffff;
  border: 1px solid #cbd5e1;
  border-radius: 4px;
  outline: none;
  transition: all 0.15s ease;
}

.mls-rmse-box-input--warn:focus {
  border-color: #d97706;
  box-shadow: 0 0 0 2px rgba(217, 119, 6, 0.15);
}

.mls-rmse-box-input--crit:focus {
  border-color: #dc2626;
  box-shadow: 0 0 0 2px rgba(220, 38, 38, 0.15);
}

.mls-toggle-btn {
  display: inline-flex;
  align-items: center;
  font-size: 10px;
  font-weight: 700;
  color: #0284c7;
  background: transparent;
  border: none;
  cursor: pointer;
  padding: 0;
}
.mls-toggle-btn:hover { color: #0369a1; }

.mls-card-body-content {
  margin-top: 4px;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

/* Action Buttons */
.mls-btn-action {
  font-size: 11px;
  font-weight: 800;
  letter-spacing: 0.03em;
  padding: 6px 12px;
  border-radius: 4px;
  border: 1px solid transparent;
  cursor: pointer;
  flex-shrink: 0;
  transition: all 0.15s ease;
  font-family: 'Manrope', sans-serif;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}
.mls-btn-action:disabled {
  background: #f1f5f9 !important;
  border-color: #cbd5e1 !important;
  color: #94a3b8 !important;
  opacity: 0.7;
  cursor: not-allowed;
}
.mls-btn-action--primary {
  background: #0284c7;
  border-color: #0284c7;
  color: #ffffff;
  flex: 1;
}
.mls-btn-action--primary:not(:disabled):hover {
  background: #0369a1;
  border-color: #0369a1;
}
.mls-btn-action--ghost {
  background: #ffffff;
  border-color: #cbd5e1;
  color: #334155;
}
.mls-btn-action--ghost:not(:disabled):hover {
  background: #f8fafc;
  border-color: #94a3b8;
  color: #0f172a;
}

/* ── RMSE Alert Highlighting in KPI Cards ── */
.mls-metric-card--rmse-warn {
  background: #fffbeb !important;
  border-color: #fcd34d !important;
  border-left-color: #d97706 !important;
}

.mls-metric-card--rmse-crit {
  background: #fef2f2 !important;
  border-color: #fca5a5 !important;
  border-left-color: #dc2626 !important;
}

.mls-rmse-val--warn {
  color: #b45309 !important;
  font-weight: 800 !important;
}

.mls-rmse-val--crit {
  color: #b91c1c !important;
  font-weight: 800 !important;
}

.mls-alert-pill {
  font-size: 8px;
  font-weight: 900;
  letter-spacing: 0.05em;
  padding: 1px 4px;
  border-radius: 2px;
  margin-left: 3px;
  vertical-align: middle;
}

.mls-alert-pill--warn {
  background: #fef3c7;
  color: #92400e;
  border: 1px solid #fde68a;
}

.mls-alert-pill--crit {
  background: #fee2e2;
  color: #991b1b;
  border: 1px solid #fca5a5;
}

.mls-alert-pill--ok {
  background: #d1fae5;
  color: #065f46;
  border: 1px solid #6ee7b7;
}

.mls-row-status-pill {
  display: inline-block;
  margin-left: 6px;
  padding: 0 5px;
  border-radius: 3px;
  font-size: 9px;
  font-weight: 800;
  letter-spacing: 0.04em;
  vertical-align: middle;
}

.mls-search-title {
  font-size: 11px;
  font-weight: 800;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: #64748b;
}

.mls-date-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 8px;
}

.mls-date-field {
  position: relative;
  display: flex;
  align-items: center;
  border: 1px solid #cbd5e1;
  border-radius: 4px;
  background: #ffffff;
  padding-left: 8px;
  transition: border-color 0.15s ease;
}
.mls-date-field:focus-within { border-color: #0284c7; }

.mls-date-prefix {
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: #64748b;
  flex-shrink: 0;
}

.mls-field-divider {
  width: 1px;
  align-self: stretch;
  background: #cbd5e1;
  margin: 4px 6px;
  flex-shrink: 0;
}

.mls-date-input {
  flex: 1;
  min-width: 0;
  border: none !important;
  outline: none;
  background: transparent !important;
  padding: 5px 20px 5px 2px;
  font-size: 12px;
  font-weight: 600;
  color: #0f172a;
  box-shadow: none !important;
  font-family: 'JetBrains Mono', 'Roboto Mono', monospace;
}

.mls-date-field :deep(.flatpickr-input),
.mls-date-field :deep(.form-control) {
  flex: 1;
  min-width: 0;
  width: 100%;
  border: none !important;
  outline: none !important;
  background: transparent !important;
  box-shadow: none !important;
  padding: 5px 20px 5px 2px;
  font-size: 12px;
  font-weight: 600;
  color: #0f172a;
  font-family: 'JetBrains Mono', 'Roboto Mono', monospace;
}

.mls-date-clear {
  position: absolute;
  right: 5px;
  top: 50%;
  transform: translateY(-50%);
  width: 14px;
  height: 14px;
  border-radius: 2px;
  border: none;
  background: #e2e8f0;
  color: #64748b;
  font-size: 11px;
  font-weight: 700;
  line-height: 1;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0;
}
.mls-date-clear:hover { background: #ef4444; color: #ffffff; }

.mls-search-btn-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 8px;
}

.mls-btn-filter {
  padding: 6px 10px;
  font-size: 11px;
  font-weight: 800;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  background: #0284c7;
  border: 1px solid #0284c7;
  color: #ffffff;
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.15s ease;
  font-family: 'Manrope', sans-serif;
  display: flex;
  align-items: center;
  justify-content: center;
}
.mls-btn-filter:hover { background: #0369a1; border-color: #0369a1; }

.mls-btn-reset {
  padding: 6px 10px;
  font-size: 11px;
  font-weight: 800;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  background: #ffffff;
  border: 1px solid #cbd5e1;
  color: #475569;
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.15s ease;
  font-family: 'Manrope', sans-serif;
  display: flex;
  align-items: center;
  justify-content: center;
}
.mls-btn-reset:hover { background: #f1f5f9; border-color: #94a3b8; color: #0f172a; }

/* 3. Table Control Bar */
.mls-table-control-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 6px 12px;
  background: #f8fafc;
  border-top: 1px solid #cbd5e1;
  border-bottom: 1px solid #cbd5e1;
  flex-shrink: 0;
}

.mls-table-control-title {
  font-size: 11px;
  font-weight: 800;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: #64748b;
  display: flex;
  align-items: center;
}

.mls-select-count-badge {
  font-size: 11px;
  font-weight: 800;
  color: #0284c7;
  margin-left: 4px;
}

.mls-table-control-actions {
  display: flex;
  align-items: center;
  gap: 6px;
}

.mls-link-action {
  background: transparent;
  border: none;
  color: #0284c7;
  font-size: 11px;
  font-weight: 700;
  cursor: pointer;
  padding: 0;
  font-family: 'Manrope', sans-serif;
  transition: color 0.15s ease;
}
.mls-link-action:disabled {
  color: #94a3b8;
  cursor: not-allowed;
}
.mls-link-action:not(:disabled):hover {
  color: #0369a1;
  text-decoration: underline;
}

.mls-link-divider {
  color: #cbd5e1;
  font-size: 11px;
}

/* 4. Table Component with Header Sorting */
.mls-table-header {
  display: grid;
  grid-template-columns: 40px 105px 100px 1fr;
  align-items: stretch;
  background: #f1f5f9;
  border-bottom: 1px solid #cbd5e1;
  flex-shrink: 0;
}

.mls-th {
  font-size: 11px;
  font-weight: 800;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: #475569;
  padding: 5px 8px;
  border-right: 1px solid #cbd5e1;
  display: flex;
  align-items: center;
}
.mls-th:last-child {
  border-right: none;
}
.mls-th-chk {
  display: flex;
  justify-content: center;
}

.mls-th-sortable {
  cursor: pointer;
  user-select: none;
  display: flex;
  align-items: center;
  justify-content: space-between;
  transition: background 0.15s ease, color 0.15s ease;
}
.mls-th-sortable:hover {
  background: #e2e8f0;
  color: #0284c7;
}
.mls-th-active {
  color: #0284c7;
  font-weight: 800;
}

.mls-sort-idle {
  color: #94a3b8;
  font-size: 11px;
  margin-left: 4px;
}

.mls-table-body {
  flex: 1;
  min-height: 0;
  overflow-y: auto;
  background: #ffffff;
  scrollbar-width: thin;
  scrollbar-color: #94a3b8 #f1f5f9;
}
.mls-table-body::-webkit-scrollbar {
  width: 6px;
  height: 6px;
}
.mls-table-body::-webkit-scrollbar-track {
  background: #f1f5f9;
  border-left: 1px solid #e2e8f0;
}
.mls-table-body::-webkit-scrollbar-thumb {
  background: #94a3b8;
  border-radius: 3px;
}
.mls-table-body::-webkit-scrollbar-thumb:hover {
  background: #64748b;
}
.mls-table-body::-webkit-scrollbar-button {
  display: none;
  width: 0;
  height: 0;
}

.mls-empty-state {
  padding: 16px 10px;
  font-size: 12px;
  color: #64748b;
  font-family: 'Manrope', sans-serif;
}

.mls-tr {
  display: grid;
  grid-template-columns: 40px 105px 100px 1fr;
  align-items: stretch;
  min-height: 32px;
  border-bottom: 1px solid #e2e8f0;
  font-family: 'JetBrains Mono', 'Roboto Mono', monospace;
  font-size: 12px;
  font-weight: 600;
  color: #334155;
  cursor: pointer;
  transition: all 0.12s ease;
}
.mls-tr:hover { background: #f0f9ff; }
.mls-tr--selected {
  background: #e0f2fe;
  color: #0f172a;
}

.mls-td {
  padding: 4px 8px;
  border-right: 1px solid #e2e8f0;
  display: flex;
  align-items: center;
  height: 100%;
}
.mls-td:last-child {
  border-right: none;
}

.mls-td-chk { display: flex; justify-content: center; }
.mls-td-date { font-weight: 700; color: #0f172a; }
.mls-td-time { color: #475569; }

.mls-checkbox {
  width: 15px;
  height: 15px;
  accent-color: #0284c7;
  cursor: pointer;
}

/* ── Sleek Table Metrics Cell & Row Expand Styles ── */
.mls-th-metrics,
.mls-td-metrics {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 6px;
}

.mls-metrics-val {
  font-family: 'JetBrains Mono', 'Roboto Mono', monospace;
  font-size: 12px;
  font-weight: 700;
  color: #0f172a;
}

.mls-row-expand-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 22px;
  height: 22px;
  border-radius: 4px;
  border: 1px solid #cbd5e1;
  background: #ffffff;
  color: #64748b;
  cursor: pointer;
  transition: all 0.15s ease;
  padding: 0;
  flex-shrink: 0;
}

.mls-row-expand-btn:hover {
  background: #f1f5f9;
  border-color: #0284c7;
  color: #0284c7;
}

.mls-row-expand-btn--open {
  background: #0284c7;
  border-color: #0284c7;
  color: #ffffff;
}

.mls-row-drawer {
  background: #f8fafc;
  border-bottom: 1px solid #cbd5e1;
  padding: 8px 12px;
  box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.04);
}

.mls-drawer-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 6px 12px;
}

@media (min-width: 360px) {
  .mls-drawer-grid {
    grid-template-columns: repeat(3, minmax(0, 1fr));
  }
}

.mls-drawer-stat {
  display: flex;
  flex-direction: column;
}

.mls-drawer-label {
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  color: #64748b;
  font-family: 'Manrope', sans-serif;
}

.mls-drawer-val {
  font-family: 'JetBrains Mono', monospace;
  font-size: 12px;
  font-weight: 700;
  color: #0f172a;
}

.mls-drawer-footer {
  margin-top: 6px;
  padding-top: 6px;
  border-top: 1px dashed #cbd5e1;
  font-size: 11px;
  color: #475569;
  font-family: 'Manrope', sans-serif;
}

.mls-drawer-time-range strong {
  color: #0f172a;
  font-weight: 700;
  font-family: 'JetBrains Mono', monospace;
}

/* ── KPI row: always 6 equal slots; active cards occupy one slot each ── */
.mls-metrics-summary-bar {
  display: grid;
  grid-template-columns: repeat(6, minmax(0, 1fr));
  gap: 8px;
  padding: 8px 12px;
  background: #ffffff;
  border-bottom: 1px solid #cbd5e1;
  justify-items: stretch;
}

.mls-metrics-summary-bar--empty {
  display: flex;
  align-items: center;
  min-height: 44px;
  grid-template-columns: none;
}

.mls-kpi-empty-hint {
  font-size: 12px;
  font-weight: 600;
  color: #94a3b8;
  font-family: 'Manrope', sans-serif;
}

.mls-metric-card-baseline-note {
  margin-top: 4px;
  font-size: 11px;
  font-weight: 600;
  color: #94a3b8;
  font-family: 'Manrope', sans-serif;
}

@media (max-width: 1100px) {
  .mls-metrics-summary-bar {
    grid-template-columns: repeat(3, minmax(0, 1fr));
  }
}

.mls-metric-card {
  background: #ffffff;
  border: 1px solid #cbd5e1;
  border-left: 3.5px solid #0284c7;
  border-radius: 6px;
  padding: 8px 10px;
  box-shadow: 0 1px 2px rgba(15, 23, 42, 0.03);
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.mls-metric-card--inactive {
  background: #f8fafc !important;
  border: 1px dashed #cbd5e1 !important;
  border-left: 3.5px solid #cbd5e1 !important;
  box-shadow: none !important;
}

.mls-metric-card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 6px;
  margin-bottom: 6px;
}

.mls-metric-title-group {
  display: flex;
  align-items: center;
  gap: 5px;
}

.mls-metric-duration-chip {
  font-size: 9.5px;
  font-weight: 800;
  font-family: 'JetBrains Mono', monospace;
  background: #f0f9ff;
  color: #0284c7;
  border: 1px solid #bae6fd;
  padding: 0px 5px;
  border-radius: 3px;
  line-height: 1.25;
}

.mls-metric-indicator {
  width: 7px;
  height: 7px;
  border-radius: 50%;
  flex-shrink: 0;
}

.mls-metric-badge-text {
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  color: #334155;
  font-family: 'Manrope', sans-serif;
}

.mls-metric-card--inactive .mls-metric-badge-text {
  color: #94a3b8 !important;
}

.mls-metric-ts {
  font-family: 'JetBrains Mono', 'Roboto Mono', monospace;
  font-size: 10.5px;
  font-weight: 600;
  color: #64748b;
}

.mls-metric-card--inactive .mls-metric-ts {
  color: #cbd5e1 !important;
  font-style: italic;
}

.mls-metric-card-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 0;
  margin-top: 2px;
}

.mls-metric-stat {
  display: flex;
  flex-direction: column;
  padding: 0 8px;
  border-right: 1px solid #e2e8f0;
}

.mls-metric-stat:first-child {
  padding-left: 0;
}

.mls-metric-stat:last-child {
  border-right: none;
  padding-right: 0;
}

.mls-metric-card--inactive .mls-metric-stat {
  border-right-color: #cbd5e1 !important;
}

.mls-metric-label {
  font-size: 9px;
  font-weight: 800;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  color: #64748b;
  font-family: 'Manrope', sans-serif;
  margin-bottom: 1px;
}

.mls-metric-card--inactive .mls-metric-label {
  color: #cbd5e1 !important;
}

.mls-metric-val {
  font-family: 'JetBrains Mono', 'Roboto Mono', monospace;
  font-size: 12px;
  font-weight: 700;
  color: #0f172a;
}

.mls-metric-card--inactive .mls-metric-val {
  color: #cbd5e1 !important;
}

/* ════════════════════════════════════════
   REDESIGNED GRAPH PANEL (Fill Height)
════════════════════════════════════════ */
.mls-graph-panel {
  display: flex;
  flex-direction: column;
  height: 100%;
  min-height: 0;
  flex: 1;
  background: #ffffff;
  overflow: hidden;
}

/* Graph Header Bar */
.mls-graph-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 10px 16px;
  border-bottom: 1px solid #e2e8f0;
  background: #ffffff;
  flex-shrink: 0;
}

.mls-graph-head-left {
  display: flex;
  align-items: center;
  gap: 10px;
}

.mls-graph-title {
  font-size: 14px;
  font-weight: 800;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  color: #0f172a;
  margin: 0;
  font-family: 'Manrope', sans-serif;
}

.mls-head-divider {
  color: #cbd5e1;
  font-size: 14px;
  font-weight: 400;
  margin: 0 4px;
}

.mls-head-meta {
  display: inline-flex;
  align-items: center;
  gap: 14px;
}

.mls-head-meta-item {
  font-family: 'JetBrains Mono', 'Roboto Mono', monospace;
  font-size: 13px;
  font-weight: 700;
  color: #0f172a;
}

.mls-head-meta-label {
  font-family: 'Manrope', sans-serif;
  font-size: 11px;
  font-weight: 800;
  letter-spacing: 0.06em;
  color: #64748b;
  margin-right: 4px;
}

.mls-graph-head-right {
  display: flex;
  align-items: center;
  gap: 8px;
}

.mls-hint-pill {
  font-size: 10px;
  font-weight: 600;
  color: #64748b;
  background: #f8fafc;
  border: 1px solid #e2e8f0;
  border-radius: 2px;
  padding: 3px 8px;
}

/* Graph Body Container */
.mls-graph-body {
  flex: 1;
  min-height: 0;
  display: flex;
  flex-direction: column;
  position: relative;
  padding: 10px;
  background: #f8fafc;
  overflow: hidden;
}

.mls-graph-canvas-box {
  flex: 1;
  min-height: 0;
  display: flex;
  flex-direction: column;
  background: #ffffff;
  border: 1px solid #cbd5e1;
  border-radius: 3px;
  box-shadow: 0 2px 8px rgba(15, 23, 42, 0.04);
  overflow: hidden;
  padding: 6px 6px 2px 6px;
}

.mls-graph-canvas-box :deep(.dygraph-chart-panel) {
  flex: 1;
  min-height: 0;
  height: 100%;
  display: flex;
  flex-direction: column;
}

.mls-graph-canvas-box :deep(.dygraph-chart-body) {
  flex: 1;
  min-height: 0;
  height: 100%;
  padding: 4px 8px 12px 2px;
}

.mls-graph-canvas-box :deep(.dygraph-chart-plot-area) {
  flex: 1;
  min-height: 0;
  height: 100%;
  border: none !important;
  box-shadow: none !important;
  padding: 4px 6px 14px 4px;
}

.mls-graph-canvas-box :deep(.dygraph-chart-canvas) {
  flex: 1;
  min-height: 0;
  height: 100%;
}

.mls-graph-placeholder {
  flex: 1;
  min-height: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 10px;
  padding: 20px;
  font-size: 13px;
  font-weight: 700;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  color: #64748b;
  background: #ffffff;
  border: 1px dashed #cbd5e1;
  border-radius: 3px;
}

.mls-placeholder-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #0284c7;
  animation: mls-pulse 1.5s ease-in-out infinite;
  flex-shrink: 0;
}

@keyframes mls-pulse {
  0%, 100% { opacity: 1; }
  50%       { opacity: 0.3; }
}

/* Scrollbar */
::-webkit-scrollbar { width: 5px; height: 5px; }
::-webkit-scrollbar-track { background: #f8fafc; }
::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 2px; }
::-webkit-scrollbar-thumb:hover { background: #94a3b8; }
</style>

<style>
/* Flatpickr calendar — light theme styling */
.pressure-fp-calendar.flatpickr-calendar {
  border: 1px solid #cbd5e1;
  background: #ffffff;
  box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1);
  padding: 12px 12px 10px;
  width: 278px !important;
  border-radius: 3px;
  font-family: 'Manrope', sans-serif;
  height: auto !important;
  overflow: visible !important;
}

.pressure-fp-calendar .flatpickr-innerContainer,
.pressure-fp-calendar .flatpickr-rContainer {
  height: auto !important;
  overflow: visible !important;
}

.pressure-fp-calendar .dayContainer,
.pressure-fp-calendar .flatpickr-days {
  width: 252px !important;
  min-width: 252px !important;
  max-width: 252px !important;
  height: auto !important;
  overflow: visible !important;
}

.pressure-fp-calendar .flatpickr-months { align-items: center; margin-bottom: 8px; }
.pressure-fp-calendar .flatpickr-month { color: #0f172a; fill: #0f172a; height: 36px; background: transparent; }
.pressure-fp-calendar .flatpickr-current-month { font-size: 14px; font-weight: 700; padding-top: 4px; color: #0f172a; display: flex; align-items: center; justify-content: center; gap: 8px; }

.pressure-fp-calendar .flatpickr-monthDropdown-months {
  appearance: none;
  -webkit-appearance: none;
  background: transparent;
  border: none;
  color: #0f172a;
  font-weight: 800;
  font-size: 14px;
  font-family: inherit;
  padding: 4px 8px;
  cursor: pointer;
  outline: none;
  border-radius: 4px;
  transition: background 0.15s ease;
}
.pressure-fp-calendar .flatpickr-monthDropdown-months:hover { background: #f1f5f9; }

.pressure-fp-calendar .numInputWrapper { width: 6ch; display: inline-block; }
.pressure-fp-calendar .numInputWrapper input.numInput {
  background: transparent;
  border: none;
  color: #0f172a;
  font-weight: 800;
  font-size: 14px;
  font-family: inherit;
  padding: 4px 6px;
  cursor: pointer;
  outline: none;
  border-radius: 4px;
  transition: background 0.15s ease;
  width: 100%;
}
.pressure-fp-calendar .numInputWrapper input.numInput:hover { background: #f1f5f9; }
.pressure-fp-calendar .numInputWrapper span.arrowUp,
.pressure-fp-calendar .numInputWrapper span.arrowDown { display: none !important; }
.pressure-fp-calendar .flatpickr-prev-month,
.pressure-fp-calendar .flatpickr-next-month { position: absolute; top: 12px; padding: 6px; cursor: pointer; display: flex; align-items: center; justify-content: center; }
.pressure-fp-calendar .flatpickr-prev-month { left: 12px; }
.pressure-fp-calendar .flatpickr-next-month { right: 12px; }
.pressure-fp-calendar .flatpickr-prev-month svg,
.pressure-fp-calendar .flatpickr-next-month svg { width: 14px; height: 14px; fill: #64748b; }
.pressure-fp-calendar .flatpickr-prev-month:hover svg,
.pressure-fp-calendar .flatpickr-next-month:hover svg { fill: #0f172a; }
.pressure-fp-calendar .flatpickr-weekday { color: #64748b; font-size: 11px; font-weight: 700; text-transform: uppercase; background: transparent; }
.pressure-fp-calendar .flatpickr-day { max-width: 36px; height: 36px; line-height: 36px; border: none; font-size: 13px; font-weight: 600; color: #334155; background: transparent; border-radius: 2px; }
.pressure-fp-calendar .flatpickr-day:hover { background: #f1f5f9; color: #0f172a; border-color: transparent; }
.pressure-fp-calendar .flatpickr-day.today { border: 1px solid #0284c7; background: transparent; color: #0284c7; }
.pressure-fp-calendar .flatpickr-day.selected,
.pressure-fp-calendar .flatpickr-day.startRange,
.pressure-fp-calendar .flatpickr-day.endRange { background: #0284c7 !important; border-color: #0284c7 !important; color: #ffffff !important; box-shadow: none; }
.pressure-fp-calendar .flatpickr-day.flatpickr-disabled { color: #cbd5e1; }
.pressure-fp-calendar .flatpickr-day.prevMonthDay,
.pressure-fp-calendar .flatpickr-day.nextMonthDay { visibility: hidden; }
.pressure-fp-calendar .flatpickr-day.inRange { background: #e0f2fe; box-shadow: none; border-color: transparent; color: #0369a1; }
</style>
