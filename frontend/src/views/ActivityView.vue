<script setup>
import { ref, onMounted, onBeforeMount, watch, computed } from "vue";
import SectionMain from "@/components/SectionMain.vue";
import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";
import * as XLSX from 'xlsx';
import Toastify from 'toastify-js';
import 'toastify-js/src/toastify.css';
import { useActivityStore } from '@/stores/ActivityStore'; 
import { useDatabaseName } from '@/stores/DatabaseName'; 
import { useMachineSamplingWithLimitsStore } from '@/stores/MachineSamplingWithLimitsStore'; 
import { useRouter } from 'vue-router';
import {
  Search as SearchIcon,
  ChevronDown as ChevronDownIcon,
  ChevronRight as ChevronRightIcon,
  RefreshCw as RefreshCwIcon,
  Save as SaveIcon,
  Download as DownloadIcon,
  Rows3 as Rows3Icon,
  Columns3 as Columns3Icon,
  ArrowUp as ArrowUpIcon,
  ArrowDown as ArrowDownIcon,
  ChevronsUpDown as ChevronsUpDownIcon,
  ExternalLink as ExternalLinkIcon,
  PanelRightOpen as PanelRightOpenIcon,
  X as XIcon,
} from 'lucide-vue-next';

const router = useRouter();
const autoRefresh = ref(false);
const refreshInterval = ref(10);
let refreshTimer = null;

const ActivityStoredata = useActivityStore();
const DatabaseName = useDatabaseName();
const machineSamplingWithLimitsStore = useMachineSamplingWithLimitsStore();

// UI State
const activeTab = ref('pending'); // 'pending' | 'completed'
const filterExpanded = ref(true);
const searchQuery = ref('');
const selectedLine = ref('ALL'); // 'ALL' | 'BLOCK' | 'CRANK' | 'HEAD'
const selectedPriority = ref('ALL'); // 'ALL' | 'A' | 'B' | 'C'
const isCompact = ref(true);
const columnsOpen = ref(false);
const showSaveConfirm = ref(false);
const showUnsavedWarning = ref(false);
const pendingTabSwitch = ref(null);
const originalSideDrawerRow = ref(null); // Store original state to detect changes

// Date State (formatted for datetime-local picker)
function formatToDatetimeLocal(ms) {
  if (!ms) return '';
  const dt = new Date(ms);
  dt.setMinutes(dt.getMinutes() - dt.getTimezoneOffset());
  return dt.toISOString().slice(0, 16);
}

const fromDatetimeStr = ref(formatToDatetimeLocal(Date.now() - 24 * 3600 * 1000));
const toDatetimeStr = ref(formatToDatetimeLocal(Date.now()));

watch(fromDatetimeStr, (val) => {
  if (val) {
    ActivityStoredata.selectedDates.from = new Date(val).getTime();
  }
});

watch(toDatetimeStr, (val) => {
  if (val) {
    ActivityStoredata.selectedDates.to = new Date(val).getTime();
  }
});

// Table Sorting & Pagination
const sortKey = ref('date_of_identification');
const sortDir = ref('desc');
const page = ref(0);
const pageSize = ref(10);
const sideDrawerRow = ref(null);

const LINES = ['ALL', 'BLOCK', 'CRANK', 'HEAD'];

const ALL_COLUMNS = [
  { key: 'id', label: 'ID', short: 'ID', numeric: true, essential: true, locked: true },
  { key: 'location', label: 'Line', short: 'LINE', essential: true },
  { key: 'name', label: 'Machine', short: 'MACHINE', essential: true },
  { key: 'group_name', label: 'Group', short: 'GROUP' },
  { key: 'parameter_name', label: 'Parameter', short: 'PARAMETER', essential: true },
  { key: 'axis_name', label: 'Axis', short: 'AXIS' },
  { key: 'condition', label: 'Condition', short: 'CONDITION', essential: true },
  { key: 'recent_value', label: 'Recent', short: 'RECENT', numeric: true, essential: true },
  { key: 'warning_limit', label: 'Warn limit', short: 'WARN', numeric: true },
  { key: 'critical_limit', label: 'Crit limit', short: 'CRIT', numeric: true },
  { key: 'date_of_identification', label: 'Identified', short: 'IDENTIFIED', essential: true },
  { key: 'latest_occurrence', label: 'Latest occur.', short: 'LATEST' },
  { key: 'days_since_identification', label: 'Age (d)', short: 'AGE (D)', numeric: true, essential: true },
  { key: 'number_of_occurrences', label: 'Occur.', short: 'OCCUR.', numeric: true },
  { key: 'target_date_of_completion', label: 'Target date', short: 'TARGET DATE', essential: true },
  { key: 'actual_date_of_completion', label: 'Actual date', short: 'ACTUAL DATE' },
  { key: 'corrective_measurement', label: 'Corrective action', short: 'CORRECTIVE ACTION', essential: true },
  { key: 'spare_required', label: 'Spare req.', short: 'SPARE' },
  { key: 'support_needed', label: 'Support', short: 'SUPPORT' },
  { key: 'responsible_person_company_id', label: 'Emp ID', short: 'EMP ID' },
  { key: 'responsible_person_username', label: 'Employee', short: 'EMPLOYEE', essential: true },
  { key: 'priority', label: 'Priority', short: 'PRIORITY', essential: true },
  { key: 'status', label: 'Status', short: 'STATUS' },
];

const visibleColumns = ref(ALL_COLUMNS.filter(c => c.essential).map(c => c.key));

const activeCols = computed(() => {
  return ALL_COLUMNS.filter(c => {
    // Exclude status column when activeTab is completed
    if (activeTab.value === 'completed' && c.key === 'status') return false;
    // Always include actual date in completed tab
    if (activeTab.value === 'completed' && c.key === 'actual_date_of_completion') return true;
    return visibleColumns.value.includes(c.key);
  });
});

function toggleCol(key) {
  if (key === 'id') return;
  if (visibleColumns.value.includes(key)) {
    visibleColumns.value = visibleColumns.value.filter(k => k !== key);
  } else {
    visibleColumns.value.push(key);
  }
}

function setPreset(preset) {
  if (preset === 'essential') {
    visibleColumns.value = ALL_COLUMNS.filter(c => c.essential).map(c => c.key);
  } else {
    visibleColumns.value = ALL_COLUMNS.map(c => c.key);
  }
}

function rowMatchesLine(row, targetLine) {
  if (!targetLine || targetLine === 'ALL' || targetLine === 'Overall' || targetLine === 'OVERALL') return true;
  const loc = String(row.location || row.line || row.name || '').trim().toUpperCase();
  const target = String(targetLine).trim().toUpperCase();
  return loc === target || loc.includes(target);
}

function getDaysSince(dateStr) {
  if (!dateStr) return 0;
  const date = new Date(dateStr);
  if (isNaN(date.getTime())) return 0;
  return Math.max(0, Math.floor((Date.now() - date.getTime()) / 86400000));
}

// Row filtering logic
function filterRows(rows) {
  if (!Array.isArray(rows)) return [];
  const q = searchQuery.value.trim().toLowerCase();
  return rows.filter((r) => {
    if (selectedLine.value !== 'ALL' && !rowMatchesLine(r, selectedLine.value)) return false;
    if (selectedPriority.value !== 'ALL' && (r.priority || 'C') !== selectedPriority.value) return false;
    if (!q) return true;
    return [r.name, r.parameter_name, r.group_name, r.responsible_person_username, r.location, r.line]
      .filter(Boolean)
      .join(' ')
      .toLowerCase()
      .includes(q);
  });
}

const filteredPendingRows = computed(() => filterRows(ActivityStoredata.pendingData || []));
const filteredCompletedRows = computed(() => filterRows(ActivityStoredata.completedData || []));

const activeRows = computed(() => {
  return activeTab.value === 'pending' ? filteredPendingRows.value : filteredCompletedRows.value;
});

