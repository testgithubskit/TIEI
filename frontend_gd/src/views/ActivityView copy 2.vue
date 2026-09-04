<script setup>
import { ref, onMounted,onBeforeMount, watch} from "vue";
import { TabulatorFull as Tabulator } from 'tabulator-tables';
import 'tabulator-tables/dist/css/tabulator.min.css';
import 'tabulator-tables/dist/js/tabulator.min.js';
import {FilterModule} from 'tabulator-tables';

import SectionMain from "@/components/SectionMain.vue";
import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";
import BlurryHorizontalDivider from "@/components/BlurryHorizontalDivider.vue";
import TimePickerFlatEmitter from "@/components/TimePickerFlatEmitter.vue";
import BaseButton from "@/components/BaseButton.vue";

import Toastify from 'toastify-js';
import 'toastify-js/src/toastify.css';


import { useActivityStore } from '@/stores/ActivityStore'; 

// State variables
const autoRefresh = ref(false);
const refreshInterval = ref(10); // Default refresh interval in seconds
const currentFilter = ref('BLOCK'); // Initial filter value
let refreshTimer;

// Function to set the auto-refresh interval
const setRefreshInterval = () => {
  // Perform any validation or additional logic if needed
  console.log(`Auto-refresh rate set to ${refreshInterval.value} seconds`);

  // Clear any existing timer before starting a new one
  cancelAutoRefresh();

  // Start auto-refresh logic (to be implemented)
  startAutoRefresh();
};


// Function to simulate auto-refresh
const startAutoRefresh = () => {
  console.log("inside start auto");
  refreshTimer = setInterval(() => {
    // Change filter value based on your logic
    switch (currentFilter.value) {
      case 'BLOCK':
        currentFilter.value = 'CRANK';
        tabulator.value.setFilter('location', 'like', 'CRANK');
        console.log("Filtered");
        break;
      case 'CRANK':
        currentFilter.value = 'HEAD';
        tabulator.value.setFilter('location', 'like', 'HEAD');
        console.log("Filtered");
        break;
      case 'HEAD': 
        currentFilter.value = 'BLOCK'; 
        tabulator.value.setFilter('location', 'like', 'BLOCK');
        console.log("Filtered");
        break;
      default: 
        // This shouldn't be needed with the new logic,
        // but you can leave it as a safeguard        
        currentFilter.value = 'BLOCK'; 
        tabulator.value.setFilter('location', 'like', 'BLOCK');
        console.log("Filtered"); 
    }
    console.log(`Auto-refreshed. Current filter: ${currentFilter.value}`);
  }, refreshInterval.value * 1000); // Convert seconds to milliseconds
};



// Function to cancel auto-refresh
const cancelAutoRefresh = () => {
  if (refreshTimer) { // Check if a timer actually exists
    console.log(refreshTimer); 
    clearInterval(refreshTimer);
    console.log('Auto-refresh canceled');
    refreshTimer = null; // Explicitly reset refreshTimer
    clearFilter();
  } else {
    console.log('No active auto-refresh timer to cancel');
  }
};


const ActivityStoredata = useActivityStore();
function subtractHours(date, hours) {
  date.setHours(date.getHours() - hours);
  return date;
};


const filterField = ref("name");
const filterType = ref("=");
const filterValue = ref("");

const applyFilter = () => {
  if (filterField.value) {
    tabulator.value.setFilter(filterField.value, filterType.value, filterValue.value);
    console.log("Filtered");
  }
};

