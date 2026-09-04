<script setup>
import { computed, ref, onBeforeMount } from "vue";

import DyLineChartMultiple from "@/components/Charts/DyLineChartMultiple.vue";
import TimePickerFlatEmitter from "@/components/TimePickerFlatEmitter.vue";
import SectionMain from "@/components/SectionMain.vue";
import CardBox from "@/components/CardBox.vue";
import BaseButton from "@/components/BaseButton.vue";
import GraphLegend from "@/components/GraphLegend.vue";
import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";
import BlurryHorizontalDivider from "@/components/BlurryHorizontalDivider.vue";
import DropDownMultiSelectPrimeVue from "@/components/DropDownMultiSelectPrimeVue.vue";
import SteplineChartPosition from "@/components/Charts/SteplineChartPosition.vue";


import CardBoxWidgetPlainWrap from "@/components/CardBoxWidgetPlainWrap.vue";

//Importing Store Statements

import { useSpecialPurposeMachinePositionStore } from '@/stores/SpecialPurposeMachinePositionStore'; 
import { useRouter } from 'vue-router';

const router = useRouter();

const selectedParameters = ref([]);

const specialPurposeMachinePositionStore = useSpecialPurposeMachinePositionStore();
const chartdata = specialPurposeMachinePositionStore.chartData


const warningInput = ref(specialPurposeMachinePositionStore.warningLimit);
const criticalInput = ref(specialPurposeMachinePositionStore.criticalLimit);

const updateWarning = () => {
  const warningLimit = parseFloat(warningInput.value);
  if (!isNaN(warningLimit)) {
    specialPurposeMachinePositionStore.updateLimits("warning_limit", warningLimit);
  }
};

const updateCritical = () => {
  const criticalLimit = parseFloat(criticalInput.value);
  if (!isNaN(criticalLimit)) {
    specialPurposeMachinePositionStore.updateLimits("critical_limit", criticalLimit);
  }
};


let chartData = computed(() => {
  return specialPurposeMachinePositionStore.chartData;
});

let availableParameters = computed(() => {
  console.log("computing");
  return specialPurposeMachinePositionStore.availableParameters;
});

let warningLimit = computed(() => {
  return specialPurposeMachinePositionStore.warningLimit;
});

let criticalLimit = computed(() => {
  return specialPurposeMachinePositionStore.criticalLimit;
});

let hoverData = computed(() => {
  return specialPurposeMachinePositionStore.hoverData;
});

function subtractHours(date, hours) {
  date.setHours(date.getHours() - hours);

  return date;
}

let currentDate = new Date();

specialPurposeMachinePositionStore.selectedDates.to = currentDate.getTime();

let oneHourEarlier = subtractHours(currentDate, 1);
let formattedDateOneHourEarlier = oneHourEarlier.getTime();

specialPurposeMachinePositionStore.selectedDates.from = formattedDateOneHourEarlier;

const handleQuerySubmit = async () => {
  // Getting the Initial Latest Data from the backend - Start
  
  specialPurposeMachinePositionStore.setSelectedParameters(selectedParameters.value);
  console.log("Selected Parameters:", specialPurposeMachinePositionStore.selectedParameters);
  
  specialPurposeMachinePositionStore.updateSelectedParts(selectedPartSearch.value);
  console.log("Selected Parts:", specialPurposeMachinePositionStore.selectedParts);

    // Log selected parts
   // Log selected parts from the "Selected Parts" section
  //  console.log("Selected Parts:", selectedPartSearch.value);
  await specialPurposeMachinePositionStore.fetchMachineParameterData();
  
};

const handleBack = async () => {
  
  router.push('/spm-overview')
};




const handleFromDateChange = (dateValue) => {
  // Handle the "from" date change event here
  // Perform any additional actions as needed
  specialPurposeMachinePositionStore.selectedDates.from = dateValue.value;
};

const handleToDateChange = (dateValue) => {
  // Handle the "to" date change event here
  // Perform any additional actions as needed
  specialPurposeMachinePositionStore.selectedDates.to = dateValue.value;
};

