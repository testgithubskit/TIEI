<script setup>
import { computed, ref, onBeforeMount,onMounted } from "vue";

import DyLineChartWithLimits from "@/components/Charts/DyLineChartWithLimits.vue";
import TimePickerFlatEmitter from "@/components/TimePickerFlatEmitter.vue";
import SectionMain from "@/components/SectionMain.vue";
import CardBox from "@/components/CardBox.vue";
import BaseButton from "@/components/BaseButton.vue";
import GraphLegend from "@/components/GraphLegend.vue";
import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";
import BlurryHorizontalDivider from "@/components/BlurryHorizontalDivider.vue";
import ParitoChart from "../components/Charts/ParitoChart.vue"
import PieChartEc from "../components/Charts/PieChartEc.vue"
import PieChart from "../components/Charts/PieChart.vue"

import { TabulatorFull as Tabulator } from 'tabulator-tables';
import 'tabulator-tables/dist/css/tabulator.min.css';
import 'tabulator-tables/dist/js/tabulator.min.js';


import CardBoxWidgetPlainWrap from "@/components/CardBoxWidgetPlainWrap.vue";

//Importing Store Statements

import { useMachineSamplingWithLimitsStore } from '@/stores/MachineSamplingWithLimitsStore'; 
import { useRouter } from 'vue-router';

const router = useRouter();

const machineSamplingWithLimitsStore = useMachineSamplingWithLimitsStore();


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

machineSamplingWithLimitsStore.selectedDates.to = currentDate.getTime();

let oneHourEarlier = subtractHours(currentDate, 1);
let formattedDateOneHourEarlier = oneHourEarlier.getTime();

machineSamplingWithLimitsStore.selectedDates.from = formattedDateOneHourEarlier;

const handleQuerySubmit = async () => {
  // Log start and end dates in epoch timestamp format
  console.log('Start Date (Epoch):', fromDate.value.getTime());
  console.log('End Date (Epoch):', toDate.value.getTime());

  // Perform any additional actions like fetching data from the backend
  await machineSamplingWithLimitsStore.fetchMachineParameterData();
};
const handleBack = async () => {
  const routeObject = { name: 'Factory Level Polling Parameter Overview Grid',
   params: { groupName: machineSamplingWithLimitsStore.parameterGroup } };
  router.push(routeObject);
};


const handleFromDateChange = (dateValue) => {
  // Handle the "from" date change event here
  // Perform any additional actions as needed
  machineSamplingWithLimitsStore.selectedDates.from = dateValue.value;
};

const handleToDateChange = (dateValue) => {
  // Handle the "to" date change event here
  // Perform any additional actions as needed
  machineSamplingWithLimitsStore.selectedDates.to = dateValue.value;
};

onBeforeMount(async () => {
  console.log("sampling on mount");
  console.log(machineSamplingWithLimitsStore.parameterGroup);
});

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


  tabulator.value = new Tabulator(table.value, {
        data: tableData.value, //link data to table
        reactiveData:true, //enable data reactivity
        layout: 'fitColumns',
        height: "400px",
        resizableColumns: true,
        columns: [
        { title: 'id', field: 'id',minWidth: 80},
        { title: 'Location', field: 'location',minWidth: 140 },
        { title: 'Name', field: 'name',minWidth: 180 },
        { title: 'Group Name', field: 'group_name',minWidth: 80},
        { title: 'Parameter Name', field: 'parameter_name',minWidth: 140 },
        { title: 'Axis Name', field: 'axis_name',minWidth: 80},
        
        { title: 'Date of Identification ', field: 'date_of_identification',minWidth: 200 },
        { title: 'Target date of Completion ', field: 'target_date_of_completion', editor: 'date',minWidth: 230,},
         { title: 'Condition ', field: 'condition',minWidth: 220  },
        { title: 'Corrective Measurments ', field: 'corrective_measurement', editor: 'input',minWidth: 210,  },
        { title: ' Spare Part Required ', field: 'spare_required', editor: 'input',minWidth: 220, },
        { title: 'Support Needed ', field: 'support_needed', editor: 'input',minWidth: 180  },
        { title: 'Responsible Person ', field: 'responsible_person',editor: 'input',minWidth: 180  },
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
       
      },
        
      ],
      
      });


})



