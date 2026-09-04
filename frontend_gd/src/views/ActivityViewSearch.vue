<script setup>
import { ref, onMounted, onBeforeMount, watch } from "vue";
import { TabulatorFull as Tabulator } from 'tabulator-tables';
import 'tabulator-tables/dist/css/tabulator.min.css';
import 'tabulator-tables/dist/js/tabulator.min.js';
import { FilterModule } from 'tabulator-tables';

import SectionMain from "@/components/SectionMain.vue";
import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";
import BlurryHorizontalDivider from "@/components/BlurryHorizontalDivider.vue";
import TimePickerFlatEmitter from "@/components/TimePickerFlatEmitter.vue";
import BaseButton from "@/components/BaseButton.vue";
import * as XLSX from 'xlsx';

import Toastify from 'toastify-js';
import 'toastify-js/src/toastify.css';

import { useActivityStore } from '@/stores/ActivityStore'; 
import { useDatabaseName } from '@/stores/DatabaseName'; 
import { coolGray } from "tailwindcss/colors";

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
    clearFilter();
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
        backgroundColor: 'red',
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
      backgroundColor: 'green',
    }).showToast();
  } catch (error) {
    console.error('Error fetching and rendering data:', error);
    Toastify({
      text: 'Error fetching Data.',
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: 'red',
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
    backgroundColor: 'orange',
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
      backgroundColor: 'red',
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
        backgroundColor: 'red',
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
      backgroundColor: 'green',
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
      backgroundColor: 'red',
    }).showToast();
  }
};

const exportData = (tabulatorInstance, fileName) => {
  if (!tabulatorInstance || typeof tabulatorInstance.getData !== 'function') {
    console.error("Invalid Tabulator instance passed to exportData");
    return;
  }

  const data = tabulatorInstance.getData(); // Ensure tabulator is valid
  const ws = XLSX.utils.json_to_sheet(data);
  const wb = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(wb, ws, 'Sheet1');
  XLSX.writeFile(wb, fileName);
};


function showRoutingPopup(e, cell) {
    if (cell && typeof cell.getValue === 'function') {
        const value = cell.getValue();
        // your logic here
        if (confirm(`Are you sure you want to route to the parameter: ${value}?`)) {
    console.log(`Routing to parameter: ${value}`);
    // Add your routing logic here
  }
    } else {
        console.error("Invalid cell object passed to showRoutingPopup");
    }
}


onBeforeMount(async () => {
  let tempEndDate = new Date();
  let tempStartDate = subtractHours(new Date(), 1);

  ActivityStoredata.selectedDates.from = tempStartDate.getTime();
  ActivityStoredata.selectedDates.to = tempEndDate.getTime();
});

