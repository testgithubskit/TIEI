<script setup>
import { ref, onMounted, onBeforeMount, watch } from "vue";
import { TabulatorFull as Tabulator } from 'tabulator-tables';
import 'tabulator-tables/dist/css/tabulator.min.css';
import SectionMain from "@/components/SectionMain.vue";
import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";
import TimePickerFlatEmitter from "@/components/TimePickerFlatEmitter.vue";
import BaseButton from "@/components/BaseButton.vue";
import * as XLSX from 'xlsx';
import Toastify from 'toastify-js';
import 'toastify-js/src/toastify.css';
import { useActivityStore } from '@/stores/ActivityStore'; 
import { useDatabaseName } from '@/stores/DatabaseName'; 

import { useRouter } from 'vue-router';
const router = useRouter();


// State variables
const autoRefresh = ref(false);

const refreshInterval = ref(10);
const currentFilter = ref('BLOCK');
let refreshTimer;

const ActivityStoredata = useActivityStore();
const DatabaseName = useDatabaseName();

const summaryTable = ref(null);
const summaryTabulator = ref(null);
const table = ref(null);
const tabulator = ref(null);
const table2 = ref(null);
const tabulator2 = ref(null);


import { useMachineSamplingWithLimitsStore } from '@/stores/MachineSamplingWithLimitsStore'; 
const machineSamplingWithLimitsStore = useMachineSamplingWithLimitsStore();

// Function to set the auto-refresh interval
const setRefreshInterval = () => {
  console.log(`Auto-refresh rate set to ${refreshInterval.value} seconds`);
  cancelAutoRefresh();
  startAutoRefresh();
};

// Function to simulate auto-refresh
const startAutoRefresh = () => {
  refreshTimer = setInterval(() => {
    switch (currentFilter.value) {
      case 'BLOCK':
        currentFilter.value = 'CRANK';
        tabulator.value.setFilter('location', 'like', 'CRANK');
        break;
      case 'CRANK':
        currentFilter.value = 'HEAD';
        tabulator.value.setFilter('location', 'like', 'HEAD');
        break;
      case 'HEAD': 
        currentFilter.value = 'BLOCK'; 
        tabulator.value.setFilter('location', 'like', 'BLOCK');
        break;
      default: 
        currentFilter.value = 'BLOCK'; 
        tabulator.value.setFilter('location', 'like', 'BLOCK');
    }
    console.log(`Auto-refreshed. Current filter: ${currentFilter.value}`);
  }, refreshInterval.value * 1000);
};

// Function to cancel auto-refresh
const cancelAutoRefresh = () => {
  if (refreshTimer) {
    clearInterval(refreshTimer);
    console.log('Auto-refresh canceled');
    refreshTimer = null;
  } else {
    console.log('No active auto-refresh timer to cancel');
  }
};

function subtractHours(date, hours) {
  date.setHours(date.getHours() - hours);
  return date;
};

const handleFromDateChange = (dateValue) => {
  ActivityStoredata.selectedDates.from = dateValue.value;
};

const handleToDateChange = (dateValue) => {
  ActivityStoredata.selectedDates.to = dateValue.value;
};

const daysSinceIdentification = (row) => {
  const identificationDate = new Date(row.getData().date_of_identification);
  const currentDate = new Date();
  const timeDifference = currentDate.getTime() - identificationDate.getTime();
  const daysElapsed = Math.floor(timeDifference / (1000 * 3600 * 24));
  return daysElapsed;
};

const handleQuerySubmit = async () => {
  try {
    if (new Date(ActivityStoredata.selectedDates.to) < new Date(ActivityStoredata.selectedDates.from)) {
      Toastify({
        text: 'Please enter a valid date range.',
        duration: 3000,
        close: true,
        gravity: 'bottom',
        position: 'right',
        backgroundColor: '#ff4d4f',
      }).showToast();
      return;
    }

    await ActivityStoredata.fetchActivityData();

    tabulator.value.setData(ActivityStoredata.pendingData);
    tabulator2.value.setData(ActivityStoredata.completedData);
    summaryTabulator.value.setData(ActivityStoredata.abnormalitySummary);
    Toastify({
      text: 'Data Fetched Successfully.',
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: '#52c41a',
    }).showToast();
  } catch (error) {
    console.error('Error fetching and rendering data:', error);
    Toastify({
      text: 'Error fetching Data.',
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: '#ff4d4f',
    }).showToast();
  }
};

