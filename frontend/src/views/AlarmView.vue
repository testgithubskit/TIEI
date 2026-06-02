<script setup>
import { computed, ref, onBeforeMount,onMounted } from "vue";

import TimePickerFlatEmitter from "@/components/TimePickerFlatEmitter.vue";
import SectionMain from "@/components/SectionMain.vue";
import CardBox from "@/components/CardBox.vue";
import BaseButton from "@/components/BaseButton.vue";
import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";
import BlurryHorizontalDivider from "@/components/BlurryHorizontalDivider.vue";
import PieChartAlarmEc from "../components/Charts/PieChartAlarmEc.vue";
import ParitoChartCountJs from "../components/Charts/ParitoChartCountJs.vue";

import ParitoChartTimeSpanJs from "../components/Charts/ParitoChartTimeSpanJs.vue";

import { useAlarmStore } from '@/stores/AlarmStore';

import ParameterWithDropDown from "@/components/ParameterWithDropDown.vue";
import DropdownSingleSelectMachine from "@/components/DropdownSingleSelectMachine.vue";

import { TabulatorFull as Tabulator } from 'tabulator-tables';
import 'tabulator-tables/dist/css/tabulator.min.css';
import 'tabulator-tables/dist/js/tabulator.min.js';


const AlarmStore = useAlarmStore();

// Selected time interval and dates
const selectedTimeInterval = ref('custom');
const fromDate = ref(subtractHours(new Date(), 24)); // Default to last 24 hours
const toDate = ref(new Date());

function subtractHours(date, hours) {
  const copiedDate = new Date(date);
  copiedDate.setHours(copiedDate.getHours() - hours);
  return copiedDate;
}

function handleTimeIntervalChange() {
  // Update "From" and "To" dates based on selected time interval
  switch (selectedTimeInterval.value) {
    case 'last24':
      setLastHours(24);
      break;
    case 'last8':
      setLastHours(8);
      break;
    case 'lastWeek':
      setLastWeek();
      break;
    case 'lastMonth':
      setLastMonth();
      break;
    case 'custom':
      // No action needed as user will manually select dates
      break;
    default:
      break;
  }
}

function setLastHours(hours) {
  const now = new Date();
  fromDate.value = subtractHours(now, hours);
  toDate.value = now;
}

function setLastWeek() {
  const now = new Date();
  const oneWeekAgo = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000); // Subtract 7 days
  fromDate.value = oneWeekAgo;
  toDate.value = now;
}

function setLastMonth() {
  const now = new Date();
  const oneMonthAgo = new Date(now.getFullYear(), now.getMonth() - 1, now.getDate());
  fromDate.value = oneMonthAgo;
  toDate.value = now;
}


let currentDate = new Date();

AlarmStore.selectedDates.to = currentDate.getTime();

let oneHourEarlier = subtractHours(currentDate, 1);
let formattedDateOneHourEarlier = oneHourEarlier.getTime();

AlarmStore.selectedDates.from = formattedDateOneHourEarlier;


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


let AlarmTimespanData = computed(() => {
  let data = AlarmStore.timespanData;
  console.log("parent timespan", data);
  return data;
});

let AlarmCountData = computed(() => {
  let data = AlarmStore.countData;
  console.log("Parent alarm count", data);
  return data;
});


//Table

const table = ref(null);
const tabulator = ref(null);
const tableData = ref([
  { slno: 1, line: 'A', criticalWarning: 'Critical', opNo: 101, problemsIdentified: 'Issue 1', identificationDate: '2024-01-31', counterMeasurement: '', spareReq: '', supportRequired: '', pendingDays: '', trgDate: '', completionDate: '', resp: '', status: 'Pending' },
  { slno: 2, line: 'B', criticalWarning: 'Warning', opNo: 102, problemsIdentified: 'Issue 2', identificationDate: '2024-01-30', counterMeasurement: '', spareReq: '', supportRequired: '', pendingDays: '', trgDate: '', completionDate: '', resp: '', status: 'In Progress' },
  { slno: 3, line: 'C', criticalWarning: 'Critical', opNo: 103, problemsIdentified: 'Issue 3', identificationDate: '2024-01-29', counterMeasurement: '', spareReq: '', supportRequired: '', pendingDays: '', trgDate: '', completionDate: '', resp: '', status: 'Completed' },
  { slno: 4, line: 'A', criticalWarning: 'Critical', opNo: 101, problemsIdentified: 'Issue 1', identificationDate: '2024-01-31', counterMeasurement: '', spareReq: '', supportRequired: '', pendingDays: '', trgDate: '', completionDate: '', resp: '', status: 'Pending' },
  { slno: 5, line: 'B', criticalWarning: 'Warning', opNo: 102, problemsIdentified: 'Issue 2', identificationDate: '2024-01-30', counterMeasurement: '', spareReq: '', supportRequired: '', pendingDays: '', trgDate: '', completionDate: '', resp: '', status: 'In Progress' },
  { slno: 6, line: 'C', criticalWarning: 'Critical', opNo: 103, problemsIdentified: 'Issue 3', identificationDate: '2024-01-29', counterMeasurement: '', spareReq: '', supportRequired: '', pendingDays: '', trgDate: '', completionDate: '', resp: '', status: 'Completed' },
]);