const sortedRows = computed(() => {
  const getVal = (r) => {
    if (sortKey.value === 'days_since_identification') {
      return getDaysSince(r.date_of_identification);
    }
    return r[sortKey.value] ?? '';
  };
  return [...activeRows.value].sort((a, b) => {
    const av = getVal(a);
    const bv = getVal(b);
    const cmp = typeof av === 'number' && typeof bv === 'number' ? av - bv : String(av).localeCompare(String(bv));
    return sortDir.value === 'asc' ? cmp : -cmp;
  });
});

const paginatedRows = computed(() => {
  const start = page.value * pageSize.value;
  return sortedRows.value.slice(start, start + pageSize.value);
});

const totalPages = computed(() => Math.max(1, Math.ceil(sortedRows.value.length / pageSize.value)));

function toggleSort(key) {
  if (sortKey.value === key) {
    sortDir.value = sortDir.value === 'desc' ? 'asc' : 'desc';
  } else {
    sortKey.value = key;
    sortDir.value = 'desc';
  }
}

// Summary Calculation (Preserving backend abnormalitySummary & live counts)
const summary = computed(() => {
  const lines = ['Overall', 'BLOCK', 'CRANK', 'HEAD'];
  const todayStr = new Date().toLocaleDateString();

  // If backend abnormalitySummary is present in store, use it
  if (ActivityStoredata.abnormalitySummary && ActivityStoredata.abnormalitySummary.length > 0) {
    return lines.map((lineKey) => {
      let warning = 0;
      let critical = 0;
      let completed = 0;

      if (lineKey === 'Overall') {
        ActivityStoredata.abnormalitySummary.forEach(item => {
          warning += Number(item.WARNING || 0);
          critical += Number(item.CRITICAL || 0);
          completed += Number(item.COMPLETED || 0);
        });
      } else {
        const found = ActivityStoredata.abnormalitySummary.find(s => String(s.line || '').toUpperCase() === lineKey.toUpperCase());
        if (found) {
          warning = Number(found.WARNING || 0);
          critical = Number(found.CRITICAL || 0);
          completed = Number(found.COMPLETED || 0);
        }
      }

      const total = warning + critical + completed;
      const warningPct = total > 0 ? (warning / total) * 100 : 0;
      const criticalPct = total > 0 ? (critical / total) * 100 : 0;
      const completedPct = total > 0 ? (completed / total) * 100 : 0;

      return {
        line: lineKey === 'Overall' ? 'OVERALL' : lineKey,
        date: todayStr,
        WARNING: warning,
        CRITICAL: critical,
        COMPLETED: completed,
        total,
        warningPct,
        criticalPct,
        completedPct,
      };
    });
  }

  // Fallback: calculate live counts from pendingData and completedData
  return lines.map((lineKey) => {
    const pendingList = ActivityStoredata.pendingData || [];
    const completedList = ActivityStoredata.completedData || [];
    const isMatch = (r) => rowMatchesLine(r, lineKey);

    const warning = pendingList.filter((r) => isMatch(r) && String(r.condition).toUpperCase() === 'WARNING').length;
    const critical = pendingList.filter((r) => isMatch(r) && String(r.condition).toUpperCase() === 'CRITICAL').length;
    const completed = completedList.filter(isMatch).length;

    const total = warning + critical + completed;
    const warningPct = total > 0 ? (warning / total) * 100 : 0;
    const criticalPct = total > 0 ? (critical / total) * 100 : 0;
    const completedPct = total > 0 ? (completed / total) * 100 : 0;

    return {
      line: lineKey === 'Overall' ? 'OVERALL' : lineKey,
      date: todayStr,
      WARNING: warning,
      CRITICAL: critical,
      COMPLETED: completed,
      total,
      warningPct,
      criticalPct,
      completedPct,
    };
  });
});

// Inline Editing Handlers
function onFieldEdit(id, field, value) {
  const pendingList = ActivityStoredata.pendingData || [];
  const row = pendingList.find(r => r.id === id);
  if (row) {
    // Auto-copy target date to actual date when status changes to Completed
    if (field === 'status' && value === 'Completed' && row.target_date_of_completion) {
      row.actual_date_of_completion = row.target_date_of_completion;
    }
    row[field] = value;
    ActivityStoredata.saveEditedRowIds(id);
  }
}

function handleTabSwitch(targetTab) {
  if (activeTab.value === 'pending' && targetTab === 'completed' && ActivityStoredata.editedRowIds.length > 0) {
    pendingTabSwitch.value = targetTab;
    showUnsavedWarning.value = true;
  } else {
    activeTab.value = targetTab;
    page.value = 0;
  }
}

function confirmTabSwitch() {
  showUnsavedWarning.value = false;
  if (pendingTabSwitch.value) {
    activeTab.value = pendingTabSwitch.value;
    page.value = 0;
    pendingTabSwitch.value = null;
  }
}

function cancelTabSwitch() {
  showUnsavedWarning.value = false;
  pendingTabSwitch.value = null;
}

function openSideDrawer(row) {
  // Store original state to detect changes later
  originalSideDrawerRow.value = JSON.parse(JSON.stringify(row));
  sideDrawerRow.value = row;
}

function saveDrawerChanges() {
  if (!sideDrawerRow.value) return;
  
  console.log('Saving drawer changes for row:', sideDrawerRow.value.id);
  console.log('Row data before save:', sideDrawerRow.value);
  
  // Check if there are actual changes by comparing with original state
  const hasChanges = JSON.stringify(sideDrawerRow.value) !== JSON.stringify(originalSideDrawerRow.value);
  
  if (!hasChanges) {
    Toastify({
      text: 'No changes to save',
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: '#f59e0b',
    }).showToast();
    return;
  }
  
  // Auto-copy target date to actual date when status changes to Completed
  if (sideDrawerRow.value.status === 'Completed' && sideDrawerRow.value.target_date_of_completion) {
    sideDrawerRow.value.actual_date_of_completion = sideDrawerRow.value.target_date_of_completion;
    console.log('Auto-copied target date to actual date:', sideDrawerRow.value.actual_date_of_completion);
  }
  
  // Find and update the row in pendingData
  const pendingList = ActivityStoredata.pendingData || [];
  const rowIndex = pendingList.findIndex(r => r.id === sideDrawerRow.value.id);
  
  if (rowIndex !== -1) {
    // Update the row in pendingData with the modified values
    pendingList[rowIndex] = { ...sideDrawerRow.value };
    console.log('Updated row in pendingData at index:', rowIndex);
  }
  
  // Mark the row as edited by adding to editedRowIds
  if (!ActivityStoredata.editedRowIds.includes(sideDrawerRow.value.id)) {
    ActivityStoredata.editedRowIds.push(sideDrawerRow.value.id);
  }
  console.log('Edited row IDs after marking:', ActivityStoredata.editedRowIds);
  
  // Show save confirmation
  showSaveConfirm.value = true;
}

const handleQuerySubmit = async () => {
  try {
    if (new Date(ActivityStoredata.selectedDates.to) < new Date(ActivityStoredata.selectedDates.from)) {
      Toastify({
        text: 'Please enter a valid date range.',
        duration: 3000,
        close: true,
        gravity: 'bottom',
        position: 'right',
        backgroundColor: '#ef4444',
      }).showToast();
      return;
    }

    await ActivityStoredata.fetchActivityData();
    page.value = 0;

    Toastify({
      text: 'Activity data refreshed',
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: '#10b981',
    }).showToast();
  } catch (error) {
    console.error('Error fetching data:', error);
    Toastify({
      text: 'Error fetching Data.',
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: '#ef4444',
    }).showToast();
  }
};

const saveEdit = async () => {
  const dirtyIds = ActivityStoredata.editedRowIds || [];
  if (dirtyIds.length === 0) {
    Toastify({
      text: 'No changes to save',
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: '#ef4444',
    }).showToast();
    return;
  }
  showSaveConfirm.value = true;
};

