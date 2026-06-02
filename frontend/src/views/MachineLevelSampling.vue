<script setup>
import { computed, ref, onMounted, watch, onBeforeMount } from "vue";
import { useMainStore } from "@/stores/main";
import {
  mdiChartTimelineVariant,
  mdiCoffeeMaker
} from "@mdi/js";

import axios from 'axios';

import LineChartDyGraph from "@/components/Charts/LineChartDyGraph.vue";
import StateChangeChart from "@/components/Charts/StateChangeChart.vue";
import DropDown from "@/components/DropDown.vue";
import TimePickerFlat from "@/components/TimePickerFlat.vue";
import SectionMain from "@/components/SectionMain.vue";
import CardBox from "@/components/CardBox.vue";
import BaseButton from "@/components/BaseButton.vue";
import LayoutAuthenticated from "@/layouts/LayoutAuthenticated.vue";
import ParameterWithDropDown from "@/components/ParameterWithDropDown.vue";
import BlurryHorizontalDivider from "@/components/BlurryHorizontalDivider.vue";
import { use } from 'echarts/core';
import { TooltipComponent, GridComponent, BarChart } from 'echarts/components';
import { CanvasRenderer } from 'echarts/renderers';
import VChart from 'vue-echarts';

use([TooltipComponent, GridComponent, BarChart, CanvasRenderer]);

//Importing Store Statements

import { useMachineSamplingStore } from '@/stores/MachineSamplingStore'; 

const machineSamplingStore = useMachineSamplingStore();


// Reactive reference for chart data
const stateChartData = ref([]);

// Cycle time specific state
const isCycleTimeSelected = ref(false);
const cycleTimeData = ref(null);
const cycleTimeChartData = ref([]);
const cycleTimeLimits = ref({ warning: 60, critical: 90 });

// Computed property for cycle time bar chart option
const cycleTimeChartOption = computed(() => {
  if (!cycleTimeChartData.value || cycleTimeChartData.value.length === 0) {
    return {};
  }

  const times = cycleTimeChartData.value.map(item => item.time);
  const cycleTimes = cycleTimeChartData.value.map(item => item.cycle_time);

  return {
    tooltip: {
      trigger: 'axis',
      axisPointer: {
        type: 'shadow'
      },
      formatter: function(params) {
        return `${params[0].axisValue}<br/>Cycle Time: ${params[0].value}s`;
      }
    },
    grid: {
      top: '10%',
      left: '3%',
      right: '4%',
      bottom: '15%',
      containLabel: true
    },
    xAxis: {
      type: 'category',
      data: times,
      axisLabel: {
        rotate: 45,
        interval: 0,
        textStyle: {
          fontSize: 10
        }
      }
    },
    yAxis: {
      type: 'value',
      name: 'Cycle Time (seconds)'
    },
    series: [{
      name: 'Cycle Time',
      type: 'bar',
      data: cycleTimes,
      itemStyle: {
        color: function(params) {
          if (params.value >= cycleTimeLimits.value.critical) {
            return '#ef4444'; // red for critical
          } else if (params.value >= cycleTimeLimits.value.warning) {
            return '#f59e0b'; // orange for warning
          } else {
            return '#22c55e'; // green for OK
          }
        }
      },
      markLine: {
        data: [
          {
            yAxis: cycleTimeLimits.value.warning,
            label: {
              formatter: 'Warning Limit'
            },
            lineStyle: {
              color: '#f59e0b',
              type: 'dashed'
            }
          },
          {
            yAxis: cycleTimeLimits.value.critical,
            label: {
              formatter: 'Critical Limit'
            },
            lineStyle: {
              color: '#ef4444',
              type: 'dashed'
            }
          }
        ]
      }
    }]
  };
});