onMounted(()=>{

  AlarmStore.fetchAvailableMachines();


  tabulator.value = new Tabulator(table.value, {
        data: tableData.value, //link data to table
        reactiveData:true, //enable data reactivity
        layout: 'fitColumns',
        height: "400px",
        resizableColumns: true,
        columns: [
        { title: 'Update Date', field: 'update_epoch_time',minWidth: 400, },
        { title: 'End Date', field: 'enddate_epoch_time',minWidth: 400 },
        { title: 'Duration (In Seconds)', field: 'timespan',minWidth: 100 },
        { title: 'Message', field: 'message',minWidth: 600},
        
      ],
      
      });


});


let availableMachines = computed(() => {
  return AlarmStore.availableMachines;
});

let initialSelectedMachine = ref(AlarmStore.selectedMachine);


const handleQuerySubmit = async () => {
  console.log("StartTime : " + AlarmStore.selectedDates.from)
  console.log("EndTime : " + AlarmStore.selectedDates.to)
  await AlarmStore.fetchAlarmData();
  tabulator.value.setData(AlarmStore.timelineData);

};


const handleFromDateChange = (dateValue) => {
  AlarmStore.selectedDates.from = dateValue.value;
  fromDate.value = dateValue.value;
};

const handleToDateChange = (dateValue) => {
  AlarmStore.selectedDates.to = dateValue.value;
  toDate.value = dateValue.value;
};




const handleSelectedParameterUpdate = async (selectedItem) => {

if (selectedItem !== null){

  AlarmStore.selectedMachine = selectedItem.value;
  console.log(AlarmStore.selectedMachine);
}
};

</script>

<template>
  <LayoutAuthenticatedSimple>
    <SectionMain class=" font-custom p-16">

      <BlurryHorizontalDivider />
      
      <div class="grid grid-cols-4 gap-2">

        <!-- Input box for machine selection -->
        <div class="flex items-center flex-col">
          <label class="block m-3 text-gray-700 font-semibold">Machine</label>
          <ParameterWithDropDown class="m-3"  :icon="mdiChartTimelineVariant"  main>
              <DropdownSingleSelectMachine 
              @item-selected-update-parameter="handleSelectedParameterUpdate" 
              :items="availableMachines"
              :defaultSelectedItem="initialSelectedMachine"
             />
          </ParameterWithDropDown>
       
        </div>

        <!-- Dropdown for time interval selection -->
        <div class="flex items-center flex-col p-4">
          <label class="block text-gray-700 font-semibold mb-3">Select Time Interval</label>
          <select v-model="selectedTimeInterval" @change="handleTimeIntervalChange" class=" mt-2 rounded-md border-2 border-black">
            <option value="last24">Last 24 Hours</option>
            <option value="last8">Last 8 Hours</option>
            <option value="lastWeek">Last Week</option>
            <option value="lastMonth">Last Month</option>
            <option value="custom">Custom Date</option>
          </select>
        </div>

        <!-- If "Custom Date" is selected, allow users to pick custom dates -->
        <div v-if="selectedTimeInterval === 'custom'" class="flex items-center m-2">
          <div class="flex items-center flex-col mr-2">
            <label class="block mb-2 mr-2 text-gray-700 font-semibold">From</label>
            <TimePickerFlatEmitter :defaultDatetime="subtractHours(new Date(), 1)" v-model="fromDate" type="from" @date-change="handleFromDateChange" />
          </div>

          <div class="flex items-center ml-2 flex-col">
            <label class="block mb-2 mr-2 text-gray-700 font-semibold">To</label>
            <TimePickerFlatEmitter :defaultDatetime="new Date()" v-model="toDate" type="to" @date-change="handleToDateChange" />
          </div>
        </div>

        <!-- Submit button -->
        <div class="flex flex-col items-center justify-end mb-6">
          <BaseButton type="submit" color="info" label="Submit" @click="handleQuerySubmit" />
        </div>

      </div>

      <BlurryHorizontalDivider />
      <CardBox class="mb-8">
        <p class="font-semibold text-red-500 text-xl text-center mb-3">Alarm Table for the Day</p>
        <div ref="table"></div>
      </CardBox>
      
      <BlurryHorizontalDivider />

      <CardBox class="mb-8">
        <p class="font-semibold text-emerald-600  text-xl text-center mb-3">Parito Chart - [Alarm Count vs Alarms]</p>
        
        <div class="w-full">
            <ParitoChartCountJs class="w-full h-[60vh]" :data="AlarmCountData" />
        </div>
      </CardBox>      

      <CardBox class="mb-8">
        <p class="font-semibold text-emerald-600  text-xl text-center mb-3">Parito Chart - [Alarm Time Span vs Alarms]</p>
        <div class="w-full">
            <ParitoChartTimeSpanJs class="w-full h-[60vh]" :data="AlarmTimespanData" />
        </div>
      </CardBox>
      
      <CardBox class="mb-8">
        <div class="w-[100vh] h-[50vh]">
          <PieChartAlarmEc :data="AlarmTimespanData"/>
        </div>
      </CardBox> 

      <!-- <CardBox class="mb-8">
        <div >
          <PieChart class="w-56"/>
        </div>
      </CardBox>  -->

      

           

      <BlurryHorizontalDivider />

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

</style>../components/Charts/ParitoChartCountJs.vue