const handleEditChange = (cell) => {
  const editedRow = cell.getRow().getData();
  const editedRowId = editedRow.id;
  ActivityStoredata.saveEditedRowIds(editedRowId);
  
  Toastify({
    text: 'Please save after editing',
    duration: 3000,
    close: true,
    gravity: 'bottom',
    position: 'right',
    backgroundColor: '#faad14',
  }).showToast();
};

const saveEdit = async () => {
  if (ActivityStoredata.editedRowIds.length === 0) {
    Toastify({
      text: 'No Changes to Save',
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: '#ff4d4f',
    }).showToast();
    return;
  }

  try {
    const editNewData = tabulator.value.getData();
    const editedRowsData = editNewData.filter(row => ActivityStoredata.editedRowIds.includes(row.id));

    const incompleteRows = editedRowsData.filter(row => {
      return row.status === 'Completed' && (!row.target_date_of_completion || !row.responsible_person_company_id);
    });

    if (incompleteRows.length > 0) {
      Toastify({
        text: 'Please enter values for Target Date of Completion or Responsible Person Company ID for rows marked as Completed.',
        duration: 5000,
        close: true,
        gravity: 'bottom',
        position: 'right',
        backgroundColor: '#ff4d4f',
      }).showToast();
      return;
    }

    editedRowsData.forEach(row => {
      for (const [key, value] of Object.entries(row)) {
        if (value === null && key !== 'target_date_of_completion' && key !== 'responsible_person_company_id') {
          row[key] = '-';
        }
        if (value === "" && key == 'priority' ) {
          row[key] = 'C';
        }
      }
    });

    await ActivityStoredata.sendEdit(editedRowsData);

    ActivityStoredata.editedRowIds = [];

    Toastify({
      text: 'Changes saved successfully!',
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: '#52c41a',
    }).showToast();

    await handleQuerySubmit();
  } catch (error) {
    console.error('Error saving edited data:', error);

    Toastify({
      text: 'Error saving changes. Please try again.',
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: '#ff4d4f',
    }).showToast();
  }
};

const exportData = (tabulatorInstance, fileName) => {
  if (!tabulatorInstance || !tabulatorInstance.getData) {
    console.error("Invalid Tabulator instance passed to exportData");
    return;
  }

  const data = tabulatorInstance.getData();
  const ws = XLSX.utils.json_to_sheet(data);
  const wb = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(wb, ws, 'Sheet1');
  XLSX.writeFile(wb, fileName);
};

function showRoutingPopup(e, cell) {
  if (cell && typeof cell.getValue === 'function') {
    const value = cell.getValue();
    if (confirm(`Are you sure you want to route to the parameter: ${value}?`)) {
      console.log(`Routing to parameter: ${value}`);
      // Add your routing logic here

      machineSamplingWithLimitsStore.machine = cell.getData().name
  machineSamplingWithLimitsStore.actualParameterName = cell.getData().parameter_name;

  machineSamplingWithLimitsStore.parameterGroup = cell.getData().group_name;
      router.push('/machine-level-sampling');
    }
  } else {
    console.error("Invalid cell object passed to showRoutingPopup");
  }
  // console.log(cell.getData().parameter_name)
  // console.log(cell.getData().name)
  // console.log(cell.getData().group_name)
}



// const handleMachineParameterClick = async (clickedParameter) => {
//   // Perform any necessary actions with the updated parameters
//   machineSamplingWithLimitsStore.machine = clickedParameter.machineName;
//   machineSamplingWithLimitsStore.actualParameterName = clickedParameter.actualParameterName;;

//   machineSamplingWithLimitsStore.parameterGroup = factoryPollOverviewGridStore.SelectedParmeter.item_name;

//   machineSamplingWithLimitsStore.refreshTimestamp();
//   await machineSamplingWithLimitsStore.fetchMachineParameterData();
//   router.push('/machine-level-sampling');
// };

onBeforeMount(async () => {
  let tempEndDate = new Date();
  let tempStartDate = subtractHours(new Date(), 1);

  ActivityStoredata.selectedDates.from = tempStartDate.getTime();
  ActivityStoredata.selectedDates.to = tempEndDate.getTime();
});