// Check URL parameters for cycle time navigation
onMounted(() => {
  console.log("MachineLevelSampling onMounted called");
  console.log("Current URL:", window.location.href);
  console.log("Current hash:", window.location.hash);

  // Try both hash query params and regular query params
  const hash = window.location.hash;
  const queryIndex = hash.indexOf('?');
  let machineParam = null;
  let parameterParam = null;

  if (queryIndex !== -1) {
    const queryString = hash.substring(queryIndex + 1);
    const urlParams = new URLSearchParams(queryString);
    machineParam = urlParams.get('machine');
    parameterParam = urlParams.get('parameter');
    console.log("Hash query params - machine:", machineParam, "parameter:", parameterParam);
  }

  // Also try regular search params
  if (!machineParam || !parameterParam) {
    const urlParams = new URLSearchParams(window.location.search);
    machineParam = machineParam || urlParams.get('machine');
    parameterParam = parameterParam || urlParams.get('parameter');
    console.log("Regular search params - machine:", machineParam, "parameter:", parameterParam);
  }

  console.log("Final params - machine:", machineParam, "parameter:", parameterParam);

  if (parameterParam === 'CYCLE_TIME' && machineParam) {
    console.log("CYCLE_TIME detected, setting up cycle time view");
    isCycleTimeSelected.value = true;
    machineSamplingStore.$patch({
      selectedMachine: {
        name: decodeURIComponent(machineParam),
        parameters: {
          SelectedParmeter: 'CYCLE_TIME'
        }
      }
    });
    console.log("Store updated with machine:", machineSamplingStore.selectedMachine.name);
    // Set default time range
    setDefaultTimeRange();
    // Fetch cycle time data
    console.log("Fetching cycle time data...");
    fetchCycleTimeData();
  } else {
    console.log("Not CYCLE_TIME, using regular flow");
  }
});

const setDefaultTimeRange = () => {
  const currentDate = new Date();
  machineSamplingStore.selectedMachine.selectedDatesDict.to = currentDate.getTime();
  const oneHourEarlier = subtractHours(currentDate, 1);
  machineSamplingStore.selectedMachine.selectedDatesDict.from = oneHourEarlier.getTime();
};

// Function to fetch state data from the endpoint
const fetchStateData = async () => {
  try {
    const response = await axios.get('http://172.18.100.87:8000/api/v1/get_machine_state_data');
    const responseData = response.data;

    // Process the response data as needed
    stateChartData.value = responseData;
    console.log("Fetched state data from the backend");
    console.log(stateChartData.value);
  } catch (error) {
    console.error('Error fetching state data:', error);
  }
};

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

  return newDate;
};

// const chartData2 = computed(() => {

//   const selectedFromDate = convertStringToDate(machineSamplingStore.selectedMachine.selectedDates[0]);
//   const selectedToDate = convertStringToDate(machineSamplingStore.selectedMachine.selectedDates[1]);

//   return generateSampleData(selectedFromDate, selectedToDate);

// })

