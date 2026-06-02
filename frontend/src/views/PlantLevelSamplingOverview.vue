<script setup>
import { computed, ref, onMounted, watch, onBeforeMount } from "vue";
import { useMainStore } from "@/stores/main";
import {
  mdiCoffeeMaker
} from "@mdi/js";

import axios from 'axios';

import LineChartDyGraph from "@/components/Charts/LineChartDyGraph.vue";
import SectionMain from "@/components/SectionMain.vue";
import CardBox from "@/components/CardBox.vue";
import BaseButton from "@/components/BaseButton.vue";
import LayoutAuthenticated from "@/layouts/LayoutAuthenticated.vue";
import BlurryHorizontalDivider from "@/components/BlurryHorizontalDivider.vue";
import DropDownPrimeVue from "@/components/DropDownPrimeVue.vue";
import DropDownParameterPrimeVue from "@/components/DropDownParameterPrimeVue.vue";
import TimePickerFlat from "@/components/TimePickerFlat.vue";
//Importing Store Statements

import { usePlantSamplingOverviewStore } from '@/stores/PlantSamplingOverviewStore'; 

const plantSamplingOverviewStore = usePlantSamplingOverviewStore();

const chartData = ref([]);

const machineSelectionbutton = ref({
  icon: mdiCoffeeMaker,
  label: '',
  menu: [
        {
          label: 'Machine 1',
        },
        {
          label: 'Machine 2',
        },
        {
          label: 'Machine 3',
        }]
});

const parameterSelectionbutton = ref({
  icon: mdiCoffeeMaker,
  label: '',
  menu: [
        {
          label: 'Machine 1',
        },
        {
          label: 'Machine 2',
        },
        {
          label: 'Machine 3',
        }]
});

// Function to generate sample data
const convertStringToDate = (inputDate) => {
  
  const dateParts = inputDate.split(" ");
  const formattedDate = `${dateParts[1]} ${dateParts[0]}, ${dateParts[2]}`;

  const dateObject = new Date(formattedDate);
  const epochTimestamp = dateObject.getTime();

  const newDate = new Date(epochTimestamp);

  console.log("Epoch Timestamp:", epochTimestamp);
  console.log("New Date:", newDate);


  return newDate;
};

// const chartData2 = computed(() => {

//   const selectedFromDate = convertStringToDate(plantSamplingOverviewStore.SelectedParmeter.selectedDates[0]);
//   const selectedToDate = convertStringToDate(plantSamplingOverviewStore.SelectedParmeter.selectedDates[1]);

//   return generateSampleData(selectedFromDate, selectedToDate);

// })

// Watcher to log changes in the date value
watch(plantSamplingOverviewStore.SelectedParmeter.selectedDatesDict, (newValue, oldValue) => {
  console.log('Datesss changed:', newValue);
});

// Function to generate sample data
const generateSampleData = (fromDate, toDate) => {
  const fromTimestamp = fromDate.getTime();
  const toTimestamp = toDate.getTime();
  const oneDay = 86400000;
  const data = [];

  for (let timestamp = fromTimestamp; timestamp <= toTimestamp; timestamp += oneDay) {
    const currentDateTime = new Date(timestamp);
    const randomValue = Math.round(Math.random() * 300);
    data.push([currentDateTime, randomValue]);
  }

  return data;
};


function generateSampleDataBetween(){
  const selectedFromDate = convertStringToDate(plantSamplingOverviewStore.SelectedParmeter.selectedDatesDict.from);
  const selectedToDate = convertStringToDate(plantSamplingOverviewStore.SelectedParmeter.selectedDatesDict.to);

  return generateSampleData(selectedFromDate, selectedToDate);
}

let sampleData  = generateSampleDataBetween();

let chartData2 = ref(sampleData);

const getGridColumnsClass = computed(() => {
  return (length) => {
    return `grid grid-cols-1 gap-6 lg:grid-cols-${length} mb-6`;
  };
});


function subtractHours(date, hours) {
  date.setHours(date.getHours() - hours);

  return date;
}

let currentDate = new Date();

plantSamplingOverviewStore.SelectedParmeter.selectedDatesDict.to = currentDate.getTime();

let oneHourEarlier = subtractHours(currentDate, 1);
let formattedDateOneHourEarlier = oneHourEarlier.getTime();

plantSamplingOverviewStore.SelectedParmeter.selectedDatesDict.from = formattedDateOneHourEarlier;