onMounted(() => {
  const commonTableOptions = {
    layout: 'fitColumns',
    height: '500px',
    pagination: 'local',
    paginationSize: 10,
    paginationSizeSelector: [10, 25, 50, 100],
    movableColumns: true,
    resizableColumns: true,
    initialSort: [{ column: 'date_of_identification', dir: 'desc' }],
  };

  summaryTabulator.value = new Tabulator(summaryTable.value, {
    ...commonTableOptions,
    data: ActivityStoredata.abnormalitySummary,
    columns: [
      { title: 'Line', field: 'line', headerFilter: 'input' },
      { title: 'Warning', field: 'WARNING', headerFilter: 'input' },
      { title: 'Critical', field: 'CRITICAL', headerFilter: 'input' },
      { title: 'Completed', field: 'COMPLETED', headerFilter: 'input' },
    ],
  });

  tabulator.value = new Tabulator(table.value, {
    ...commonTableOptions,
    data: ActivityStoredata.pendingData,
    columns: [
      { title: 'ID', field: 'id', headerFilter: 'input', width: 80 },
      { title: 'Location', field: 'location', headerFilter: 'input', width: 150 },
      { title: 'Name', field: 'name', headerFilter: 'input', width: 150 },
      { title: 'Group Name', field: 'group_name', headerFilter: 'input', width: 150 },
      { title: 'Parameter Name', field: 'parameter_name', width: 400, headerFilter: 'input', frozen: true, cellClick: showRoutingPopup },
      { title: 'Axis', field: 'axis_name', headerFilter: 'input', width: 100 },
      { title: 'Date of Identification', field: 'date_of_identification', width: 150, headerFilter: 'input' },
      { title: 'Latest Occurrence', field: 'latest_occurrence', headerFilter: 'input', width: 150 },
      { title: 'Recent Value', field: 'recent_value', headerFilter: 'input', width: 120 },
      { title: 'Warning Limit', field: 'warning_limit', headerFilter: 'input', width: 120 },
      { title: 'Critical Limit', field: 'critical_limit', headerFilter: 'input', width: 120 },
      {
        title: 'Days Since Identification',
        field: 'days_since_identification',
        headerFilter: 'input',
        formatter: function(cell) {
          return daysSinceIdentification(cell.getRow());
        },
        width: 180
      },
      { title: 'Target Date of Completion', field: 'target_date_of_completion', editor: 'date', headerFilter: 'input', width: 180, cellEdited: handleEditChange },
      { title: 'Number of Occurrences', field: 'number_of_occurrences', headerFilter: 'input', width: 180 },
      { title: 'Condition', field: 'condition', headerFilter: 'input', width: 120 },
      { title: 'Corrective Measurements', field: 'corrective_measurement', editor: 'input', headerFilter: 'input', cellEdited: handleEditChange, width: 200 },
      { title: 'Spare Part Required', field: 'spare_required', editor: 'input', headerFilter: 'input', cellEdited: handleEditChange, width: 150 },
      { title: 'Support Needed', field: 'support_needed', editor: 'input', headerFilter: 'input', cellEdited: handleEditChange, width: 150 },
      { title: 'Responsible Person Company ID', field: 'responsible_person_company_id', editor: 'input', headerFilter: 'input', cellEdited: handleEditChange, width: 250 },
      { title: 'Responsible Person Name', field: 'responsible_person_username', headerFilter: 'input', width: 200 },
      {
        title: 'Status',
        field: 'status',
        editor: 'select',
        editorParams: { values: ['Pending', 'Completed'] },
        headerFilter: 'select',
        headerFilterParams: { values: ['Pending', 'Completed'] },
        cellEdited: handleEditChange,
        width: 120,
      },
      {
        title: 'Priority',
        field: 'priority',
        editor: 'select',
        editorParams: { values: ['A', 'B', 'C'] },
        headerFilter: 'select',
        headerFilterParams: { values: ['A', 'B', 'C'] },
        cellEdited: handleEditChange,
        width: 100,
      },
    ],
    rowFormatter: function(row) {
      let priorityValue = row.getData().priority;
      let colors = {
        "A": "#FFCCCB",
        "B": "#FFFFD1"
      };
      if (colors.hasOwnProperty(priorityValue)) {
        row.getElement().style.backgroundColor = colors[priorityValue];
      }
    },
  });

  tabulator2.value = new Tabulator(table2.value, {
    ...commonTableOptions,
    data: ActivityStoredata.completedData,
    columns: [
      { title: 'ID', field: 'id', headerFilter: 'input', width: 80 },
      { title: 'Location', field: 'location', headerFilter: 'input', width: 150 },
      { title: 'Name', field: 'name', headerFilter: 'input', width: 150 },
      { title: 'Group Name', field: 'group_name', headerFilter: 'input', width: 150 },
      { title: 'Parameter Name', field: 'parameter_name', headerFilter: 'input', width: 200 },
      { title: 'Axis', field: 'axis_name', headerFilter: 'input', width: 100 },
      { title: 'Date of Identification', field: 'date_of_identification', headerFilter: 'input', width: 150 },
      { title: 'Latest Occurrence', field: 'latest_occurrence', headerFilter: 'input', width: 150 },
      { title: 'Recent Value', field: 'recent_value', headerFilter: 'input', width: 120 },
      { title: 'Warning Limit', field: 'warning_limit', headerFilter: 'input', width: 120 },
      { title: 'Critical Limit', field: 'critical_limit', headerFilter: 'input', width: 120 },
      { title: 'Target Date of Completion', field: 'target_date_of_completion', headerFilter: 'input', width: 180 },
      { title: 'Actual Date of Completion', field: 'actual_date_of_completion', headerFilter: 'input', width: 180 },
      { title: 'Number of Occurrences', field: 'number_of_occurrences', headerFilter: 'input', width: 180 },
      { title: 'Condition', field: 'condition', headerFilter: 'input', width: 120 },
      { title: 'Corrective Measurements', field: 'corrective_measurement', headerFilter: 'input', width: 200 },
      { title: 'Spare Part Required', field: 'spare_required', headerFilter: 'input', width: 150 },
      { title: 'Support Needed', field: 'support_needed', headerFilter: 'input', width: 150 },
      { title: 'Responsible Person Company ID', field: 'responsible_person_company_id', headerFilter: 'input', width: 250 },
      { title: 'Responsible Person', field: 'responsible_person_username', headerFilter: 'input', width: 200 },
      { title: 'Priority', field: 'priority', headerFilter: 'input', width: 100 },
    ],
  });

  // Initial data load
  tabulator.value.setData(ActivityStoredata.pendingData);
  tabulator2.value.setData(ActivityStoredata.completedData);
  summaryTabulator.value.setData(ActivityStoredata.abnormalitySummary);
});