// Watcher to log changes in the date value
watch(machineSamplingStore.selectedMachine.selectedDatesDict, (newValue, oldValue) => {
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
  const selectedFromDate = convertStringToDate(machineSamplingStore.selectedMachine.selectedDates[0]);
  const selectedToDate = convertStringToDate(machineSamplingStore.selectedMachine.selectedDates[1]);

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

machineSamplingStore.selectedMachine.selectedDatesDict.to = currentDate.getTime();

let oneHourEarlier = subtractHours(currentDate, 1);
let formattedDateOneHourEarlier = oneHourEarlier.getTime();

machineSamplingStore.selectedMachine.selectedDatesDict.from = formattedDateOneHourEarlier;


// const handleQuerySubmit = () => {
//   // Handle the click event here
//   console.log("Button clicked");
//   // Perform any additional actions as needed
//   console.log(machineSamplingStore.selectedMachine.selectedDatesDict);
// };


const handleQuerySubmit = async () => {
  // Getting the Initial Latest Data from the backend - Start

  const machineName = machineSamplingStore.selectedMachine.name;
  const parameterName = machineSamplingStore.selectedMachine.parameters.SelectedParmeter;// Get the start time from the Pinia store
  // In the below code we're not using .selectedDatesDict.from.getTime(), for some reason, it is being stored
  // As epochtimestamp itself, unlike the function ``handleSelectedParameterUpdate``, which has the date as object
  // Instead of epoch timestamp
  const startTime = machineSamplingStore.selectedMachine.selectedDatesDict.from; // Get the start time from the Pinia store
  const endTime = machineSamplingStore.selectedMachine.selectedDatesDict.to; // Get the end time from the Pinia store

  try {
    const processedData = await fetchMachineParameterData(machineName, parameterName, startTime, endTime);

    // Process the response data as needed
    chartData2.value = processedData;

  } catch (error) {
    console.error('Error fetching data:', error);
  }
};

const fetchCycleTimeData = async () => {
  try {
    const machineName = machineSamplingStore.selectedMachine.name;
    const fromTime = new Date(machineSamplingStore.selectedMachine.selectedDatesDict.from);
    const toTime = new Date(machineSamplingStore.selectedMachine.selectedDatesDict.to);

    // Format dates as ISO strings with timezone (using space instead of T)
    const fromTimeStr = fromTime.toISOString().replace('T', ' ');
    const toTimeStr = toTime.toISOString().replace('T', ' ');

    const url = `http://172.18.100.87:8000/api/v1/cycle-time/machine/${encodeURIComponent(machineName)}?fromTime=${encodeURIComponent(fromTimeStr)}&toTime=${encodeURIComponent(toTimeStr)}`;

    const response = await axios.get(url);
    cycleTimeData.value = response.data;
    cycleTimeLimits.value = {
      warning: response.data.warning_limit,
      critical: response.data.critical_limit
    };

    // Convert cycle time data to chart format
    cycleTimeChartData.value = response.data.cycle_time_data.map(item => ({
      time: new Date(item.time).toLocaleString(),
      cycle_time: item.cycle_time
    }));

    console.log("Cycle time data:", cycleTimeData.value);
    console.log("Cycle time chart data:", cycleTimeChartData.value);
  } catch (error) {
    console.error('Error fetching cycle time data:', error);
  }
};

const handleCycleTimeSubmit = async () => {
  await fetchCycleTimeData();
};


const handleSelectedMachineUpdate = async (selectedItem) => {
  // Update the necessary property in the store using the imported Pinia store instance
  //homeStore.updateSelectedItem(selectedItem);
  machineSamplingStore.$patch({
    selectedMachine: {
      name: selectedItem.label
    }
  });
  await machineSamplingStore.fetchAndUpdateAvailableParameters();

  parameterSelectionbutton.value.label = machineSamplingStore.availableMachines[0];
  parameterSelectionbutton.value.menu = machineSamplingStore.selectedMachine.parameters.availableParameters.map(parameter => ({ label: parameter }));

};


async function fetchMachineParameterData(machineName, parameterName, startTime, endTime) {
  const url = `http://172.18.100.87:8000/api/v1/machines/${machineName}/parameters/${parameterName}?startTime=${encodeURIComponent(startTime)}&endTime=${encodeURIComponent(endTime)}`;

  try {
    const response = await axios.get(url);
    const responseData = response.data;
    
    // Convert the first element of each array to a JavaScript Date object
    const processedData = responseData.data.map((entry) => {
      const datetimeEpoch = entry[0];
      const value = entry[1];
      const datetimeObject = new Date(datetimeEpoch);
      return [datetimeObject, value];
    });
    
    // Process the response data as needed   
    return processedData;

  } catch (error) {
    console.error('Error fetching data:', error);
    throw error;
  }
}


const handleSelectedParameterUpdate = async (selectedItem) => {
  // Update the necessary property in the store using the imported Pinia store instance
  //homeStore.updateSelectedItem(selectedItem);
  machineSamplingStore.$patch({
    selectedMachine: {
      parameters: {
        SelectedParmeter: selectedItem.label
      }
    }
  })

  // Check if CYCLE_TIME is selected
  isCycleTimeSelected.value = selectedItem.label === 'CYCLE_TIME';

  if (isCycleTimeSelected.value) {
    setDefaultTimeRange();
    await fetchCycleTimeData();
  } else {
    cycleTimeData.value = null;
    cycleTimeChartData.value = [];
  }

  // Getting the Initial Latest Data from the backend - Start

  const machineName = machineSamplingStore.selectedMachine.name;
  const parameterName = machineSamplingStore.selectedMachine.parameters.SelectedParmeter;
  // Here for some reason, the dates are stored as object, hence we need to use the method getTime(), 
  // Even though the dates are stored as epoch timestamp initially.
  const startTime = machineSamplingStore.selectedMachine.selectedDatesDict.from.getTime(); // Get the start time from the Pinia store
  const endTime = machineSamplingStore.selectedMachine.selectedDatesDict.to.getTime(); // Get the end time from the Pinia store

  try {
    const processedData = await fetchMachineParameterData(machineName, parameterName, startTime, endTime);
    
    // Process the response data as needed
    chartData2.value = processedData;

  } catch (error) {
    console.error('Error fetching data:', error);
  }

  // Getting the Initial Latest Data from the backend - End

};



onBeforeMount(async () => {
  await machineSamplingStore.fetchAndUpdateAvailableMachines();
  machineSelectionbutton.value.label = machineSamplingStore.availableMachines[0];
  machineSelectionbutton.value.menu = machineSamplingStore.availableMachines.map(machine => ({ label: machine }));
});


</script>

<!-- Template -->

<template>
  <LayoutAuthenticated>
    <SectionMain>
      
      <div class="grid grid-cols-7 gap-2">
        <ParameterWithDropDown class="col-span-3" :icon="mdiChartTimelineVariant" title="Machine Name:" main>
          <DropDown @item-selected="handleSelectedMachineUpdate" :item="machineSelectionbutton" />
        </ParameterWithDropDown>

        <!-- <div class="min-h-[1em] w-px self-stretch bg-gradient-to-tr from-transparent via-neutral-500 to-transparent opacity-20 dark:opacity-100 col-span-1"></div> -->

        <ParameterWithDropDown class="col-span-3"  :icon="mdiChartTimelineVariant" title="Parameter:" main>
          <DropDown @item-selected="handleSelectedParameterUpdate" :item="parameterSelectionbutton" />
        </ParameterWithDropDown>
      </div>

      
      <!-- <TestButton /> -->
      <BlurryHorizontalDivider />


      <!-- Select Parameter Section: Start -->

      <!-- <SectionTitleLineWithButton
        :icon="mdiChartTimelineVariant"
        title="Parameter:"
        main
      >

      <DropDown @item-selected="handleSelectedParameterUpdate" :item="parameterSelectionbutton" />

      </SectionTitleLineWithButton> -->

      <!-- <BlurryHorizontalDivider /> -->
      
      <!-- Select Parameter Section: End -->

      <!-- Select Date Section: Start -->

      <!-- <DatePicker />
      <BlurryHorizontalDivider /> -->
      
      <!-- Select Date Section: End -->

      <!-- Select Time Section: Start -->

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
          <BaseButton
            type="submit"
            color="info"
            label="Submit"
            @click="isCycleTimeSelected ? handleCycleTimeSubmit() : handleQuerySubmit()"
          />
        </div>
      </div>

      <BlurryHorizontalDivider />

      <!-- Select Time Section: End -->

      <!-- Cycle Time Specific Section -->
      <div v-if="isCycleTimeSelected && cycleTimeData">
        <CardBox class="mb-6">
          <div class="grid grid-cols-2 gap-4">
            <div>
              <h3 class="text-lg font-semibold mb-2">Machine Information</h3>
              <p><strong>Machine Name:</strong> {{ cycleTimeData.machine_name }}</p>
              <p><strong>Parameter Group:</strong> CYCLE_TIME</p>
              <p><strong>Machine State:</strong>
                <span :class="{
                  'text-red-600': cycleTimeData.machine_state === 'CRITICAL',
                  'text-yellow-600': cycleTimeData.machine_state === 'WARNING',
                  'text-green-600': cycleTimeData.machine_state === 'OK'
                }">
                  {{ cycleTimeData.machine_state }}
                </span>
              </p>
            </div>
            <div>
              <h3 class="text-lg font-semibold mb-2">Limits</h3>
              <p><strong>Warning Limit:</strong> {{ cycleTimeData.warning_limit }} seconds</p>
              <p><strong>Critical Limit:</strong> {{ cycleTimeData.critical_limit }} seconds</p>
              <p><strong>Current Cycle Time:</strong> {{ cycleTimeData.cycle_time_value }} seconds</p>
            </div>
          </div>
        </CardBox>

        <CardBox class="mb-6">
          <h3 class="text-lg font-semibold mb-4">Cycle Time vs Time</h3>
          <div class="h-96">
            <v-chart class="h-full" :option="cycleTimeChartOption" autoresize />
          </div>
        </CardBox>
      </div>


      <!-- <SectionTitleLineWithButton :icon="mdiChartPie" title="Part Count">
        <BaseButton
          :icon="mdiReload"
          color="whiteDark"
        />
      </SectionTitleLineWithButton> -->

      <!-- Main Line Chart: Start -->

      <!-- <DropDownFlowBite />
      <BlurryHorizontalDivider />
      <BlurryHorizontalDivider /> -->
      <CardBox v-if="!isCycleTimeSelected" class="mb-8">
        <div>
          <LineChartDyGraph class="h-96" :data="chartData2" />
        </div>
      </CardBox>

      <!-- Main Line Chart: End -->

      <!-- <CardBox class="mb-6">
        <div>
          <PieChartEc class="h-96" />
        </div>
      </CardBox>

      <CardBox class="mb-6">
        <div>
          <BarChartDrillEc class="h-96" />
        </div>
      </CardBox>

      <CardBox class="mb-6">
        <div>
          <BarChartEc class="h-96" />
        </div>
      </CardBox> -->

      <!-- <CardBox class="mb-6">
        <div>
          <GanttChartPlotly />
        </div>
      </CardBox> -->
      <div>
          <StateChangeChart class="h-96" :chartData="stateChartData" />
      </div>
      <BlurryHorizontalDivider />
      <BlurryHorizontalDivider />
      <BlurryHorizontalDivider />

    </SectionMain>
  </LayoutAuthenticated>
</template>