const confirmSaveEdit = async () => {
  showSaveConfirm.value = false;
  const dirtyIds = ActivityStoredata.editedRowIds || [];
  
  // Check if there are any edited rows
  if (dirtyIds.length === 0) {
    Toastify({
      text: 'No changes to save',
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: '#f59e0b',
    }).showToast();
    return;
  }
  
  const pendingList = ActivityStoredata.pendingData || [];
  const editedRowsData = pendingList.filter(row => dirtyIds.includes(row.id));

  const invalid = editedRowsData.filter(row => {
    return row.status === 'Completed' && (!row.target_date_of_completion || !row.responsible_person_company_id);
  });

  if (invalid.length > 0) {
    Toastify({
      text: 'Missing fields: Completed rows need a target date and responsible person.',
      duration: 5000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: '#ef4444',
    }).showToast();
    return;
  }

  try {
    editedRowsData.forEach(row => {
      for (const [key, value] of Object.entries(row)) {
        if (value === null && key !== 'target_date_of_completion' && key !== 'responsible_person_company_id') {
          row[key] = '-';
        }
        if (value === "" && key === 'priority') {
          row[key] = 'C';
        }
      }
    });

    console.log('Saving edited rows:', editedRowsData);
    console.log('Row status being sent:', editedRowsData[0]?.status);
    console.log('Row ID being sent:', editedRowsData[0]?.id);

    // Use the store's sendEdit function which was working before
    const result = await ActivityStoredata.sendEdit(editedRowsData);
    console.log('Save result:', result);

    // Check if the response contains an error message
    if (result && (result.error || result.detail || result.message)) {
      const errorMessage = result.error || result.detail || result.message;
      throw new Error(errorMessage);
    }

    ActivityStoredata.editedRowIds = [];

    Toastify({
      text: 'Edits saved successfully',
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: '#10b981',
    }).showToast();

    console.log('Refreshing data after save...');
    await ActivityStoredata.fetchActivityData();
    console.log('Data refreshed. Pending count:', ActivityStoredata.pendingData.length, 'Completed count:', ActivityStoredata.completedData.length);
  } catch (error) {
    console.error('Error saving edits:', error);
    Toastify({
      text: `Error saving edits: ${error.message}`,
      duration: 5000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: '#ef4444',
    }).showToast();
  }
};

const exportCsv = () => {
  const rows = activeRows.value;
  if (!rows || !rows.length) return;
  const ws = XLSX.utils.json_to_sheet(rows);
  const wb = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(wb, ws, activeTab.value === 'pending' ? 'Pending' : 'Completed');
  XLSX.writeFile(wb, `${activeTab.value}-activities.xlsx`);
  Toastify({
    text: 'Export started',
    duration: 3000,
    close: true,
    gravity: 'bottom',
    position: 'right',
    backgroundColor: '#10b981',
  }).showToast();
};

function onParameterClick(row) {
  console.log('Parameter clicked:', row);
  console.log('Machine:', row.name, 'Parameter:', row.parameter_name, 'Group:', row.group_name);
  
  // Clear session storage to prevent old defaults from being restored
  sessionStorage.removeItem('machineSamplingWithLimitsSession');
  
  machineSamplingWithLimitsStore.machine = row.name;
  machineSamplingWithLimitsStore.actualParameterName = row.parameter_name;
  machineSamplingWithLimitsStore.parameterGroup = row.group_name;
  
  // Also update lastSelectedParameter to prevent it from overriding
  machineSamplingWithLimitsStore.lastSelectedParameter = {
    machine: row.name,
    actualParameterName: row.parameter_name,
    parameterGroup: row.group_name,
  };
  
  console.log('Store after update:', {
    machine: machineSamplingWithLimitsStore.machine,
    actualParameterName: machineSamplingWithLimitsStore.actualParameterName,
    parameterGroup: machineSamplingWithLimitsStore.parameterGroup
  });
  router.push('/machine-level-sampling');
}

function setLine(l) {
  selectedLine.value = l;
  page.value = 0;
}

function clearFilters() {
  searchQuery.value = '';
  selectedLine.value = 'ALL';
  selectedPriority.value = 'ALL';
  page.value = 0;
}

// Auto Cycle Timer
const setRefreshInterval = () => {
  cancelAutoRefresh();
  startAutoRefresh();
};

const startAutoRefresh = () => {
  const order = ['BLOCK', 'CRANK', 'HEAD'];
  refreshTimer = setInterval(() => {
    const currentIndex = order.indexOf(selectedLine.value);
    const nextLine = order[(currentIndex + 1) % order.length];
    setLine(nextLine);
  }, refreshInterval.value * 1000);
};

const cancelAutoRefresh = () => {
  if (refreshTimer) {
    clearInterval(refreshTimer);
    refreshTimer = null;
  }
};

watch(autoRefresh, (newValue) => {
  if (newValue) {
    startAutoRefresh();
  } else {
    cancelAutoRefresh();
  }
});

onBeforeMount(async () => {
  const toMs = Date.now();
  const fromMs = toMs - 24 * 3600 * 1000;
  ActivityStoredata.selectedDates.from = fromMs;
  ActivityStoredata.selectedDates.to = toMs;
  fromDatetimeStr.value = formatToDatetimeLocal(fromMs);
  toDatetimeStr.value = formatToDatetimeLocal(toMs);
});

onMounted(() => {
  ActivityStoredata.fetchActivityData();
});
</script>

