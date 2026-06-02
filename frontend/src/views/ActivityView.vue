<script setup>
import { ref, onMounted, onBeforeMount, watch, computed } from "vue";
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

const favoriteViews = ref([]);
const currentViewName = ref('');
const selectedViewName = ref('');
const quickFilterValue = ref('all');
const searchValue = ref('');

// Favorite Views feature
const saveFavoriteView = () => {
  if (currentViewName.value) {
    const newView = {
      name: currentViewName.value,
      config: {
        filters: tabulator.value.getFilters(),
        sort: tabulator.value.getSorters(),
        columns: tabulator.value.getColumns().map(column => ({
          field: column.getField(),
          visible: column.isVisible(),
          width: column.getWidth()
        }))
      }
    };
    favoriteViews.value.push(newView);
    localStorage.setItem('favoriteViews', JSON.stringify(favoriteViews.value));
    currentViewName.value = '';
    selectedViewName.value = newView.name;
    Toastify({
      text: 'View saved successfully!',
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: '#4CAF50',
    }).showToast();
  }
};

const loadFavoriteView = (viewName) => {
  const view = favoriteViews.value.find(v => v.name === viewName);
  if (view) {
    tabulator.value.clearFilter();
    tabulator.value.setFilter(view.config.filters);
    tabulator.value.setSort(view.config.sort);
    view.config.columns.forEach(column => {
      const tabulatorColumn = tabulator.value.getColumn(column.field);
      if (tabulatorColumn) {
        tabulatorColumn.show(column.visible);
        tabulatorColumn.setWidth(column.width);
      }
    });
    selectedViewName.value = viewName;
    Toastify({
      text: `Loaded view: ${viewName}`,
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: '#2196F3',
    }).showToast();
  }
};
// Quick filter feature
const applyQuickFilter = () => {
  tabulator.value.clearFilter();
  if (quickFilterValue.value !== 'all') {
    tabulator.value.setFilter('priority', '=', quickFilterValue.value);
  }
};

