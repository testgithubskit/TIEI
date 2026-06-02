<script setup>
import { computed, ref, onBeforeMount } from "vue";

import DyLineChartMultiple from "@/components/Charts/DyLineChartMultiple.vue";
import SteplineChart from "@/components/Charts/SteplineChart.vue";
import TimePickerFlatEmitter from "@/components/TimePickerFlatEmitter.vue";
import SectionMain from "@/components/SectionMain.vue";
import CardBox from "@/components/CardBox.vue";
import BaseButton from "@/components/BaseButton.vue";
import GraphLegend from "@/components/GraphLegend.vue";
import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";
import BlurryHorizontalDivider from "@/components/BlurryHorizontalDivider.vue";
import DropDownMultiSelectPrimeVue from "@/components/DropDownMultiSelectPrimeVue.vue";
import DropdownSingleSelectMachineSpm from "@/components/DropdownSingleSelectMachineSpm.vue";


import CardBoxWidgetPlainWrap from "@/components/CardBoxWidgetPlainWrap.vue";

//Importing Store Statements

import { useSpecialPurposeMachineDetailStore } from '@/stores/SpecialPurposeMachineDetailStore'; 
import { useRouter } from 'vue-router';

const router = useRouter();

const selectedParameters = ref([]);

const specialPurposeMachineDetailStore = useSpecialPurposeMachineDetailStore();
const chartData = specialPurposeMachineDetailStore.chartData

const warningInput = ref(specialPurposeMachineDetailStore.warningLimit);
const criticalInput = ref(specialPurposeMachineDetailStore.criticalLimit);

const updateWarning = () => {
  const warningLimit = parseFloat(warningInput.value);
  if (!isNaN(warningLimit)) {
    specialPurposeMachineDetailStore.updateLimits("warning_limit", warningLimit);
  }
};

const updateCritical = () => {
  const criticalLimit = parseFloat(criticalInput.value);
  if (!isNaN(criticalLimit)) {
    specialPurposeMachineDetailStore.updateLimits("critical_limit", criticalLimit);
  }
};


let seriesData = computed(() => {
  return specialPurposeMachineDetailStore.seriesData;
});

const seriesArray = [seriesData];
console.log("first series")
console.log(seriesArray)

let availableParameters = computed(() => {
  console.log("computing");
  return specialPurposeMachineDetailStore.availableParameters;
});

let warningLimit = computed(() => {
  return specialPurposeMachineDetailStore.warningLimit;
});

let criticalLimit = computed(() => {
  return specialPurposeMachineDetailStore.criticalLimit;
});

let hoverData = computed(() => {
  return specialPurposeMachineDetailStore.hoverData;
});

function subtractHours(date, hours) {
  date.setHours(date.getHours() - hours);

  return date;
}

let currentDate = new Date();

specialPurposeMachineDetailStore.selectedDates.to = currentDate.getTime();

let oneHourEarlier = subtractHours(currentDate, 1);
let formattedDateOneHourEarlier = oneHourEarlier.getTime();

specialPurposeMachineDetailStore.selectedDates.from = formattedDateOneHourEarlier;

const handleQuerySubmit = async () => {
  // Getting the Initial Latest Data from the backend - Start
  specialPurposeMachineDetailStore.setSelectedParameters(selectedParameters.value);
  console.log("Selected Parameters:", specialPurposeMachineDetailStore.selectedParameters);
 
  await specialPurposeMachineDetailStore.fetchMachineParameterData();
  console.log("updateedddddddddd")
  console.log(specialPurposeMachineDetailStore.chartData)
   
};

const handleBack = async () => {
  const routeObject = { name: 'Factory Level Polling Parameter Overview Grid',
   params: { groupName: specialPurposeMachineDetailStore.parameterGroup } };
  router.push(routeObject);
};


const handleFromDateChange = (dateValue) => {
  // Handle the "from" date change event here
  // Perform any additional actions as needed
  specialPurposeMachineDetailStore.selectedDates.from = dateValue.value;
};

const handleToDateChange = (dateValue) => {
  // Handle the "to" date change event here
  // Perform any additional actions as needed
  specialPurposeMachineDetailStore.selectedDates.to = dateValue.value;
};