onMounted(() => {
  const commonTableOptions = {
    layout: 'fitColumns',
    // responsiveLayout: 'hide',
    
    height: '500px',
    pagination: 'local',
    history:true,
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
      { title: 'ID', field: 'id', headerFilter: 'input',minWidth: 100  },
      { title: 'Location', field: 'location', headerFilter: 'input', minWidth: 400 },
      { title: 'Name', field: 'name', headerFilter: 'input', minWidth: 400 },
      { title: 'Group Name', field: 'group_name', headerFilter: 'input', minWidth: 400 },
      { title: 'Parameter Name', field: 'parameter_name', minWidth: 400, headerFilter: 'input', frozen: true, cellClick: showRoutingPopup },
      { title: 'Axis', field: 'axis_name', headerFilter: 'input', minWidth: 400 },
      { title: 'Date of Identification', field: 'date_of_identification', minWidth: 400 ,headerFilter: 'input' },
      { title: 'Latest Occurrence', field: 'latest_occurrence', headerFilter: 'input' , minWidth: 400},
      { title: 'Recent Value', field: 'recent_value', headerFilter: 'input', minWidth: 400 },
      { title: 'Warning Limit', field: 'warning_limit', headerFilter: 'input' , minWidth: 400},
      { title: 'Critical Limit', field: 'critical_limit', headerFilter: 'input', minWidth: 400 },
      {
        title: 'Days Since Identification',
        field: 'days_since_identification',
        headerFilter: 'input',
        formatter: function(cell) {
          return daysSinceIdentification(cell.getRow());
        }, minWidth: 400
      },
      { title: 'Target Date of Completion', field: 'target_date_of_completion', editor: 'date', headerFilter: 'input', minWidth: 400 ,cellEdited: handleEditChange },
      { title: 'Number of Occurrences', field: 'number_of_occurrences', headerFilter: 'input', minWidth: 400 },
      { title: 'Condition', field: 'condition', headerFilter: 'input', minWidth: 400 },
      { title: 'Corrective Measurements', field: 'corrective_measurement', editor: 'input', headerFilter: 'input', cellEdited: handleEditChange , minWidth: 400},
      { title: 'Spare Part Required', field: 'spare_required', editor: 'input', headerFilter: 'input', cellEdited: handleEditChange , minWidth: 400},
      { title: 'Support Needed', field: 'support_needed', editor: 'input', headerFilter: 'input', cellEdited: handleEditChange , minWidth: 400},
      { title: 'Responsible Person Company ID', field: 'responsible_person_company_id', editor: 'input', headerFilter: 'input', cellEdited: handleEditChange, minWidth: 400 },
      { title: 'Responsible Person Name', field: 'responsible_person_username', headerFilter: 'input', minWidth: 400 },
      {
        title: 'Status',
        field: 'status',
        editor: 'select',
        editorParams: { values: ['Pending', 'Completed'] },
        headerFilter: 'select',
        headerFilterParams: { values: ['Pending', 'Completed'] },
        cellEdited: handleEditChange, minWidth: 400,
      },
      {
        title: 'Priority',
        field: 'priority',
        editor: 'select',
        editorParams: { values: ['A', 'B', 'C'] },
        headerFilter: 'select',
        headerFilterParams: { values: ['A', 'B', 'C'] },
        cellEdited: handleEditChange, minWidth: 400,
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
      { title: 'ID', field: 'id', headerFilter: 'input' },
      { title: 'Location', field: 'location', headerFilter: 'input' },
      { title: 'Name', field: 'name', headerFilter: 'input' },
      { title: 'Group Name', field: 'group_name', headerFilter: 'input' },
      { title: 'Parameter Name', field: 'parameter_name', headerFilter: 'input' },
      { title: 'Axis', field: 'axis_name', headerFilter: 'input' },
      { title: 'Date of Identification', field: 'date_of_identification', headerFilter: 'input' },
      { title: 'Latest Occurrence', field: 'latest_occurrence', headerFilter: 'input' },
      { title: 'Recent Value', field: 'recent_value', headerFilter: 'input' },
      { title: 'Warning Limit', field: 'warning_limit', headerFilter: 'input' },
      { title: 'Critical Limit', field: 'critical_limit', headerFilter: 'input' },
      { title: 'Target Date of Completion', field: 'target_date_of_completion', headerFilter: 'input' },
      { title: 'Actual Date of Completion', field: 'actual_date_of_completion', headerFilter: 'input' },
      { title: 'Number of Occurrences', field: 'number_of_occurrences', headerFilter: 'input' },
      { title: 'Condition', field: 'condition', headerFilter: 'input' },
      { title: 'Corrective Measurements', field: 'corrective_measurement', headerFilter: 'input' },
      { title: 'Spare Part Required', field: 'spare_required', headerFilter: 'input' },
      { title: 'Support Needed', field: 'support_needed', headerFilter: 'input' },
      { title: 'Responsible Person Company ID', field: 'responsible_person_company_id', headerFilter: 'input' },
      { title: 'Responsible Person', field: 'responsible_person_username', headerFilter: 'input' },
      { title: 'Priority', field: 'priority', headerFilter: 'input' },
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
      <div class="container mx-auto flex flex-col space-y-4">
        <BlurryHorizontalDivider class="mb-4" />
        <BlurryHorizontalDivider class="mt-4" />
        
        <div class="grid grid-cols-3 gap-2">
          <div>
            <label class="block mb-2 text-gray-700">From</label>
            <TimePickerFlatEmitter :defaultDatetime="subtractHours(new Date(), 1)" type="from" @date-change="handleFromDateChange" />
          </div>

          <div>
            <label class="block mb-2 text-gray-700">To</label>
            <TimePickerFlatEmitter :defaultDatetime="new Date()" type="to" @date-change="handleToDateChange" />
          </div>

          <div class="mt-8">
            <BaseButton type="submit" color="info" label="Submit" @click="handleQuerySubmit" />
          </div>
        </div>
      
        <BlurryHorizontalDivider class="mt-8"/>

        <div class="auto-refresh-container p-4 mt-4 flex items-center space-x-4"> 
          <label for="auto-toggle" class="mr-2">Auto</label>
          <input type="checkbox" id="auto-toggle" v-model="autoRefresh" class="form-checkbox" />

          <div v-if="autoRefresh" class="flex items-center space-x-2"> 
            <label for="refresh-interval" class="mr-2">Set Interval</label>
            <input type="number" id="refresh-interval" v-model="refreshInterval" class="form-input w-16 px-2 py-1 border border-gray-300 rounded" />
            <button @click="setRefreshInterval" class="bg-blue-500 hover:bg-blue-700 text-white px-3 py-1.5 rounded">Set Interval</button>
          </div>

          <div v-if="autoRefresh" class="flex flex-col ml-6"> 
            <p class="text-sm bg-gray-200 hover:bg-gray-300 border border-gray-400 rounded-md px-3 py-1.5 cursor-pointer">Current filter: {{ currentFilter }}</p>
          </div>
        </div>
      
        <BlurryHorizontalDivider class="mt-8"/>

        <div class="w-full"><h2 class="font-semibold text-3xl font-custom text-yellow-500 mb-8 mt-8">Abnormal Activity Summary</h2></div>
        <div ref="summaryTable" class="tabulator-custom"></div>
        <BlurryHorizontalDivider />
        
        <div class="flex flex-row mt-8 h-8 justify-between items-center">
          <h2 class="font-semibold text-3xl font-custom text-yellow-500">Pending Activity View</h2>
          <div class="flex space-x-2">
            <BaseButton type="button" color="success" label="Save Edited" @click="saveEdit" />
            <BaseButton type="button" color="info" label="Export Data" @click="() => exportData(tabulator.value, 'pending_activities.xlsx')" />
          </div>
        </div>

        <div ref="table" class="tabulator-custom"></div>
        <BlurryHorizontalDivider />
        
        <div class="flex flex-row mt-8 h-8 justify-between items-center">
          <h2 class="font-semibold text-3xl font-custom text-emerald-600">Completed Activity View</h2>
          <BaseButton type="button" color="info" label="Export Data" @click="() => exportData(tabulator2.value, 'completed_activities.xlsx')" />
        </div>
        
        <div ref="table2" class="tabulator-custom"></div>
        <BlurryHorizontalDivider /> 
      </div>
    </SectionMain>
  </LayoutAuthenticatedSimple>
</template>

<style>
@import 'tabulator-tables/dist/css/tabulator.min.css';

.tabulator-custom {
  background-color: #ffffff;
  border: 2px solid #e2e8f0;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.tabulator .tabulator-header {
  background-color: #2c3e50;
  color: #ffffff;
  font-weight: bold;
}

.tabulator .tabulator-header .tabulator-col {
  background-color: #34495e;
  border-right: 1px solid #2c3e50;
}

.tabulator .tabulator-header .tabulator-col:hover {
  background-color: #2c3e50;
}

.tabulator .tabulator-row {
  border-bottom: 1px solid #e2e8f0;
}

.tabulator .tabulator-row:nth-child(even) {
  background-color: #f8fafc;
}

.tabulator .tabulator-row:hover {
  background-color: #e2e8f0;
}

.tabulator .tabulator-row .tabulator-cell {
  padding: 12px;
}

.tabulator .tabulator-footer {
  background-color: #f1f5f9;
  border-top: 1px solid #e2e8f0;
}

.tabulator .tabulator-footer .tabulator-paginator {
  color: #4a5568;
}

.tabulator .tabulator-footer .tabulator-page {
  border: 1px solid #cbd5e0;
  background-color: #ffffff;
  color: #4a5568;
}

.tabulator .tabulator-footer .tabulator-page.active {
  background-color: #3182ce;
  color: #ffffff;
}

.tabulator .tabulator-footer .tabulator-page:not(.disabled):hover {
  background-color: #edf2f7;
}
</style>