// Search feature
const applySearch = () => {
  tabulator.value.setFilter([
    [
      {field: 'name', type: 'like', value: searchValue.value},
      {field: 'group_name', type: 'like', value: searchValue.value},
      {field: 'parameter_name', type: 'like', value: searchValue.value},
    ]
  ]);
};

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
    rowFormatter: function(row) {
      let priorityValue = row.getData().priority;
      let colors = {
        "A": "#FFCCCB",
        "B": "#FFFFD1",
        "C": "#E6F3FF"
      };
      if (colors.hasOwnProperty(priorityValue)) {
        row.getElement().style.backgroundColor = colors[priorityValue];
      }
    },
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
      { title: 'Name', field: 'name', headerFilter: 'input', width: 200 },
      { title: 'Group Name', field: 'group_name', headerFilter: 'input', width: 300 },
      { title: 'Parameter Name', field: 'parameter_name', width: 400, headerFilter: 'input', frozen: true, cellClick: showRoutingPopup },
      { title: 'Axis', field: 'axis_name', headerFilter: 'input', width: 100 },
      { title: 'Date of Identification', field: 'date_of_identification', width: 300, headerFilter: 'input' },
      { title: 'Latest Occurrence', field: 'latest_occurrence', headerFilter: 'input', width: 300 },
      { title: 'Recent Value', field: 'recent_value', headerFilter: 'input', width: 300 },
      { title: 'Warning Limit', field: 'warning_limit', headerFilter: 'input', width: 300 },
      { title: 'Critical Limit', field: 'critical_limit', headerFilter: 'input', width: 300 },
      {
        title: 'Days Since Identification',
        field: 'days_since_identification',
        headerFilter: 'input',
        formatter: function(cell) {
          return daysSinceIdentification(cell.getRow());
        },
        width: 300
      },
      { title: 'Target Date of Completion', field: 'target_date_of_completion', editor: 'date', headerFilter: 'input', width: 300, cellEdited: handleEditChange },
      { title: 'Number of Occurrences', field: 'number_of_occurrences', headerFilter: 'input', width: 300 },
      { title: 'Condition', field: 'condition', headerFilter: 'input', width: 300 },
      { title: 'Corrective Measurements', field: 'corrective_measurement', editor: 'input', headerFilter: 'input', cellEdited: handleEditChange, width: 200 },
      { title: 'Spare Part Required', field: 'spare_required', editor: 'input', headerFilter: 'input', cellEdited: handleEditChange, width: 300 },
      { title: 'Support Needed', field: 'support_needed', editor: 'input', headerFilter: 'input', cellEdited: handleEditChange, width: 300 },
      { title: 'Responsible Person Company ID', field: 'responsible_person_company_id', editor: 'input', headerFilter: 'input', cellEdited: handleEditChange, width: 300 },
      { title: 'Responsible Person Name', field: 'responsible_person_username', headerFilter: 'input', width: 300 },
      {
        title: 'Status',
        field: 'status',
        editor: 'select',
        editorParams: { values: ['Pending', 'Completed'] },
        headerFilter: 'select',
        headerFilterParams: { values: ['Pending', 'Completed'] },
        cellEdited: handleEditChange,
        width: 300,
      },
      {
        title: 'Priority',
        field: 'priority',
        editor: 'select',
        editorParams: { values: ['A', 'B', 'C'] },
        headerFilter: 'select',
        headerFilterParams: { values: ['A', 'B', 'C'] },
        cellEdited: handleEditChange,
        width: 300,
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

  const savedViews = localStorage.getItem('favoriteViews');
  if (savedViews) {
    favoriteViews.value = JSON.parse(savedViews);
  }

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
  <LayoutAuthenticatedSimple class="font-custom bg-gray-100">
    <SectionMain>
      <div class="container mx-auto px-4 py-8">
        <h1 class="text-4xl font-bold text-gray-800 mb-8">Activity View</h1>
        <!-- Favorite Views feature -->
        <!-- <div class="bg-white shadow-lg rounded-lg p-6 mb-8">
          <h2 class="text-2xl font-semibold text-gray-700 mb-4">Favorite Views</h2>
          <div class="flex flex-wrap items-center gap-4">
            <input v-model="currentViewName" type="text" placeholder="View name" class="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" />
            <BaseButton @click="saveFavoriteView" color="primary" label="Save Current View" class="bg-green-500 hover:bg-green-600 text-white font-bold py-2 px-4 rounded-lg transition duration-300 ease-in-out" />
            <select @change="loadFavoriteView($event.target.value)" class="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
              <option value="">Load a view</option>
              <option v-for="view in favoriteViews" :key="view.name" :value="view">{{ view.name }}</option>
            </select>
          </div>
        </div> -->

        <!-- Quick filter and search for Pending Activity View -->
        <div class="mb-6 flex flex-wrap items-center gap-4">
          <select v-model="quickFilterValue" @change="applyQuickFilter" class="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
            <option value="all">All Priorities</option>
            <option value="A">Priority A</option>
            <option value="B">Priority B</option>
            <option value="C">Priority C</option>
          </select>
          <div class="flex-1 relative">
            <input v-model="searchValue" @input="applySearch" type="text" placeholder="Search..." class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 pl-10" />
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
          </div>
        </div>

        
        <div class="bg-white shadow-lg rounded-lg p-6 mb-8">
          <h2 class="text-2xl font-semibold text-gray-700 mb-4">Date Range Selection</h2>
          <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">From</label>
              <TimePickerFlatEmitter :defaultDatetime="subtractHours(new Date(), 1)" type="from" @date-change="handleFromDateChange" class="w-full" />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">To</label>
              <TimePickerFlatEmitter :defaultDatetime="new Date()" type="to" @date-change="handleToDateChange" class="w-full" />
            </div>
            <div class="flex items-end">
              <BaseButton type="submit" color="primary" label="Submit" @click="handleQuerySubmit" class="w-full bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded-lg transition duration-300 ease-in-out transform hover:scale-105" />
            </div>
          </div>
        </div>

        <div class="bg-white shadow-lg rounded-lg p-6 mb-8">
          <h2 class="text-2xl font-semibold text-gray-700 mb-4">Auto Refresh Settings</h2>
          <div class="flex flex-wrap items-center gap-6">
            <label for="auto-toggle" class="flex items-center cursor-pointer">
              <div class="relative">
                <input type="checkbox" id="auto-toggle" v-model="autoRefresh" class="sr-only" />
                <div class="w-14 h-7 bg-gray-300 rounded-full shadow-inner"></div>
                <div class="dot absolute w-7 h-7 bg-white rounded-full shadow transition-transform duration-300 ease-in-out" :class="{ 'translate-x-7': autoRefresh }"></div>
              </div>
              <div class="ml-3 text-gray-700 font-medium">
                Auto Refresh
              </div>
            </label>

            <div v-if="autoRefresh" class="flex items-center space-x-2">
              <label for="refresh-interval" class="text-sm font-medium text-gray-700">Interval (seconds)</label>
              <input type="number" id="refresh-interval" v-model="refreshInterval" class="form-input w-20 px-2 py-1 text-sm border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500" />
              <BaseButton @click="setRefreshInterval" color="secondary" label="Set" class="bg-gray-500 hover:bg-gray-600 text-white font-bold py-1 px-3 rounded-md transition duration-300 ease-in-out" />
            </div>

            <div v-if="autoRefresh" class="flex items-center">
              <span class="text-sm font-medium text-gray-700 mr-2">Current filter:</span>
              <span class="text-sm bg-blue-100 text-blue-800 py-1 px-3 rounded-full font-semibold">{{ currentFilter }}</span>
            </div>
          </div>
        </div>

        <div class="mb-12">
          <h2 class="text-3xl font-semibold text-yellow-600 mb-6">Abnormal Activity Summary</h2>
          <div ref="summaryTable" class="tabulator-custom"></div>
        </div>

        <div class="mb-12">
          <div class="flex justify-between items-center mb-6">
            <h2 class="text-3xl font-semibold text-yellow-600">Pending Activity View</h2>
            <div class="space-x-4">
              <BaseButton type="button" color="success" label="Save Edited" @click="saveEdit" class="bg-green-500 hover:bg-green-600 text-white font-bold py-2 px-4 rounded-lg transition duration-300 ease-in-out transform hover:scale-105" />
              <BaseButton type="button" color="info" label="Export Data" @click="() => exportData(tabulator, 'pending_activities.xlsx')" class="bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded-lg transition duration-300 ease-in-out transform hover:scale-105" />
            </div>
          </div>
          <div ref="table" class="tabulator-custom"></div>
        </div>

        <div class="mb-12">
          <div class="flex justify-between items-center mb-6">
            <h2 class="text-3xl font-semibold text-green-600">Completed Activity View</h2>
            <BaseButton type="button" color="info" label="Export Data" @click="() => exportData(tabulator2, 'completed_activities.xlsx')" class="bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded-lg transition duration-300 ease-in-out transform hover:scale-105" />
          </div>
          <div ref="table2" class="tabulator-custom"></div>
        </div>
      </div>
    </SectionMain>
  </LayoutAuthenticatedSimple>
</template>

<style>
@import 'tabulator-tables/dist/css/tabulator.min.css';

.tabulator-custom {
  @apply bg-white border border-gray-200 rounded-lg overflow-hidden shadow-md;
}

.tabulator .tabulator-header {
  @apply bg-gray-100 text-gray-700 font-semibold  ;
}

.tabulator .tabulator-header .tabulator-col {
  @apply bg-gray-100 border-r border-gray-200 p-4 text-sm;
}

.tabulator .tabulator-header .tabulator-col:hover {
  @apply bg-gray-200 transition-colors duration-200;
}

.tabulator .tabulator-row {
  @apply border-b border-gray-100 transition-colors duration-200;
}

.tabulator .tabulator-row:nth-child(even) {
  @apply bg-gray-50;
}

.tabulator .tabulator-row:hover {
  @apply bg-blue-50;
}

.tabulator .tabulator-row .tabulator-cell {
  @apply p-3;
}

.tabulator .tabulator-footer {
  @apply bg-gray-100 border-t border-gray-200 p-2;
}

.tabulator .tabulator-footer .tabulator-paginator {
  @apply text-gray-700 flex justify-between items-center;
}

.tabulator .tabulator-footer .tabulator-page {
  @apply border border-gray-300 bg-white text-gray-700 px-3 py-1 rounded-md mx-1 transition-colors duration-200;
}

.tabulator .tabulator-footer .tabulator-page.active {
  @apply bg-blue-500 text-white;
}

.tabulator .tabulator-footer .tabulator-page:not(.disabled):hover {
  @apply bg-gray-100;
}

.tabulator .tabulator-header .tabulator-header-filter input {
  @apply w-full p-2 text-sm bg-gray-300 text-gray-800 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200;
}

.favorite-views-container {
  @apply flex flex-wrap items-center gap-4 mb-4;
}

.favorite-views-input {
  @apply px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500;
}

.quick-filter-select {
  @apply px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500;
}

.search-input {
  @apply w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 pl-10;
}

.search-icon {
  @apply h-5 w-5 absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400;
}

/* Responsive adjustments */
@media (max-width: 640px) {
  .tabulator .tabulator-header .tabulator-col {
    @apply p-2;
  }
  
  .tabulator .tabulator-row .tabulator-cell {
    @apply p-2;
  }
}

/* Toggle button styles */
.dot {
  top: -0.20rem;
  left: -0.20rem;
  transition: all 0.3s ease-in-out;
}

input:checked ~ .dot {
  transform: translateX(100%);
  background-color: #48bb78;
}
</style>