// Watch for changes in autoRefresh
watch(autoRefresh, (newValue) => {
  if (newValue) {
    startAutoRefresh();
  } else {
    cancelAutoRefresh();
  }
});
</script>

<template>
  <LayoutAuthenticatedSimple class="font-custom">
    <SectionMain>
      <div class="container mx-auto px-4 py-8">
        <h1 class="text-3xl font-bold text-gray-800 mb-8">Activity View</h1>
        
        <div class="bg-white shadow-md rounded-lg p-6 mb-8">
          <h2 class="text-xl font-semibold text-gray-700 mb-4">Date Range Selection</h2>
          <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">From</label>
              <TimePickerFlatEmitter :defaultDatetime="subtractHours(new Date(), 1)" type="from" @date-change="handleFromDateChange" class="w-full" />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">To</label>
              <TimePickerFlatEmitter :defaultDatetime="new Date()" type="to" @date-change="handleToDateChange" class="w-full" />
            </div>
            <div class="flex items-end">
              <BaseButton type="submit" color="primary" label="Submit" @click="handleQuerySubmit" class="w-full bg-emerald-300 font-custom shadow-lg rounded-lg font-bold border-2 border-emerald-400 hover:scale-105 transition-all hover:text-warning-50 " />
            </div>
          </div>
        </div>

        <div class="bg-white shadow-md rounded-lg p-6 mb-8">
          <h2 class="text-xl font-semibold text-gray-700 mb-4">Auto Refresh Settings</h2>
          <div class="flex items-center space-x-4">
            <label for="auto-toggle" class="flex items-center cursor-pointer">
              <div class="relative">
                <input type="checkbox" id="auto-toggle" v-model="autoRefresh" class="sr-only" />
                <div class="w-10 h-4 bg-gray-400 rounded-full shadow-inner"></div>
                <div class="dot absolute w-6 h-6 bg-white rounded-full shadow -left-1 -top-1 transition"></div>
              </div>
              <div class="ml-3 text-gray-700 font-medium">
                Auto Refresh
              </div>
            </label>

            <div v-if="autoRefresh" class="flex items-center space-x-2">
              <label for="refresh-interval" class="text-sm font-medium text-gray-700">Interval (seconds)</label>
              <input type="number" id="refresh-interval" v-model="refreshInterval" class="form-input w-16 px-2 py-1 text-sm border border-gray-300 rounded" />
              <BaseButton @click="setRefreshInterval" color="secondary" label="Set" class="text-sm" />
            </div>

            <div v-if="autoRefresh" class="flex items-center ml-4">
              <span class="text-sm font-medium text-gray-700 mr-2">Current filter:</span>
              <span class="text-sm bg-gray-100 text-gray-800 py-1 px-2 rounded">{{ currentFilter }}</span>
            </div>
          </div>
        </div>

        <div class="mb-8">
          <h2 class="text-2xl font-semibold text-yellow-600 mb-4">Abnormal Activity Summary</h2>
          <div ref="summaryTable" class="tabulator-custom font-custom"></div>
        </div>

        <div class="mb-8">
          <div class="flex justify-between items-center mb-4">
            <h2 class="text-2xl font-semibold text-yellow-600">Pending Activity View</h2>
            <div class="space-x-2">
              <BaseButton type="button" color="success" label="Save Edited" @click="saveEdit" />
              <BaseButton type="button" color="info" label="Export Data" @click="() => exportData(tabulator, 'pending_activities.xlsx')" />
            </div>
          </div>
          <div ref="table" class="tabulator-custom font-custom "></div>
        </div>

        <div class="mb-8">
          <div class="flex justify-between items-center mb-4">
            <h2 class="text-2xl font-semibold text-green-600">Completed Activity View</h2>
            <BaseButton type="button" color="info" label="Export Data" @click="() => exportData(tabulator2, 'completed_activities.xlsx')" />
          </div>
          <div ref="table2" class="tabulator-custom font-custom"></div>
        </div>
      </div>
    </SectionMain>
  </LayoutAuthenticatedSimple>
