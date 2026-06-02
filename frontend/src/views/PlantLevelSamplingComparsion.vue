<script setup>
import { computed, ref, onMounted, watch, onBeforeMount } from "vue";
import { useMainStore } from "@/stores/main";
import {
  mdiAccountMultiple,
  mdiCartOutline,
  mdiChartTimelineVariant,
  mdiMonitorCellphone,
  mdiReload,
  mdiGithub,
  mdiChartPie,
  mdiCoffeeMaker
} from "@mdi/js";

import axios from 'axios';

import LineChartDyGraph from "@/components/Charts/LineChartDyGraph.vue";
import TimeSeriesPlotly from "@/components/Charts/TimeSeriesPlotly.vue";
import StateChangeChart from "@/components/Charts/StateChangeChart.vue";
import DropDown from "@/components/DropDown.vue";
import TimePickerFlat from "@/components/TimePickerFlat.vue";
import SectionMain from "@/components/SectionMain.vue";
import CardBox from "@/components/CardBox.vue";
import BaseButton from "@/components/BaseButton.vue";
import LayoutAuthenticated from "@/layouts/LayoutAuthenticated.vue";
import ParameterWithDropDown from "@/components/ParameterWithDropDown.vue";
import BlurryHorizontalDivider from "@/components/BlurryHorizontalDivider.vue";
import DropDownParameterPrimeVue from "@/components/DropDownParameterPrimeVue.vue";
import DropDownMultiSelectPrimeVue from "@/components/DropDownMultiSelectPrimeVue.vue";
import DropDownMultiSelectMachinePrimeVue from "@/components/DropDownMultiSelectMachinePrimeVue.vue";

//Importing Store Statements

import { usePlantSamplingComparsionStore } from '@/stores/PlantSamplingComparsionStore'; 

const plantSamplingComparsionStore = usePlantSamplingComparsionStore();


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