</script>

<template>
  <LayoutAuthenticatedSimple>
    <SectionMain class=" font-custom    ">
      <!-- <BaseButton type="submit" color="infolightDark" label="Back" @click="handleBack" /> -->

      <div v-if="machineSamplingWithLimitsStore.alertMessage" 
      :class="{ 'alert': true, 'bg-emerald-500 border-black': machineSamplingWithLimitsStore.isSuccessMessage,
       'bg-red-600 border-black': !machineSamplingWithLimitsStore.isSuccessMessage }">
        {{ machineSamplingWithLimitsStore.alertMessage }}
      </div>

      <BlurryHorizontalDivider />
      <!-- Display machine information Start -->
      <div class="grid grid-cols-1 gap-6 lg:grid-cols-3 mb-6">
        <CardBoxWidgetPlainWrap 
        label="Machine Name"
        :parameter-value="machineSamplingWithLimitsStore.machine">
        </CardBoxWidgetPlainWrap>
        <CardBoxWidgetPlainWrap 
        label="Parameter Group"
        :parameter-value="machineSamplingWithLimitsStore.parameterGroup">
        </CardBoxWidgetPlainWrap>
        <CardBoxWidgetPlainWrap 
        label="Parameter Name"
        :parameter-value="machineSamplingWithLimitsStore.actualParameterName">
        </CardBoxWidgetPlainWrap>
        
      </div>

      <BlurryHorizontalDivider />
      
      <div class="grid grid-cols-4 gap-2">
        <!-- Dropdown for time interval selection -->
        <div>
          <label class="block mb-2 text-gray-700">Select Time Interval</label>
          <select v-model="selectedTimeInterval" @change="handleTimeIntervalChange" class="rounded-md px-6  py-2 bg-gray-200">
            <option value="last24">Last 24 Hours</option>
            <option value="last8">Last 8 Hours</option>
            <option value="lastWeek">Last Week</option>
            <option value="lastMonth">Last Month</option>
            <option value="custom">Custom Date</option>
          </select>
        </div>

        <!-- If "Custom Date" is selected, allow users to pick custom dates -->
        <template v-if="selectedTimeInterval === 'custom'">
          <div>
            <label class="block mb-2 text-gray-700">From</label>
            <TimePickerFlatEmitter v-model="fromDate" type="from" @date-change="handleFromDateChange" />
          </div>

          <div>
            <label class="block mb-2 text-gray-700">To</label>
            <TimePickerFlatEmitter v-model="toDate" type="to" @date-change="handleToDateChange" />
          </div>
        </template>

        <!-- Submit button -->
        <div class="flex flex-col items-center justify-end">
          <BaseButton type="submit" color="info" label="Submit" @click="handleQuerySubmit" />
        </div>
      </div>

     

      <BlurryHorizontalDivider />
      <CardBox>
        <p class="font-semibold text-red-500 text-xl text-center mb-3">Alarm Table for the Day</p>
        <div ref="table"></div>
      </CardBox>
      
      <BlurryHorizontalDivider />

      <CardBox class="mb-8   ">
        <p class="font-semibold text-emerald-600  text-xl text-center mb-3">Parito Chart - [Alarm Count vs Alarms]</p>
        <div class=" w-full ">
          <ParitoChart class="h-[60vh]"  />
        </div>
      </CardBox>      

      <CardBox class="mb-8">
        <p class="font-semibold text-emerald-600  text-xl text-center mb-3">Parito Chart - [Alarm Time Span vs Alarms]</p>
        <div class="w-full">
          <ParitoChart />
        </div>
      </CardBox>
      
      <CardBox class="mb-8">
        <div class="w-[100vh] h-[50vh]">
          <PieChartEc/>
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

</style>