<template>
  <LayoutAuthenticatedSimple class="font-sans bg-[#f8fafc] min-h-screen text-[#0f172a]">
    <SectionMain class="p-2 sm:p-3 space-y-2 mt-10">
      <!-- ── BOLD PAGE HEADING "Activity View" ── -->
      <div class="px-0.5 pt-1 pb-1">
        <h1 class="text-2xl font-bold tracking-tight text-[#0f172a]">Activity View</h1>
      </div>

      <!-- ── TOP SINGLE-ROW FILTER CONTAINER ── -->
      <div class="border border-[#e2e8f0] bg-white p-2 rounded-none shadow-none flex flex-wrap items-center gap-3">
        <!-- Date Range Box (FROM, TO & Search button inside an inner bordered box) -->
        <div class="flex shrink-0 items-center gap-3 border border-[#e2e8f0] bg-[#f8fafc] p-1.5 rounded-none">
          <div class="flex items-center gap-2">
            <span class="text-[10px] uppercase tracking-widest text-[#64748b] whitespace-nowrap font-semibold">FROM</span>
            <input
              type="datetime-local"
              v-model="fromDatetimeStr"
              class="h-8 font-mono text-xs border border-[#e2e8f0] bg-white px-2 rounded-none text-[#0f172a] focus:outline-none focus:border-[#007088]"
            />
          </div>
          <div class="flex items-center gap-2 border-l border-[#e2e8f0] pl-3">
            <span class="text-[10px] uppercase tracking-widest text-[#64748b] whitespace-nowrap font-semibold">TO</span>
            <input
              type="datetime-local"
              v-model="toDatetimeStr"
              class="h-8 font-mono text-xs border border-[#e2e8f0] bg-white px-2 rounded-none text-[#0f172a] focus:outline-none focus:border-[#007088]"
            />
          </div>
          <button
            type="button"
            @click="handleQuerySubmit"
            class="h-8 text-[10px] px-4 font-semibold ml-1 bg-[#007088] hover:bg-[#005a6e] text-white rounded-none transition-colors"
          >
            Search
          </button>
        </div>

        <!-- Filter Toggle Button (Right beside Search in the SAME row) -->
        <button
          type="button"
          @click="filterExpanded = !filterExpanded"
          class="h-8 border border-[#e2e8f0] px-3 text-xs font-semibold flex items-center gap-1.5 bg-white hover:bg-[#f1f5f9] rounded-none transition-all"
        >
          <SearchIcon class="size-3.5 text-[#64748b]" />
          <span class="text-[11px] font-semibold text-[#0f172a]">Filter</span>
          <ChevronDownIcon v-if="filterExpanded" class="size-3.5 text-[#64748b]" />
          <ChevronRightIcon v-else class="size-3.5 text-[#64748b]" />
        </button>

        <!-- Expanded Filters in the EXACT SAME Flex Row -->
        <template v-if="filterExpanded">
          <!-- Search Box -->
          <div class="flex items-center gap-2 border-l border-[#e2e8f0] pl-3">
            <span class="text-[10px] uppercase tracking-widest text-[#64748b] whitespace-nowrap font-semibold">SEARCH</span>
            <div class="relative">
              <SearchIcon class="pointer-events-none absolute left-2.5 top-1/2 size-3.5 -translate-y-1/2 text-[#64748b]" />
              <input
                v-model="searchQuery"
                placeholder="Search…"
                class="h-8 w-44 pl-8 text-xs border border-[#e2e8f0] bg-white rounded-none focus:outline-none focus:border-[#007088]"
              />
            </div>
          </div>

          <!-- Priority Select -->
          <div class="flex items-center gap-2 border-l border-[#e2e8f0] pl-3">
            <span class="text-[10px] uppercase tracking-widest text-[#64748b] whitespace-nowrap font-semibold">PRIORITY</span>
            <select
              v-model="selectedPriority"
              class="h-8 w-28 text-xs border border-[#e2e8f0] bg-white rounded-none px-2 focus:outline-none focus:border-[#007088]"
            >
              <option value="ALL">All priority</option>
              <option value="A">A — highest</option>
              <option value="B">B — medium</option>
              <option value="C">C — low</option>
            </select>
          </div>

          <!-- Line Buttons -->
          <div class="flex items-center gap-2 border-l border-[#e2e8f0] pl-3">
            <span class="text-[10px] uppercase tracking-widest text-[#64748b] whitespace-nowrap font-semibold">LINE</span>
            <div class="flex items-center border border-[#e2e8f0] bg-[#f1f5f9]/60 p-0.5 rounded-none">
              <button
                v-for="l in LINES"
                :key="l"
                type="button"
                @click="setLine(l)"
                :class="[
                  'px-2 py-1 text-xs font-medium transition-colors rounded-none relative',
                  selectedLine === l
                    ? 'bg-white text-[#0f172a] shadow-sm font-semibold'
                    : 'text-[#64748b] hover:text-[#0f172a]'
                ]"
              >
                {{ l === 'ALL' ? 'All' : l }}
                <span
                  v-if="autoRefresh && selectedLine === l && l !== 'ALL'"
                  class="absolute -top-0.5 -right-0.5 size-2 bg-[#007088] rounded-full animate-ping"
                />
              </button>
            </div>
          </div>

          <!-- Auto Cycle Toggle Switch (Pill toggle with sliding knob) -->
          <div class="flex items-center gap-2 border-l border-[#e2e8f0] pl-3">
            <button
              type="button"
              @click="autoRefresh = !autoRefresh"
              :class="[
                'relative inline-flex h-5 w-9 shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out focus:outline-none',
                autoRefresh ? 'bg-[#007088]' : 'bg-[#cbd5e1]'
              ]"
            >
              <span
                :class="[
                  'pointer-events-none inline-block h-4 w-4 transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out',
                  autoRefresh ? 'translate-x-4' : 'translate-x-0'
                ]"
              />
            </button>
            <label @click="autoRefresh = !autoRefresh" class="text-xs font-semibold cursor-pointer whitespace-nowrap text-[#0f172a]">
              Auto cycle
            </label>
            <div class="flex items-center gap-1">
              <input
                type="number"
                min="5"
                v-model.number="refreshInterval"
                @change="setRefreshInterval"
                class="h-7 w-14 font-mono text-xs border border-[#e2e8f0] bg-white rounded-none text-center"
              />
              <span class="text-xs font-semibold text-[#64748b]">s</span>
            </div>
          </div>

          <!-- Refresh Button -->
          <button
            type="button"
            @click="handleQuerySubmit"
            class="h-8 border border-[#e2e8f0] px-3 text-xs flex items-center gap-1 bg-white hover:bg-[#f1f5f9] rounded-none"
          >
            <RefreshCwIcon class="size-3.5 mr-1 text-[#64748b]" />
            Refresh
          </button>

          <!-- Clear Button -->
          <button
            v-if="searchQuery || selectedLine !== 'ALL' || selectedPriority !== 'ALL'"
            type="button"
            @click="clearFilters"
            class="h-8 px-2 text-xs text-[#64748b] hover:text-[#0f172a]"
          >
            Clear
          </button>
        </template>
      </div>

      <!-- ── ABNORMALITY SUMMARY SECTION ── -->
      <div class="border border-[#e2e8f0] bg-white p-2 rounded-none shadow-none">
        <div class="text-[10px] font-semibold uppercase tracking-widest text-[#64748b] mb-1.5 px-0.5">
          ABNORMALITY SUMMARY
        </div>
        <div class="grid gap-2 grid-cols-1 sm:grid-cols-2 lg:grid-cols-4">
          <div
            v-for="s in summary"
            :key="s.line"
            class="border border-[#e2e8f0] bg-[#f1f5f9]/30 p-2.5 transition-colors hover:border-[#007088]/40 rounded-none"
          >
            <div class="flex items-center justify-between mb-2">
              <span class="text-[11px] font-bold uppercase tracking-widest text-[#0f172a]">{{ s.line }}</span>
              <span class="text-[9px] font-mono text-[#64748b]">{{ s.date }}</span>
            </div>

            <!-- Multi-segment Progress Bar -->
            <div class="h-1.5 w-full bg-[#f1f5f9] rounded-none overflow-hidden mb-2 flex">
              <div class="h-full bg-amber-500 transition-all" :style="{ width: `${s.warningPct}%` }" />
              <div class="h-full bg-red-500 transition-all" :style="{ width: `${s.criticalPct}%` }" />
              <div class="h-full bg-emerald-500 transition-all" :style="{ width: `${s.completedPct}%` }" />
            </div>

            <!-- 3 Stat Blocks - Connected Table Layout -->
            <div class="grid grid-cols-3 gap-0 text-center border border-[#e2e8f0] rounded-none overflow-hidden">
              <div class="p-1.5 border-r border-[#e2e8f0]">
                <p class="font-mono text-base font-bold text-amber-600">{{ s.WARNING }}</p>
                <p class="text-[8px] uppercase tracking-wide text-[#64748b] font-semibold">WARNING</p>
              </div>
              <div class="p-1.5 border-r border-[#e2e8f0]">
                <p class="font-mono text-base font-bold text-red-600">{{ s.CRITICAL }}</p>
                <p class="text-[8px] uppercase tracking-wide text-[#64748b] font-semibold">CRITICAL</p>
              </div>
              <div class="p-1.5">
                <p class="font-mono text-base font-bold text-emerald-600">{{ s.COMPLETED }}</p>
                <p class="text-[8px] uppercase tracking-wide text-[#64748b] font-semibold">COMPLETED</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- ── MAIN ACTIVITIES TABLE SECTION ── -->
      <div class="space-y-1">
        <!-- Tabs & Actions Toolbar Header Row -->
        <div class="flex items-center justify-between gap-2 border-b border-[#e2e8f0] pb-2">
          <!-- Pending / Completed Tabs -->
          <div class="min-w-0 h-9 p-1 bg-[#f1f5f9]/70 rounded-none flex items-center gap-1">
            <button
              type="button"
              @click="handleTabSwitch('pending')"
              :class="[
                'h-7 px-4 text-xs font-semibold rounded-none transition-all flex items-center gap-2',
                activeTab === 'pending'
                  ? 'bg-red-600 text-white shadow-sm font-bold'
                  : 'text-[#64748b] hover:text-[#0f172a]'
              ]"
            >
              <span>Pending</span>
              <span
                :class="[
                  'px-2 py-0.5 rounded-full font-mono text-[10px] font-bold',
                  activeTab === 'pending' ? 'bg-white/20 text-white' : 'bg-red-100 text-red-700'
                ]"
              >
                {{ filteredPendingRows.length }}
              </span>
            </button>

            <button
              type="button"
              @click="handleTabSwitch('completed')"
              :class="[
                'h-7 px-4 text-xs font-semibold rounded-none transition-all flex items-center gap-2',
                activeTab === 'completed'
                  ? 'bg-emerald-600 text-white shadow-sm font-bold'
                  : 'text-[#64748b] hover:text-[#0f172a]'
              ]"
            >
              <span>Completed</span>
              <span
                :class="[
                  'px-2 py-0.5 rounded-full font-mono text-[10px] font-bold',
                  activeTab === 'completed' ? 'bg-white/20 text-white' : 'bg-emerald-100 text-emerald-700'
                ]"
              >
                {{ filteredCompletedRows.length }}
              </span>
            </button>
          </div>

          <!-- Actions on the right side of the SAME row (Square Icon Buttons size-3.5) -->
          <div class="flex shrink-0 items-center gap-1.5">
            <template v-if="activeTab === 'pending'">
              <span v-if="ActivityStoredata.editedRowIds.length > 0" class="font-mono text-[10px] text-amber-600 font-semibold mr-1">
                {{ ActivityStoredata.editedRowIds.length }} unsaved
              </span>

              <button
                type="button"
                @click="saveEdit"
                :disabled="ActivityStoredata.editedRowIds.length === 0"
                class="h-8 w-8 border border-[#e2e8f0] bg-white hover:bg-[#f1f5f9] flex items-center justify-center rounded-none disabled:opacity-40 transition-colors"
                title="Save Edits"
              >
                <SaveIcon :style="{ width: '18px', height: '18px' }" class="text-[#0f172a]" />
              </button>
            </template>

            <button
              type="button"
              @click="exportCsv"
              class="h-8 w-8 border border-[#e2e8f0] bg-white hover:bg-[#f1f5f9] flex items-center justify-center rounded-none transition-colors"
              title="Export CSV/Excel"
            >
              <DownloadIcon :style="{ width: '18px', height: '18px' }" class="text-[#0f172a]" />
            </button>

            <button
              type="button"
              @click="isCompact = !isCompact"
              class="h-8 w-8 border border-[#e2e8f0] bg-white hover:bg-[#f1f5f9] flex items-center justify-center rounded-none transition-colors"
              title="Toggle Row Density"
            >
              <Rows3Icon :style="{ width: '18px', height: '18px' }" class="text-[#0f172a]" />
            </button>

            <div class="relative">
              <button
                type="button"
                @click="columnsOpen = !columnsOpen"
                class="h-8 w-8 border border-[#e2e8f0] bg-white hover:bg-[#f1f5f9] flex items-center justify-center rounded-none transition-colors"
                title="Columns"
              >
                <Columns3Icon :style="{ width: '18px', height: '18px' }" class="text-[#0f172a]" />
              </button>

              <!-- Columns Dropdown Menu -->
              <div
                v-if="columnsOpen"
                class="absolute right-0 mt-1 w-56 bg-white border border-[#e2e8f0] shadow-md z-50 p-2 max-h-80 overflow-y-auto rounded-none"
              >
                <div class="text-[11px] uppercase tracking-widest text-[#64748b] font-bold mb-1 px-2">
                  Visible Columns
                </div>
                <button
                  @click="setPreset('essential')"
                  class="w-full text-left text-xs px-2 py-1 hover:bg-[#f1f5f9] font-medium text-[#0f172a]"
                >
                  Essential preset
                </button>
                <button
                  @click="setPreset('all')"
                  class="w-full text-left text-xs px-2 py-1 hover:bg-[#f1f5f9] font-medium text-[#0f172a] mb-1"
                >
                  Show all
                </button>
                <div class="border-t border-[#e2e8f0] my-1"></div>
                <div
                  v-for="col in ALL_COLUMNS"
                  :key="col.key"
                  class="flex items-center px-2 py-1 hover:bg-[#f1f5f9]"
                >
                  <input
                    type="checkbox"
                    :id="'col-' + col.key"
                    :checked="visibleColumns.includes(col.key)"
                    :disabled="col.locked"
                    @change="toggleCol(col.key)"
                    class="rounded-none text-[#007088] focus:ring-0"
                  />
                  <label
                    :for="'col-' + col.key"
                    class="ml-2 text-xs text-[#0f172a] cursor-pointer select-none flex-1 font-mono"
                  >
                    {{ col.label }}
                  </label>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- HTML Table (Clean white rows, soft blue hover highlight, soft red tint ONLY for critical pending items) -->
        <div class="overflow-x-auto border border-[#e2e8f0] bg-white">
          <table class="w-full text-sm text-left border-collapse">
            <thead>
              <tr class="border-b border-[#e2e8f0] bg-[#e2e8f0] text-[11px] font-semibold uppercase tracking-wider text-[#0f172a]">
                <th
                  v-for="col in activeCols"
                  :key="col.key"
                  @click="toggleSort(col.key)"
                  :class="[
                    'h-8 px-3 py-1.5 cursor-pointer select-none whitespace-nowrap hover:text-[#0f172a]',
                    col.numeric ? 'text-right' : ''
                  ]"
                >
                  <span :class="['inline-flex items-center gap-1', sortKey === col.key ? 'text-[#0f172a]' : '']">
                    {{ col.short || col.label }}
                    <ArrowUpIcon v-if="sortKey === col.key && sortDir === 'asc'" :style="{ width: '12px', height: '12px' }" class="text-[#0f172a]" />
                    <ArrowDownIcon v-else-if="sortKey === col.key && sortDir === 'desc'" :style="{ width: '12px', height: '12px' }" class="text-[#0f172a]" />
                    <ChevronsUpDownIcon v-else :style="{ width: '12px', height: '12px' }" class="opacity-40" />
                  </span>
                </th>
                <th class="h-8 w-10 px-2 py-1.5"></th>
              </tr>
            </thead>
            <tbody class="divide-y divide-[#e2e8f0]/70">
              <tr v-if="paginatedRows.length === 0">
                <td :colspan="activeCols.length + 1" class="h-28 text-center text-[#64748b] text-xs font-mono">
                  No activities match the current filters.
                </td>
              </tr>
              <tr
                v-for="row in paginatedRows"
                :key="row.id"
                :class="[
                  'transition-colors hover:bg-blue-50 cursor-pointer',
                  row.condition === 'CRITICAL' && activeTab === 'pending' ? 'bg-red-50' : 'bg-white'
                ]"
                @click="openSideDrawer(row)"
              >
                <td
                  v-for="col in activeCols"
                  :key="col.key"
                  :class="[
                    isCompact ? 'py-1.5 px-3' : 'py-3 px-3',
                    col.numeric ? 'text-right font-mono' : '',
                    'text-sm'
                  ]"
                >
                  <!-- ID -->
                  <template v-if="col.key === 'id'">
                    <span class="font-mono text-xs text-[#64748b]">{{ row.id }}</span>
                  </template>

                  <!-- LINE -->
                  <template v-else-if="col.key === 'location'">
                    <span class="border border-[#e2e8f0] bg-[#f1f5f9] px-1.5 py-0.5 font-mono text-[11px] tracking-wide uppercase text-[#0f172a]">
                      {{ row.location || row.line || '—' }}
                    </span>
                  </template>

                  <!-- MACHINE -->
                  <template v-else-if="col.key === 'name'">
                    <span class="whitespace-nowrap font-mono text-xs text-[#0f172a]">{{ row.name }}</span>
                  </template>

                  <!-- PARAMETER NAME (Blue link with hover underline, size-3 icon) -->
                  <template v-else-if="col.key === 'parameter_name'">
                    <button
                      type="button"
                      @click="onParameterClick(row)"
                      class="group inline-flex items-center gap-1 whitespace-nowrap font-medium text-[#0284c7] hover:underline text-xs"
                    >
                      {{ row.parameter_name }}
                      <ExternalLinkIcon class="size-3 opacity-0 group-hover:opacity-100 transition-opacity text-[#0284c7]" />
                    </button>
                  </template>

                  <!-- CONDITION BADGE -->
                  <template v-else-if="col.key === 'condition'">
                    <span
                      :class="[
                        'inline-block px-2 py-0.5 text-[10px] font-bold uppercase tracking-wide border rounded-none',
                        row.condition === 'CRITICAL'
                          ? 'border-red-300 bg-red-50 text-red-600'
                          : 'border-amber-400 bg-amber-50 text-amber-800'
                      ]"
                    >
                      {{ row.condition }}
                    </span>
                  </template>

                  <!-- RECENT VALUE -->
                  <template v-else-if="col.key === 'recent_value'">
                    <span :class="['font-mono', row.recent_value >= row.critical_limit ? 'font-semibold text-red-600' : 'text-[#0f172a]']">
                      {{ row.recent_value }}
                    </span>
                  </template>

                  <!-- DAYS SINCE IDENTIFICATION -->
                  <template v-else-if="col.key === 'days_since_identification'">
                    <span :class="['font-mono', getDaysSince(row.date_of_identification) > 30 ? 'font-semibold text-red-600' : 'text-[#64748b]']">
                      {{ getDaysSince(row.date_of_identification) }}
                    </span>
                  </template>

                  <!-- TARGET DATE (Editable in Pending) -->
                  <template v-else-if="col.key === 'target_date_of_completion'">
                    <input
                      v-if="activeTab === 'pending'"
                      type="date"
                      :value="row.target_date_of_completion || ''"
                      @input="onFieldEdit(row.id, 'target_date_of_completion', $event.target.value)"
                      class="h-8 w-40 font-mono text-xs border border-[#e2e8f0] bg-white px-2 rounded-none text-[#0f172a] focus:outline-none focus:border-[#007088]"
                    />
                    <span v-else class="font-mono text-xs text-[#64748b]">
                      {{ row.target_date_of_completion || '—' }}
                    </span>
                  </template>

                  <!-- ACTUAL DATE (Read-only) -->
                  <template v-else-if="col.key === 'actual_date_of_completion'">
                    <span class="font-mono text-xs text-[#64748b]">
                      {{ row.actual_date_of_completion || '—' }}
                    </span>
                  </template>

                  <!-- CORRECTIVE ACTION (Editable in Pending) -->
                  <template v-else-if="col.key === 'corrective_measurement'">
                    <input
                      v-if="activeTab === 'pending'"
                      type="text"
                      :value="row.corrective_measurement || ''"
                      @input="onFieldEdit(row.id, 'corrective_measurement', $event.target.value)"
                      placeholder="Add action…"
                      class="h-8 w-48 text-xs border border-[#e2e8f0] bg-white px-2 rounded-none text-[#0f172a] focus:outline-none focus:border-[#007088]"
                    />
                    <span v-else class="truncate block max-w-xs text-xs text-[#64748b]">
                      {{ row.corrective_measurement || '—' }}
                    </span>
                  </template>

                  <!-- SPARE REQUIRED (Editable in Pending) -->
                  <template v-else-if="col.key === 'spare_required'">
                    <input
                      v-if="activeTab === 'pending'"
                      type="text"
                      :value="row.spare_required || ''"
                      @input="onFieldEdit(row.id, 'spare_required', $event.target.value)"
                      placeholder="Spare req…"
                      class="h-8 w-28 text-xs border border-[#e2e8f0] bg-white px-2 rounded-none text-[#0f172a] focus:outline-none focus:border-[#007088]"
                    />
                    <span v-else class="font-mono text-xs text-[#64748b]">
                      {{ row.spare_required || '—' }}
                    </span>
                  </template>

                  <!-- SUPPORT NEEDED (Editable in Pending) -->
                  <template v-else-if="col.key === 'support_needed'">
                    <input
                      v-if="activeTab === 'pending'"
                      type="text"
                      :value="row.support_needed || ''"
                      @input="onFieldEdit(row.id, 'support_needed', $event.target.value)"
                      placeholder="Support…"
                      class="h-8 w-28 text-xs border border-[#e2e8f0] bg-white px-2 rounded-none text-[#0f172a] focus:outline-none focus:border-[#007088]"
                    />
                    <span v-else class="font-mono text-xs text-[#64748b]">
                      {{ row.support_needed || '—' }}
                    </span>
                  </template>

                  <!-- RESPONSIBLE PERSON COMPANY ID / EMP ID (Editable in Pending) -->
                  <template v-else-if="col.key === 'responsible_person_company_id'">
                    <input
                      v-if="activeTab === 'pending'"
                      type="text"
                      :value="row.responsible_person_company_id || ''"
                      @input="onFieldEdit(row.id, 'responsible_person_company_id', $event.target.value)"
                      placeholder="Emp ID…"
                      class="h-8 w-28 font-mono text-xs border border-[#e2e8f0] bg-white px-2 rounded-none text-[#0f172a] focus:outline-none focus:border-[#007088]"
                    />
                    <span v-else class="font-mono text-xs text-[#64748b]">
                      {{ row.responsible_person_company_id || '—' }}
                    </span>
                  </template>

                  <!-- RESPONSIBLE PERSON USERNAME / EMPLOYEE NAME (Automatic text) -->
                  <template v-else-if="col.key === 'responsible_person_username'">
                    <span class="whitespace-nowrap text-xs font-medium text-[#0f172a]">{{ row.responsible_person_username || '—' }}</span>
                  </template>

                  <!-- PRIORITY (Clear dropdown with w-20 width & px-1.5, no text cut-off) -->
                  <template v-else-if="col.key === 'priority'">
                    <select
                      v-if="activeTab === 'pending'"
                      :value="row.priority || 'C'"
                      @change="onFieldEdit(row.id, 'priority', $event.target.value)"
                      class="h-7 w-20 text-xs border border-[#e2e8f0] bg-white text-[#0f172a] font-mono rounded-none px-1.5 py-0 cursor-pointer focus:outline-none focus:border-[#007088]"
                    >
                      <option value="A">A</option>
                      <option value="B">B</option>
                      <option value="C">C</option>
                    </select>
                    <span
                      v-else
                      :class="[
                        'inline-block px-1.5 py-0.5 text-[10px] font-bold border rounded-none font-mono',
                        row.priority === 'A' ? 'bg-red-50 text-red-700 border-red-200' :
                        row.priority === 'B' ? 'bg-amber-50 text-amber-800 border-amber-200' :
                        'bg-slate-100 text-slate-700 border-slate-200'
                      ]"
                    >
                      {{ row.priority || 'C' }}
                    </span>
                  </template>

                  <!-- STATUS (Clear dropdown with w-28 width & px-1.5, no text cut-off) -->
                  <template v-else-if="col.key === 'status'">
                    <select
                      v-if="activeTab === 'pending'"
                      :value="row.status || 'Pending'"
                      @change="onFieldEdit(row.id, 'status', $event.target.value)"
                      class="h-7 w-28 text-xs border border-[#e2e8f0] bg-white text-[#0f172a] rounded-none px-1.5 py-0 cursor-pointer focus:outline-none focus:border-[#007088]"
                    >
                      <option value="Pending">Pending</option>
                      <option value="Completed">Completed</option>
                    </select>
                    <span
                      v-else
                      :class="[
                        'inline-block px-2 py-0.5 text-[10px] uppercase font-semibold border rounded-none',
                        row.status === 'Completed' ? 'border-emerald-300 bg-emerald-50 text-emerald-700' : 'border-slate-300 bg-slate-100 text-slate-600'
                      ]"
                    >
                      {{ row.status || 'Pending' }}
                    </span>
                  </template>

                  <!-- DEFAULT FIELD -->
                  <template v-else>
                    <span class="font-mono text-xs text-[#64748b]">
                      {{ row[col.key] === null || row[col.key] === undefined || row[col.key] === '' ? '—' : row[col.key] }}
                    </span>
                  </template>
                </td>

                <!-- Side Drawer Action Icon Button -->
                <td class="h-8 w-10 px-2 py-1.5 text-right">
                  <button
                    type="button"
                    @click="openSideDrawer(row)"
                    class="h-7 w-7 inline-flex items-center justify-center hover:bg-[#f1f5f9] text-[#64748b] hover:text-[#0f172a] rounded-none"
                    title="Open Record Details"
                  >
                    <PanelRightOpenIcon :style="{ width: '18px', height: '18px' }" />
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- Table Footer Pagination Bar (Exact Lovable match, non-truncated dropdown) -->
        <div class="flex flex-wrap items-center justify-between gap-2 border border-t-0 border-[#e2e8f0] bg-white px-3 py-2 text-xs">
          <div class="text-[#64748b] font-mono">
            Showing
            <span class="text-[#0f172a] font-bold">{{ sortedRows.length === 0 ? 0 : page * pageSize + 1 }}–{{ Math.min(sortedRows.length, (page + 1) * pageSize) }}</span>
            of <span class="text-[#0f172a] font-bold">{{ sortedRows.length }}</span>
          </div>

          <div class="flex items-center gap-2">
            <select v-model.number="pageSize" @change="page = 0" class="h-9 w-20 text-xs border border-[#e2e8f0] bg-white font-mono rounded-none px-1.5 focus:outline-none focus:border-[#007088] cursor-pointer">
              <option :value="10">10</option>
              <option :value="25">25</option>
              <option :value="50">50</option>
              <option :value="100">100</option>
            </select>

            <button
              type="button"
              @click="page = Math.max(0, page - 1)"
              :disabled="page === 0"
              class="h-7 px-2.5 border border-[#e2e8f0] bg-white hover:bg-[#f1f5f9] text-xs disabled:opacity-40 rounded-none font-mono"
            >
              Prev
            </button>

            <span class="font-mono text-[#64748b] text-xs">
              {{ page + 1 }}/{{ totalPages }}
            </span>

            <button
              type="button"
              @click="page = Math.min(totalPages - 1, page + 1)"
              :disabled="page >= totalPages - 1"
              class="h-7 px-2.5 border border-[#e2e8f0] bg-white hover:bg-[#f1f5f9] text-xs disabled:opacity-40 rounded-none font-mono"
            >
              Next
            </button>
          </div>
        </div>
      </div>

      <!-- Side Drawer Modal for Record Details -->
      <div v-if="sideDrawerRow" class="fixed inset-0 z-50 flex justify-end bg-black/40 backdrop-blur-xs">
        <div class="w-full max-w-xl bg-white h-full shadow-2xl flex flex-col justify-between overflow-y-auto p-4 border-l border-[#e2e8f0]">
          <div>
            <div class="flex items-center justify-between border-b border-[#e2e8f0] pb-3 mb-4">
              <div>
                <h3 class="text-base font-bold text-[#0f172a] flex items-center gap-2">
                  <span class="font-mono text-[#64748b]">#{{ sideDrawerRow.id }}</span>
                  {{ sideDrawerRow.parameter_name }}
                  <span
                    :class="[
                      'inline-block px-2 py-0.5 text-[10px] font-bold uppercase border rounded-none',
                      sideDrawerRow.condition === 'CRITICAL' ? 'border-red-300 bg-red-50 text-red-600' : 'border-amber-400 bg-amber-50 text-amber-800'
                    ]"
                  >
                    {{ sideDrawerRow.condition }}
                  </span>
                </h3>
                <p class="font-mono text-xs text-[#64748b] mt-1">
                  {{ sideDrawerRow.location }} · {{ sideDrawerRow.name }} · {{ sideDrawerRow.group_name }} · axis {{ sideDrawerRow.axis_name }}
                </p>
              </div>
              <button @click="sideDrawerRow = null" class="p-1 hover:bg-[#f1f5f9] rounded-none">
                <XIcon class="size-5 text-[#64748b]" />
              </button>
            </div>

            <!-- Stats -->
            <div class="grid grid-cols-3 gap-2 text-center mb-4">
              <div class="border border-[#e2e8f0] bg-[#f1f5f9]/40 p-2">
                <p class="font-mono text-lg font-bold text-red-600">{{ sideDrawerRow.recent_value }}</p>
                <p class="text-[10px] uppercase font-semibold text-[#64748b]">Recent</p>
              </div>
              <div class="border border-[#e2e8f0] bg-[#f1f5f9]/40 p-2">
                <p class="font-mono text-lg font-bold text-amber-700">{{ sideDrawerRow.warning_limit }}</p>
                <p class="text-[10px] uppercase font-semibold text-[#64748b]">Warn Limit</p>
              </div>
              <div class="border border-[#e2e8f0] bg-[#f1f5f9]/40 p-2">
                <p class="font-mono text-lg font-bold text-red-600">{{ sideDrawerRow.critical_limit }}</p>
                <p class="text-[10px] uppercase font-semibold text-[#64748b]">Crit Limit</p>
              </div>
            </div>

            <dl class="grid grid-cols-3 gap-x-4 gap-y-3 text-xs mb-4">
              <div>
                <dt class="text-[10px] uppercase tracking-widest text-[#64748b] font-semibold">Identified</dt>
                <dd class="font-mono text-xs text-[#0f172a]">{{ sideDrawerRow.date_of_identification || '—' }}</dd>
              </div>
              <div>
                <dt class="text-[10px] uppercase tracking-widest text-[#64748b] font-semibold">Latest Occurrence</dt>
                <dd class="font-mono text-xs text-[#0f172a]">{{ sideDrawerRow.latest_occurrence || '—' }}</dd>
              </div>
              <div>
                <dt class="text-[10px] uppercase tracking-widest text-[#64748b] font-semibold">Days Since Ident.</dt>
                <dd class="font-mono text-xs text-[#0f172a]">{{ getDaysSince(sideDrawerRow.date_of_identification) }}</dd>
              </div>
              <div>
                <dt class="text-[10px] uppercase tracking-widest text-[#64748b] font-semibold">Occurrences</dt>
                <dd class="font-mono text-xs text-[#0f172a]">{{ sideDrawerRow.number_of_occurrences || '1' }}</dd>
              </div>
              <div>
                <dt class="text-[10px] uppercase tracking-widest text-[#64748b] font-semibold">Spare Required</dt>
                <dd class="font-mono text-xs text-[#0f172a]">{{ sideDrawerRow.spare_required || '—' }}</dd>
              </div>
              <div>
                <dt class="text-[10px] uppercase tracking-widest text-[#64748b] font-semibold">Support Needed</dt>
                <dd class="font-mono text-xs text-[#0f172a]">{{ sideDrawerRow.support_needed || '—' }}</dd>
              </div>
              <div>
                <dt class="text-[10px] uppercase tracking-widest text-[#64748b] font-semibold">Emp ID</dt>
                <dd class="font-mono text-xs text-[#0f172a]">{{ sideDrawerRow.responsible_person_company_id || '—' }}</dd>
              </div>
              <div>
                <dt class="text-[10px] uppercase tracking-widest text-[#64748b] font-semibold">Employee</dt>
                <dd class="text-xs text-[#0f172a]">{{ sideDrawerRow.responsible_person_username || '—' }}</dd>
              </div>
            </dl>

            <!-- Editable fields only for pending tab -->
            <div v-if="activeTab === 'pending'" class="border-t border-[#e2e8f0] pt-4 space-y-3">
              <div class="grid grid-cols-2 gap-3">
                <div>
                  <label class="block text-[10px] uppercase tracking-widest text-[#64748b] font-semibold mb-1">Target Date</label>
                  <input
                    type="date"
                    v-model="sideDrawerRow.target_date_of_completion"
                    class="w-full h-8 font-mono text-xs border border-[#e2e8f0] bg-white px-2 rounded-none text-[#0f172a]"
                  />
                </div>
                <div>
                  <label class="block text-[10px] uppercase tracking-widest text-[#64748b] font-semibold mb-1">Actual Date</label>
                  <span class="font-mono text-xs text-[#64748b] block h-8 px-2 py-2 border border-[#e2e8f0] bg-[#f1f5f9]/50 rounded-none">
                    {{ sideDrawerRow.actual_date_of_completion || '—' }}
                  </span>
                </div>
              </div>

              <div class="grid grid-cols-3 gap-3">
                <div>
                  <label class="block text-[10px] uppercase tracking-widest text-[#64748b] font-semibold mb-1">Spare Required</label>
                  <input
                    type="text"
                    v-model="sideDrawerRow.spare_required"
                    placeholder="Spare req…"
                    class="w-full h-8 text-xs border border-[#e2e8f0] bg-white px-2 rounded-none text-[#0f172a]"
                  />
                </div>
                <div>
                  <label class="block text-[10px] uppercase tracking-widest text-[#64748b] font-semibold mb-1">Support Needed</label>
                  <input
                    type="text"
                    v-model="sideDrawerRow.support_needed"
                    placeholder="Support…"
                    class="w-full h-8 text-xs border border-[#e2e8f0] bg-white px-2 rounded-none text-[#0f172a]"
                  />
                </div>
                <div>
                  <label class="block text-[10px] uppercase tracking-widest text-[#64748b] font-semibold mb-1">Emp ID</label>
                  <input
                    type="text"
                    v-model="sideDrawerRow.responsible_person_company_id"
                    placeholder="Emp ID…"
                    class="w-full h-8 font-mono text-xs border border-[#e2e8f0] bg-white px-2 rounded-none text-[#0f172a]"
                  />
                </div>
              </div>

              <div>
                <label class="block text-[10px] uppercase tracking-widest text-[#64748b] font-semibold mb-1">Corrective Measurement</label>
                <textarea
                  rows="4"
                  v-model="sideDrawerRow.corrective_measurement"
                  placeholder="Describe corrective action in full…"
                  class="w-full text-xs border border-[#e2e8f0] bg-white p-2 rounded-none text-[#0f172a]"
                ></textarea>
              </div>

              <div class="grid grid-cols-2 gap-3">
                <div>
                  <label class="block text-[10px] uppercase tracking-widest text-[#64748b] font-semibold mb-1">Priority</label>
                  <select
                    v-model="sideDrawerRow.priority"
                    class="w-full h-8 text-xs border border-[#e2e8f0] bg-white font-mono rounded-none text-[#0f172a]"
                  >
                    <option value="A">A</option>
                    <option value="B">B</option>
                    <option value="C">C</option>
                  </select>
                </div>
                <div>
                  <label class="block text-[10px] uppercase tracking-widest text-[#64748b] font-semibold mb-1">Status</label>
                  <select
                    v-model="sideDrawerRow.status"
                    class="w-full h-8 text-xs border border-[#e2e8f0] bg-white rounded-none text-[#0f172a]"
                  >
                    <option value="Pending">Pending</option>
                    <option value="Completed">Completed</option>
                  </select>
                </div>
              </div>
            </div>

            <!-- Read-only display for completed tab -->
            <div v-else class="border-t border-[#e2e8f0] pt-4 space-y-3">
              <div class="grid grid-cols-2 gap-3">
                <div>
                  <label class="block text-[10px] uppercase tracking-widest text-[#64748b] font-semibold mb-1">Target Date</label>
                  <span class="font-mono text-xs text-[#64748b] block h-8 px-2 py-2 border border-[#e2e8f0] bg-[#f1f5f9]/50 rounded-none">
                    {{ sideDrawerRow.target_date_of_completion || '—' }}
                  </span>
                </div>
                <div>
                  <label class="block text-[10px] uppercase tracking-widest text-[#64748b] font-semibold mb-1">Actual Date</label>
                  <span class="font-mono text-xs text-[#64748b] block h-8 px-2 py-2 border border-[#e2e8f0] bg-[#f1f5f9]/50 rounded-none">
                    {{ sideDrawerRow.actual_date_of_completion || '—' }}
                  </span>
                </div>
              </div>

              <div>
                <label class="block text-[10px] uppercase tracking-widest text-[#64748b] font-semibold mb-1">Corrective Measurement</label>
                <p class="text-xs text-[#64748b] p-2 border border-[#e2e8f0] bg-[#f1f5f9]/50 rounded-none min-h-[80px]">
                  {{ sideDrawerRow.corrective_measurement || '—' }}
                </p>
              </div>

              <div class="grid grid-cols-2 gap-3">
                <div>
                  <label class="block text-[10px] uppercase tracking-widest text-[#64748b] font-semibold mb-1">Priority</label>
                  <span
                    :class="[
                      'inline-block px-1.5 py-0.5 text-[10px] font-bold border rounded-none font-mono',
                      sideDrawerRow.priority === 'A' ? 'bg-red-50 text-red-700 border-red-200' :
                      sideDrawerRow.priority === 'B' ? 'bg-amber-50 text-amber-800 border-amber-200' :
                      'bg-slate-100 text-slate-700 border-slate-200'
                    ]"
                  >
                    {{ sideDrawerRow.priority || 'C' }}
                  </span>
                </div>
                <div>
                  <label class="block text-[10px] uppercase tracking-widest text-[#64748b] font-semibold mb-1">Status</label>
                  <span class="inline-block px-2 py-0.5 text-[10px] uppercase font-semibold border rounded-none border-emerald-300 bg-emerald-50 text-emerald-700">
                    Completed
                  </span>
                </div>
              </div>
            </div>
          </div>

          <div class="border-t border-[#e2e8f0] pt-3 flex justify-end gap-2">
            <button
              @click="sideDrawerRow = null"
              class="h-8 px-4 text-xs font-semibold border border-[#e2e8f0] bg-white hover:bg-[#f1f5f9] rounded-none"
            >
              Cancel
            </button>
            <button
              v-if="activeTab === 'pending'"
              @click="saveDrawerChanges"
              class="h-8 px-4 text-xs font-semibold bg-[#007088] text-white rounded-none hover:bg-[#005a6e]"
            >
              Save Changes
            </button>
            <button
              v-else
              @click="sideDrawerRow = null"
              class="h-8 px-4 text-xs font-semibold bg-[#007088] text-white rounded-none hover:bg-[#005a6e]"
            >
              Done
            </button>
          </div>
        </div>
      </div>

      <!-- Save Confirmation Dialog -->
      <div v-if="showSaveConfirm" class="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-xs">
        <div class="bg-white border border-[#e2e8f0] shadow-2xl p-6 max-w-sm w-full">
          <h3 class="text-sm font-bold text-[#0f172a] mb-2">Save Changes</h3>
          <p class="text-xs text-[#64748b] mb-4">
            Are you sure you want to save {{ ActivityStoredata.editedRowIds.length }} edited row(s)?
          </p>
          <div class="flex justify-end gap-2">
            <button
              @click="showSaveConfirm = false"
              class="h-8 px-4 text-xs font-semibold border border-[#e2e8f0] bg-white hover:bg-[#f1f5f9] rounded-none"
            >
              Cancel
            </button>
            <button
              @click="confirmSaveEdit"
              class="h-8 px-4 text-xs font-semibold bg-[#007088] text-white rounded-none hover:bg-[#005a6e]"
            >
              Save
            </button>
          </div>
        </div>
      </div>

      <!-- Unsaved Changes Warning Dialog -->
      <div v-if="showUnsavedWarning" class="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-xs">
        <div class="bg-white border border-[#e2e8f0] shadow-2xl p-6 max-w-sm w-full">
          <h3 class="text-sm font-bold text-[#0f172a] mb-2">Unsaved Changes</h3>
          <p class="text-xs text-[#64748b] mb-4">
            You have {{ ActivityStoredata.editedRowIds.length }} unsaved edit(s). Please save your changes before switching tabs.
          </p>
          <div class="flex justify-end gap-2">
            <button
              @click="cancelTabSwitch"
              class="h-8 px-4 text-xs font-semibold border border-[#e2e8f0] bg-white hover:bg-[#f1f5f9] rounded-none"
            >
              Stay on Pending
            </button>
            <button
              @click="confirmTabSwitch"
              class="h-8 px-4 text-xs font-semibold bg-[#007088] text-white rounded-none hover:bg-[#005a6e]"
            >
              Switch Anyway
            </button>
          </div>
        </div>
      </div>
    </SectionMain>
  </LayoutAuthenticatedSimple>
</template>

<style scoped>
/* Sharp borders and clear datetime picker */
input[type="datetime-local"]::-webkit-calendar-picker-indicator,
input[type="date"]::-webkit-calendar-picker-indicator {
  cursor: pointer;
  opacity: 0.6;
}
input[type="datetime-local"]::-webkit-calendar-picker-indicator:hover,
input[type="date"]::-webkit-calendar-picker-indicator:hover {
  opacity: 1;
}
</style>