// Watcher to log changes in the date value
watch(plantSamplingComparsionStore.selectedMachines.selectedDatesDict, (newValue, oldValue) => {
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
  const selectedFromDate = convertStringToDate(plantSamplingComparsionStore.selectedMachines.selectedDatesDict.from);
  const selectedToDate = convertStringToDate(plantSamplingComparsionStore.selectedMachines.selectedDatesDict.to);

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

plantSamplingComparsionStore.selectedMachines.selectedDatesDict.to = currentDate.getTime();

let oneHourEarlier = subtractHours(currentDate, 1);
let formattedDateOneHourEarlier = oneHourEarlier.getTime();

plantSamplingComparsionStore.selectedMachines.selectedDatesDict.from = formattedDateOneHourEarlier;

console.log("current dates");
// Perform any additional actions as needed
console.log(typeof(plantSamplingComparsionStore.selectedMachines.selectedDatesDict.from));
console.log(plantSamplingComparsionStore.selectedMachines.selectedDatesDict.to);


// const handleQuerySubmit = () => {
//   // Handle the click event here
//   console.log("Button clicked");
//   // Perform any additional actions as needed
//   console.log(plantSamplingComparsionStore.selectedMachines.selectedDatesDict);
// };


const handleQuerySubmit = async () => {
  // Getting the Initial Latest Data from the backend - Start

  const machineName = plantSamplingComparsionStore.selectedMachines.name;
  const parameterName = plantSamplingComparsionStore.selectedMachines.parameters.SelectedParmeter;
  console.log("From data after query submit", plantSamplingComparsionStore.selectedMachines.selectedDatesDict.from); // Get the start time from the Pinia store
  // In the below code we're not using .selectedDatesDict.from.getTime(), for some reason, it is being stored
  // As epochtimestamp itself, unlike the function ``handleSelectedParameterUpdate``, which has the date as object
  // Instead of epoch timestamp
  const startTime = plantSamplingComparsionStore.selectedMachines.selectedDatesDict.from; // Get the start time from the Pinia store
  const endTime = plantSamplingComparsionStore.selectedMachines.selectedDatesDict.to; // Get the end time from the Pinia store

  try {
    const processedData = await fetchMachineParameterData(machineName, parameterName, startTime, endTime);
    
    // Process the response data as needed
    console.log(processedData);    
    chartData2.value = processedData;
    console.log("got Query data from the backend");
    console.log(processedData);

  } catch (error) {
    console.error('Error fetching data:', error);
  }
};


const handleSelectedMachinesUpdate = async (selectedItem) => {
  // Update the necessary property in the store using the imported Pinia store instance
  // homeStore.updateSelectedItem(selectedItem);
  console.log("Update from the parent");
  console.log(selectedItem);
  let selectedMachineList = selectedItem.map(item => item.value);
  plantSamplingComparsionStore.$patch({
    selectedMachines: {
      names: selectedMachineList
    }
  });
  console.log("plantSamplingComparsionStore.selectedMachines", plantSamplingComparsionStore.selectedMachines.names);
  console.log("Getting the list of available parameters for this machine");
  await plantSamplingComparsionStore.fetchAndUpdateAvailableParameters();

  parameterDropdownProps.value.items = plantSamplingComparsionStore.selectedMachines.parameters.availableParameters
  console.log("parameterSelectionbutton", parameterDropdownProps.value);

};


async function fetchMachineParameterData(machineName, parameterName, startTime, endTime) {
  const url = `http://172.18.100.87:8000/api/v1/machines/${machineName}/parameters/${parameterName}?startTime=${encodeURIComponent(startTime)}&endTime=${encodeURIComponent(endTime)}`;

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


const handleSelectedParameterUpdate = async (selectedItem) => {
  // Update the necessary property in the store using the imported Pinia store instance
  //homeStore.updateSelectedItem(selectedItem);
  console.log("Update from the parent, parmeter update");
  console.log(selectedItem);
  plantSamplingComparsionStore.$patch({
    selectedMachines: {
      parameters: {
        SelectedParmeter: selectedItem.value
      }
    }
  })
  console.log("plantSamplingComparsionStore.SelectedParmeter", plantSamplingComparsionStore.selectedMachines.parameters.SelectedParmeter);

  // Getting the Initial Latest Data from the backend - Start

  const machineName = plantSamplingComparsionStore.selectedMachines.name;
  const parameterName = plantSamplingComparsionStore.selectedMachines.parameters.SelectedParmeter;
  console.log("From data after parameter update", plantSamplingComparsionStore.selectedMachines.selectedDatesDict.from.getTime()); // Get the start time from the Pinia store
  // Here for some reason, the dates are stored as object, hence we need to use the method getTime(), 
  // Even though the dates are stored as epoch timestamp initially.
  const startTime = plantSamplingComparsionStore.selectedMachines.selectedDatesDict.from.getTime(); // Get the start time from the Pinia store
  const endTime = plantSamplingComparsionStore.selectedMachines.selectedDatesDict.to.getTime(); // Get the end time from the Pinia store

  try {
    const processedData = await fetchMachineParameterData(machineName, parameterName, startTime, endTime);
    
    // Process the response data as needed
    console.log(processedData);    
    chartData2.value = processedData;
    console.log("got initial data from the backend");
    console.log(processedData);

  } catch (error) {
    console.error('Error fetching data:', error);
  }

  // Getting the Initial Latest Data from the backend - End

};



onBeforeMount(async () => {
  console.log("Creating the polling");
  await plantSamplingComparsionStore.fetchAndUpdateAvailableMachines();
  machineDropdownProps.value.items = plantSamplingComparsionStore.availableMachines;
  console.log("test", machineDropdownProps.value.items);
});

const parameterDropdownProps = ref({
  items: [
                      "actual_production_time_cumulative",
                      "actual_production_time_current_day",
                      "actual_production_time_current_shift",
                      "availability_cumulative",
                      "availability_current_day",
                      "availability_current_shift",
                      "bad_part_count_cumulative",
                      "bad_part_count_current_day",
                      "bad_part_count_current_shift",
                      "execution_mode",
                      "good_part_count_cumulative",
                      "good_part_count_current_day",
                      "good_part_count_current_shift",
                      "ideal_production_time_cumulative",
                      "ideal_production_time_current_day",
                      "ideal_production_time_current_shift",
                      "machine_status",
                      "oee_cumulative",
                      "oee_current_day",
                      "oee_current_shift",
                      "performance_cumulative",
                      "performance_current_day",
                      "performance_current_shift",
                      "planned_production_time_cumulative",
                      "planned_production_time_current_day",
                      "planned_production_time_current_shift",
                      "program_status",
                      "quality_cumulative",
                      "quality_current_day",
                      "quality_current_shift",
                      "total_part_count_cumulative",
                      "total_part_count_current_day",
                      "total_part_count_current_shift"
                    ]
});

const machineDropdownProps = ref({
  items: ["machine_1",
          "machine_2",
          "machine_3"]
});

</script>

<!-- Template -->

<template>
  <LayoutAuthenticated>
    <SectionMain>
      
      <div class="grid grid-cols-2 gap-2">
        <div>
          <label class="block mb-2 text-gray-700">Machine</label>
          <DropDownMultiSelectMachinePrimeVue  @item-selected-update-machine="handleSelectedMachinesUpdate"
           :items="machineDropdownProps.items" />
        </div>

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

      <BlurryHorizontalDivider />
      
      <CardBox class="mb-8">
        <div>
          <TimeSeriesPlotly class="h-96" />
        </div>
      </CardBox>

      <!-- Main Line Chart: End -->

<!--       
      <div>
          <StateChangeChart class="h-96" />
      </div>
      <BlurryHorizontalDivider />
      <BlurryHorizontalDivider />
      <BlurryHorizontalDivider /> -->

    </SectionMain>
  </LayoutAuthenticated>
</template>