console.log("current dates");
// Perform any additional actions as needed
console.log(typeof(plantSamplingOverviewStore.SelectedParmeter.selectedDatesDict.from));
console.log(plantSamplingOverviewStore.SelectedParmeter.selectedDatesDict.to);


// const handleQuerySubmit = () => {
//   // Handle the click event here
//   console.log("Button clicked");
//   // Perform any additional actions as needed
//   console.log(plantSamplingOverviewStore.SelectedParmeter.selectedDatesDict);
// };


const handleQuerySubmit = async () => {
  // Getting the Initial Latest Data from the backend - Start

  const parameterName = plantSamplingOverviewStore.SelectedParmeter.name;
  console.log("From data after query submit", plantSamplingOverviewStore.SelectedParmeter.selectedDatesDict.from);
  // Get the start time from the Pinia store
  // In the below code we're not using .selectedDatesDict.from.getTime(), for some reason, it is being stored
  // As epochtimestamp itself, unlike the function ``handleSelectedParameterUpdate``, which has the date as object
  // Instead of epoch timestamp
  const startTime = plantSamplingOverviewStore.SelectedParmeter.selectedDatesDict.from; // Get the start time from the Pinia store
  const endTime = plantSamplingOverviewStore.SelectedParmeter.selectedDatesDict.to; // Get the end time from the Pinia store

  try {
    const processedData = await fetchPlantParameterData(parameterName, startTime, endTime);
    
    // Process the response data as needed
    console.log(processedData);    
    chartData2.value = processedData;
    console.log("got Query data from the backend");
    console.log(processedData);

  } catch (error) {
    console.error('Error fetching data:', error);
  }
};


const handleSelectedParameterUpdate = async (selectedItem) => {
  // Update the necessary property in the store using the imported Pinia store instance
  //homeStore.updateSelectedItem(selectedItem);
  console.log("Update from the parent");
  console.log(selectedItem);
  plantSamplingOverviewStore.$patch({
    SelectedParmeter: {
      name: selectedItem.value
    }
  });
  console.log("plantSamplingOverviewStore.SelectedParmeter", plantSamplingOverviewStore.SelectedParmeter.name);

};


async function fetchPlantParameterData(parameterName, startTime, endTime) {
  const url = `http://172.18.100.87:8000/api/v1/machines/ams_mcv_450/parameters/${parameterName}?startTime=${encodeURIComponent(startTime)}&endTime=${encodeURIComponent(endTime)}`;

  try {
    const response = await axios.get(url);
    const responseData = response.data;
    
    // Convert the first element of each array to a JavaScript Date object
    const processedData = responseData.data.map((entry) => {
      const datetimeEpoch = entry[0];
      console.log("First value", typeof(entry[0]));
      const value = entry[1];
      const datetimeObject = new Date(datetimeEpoch);
      return [datetimeObject, value];
    });
    
    // Process the response data as needed
    console.log(processedData);    
    return processedData;

  } catch (error) {
    console.error('Error fetching data:', error);
    throw error;
  }
}


onBeforeMount(async () => {
  console.log("Creating the polling");
  await plantSamplingOverviewStore.fetchAndUpdateAvailableParameters(); 
  parameterDropdownProps.value.items = plantSamplingOverviewStore.SelectedParmeter.availableParameters;
  console.log("test", parameterDropdownProps.value.items);
});


const parameterDropdownProps = ref({
  items: []
});


</script>

<!-- Template -->

<template>
  <LayoutAuthenticated>
    <SectionMain>
      <BlurryHorizontalDivider />
      <div class="grid grid-cols-2 gap-2">
        <div>
          <label class="block mb-2 text-gray-700">Parameter</label>
          <DropDownParameterPrimeVue @item-selected-update-parameter="handleSelectedParameterUpdate"
           :items="parameterDropdownProps.items" />
        </div>
      </div>
      <BlurryHorizontalDivider />

      <div class="grid grid-cols-3 gap-2">
        <div>
          <label class="block mb-2 text-gray-700">From</label>
          <TimePickerFlat :defaultDatetime="subtractHours(new Date(), 1)" type="from" />
        </div>

        <div>
          <label class="block mb-2 text-gray-700">To</label>
          <TimePickerFlat type="to" />
        </div>

        <div class="flex flex-col items-center justify-end">
          <BaseButton type="submit" color="info" label="Submit" @click="handleQuerySubmit" />
        </div>
      </div>

      <CardBox class="mb-8">
        <div>
          <LineChartDyGraph class="h-96" :data="chartData2" />
        </div>
      </CardBox>

    </SectionMain>
  </LayoutAuthenticated>
</template>