onBeforeMount(async () => {
  console.log("sampling on mount");
  specialPurposeMachinePositionStore.fetchMachineParameterList();
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


function OnHoverCallBack(hoverData){
  console.log("hover parent");
  console.log(hoverData);
  let dateTime = convertEpochToLocal(hoverData[0]["xval"]);
  let newHoverData = {
      "xAxisValue": dateTime,
      "yAxisValue": hoverData[0]["yval"],
      "xAxisLabel": specialPurposeMachinePositionStore.hoverData.xAxisLabel,
      "yAxisLabel": specialPurposeMachinePositionStore.hoverData.yAxisLabel,
      "xAxisUnits": specialPurposeMachinePositionStore.hoverData.xAxisUnits,
      "yAxisUnits": specialPurposeMachinePositionStore.hoverData.yAxisUnits
    }
  specialPurposeMachinePositionStore.hoverData = newHoverData;
}


//Search



const searchQuery = ref('');
const searchResults = ref([]); // Initialize as an empty array
let debounceTimer = null;
const selectedPartSearch = ref([]);
const Parts = ref([]);



const handleSearch = () => {
  
  clearTimeout(debounceTimer);
  debounceTimer = setTimeout(() => {
    if (searchQuery.value.trim().length < 2) {
      searchResults.value = [];
      return;
    }

    // Adjust URL according to your backend endpoint
    const url = `/spm/laser/${specialPurposeMachinePositionStore.machine}/similar-part?part_number=${searchQuery.value}`;

    fetch(url)
      .then(response => response.json())
      .then(data => {
        // Assuming data is an object with a 'data' property containing the results array
        searchResults.value = data.data || [];

        // selectedPartSearch.value = data.data.map(item => item.name);
      })
      .catch(error => console.error('Error fetching search results:', error));
  }, 300); // Adjust debounce time as needed
};

// Function to handle the click event when a parameter is clicked from the search results
// const handleResultClick = (result) => {
//   // Check if the parameter is already in the selectedParameters array
//   if (!Parts.value.includes(result)) {
//     // Add the parameter to the selectedParameters array
//     Parts.value.push(result);
//   }
//   console.log("selctedddddddddd")
//   console.log(Parts.value)
// };


// Handle result click to add part
const handleResultClick = (result) => {
  if (!Parts.value.includes(result)) {
    Parts.value.push(result);
    // Update selectedPartSearch to reflect new selection
    selectedPartSearch.value.push(result);
  }
};


// Handle document click to close search results
document.addEventListener('click', (event) => {
  const searchContainer = document.querySelector('.search-container');
  if (searchContainer && !searchContainer.contains(event.target)) {
    searchResults.value = []; // Clear search results when clicking outside
  }
});



// const handleParameterUncheck = (part) => {
//   // Check if the parameter is in the selectedPartSearch array
//   const index = selectedPartSearch.value.indexOf(part);
//   if (index !== -1) {
//     // Toggle the selection state instead of removing the parameter
//     selectedPartSearch.value[index].selected = !selectedPartSearch.value[index].selected;
//   }
// };

// Define redirectToPosition method to handle the "Position" button click
const redirectToDetails = () => {
  router.push('/spm-detail');
};



</script>

<template>
  <LayoutAuthenticatedSimple>
    <SectionMain>
      <div class="container mx-auto flex flex-col space-y-4">

        <div class="w-auto h-8 flex">
          <!-- <BaseButton type="submit" color="infolightDark" label="Back" @click="handleBack" /> -->
          <div class="flex flex-col items-center justify-end ml-8">
            <BaseButton type="submit" color="info" label="TIME-SERIES"  @click="redirectToDetails" />
          </div>
          
        </div>

        <div v-if="specialPurposeMachinePositionStore.alertMessage" 
        :class="{ 'alert': true, 'bg-emerald-500 border-black': specialPurposeMachinePositionStore.isSuccessMessage,
        'bg-red-600 border-black': !specialPurposeMachinePositionStore.isSuccessMessage }">
          {{ specialPurposeMachinePositionStore.alertMessage }}
        </div>

        <BlurryHorizontalDivider />
        <!-- Display machine information Start -->
        <div class="grid grid-cols-1 gap-2 lg:grid-cols-4 mb-6 ml-24">
          <CardBoxWidgetPlainWrap 
          label="Machine Name"
          :parameter-value="specialPurposeMachinePositionStore.machine"
          class="">
          </CardBoxWidgetPlainWrap>
          
            <!-- Search input and results -->
        <div  class="search-container relative w-64 mt-10 ml-4 ">
          <input v-model="searchQuery" type="text" placeholder="Search..." @input="handleSearch" class="border border-gray-300 rounded-md px-3 py-2 w-full">
          <ul v-if="searchResults && searchResults.length > 0" class="absolute top-full left-0 w-full bg-white border border-gray-300 rounded-md -mt-14 overflow-auto max-h-24  ">
            <li v-for="(result, index) in searchResults" :key="index" @click="handleResultClick(result)" class="px-3 py-2 cursor-pointer hover:bg-gray-100">{{ result }}</li>
          </ul>
        </div>
         

           
          
          <CardBoxWidgetPlainWrap label="Parameters :" class="w-auto -ml-10  h-36">
             <!-- New div to display available parameters -->
            <div class="overflow-auto max-h-20">
              <div v-for="(parameter, index) in availableParameters" :key="index">
                <!-- Apply dynamic class based on parameter's item_state -->
                <div :class="{'text-green-500': parameter.item_state === 'OK', 'text-yellow-500': parameter.item_state === 'WARNING', 'text-red-500': parameter.item_state === 'CRITICAL', 'opacity-50': selectedParameters.length >= 3 && !selectedParameters.includes(parameter.name)}">
                  <input type="checkbox" :id="'parameter_' + index" v-model="selectedParameters" :value="parameter.name" :disabled="selectedParameters.length >= 3 && !selectedParameters.includes(parameter.name)">
                  <label :for="'parameter_' + index" class="ml-2">{{ parameter.name }}</label>
                </div>
              </div>
            </div>
          </CardBoxWidgetPlainWrap>
          
          
  

   <!-- Selected Parts Section -->
   
          <CardBoxWidgetPlainWrap label="Selected Parts :" class="w-76 h-36">
            <div class="overflow-auto max-h-20">
              <div v-for="(part, index) in Parts" :key="'selected_' + index">
                <div>
                  <input type="checkbox" :id="'selected_part_' + index" v-model="selectedPartSearch" :value="part" :disabled="selectedPartSearch.length >= 3 && !selectedPartSearch.includes(part)">
                  <label :for="'selected_part_' + index" class="ml-2">{{ part }}</label>
                </div>
              </div>
            </div>
          </CardBoxWidgetPlainWrap>
      

        

  



          
          

          
        </div>

        

        <div class="flex justify-center">
          <!-- <BlurryHorizontalDivider /> -->
        <div class="flex flex-col items-center justify-end mt-8 ">
            <BaseButton type="submit" color="info" label="Submit" @click="handleQuerySubmit" />
          </div>
          <!-- <div>
            <label class="block mb-2 text-gray-700">From</label>
            <TimePickerFlatEmitter :defaultDatetime="subtractHours(new Date(), 1)" type="from" @date-change="handleFromDateChange" />
          </div>

          <div class="ml-8">
            <label class="block mb-2 text-gray-700">To</label>
            <TimePickerFlatEmitter :defaultDatetime="new Date()" type="to" @date-change="handleToDateChange" />
          </div> -->

          <!-- <div class="flex flex-col items-center justify-end ml-8">
            <BaseButton type="submit" color="info" label="Submit" @click="handleQuerySubmit" />
          </div> -->
        </div>

        <BlurryHorizontalDivider />

        <CardBox class="mb-8">
         
          <div>
    <h1>Stepline Chart</h1>
    <SteplineChartPosition :data="chartData" />
  </div>
        </CardBox>      

        <BlurryHorizontalDivider />
        <!-- <GraphLegend :data="hoverData"></GraphLegend> -->
      </div>

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

.search-container {
  position: relative;
}

</style>
@/stores/SpecialPurposeMachine