onBeforeMount(async () => {
  console.log("sampling on mount");
  specialPurposeMachineDetailStore.fetchMachineParameterList();
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


const machineNames = [
  'Laser Cladding A',
  'JOURNAL FINISH-GRINDING_JOP_105',
  'JOURNAL FINISH-GRINDING_JOP_130',
  'JOURNAL FINISH-GRINDING_JOP_140',
  'Laser Cladding B',
  // Add more machine names as needed
];

const selectedMachine = ref(machineNames[0]);

const handleMachineSelection = async machine => {
  selectedMachine.value = machine;
  specialPurposeMachineDetailStore.setSelectedMachine(machine);
  await specialPurposeMachineDetailStore.fetchMachineParameterList(); // Await for the parameter list to be fetched
  console.log("Machine updated:", specialPurposeMachineDetailStore.selectedMachine.value);
  console.log("Parameters updated:", specialPurposeMachineDetailStore.availableParameters);
};

function OnHoverCallBack(hoverData){
  console.log("hover parent");
  console.log(hoverData);
  let dateTime = convertEpochToLocal(hoverData[0]["xval"]);
  let newHoverData = {
      "xAxisValue": dateTime,
      "yAxisValue": hoverData[0]["yval"],
      "xAxisLabel": specialPurposeMachineDetailStore.hoverData.xAxisLabel,
      "yAxisLabel": specialPurposeMachineDetailStore.hoverData.yAxisLabel,
      "xAxisUnits": specialPurposeMachineDetailStore.hoverData.xAxisUnits,
      "yAxisUnits": specialPurposeMachineDetailStore.hoverData.yAxisUnits
    }
  specialPurposeMachineDetailStore.hoverData = newHoverData;
}
</script>

<template>
  <LayoutAuthenticatedSimple>
    <SectionMain>
      <div class="container mx-auto flex flex-col space-y-4">

        <div class="w-16 h-8">
          <!-- <BaseButton type="submit" color="infolightDark" label="Back" @click="handleBack" /> -->
        </div>

        <div v-if="specialPurposeMachineDetailStore.alertMessage" 
        :class="{ 'alert': true, 'bg-emerald-500 border-black': specialPurposeMachineDetailStore.isSuccessMessage,
        'bg-red-600 border-black': !specialPurposeMachineDetailStore.isSuccessMessage }">
          {{ specialPurposeMachineDetailStore.alertMessage }}
        </div>

        <BlurryHorizontalDivider />
        <!-- Display machine information Start -->
        <div class="grid grid-cols-1 gap-6 lg:grid-cols-5 mb-6 ml-24">
          <DropdownSingleSelectMachineSpm
          :items="machineNames"
          v-model="selectedMachine"
          @item-selected-update-parameter="handleMachineSelection"
          />
          <!-- <div>
    <label for="machines">Select Machine:</label>
    <Dropdown
      v-model="selectedMachine"
      :options="machineOptions"
      optionLabel="label"
      optionValue="value"
      placeholder="Select a machine"
      id="machines"
      @change="handleMachineChange"
    />
  </div> -->
          <CardBoxWidgetPlainWrap 
          label="Machine Name"
          :parameter-value="specialPurposeMachineDetailStore.machine"
          class="h-36">
          </CardBoxWidgetPlainWrap>
          <CardBoxWidgetPlainWrap label="Warning Limit:" class="h-36">
            <div class="flex flex-row">
              <div class="relative mt-2">
                <input v-model="warningInput" type="number" class="w-full h-8 p-2 border-2 border-black rounded-lg" />
              </div>
              <button @click="updateWarning" class="text-blue-500  mx-2 mt-2">
                <img class="w-12" src="@/assets/icons/update.svg " alt="">
              </button>
            </div>
          </CardBoxWidgetPlainWrap>

          <CardBoxWidgetPlainWrap label="Critical Limit:" class="h-36">
            <div class="flex flex-row">
              <div class="relative mt-2">
                <input v-model="criticalInput" type="number" class="w-full h-8 p-2 border-2 border-black rounded-lg" />
              </div>
              <button @click="updateCritical" class="text-blue-500 mx-2 mt-2">
                <img class="w-12" src="@/assets/icons/update.svg " alt="">
              </button>
            </div>
            
          </CardBoxWidgetPlainWrap>
          <CardBoxWidgetPlainWrap label="Parameters :" class="w-96 h-36">
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
          

          
        </div>

        <BlurryHorizontalDivider />

        <div class="flex justify-center">
          <div>
            <label class="block mb-2 text-gray-700">From</label>
            <TimePickerFlatEmitter :defaultDatetime="subtractHours(new Date(), 1)" type="from" @date-change="handleFromDateChange" />
          </div>

          <div class="ml-8">
            <label class="block mb-2 text-gray-700">To</label>
            <TimePickerFlatEmitter :defaultDatetime="new Date()" type="to" @date-change="handleToDateChange" />
          </div>

          <div class="flex flex-col items-center justify-end ml-8">
            <BaseButton type="submit" color="info" label="Submit" @click="handleQuerySubmit" />
          </div>
        </div>

        <BlurryHorizontalDivider />


        
        <!-- Please take a look at the graph  -->


        <!-- <CardBox class="mb-8">
          <div>
            <DyLineChartMultiple :seriesData="seriesData" 
            :warningLimit="warningLimit"
            :criticalLimit="criticalLimit"
            class="h-96"
            @data-hovered="OnHoverCallBack" />
          </div>
        </CardBox>       -->

        <BlurryHorizontalDivider />
        <!-- <GraphLegend :data="hoverData"></GraphLegend> -->
      </div>

      <div>
    <h1>Stepline Chart</h1>
    <SteplineChart :data="chartData" />
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

</style>