const clearFilter = () => {
  filterField.value = "";
  filterType.value = "=";
  filterValue.value = "";
  tabulator.value.clearFilter(); // Clear the filter immediately
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
    // Validate date range
    if (new Date(ActivityStoredata.selectedDates.to) < new Date(ActivityStoredata.selectedDates.from)) {
      // Show toast notification for invalid date range
      Toastify({
        text: 'Please enter a valid date range.',
        duration: 3000,
        close: true,
        gravity: 'bottom',
        position: 'right',
        backgroundColor: 'red',
      }).showToast();
      return; // Stop further execution if the date range is invalid
    }

    // Fetch activity data
    await ActivityStoredata.fetchActivityData();

    // Update dataSource with the fetched data for pending and completed tables
    console.log("dfsdf");
    console.log(ActivityStoredata.pendingData);
    tabulator.value.setData(ActivityStoredata.pendingData);
    tabulator2.value.setData(ActivityStoredata.completedData);
    summaryTabulator.value.setData(ActivityStoredata.abnormalitySummary);
    Toastify({
        text: 'Data Fetched Succesfully.',
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


const summaryTable = ref(null);
const summaryTabulator = ref(null);
const summaryTableData = ref([
  {line: 'Overall', critical: 100, warning: 120, completed:200},
  {line: 'Crank', critical: 300, warning: 201, completed: 230},
  {line: 'Head', critical: 300, warning: 201, completed: 230},
  {line: 'Block', critical: 300, warning: 201, completed: 230},
]);


const table = ref(null);
const tabulator = ref(null);
const tableData = ref([
  { slno: 1, line: 'A', criticalWarning: 'Critical', opNo: 101, problemsIdentified: 'Issue 1', identificationDate: '2024-01-31', counterMeasurement: '', spareReq: '', supportRequired: '', pendingDays: '', trgDate: '', completionDate: '', resp: '', status: '' },
  { slno: 2, line: 'B', criticalWarning: 'Warning', opNo: 102, problemsIdentified: 'Issue 2', identificationDate: '2024-01-30', counterMeasurement: '', spareReq: '', supportRequired: '', pendingDays: '', trgDate: '', completionDate: '', resp: '', status: '' },
  { slno: 3, line: 'C', criticalWarning: 'Critical', opNo: 103, problemsIdentified: 'Issue 3', identificationDate: '2024-01-29', counterMeasurement: '', spareReq: '', supportRequired: '', pendingDays: '', trgDate: '', completionDate: '', resp: '', status: '' },
  { slno: 4, line: 'A', criticalWarning: 'Critical', opNo: 101, problemsIdentified: 'Issue 1', identificationDate: '2024-01-31', counterMeasurement: '', spareReq: '', supportRequired: '', pendingDays: '', trgDate: '', completionDate: '', resp: '', status: '' },
  { slno: 5, line: 'B', criticalWarning: 'Warning', opNo: 102, problemsIdentified: 'Issue 2', identificationDate: '2024-01-30', counterMeasurement: '', spareReq: '', supportRequired: '', pendingDays: '', trgDate: '', completionDate: '', resp: '', status: '' },
  { slno: 6, line: 'C', criticalWarning: 'Critical', opNo: 103, problemsIdentified: 'Issue 3', identificationDate: '2024-01-29', counterMeasurement: '', spareReq: '', supportRequired: '', pendingDays: '', trgDate: '', completionDate: '', resp: '', status: '' },
]);


const table2 = ref(null);
const tabulator2 = ref(null);
const tableData2 = ref([
  { slno: 1, line: 'A', criticalWarning: 'Critical', opNo: 101, problemsIdentified: 'Issue 1', identificationDate: '2024-01-31', counterMeasurement: '', spareReq: '', supportRequired: '', pendingDays: '', trgDate: '', completionDate: '', resp: '', status: '' },
  { slno: 2, line: 'B', criticalWarning: 'Warning', opNo: 102, problemsIdentified: 'Issue 2', identificationDate: '2024-01-30', counterMeasurement: '', spareReq: '', supportRequired: '', pendingDays: '', trgDate: '', completionDate: '', resp: '', status: '' },
  { slno: 3, line: 'C', criticalWarning: 'Critical', opNo: 103, problemsIdentified: 'Issue 3', identificationDate: '2024-01-29', counterMeasurement: '', spareReq: '', supportRequired: '', pendingDays: '', trgDate: '', completionDate: '', resp: '', status: '' },
  { slno: 4, line: 'A', criticalWarning: 'Critical', opNo: 101, problemsIdentified: 'Issue 1', identificationDate: '2024-01-31', counterMeasurement: '', spareReq: '', supportRequired: '', pendingDays: '', trgDate: '', completionDate: '', resp: '', status: '' },
  { slno: 5, line: 'B', criticalWarning: 'Warning', opNo: 102, problemsIdentified: 'Issue 2', identificationDate: '2024-01-30', counterMeasurement: '', spareReq: '', supportRequired: '', pendingDays: '', trgDate: '', completionDate: '', resp: '', status: '' },
  { slno: 6, line: 'C', criticalWarning: 'Critical', opNo: 103, problemsIdentified: 'Issue 3', identificationDate: '2024-01-29', counterMeasurement: '', spareReq: '', supportRequired: '', pendingDays: '', trgDate: '', completionDate: '', resp: '', status: '' },
]);


const handleEditChange = (cell) => {
  const editedRow = cell.getRow().getData();
  const editedRowId = editedRow.id; // Assuming your row object has an 'id' property
  ActivityStoredata.saveEditedRowIds(editedRowId);

  // Show a toast notification
  Toastify({
    text: 'Please save after editing',
    duration: 3000, // Display duration in milliseconds
    close: true,
    gravity: 'bottom', // Other gravity options: 'top', 'bottom', 'left', 'right'
    position: 'right', // Other position options: 'left', 'right', 'center'
    backgroundColor: 'red',
  }).showToast();
};

const saveEdit = async () => {
  if (ActivityStoredata.editedRowIds.length === 0){
    // Show error toast
    Toastify({
      text: 'No Changes to Save',
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: 'red', // You can customize the background color for error
    }).showToast();
    return
  }

  try {
    // Get the current data from Tabulator
    const editNewData = tabulator.value.getData();

    // Filter out the rows whose IDs match the editedRowIds
    const editedRowsData = editNewData.filter(row => ActivityStoredata.editedRowIds.includes(row.id));

    // Log the data of the edited rows
    console.log("Edited rows data:", editedRowsData);
    
    // Send the edited rows data to the backend or perform any other logic here
    await ActivityStoredata.sendEdit(editedRowsData);

    // Clear the edited row IDs array
    ActivityStoredata.editedRowIds = [];

    // Show success toast
    Toastify({
      text: 'Changes saved successfully!',
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: 'green', // You can customize the background color for success
    }).showToast();

    //await handleQuerySubmit();
    console.log("refreshing Data");
  } catch (error) {
    console.error('Error saving edited data:', error);

    // Show error toast
    Toastify({
      text: 'Error saving changes. Please try again.',
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: 'red', // You can customize the background color for error
    }).showToast();
  }
};


onBeforeMount(() => {
  console.log("before mount")
  console.log(ActivityStoredata.selectedDates.from)
  let tempEndDate = new Date();
  let tempStartDate = subtractHours(new Date(),1)

  ActivityStoredata.selectedDates.from = tempStartDate.getTime();
  ActivityStoredata.selectedDates.to = tempEndDate.getTime();
}),


onMounted(() => {

  console.log("On mount");
  console.log(ActivityStoredata.selectedDates.from);

  summaryTabulator.value = new Tabulator(summaryTable.value, {
        data: summaryTableData.value, //link data to table
        reactiveData:true, //enable data reactivity
        layout: 'fitColumns',
        height: "350px",
        resizableColumns: true,
        columns: [
        { title: 'Line', field: 'line',minWidth: 80},
        { title: 'Warning', field: 'WARNING',minWidth: 140 },
        { title: 'Critical', field: 'CRITICAL',minWidth: 180 },
        { title: 'Completed', field: 'COMPLETED',minWidth: 80}],
      
      });


  //summaryTabulator.value.setFilter("warning", ">", 150);
  tabulator.value = new Tabulator(table.value, {
      data: tableData.value, //link data to table
      reactiveData:true, //enable data reactivity
      layout: 'fitColumns',
      height: "500px",
      resizableColumns: true,
      columns: [
      { title: 'id', field: 'id',minWidth: 80},
      { title: 'Location', field: 'location',minWidth: 140 },
      { title: 'Name', field: 'name',minWidth: 180 },
      { title: 'Group Name', field: 'group_name',minWidth: 540},
      { title: 'Parameter Name', field: 'parameter_name',minWidth: 540, frozen: true },
      { title: 'Axis', field: 'axis_name',minWidth: 80},
      { title: 'Date of Identification', field: 'date_of_identification', minWidth: 300 },
      { title: 'Latest Occurence', field: 'latest_occurrence', minWidth: 300 },
      { title: 'Recent Value', field: 'recent_value', minWidth: 150 },
      { title: 'Warning Limit', field: 'warning_limit', minWidth: 150 },
      { title: 'Critical Limit', field: 'critical_limit', minWidth: 150 },
      {
        title: 'Days Since Identification',
        field: 'days_since_identification',
        minWidth: 180,
        formatter: function(cell) {
          const row = cell.getRow();
          return daysSinceIdentification(row);
        },
      },
      { title: 'Target date of Completion ', field: 'target_date_of_completion', editor: 'date',minWidth: 300,cellEdited: handleEditChange},
      { title: 'Number of Occurrences ', field: 'number_of_occurrences', minWidth: 140},
      { title: 'Condition', field: 'condition', minWidth: 220 },
      { title: 'Corrective Measurments ', field: 'corrective_measurement', editor: 'input',minWidth: 210,cellEdited: handleEditChange},
      { title: ' Spare Part Required ', field: 'spare_required', editor: 'input',minWidth: 220, cellEdited: handleEditChange},
      { title: 'Support Needed ', field: 'support_needed', editor: 'input',minWidth: 180, cellEdited: handleEditChange },
      { title: 'Responsible Person Company Id', field: 'responsible_person_company_id', minWidth: 180, editor: 'input',cellEdited: handleEditChange},
      { title: 'Responsible Person Name', field: 'responsible_person_username',minWidth: 240},
      {
        title: 'Status',
        field: 'status',
        minWidth: 140,
        editor: 'select', // Set the editor to 'select' for a dropdown
        editorParams: {
          values: {
            'Pending': 'Pending', // Default value
            'Completed': 'Completed',
          },
        },
        cellEdited: handleEditChange,
      },
      {
        title: 'Priority',
        field: 'priority',
        minWidth: 140,
        editor: 'select', // Set the editor to 'select' for a dropdown
        editorParams: {
          values: {
            'A': 'A', // Default value
            'B': 'B',
            'C': 'C',
          },
        },
        cellEdited: handleEditChange,
      }],

      rowFormatter: function(row) {
        let priorityValue = row.getData().priority;

        // Define colors based on priority values
        let colors = {
            "A": "red",
            "B": "yellow"
            // Add more mappings as needed
        };

        // Check if the priority value has a corresponding color mapping
        if (colors.hasOwnProperty(priorityValue)) {
            row.getElement().style.backgroundColor = colors[priorityValue];
        }
    },
    
    });

  tabulator2.value = new Tabulator(table2.value, {
    data: tableData2.value, //link data to table
    reactiveData:true, //enable data reactivity
    layout: 'fitColumns',
    height: "500px",
    resizableColumns: true,
    columns: [
    
    { title: 'id', field: 'id', minWidth: 80},
    { title: 'Location', field: 'location', minWidth: 140 },
    { title: 'Name', field: 'name' ,minWidth: 180 },
    { title: 'Group Name', field: 'group_name', minWidth: 540},
    { title: 'Parameter Name', field: 'parameter_name', minWidth: 540 },
    { title: 'Axis', field: 'axis_name' ,minWidth: 80},
    { title: 'Date of Identification ', field: 'date_of_identification',minWidth: 300},
    { title: 'Latest Occurence', field: 'latest_occurrence', minWidth: 300},
    { title: 'Recent Value', field: 'recent_value', minWidth: 150 },
    { title: 'Warning Limit', field: 'warning_limit', minWidth: 150 },
    { title: 'Critical Limit', field: 'critical_limit', minWidth: 150 },
    { title: 'Target date of Completion ', field: 'target_date_of_completion', minWidth: 300,cellEdited: handleEditChange},
    { title: 'Actual Date of Completion ', field: 'actual_date_of_completion', minWidth: 300},
    { title: 'Number of Occurrences ', field: 'number_of_occurrences', minWidth: 140},
    { title: 'Condition ', field: 'condition', minWidth: 220  },
    { title: 'Corrective Measurments ', field: 'corrective_measurement', minWidth: 210,cellEdited: handleEditChange },
    { title: 'Spare Part Required ', field: 'spare_required' ,minWidth: 220,cellEdited: handleEditChange },
    { title: 'Support Needed ', field: 'support_needed', minWidth: 180  },
    { title: 'Responsible Person  Company Id', field: 'responsible_person_company_id', minWidth: 180 },
    { title: 'Responsible Person', field: 'responsible_person_username', minWidth: 240 },
    { title: 'Priority', field: 'priority', minWidth: 140 }
  ]      
  });
});


// Watch for changes in autoRefresh and automatically start or cancel auto-refresh
watch(autoRefresh, (newValue) => {
  if (newValue) {
    console.log("sfsfsdfsdf");
    startAutoRefresh();
  } else {
    console.log("fsdfs");
    cancelAutoRefresh();
  }
});

</script>

<template >
  
  <LayoutAuthenticatedSimple class=" font-custom ">
    <SectionMain>
      <div class="container mx-auto flex flex-col space-y-4">
        <BlurryHorizontalDivider />
        <div class="grid grid-cols-3 gap-2">
          <div>
            <label class="block mb-2 text-gray-700">From</label>
            <TimePickerFlatEmitter :defaultDatetime="subtractHours(new Date(), 1) " type="from" @date-change="handleFromDateChange" />
          </div>

          <div>
            <label class="block mb-2 text-gray-700">To</label>
            <TimePickerFlatEmitter :defaultDatetime="new Date()" type="to" @date-change="handleToDateChange" />
          </div>

          <div class=" mt-8 ">
            <BaseButton type="submit" color="info" label="Submit" @click="handleQuerySubmit" />
          </div>
        </div>
      
        <BlurryHorizontalDivider class="mt-8"/>

        <div class="auto-refresh-container p-4mt-4 flex items-center space-x-4"> 
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

        <div class="w-2/4 flex justify-start"><p class="font-semibold text-3xl font-custom text-yellow-500 mb-8 mt-8 ">Abnormal Activity Summary</p></div>
        <div ref="summaryTable"></div>
        <BlurryHorizontalDivider />
        
        <div class="flex flex-row mt-8 h-8"><!-- Button to save edited rows -->
          <div class="w-2/4 flex justify-start"><p class="font-semibold text-3xl font-custom text-yellow-500  ">Pending Activity View</p></div>
        </div>

        <!-- Filter options -->
        <div class="w-full flex justify-normal space-x-4" v-if="!autoRefresh">
          <div>
            <label class="block mb-2 text-gray-700">Filter by:</label>
            <select id="filter-field" class="bg-slate-50 text-black border rounded-lg shadow" v-model="filterField">
              <option value="name">Name</option>
              <option value="location">Location</option>
              <option value="group_name">Group Name</option>
              <option value="parameter_name">Parameter Name</option>
            </select>
          </div>

          <div>
            <label class="block mb-2 text-gray-700">Filter:</label>
            <select id="filter-type" class="bg-slate-50 text-black border rounded-lg shadow" v-model="filterType">
              <option value="=">=</option>
              <option value="like">like</option>
            </select>
          </div>

          <div>
            <label class="block mb-2 text-gray-700">Filter value:</label>
            <input id="filter-value" v-model="filterValue" class="bg-slate-50 text-black border rounded-lg shadow" type="text" placeholder="Value to filter" />
          </div>

          <div class="mt-8">
            <BaseButton type="submit" color="info" label="Filter" @click="applyFilter" />
          </div>

          <div class="mt-8">
            <BaseButton type="submit" color="info" label="Clear" @click="clearFilter" />
          </div>
          <div class="w-2/4  flex justify-end h-18 items-end">
            <BaseButton type="button" color="success" label="Save Edited" @click="saveEdit" />
          </div>
        </div>

        <div ref="table"></div>
        <BlurryHorizontalDivider />
        <div>
          <div class="w-2/4 flex justify-start mt-8 mb-4">
            <p class="font-semibold text-3xl font-custom text-emerald-600  ">Completed Activity View</p>
          </div>
        </div>
        <div ref="table2"></div>
        <BlurryHorizontalDivider /> 
      </div>
    </SectionMain>
  </LayoutAuthenticatedSimple>
</template>

<style>
  /* Import Tabulator CSS globally */
  @import 'tabulator-tables/dist/css/tabulator.min.css';

  /* Your global styles here, including Tailwind or custom styles */

  /* Override specific Tabulator styles */
  .tabulator {
  /* Your existing styles here */
  background-color: #ffffff;
  border-style: solid;
  border-color: rgb(179, 179, 179);
  border-width: 2px;
  border-radius: 10px;
  padding: 6px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.tabulator .tabulator-tableholder {
  border-width: 2px;
  border-radius: 6px;
}

.tabulator .tabulator-header {
  background-color: #ffffff;
  color: #fdfdfd;
  border-width: 2px;
  border-radius: 6px;
}

.tabulator .tabulator-header .tabulator-col {
  background-color: #000000;
  height: 50px;
  align-items: center;
  justify-content: center;
  font-size: 20px;
  font-size: 20px;
  /* Add this line */
}

.tabulator .tabulator-header .tabulator-col:hover {
  background-color: #00000000;
  color: #ffffff;
  font-size: medium;
  border-bottom: 2px solid #ffffff; /* Add this line */
}

.tabulator .tabulator-row {
  background-color: #ffffff;
  height: 60px; /* Adjust the height as needed */
  line-height: 60px; /* Add this line */
  border-bottom: 2px solid #ececec; /* Add this line for horizontal lines between rows */
  font-size: 20px;
  font-size: 20px;
}

div.tabulator-frozen.tabulator-cell {
  background-color: #ffffff;
  height: 60px; /* Adjust the height as needed */
  line-height: 60px; /* Add this line */
  border: 2px solid #ececec; /* Add this line for horizontal lines between rows */
  font-size: 20px;
  font-size: 20px;
}

.tabulator .tabulator-row:hover {
  background-color: #f9f9f9;
}

.tabulator .tabulator-cell {
    text-align: center; /* Center the text in cells */
  }

/* Add more custom styles as needed */

  /* Add more custom styles as needed */
</style>