</template>

<style>
@import 'tabulator-tables/dist/css/tabulator.min.css';

.tabulator-custom {
  @apply bg-white border border-gray-200 rounded-lg overflow-hidden shadow-sm    ;
 
}

.tabulator .tabulator-header {
  @apply bg-gray-100 text-gray-700 font-semibold   ;
}

.tabulator .tabulator-header .tabulator-col {
  @apply bg-gray-100 border-r border-gray-200 items-center p-4 ;
}


.tabulator .tabulator-header .tabulator-col:hover {
  @apply bg-gray-200;
}

.tabulator .tabulator-row {
  @apply border-b border-gray-100;
}

.tabulator .tabulator-row:nth-child(even) {
  @apply bg-gray-50;
}

.tabulator .tabulator-row:hover {
  @apply bg-gray-100;
}

.tabulator .tabulator-row .tabulator-cell {
  @apply p-2;
}

.tabulator .tabulator-footer {
  @apply bg-gray-100 border-t border-gray-200;
}

.tabulator .tabulator-footer .tabulator-paginator {
  @apply text-gray-700;
}

.tabulator .tabulator-footer .tabulator-page {
  @apply border border-gray-300 bg-white text-gray-700;
}

.tabulator .tabulator-footer .tabulator-page.active {
  @apply bg-blue-500 text-white;
}

.tabulator .tabulator-footer .tabulator-page:not(.disabled):hover {
  @apply bg-gray-100;
}

/* .tabulator .tabulator-header .tabulator-header-filter{
  @apply  mt-2  items-center justify-center gap-2
} */

.tabulator .tabulator-header .tabulator-header-filter input {
  @apply w-full p-1 text-sm text-slate-800 border border-gray-300 rounded ;
}

/* Toggle button styles */
.dot {
  top: -0.25rem;
  left: -0.25rem;
  transition: all 0.3s ease-in-out;
}

input:checked ~ .dot {
  transform: translateX(100%);
  background-color: #48bb78;
}

</style>