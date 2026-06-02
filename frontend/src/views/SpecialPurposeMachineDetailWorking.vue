<script setup>
import { computed, ref, onBeforeMount } from "vue";

import DyLineChartWithLimits from "@/components/Charts/DyLineChartWithLimits.vue";
import TimePickerFlatEmitter from "@/components/TimePickerFlatEmitter.vue";
import SectionMain from "@/components/SectionMain.vue";
import CardBox from "@/components/CardBox.vue";
import BaseButton from "@/components/BaseButton.vue";
import GraphLegend from "@/components/GraphLegend.vue";
import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";
import BlurryHorizontalDivider from "@/components/BlurryHorizontalDivider.vue";
import DropDownMultiSelectPrimeVue from "@/components/DropDownMultiSelectPrimeVue.vue";


import CardBoxWidgetPlainWrap from "@/components/CardBoxWidgetPlainWrap.vue";

//Importing Store Statements

import { useSpecialPurposeMachineDetailStore } from '@/stores/SpecialPurposeMachineDetailStore'; 
import { useRouter } from 'vue-router';

const router = useRouter();

const specialPurposeMachineDetailStore = useSpecialPurposeMachineDetailStore();


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


let chartData = computed(() => {
  return specialPurposeMachineDetailStore.chartData;
});

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
  await specialPurposeMachineDetailStore.fetchMachineParameterData();
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
        <div class="grid grid-cols-1 gap-6 lg:grid-cols-5 mb-6">
          <CardBoxWidgetPlainWrap 
          label="Machine Name"
          :parameter-value="specialPurposeMachineDetailStore.machine">
          </CardBoxWidgetPlainWrap>
          <CardBoxWidgetPlainWrap label="Warning Limit:">
            <div class="flex flex-row">
              <div class="relative mt-2">
                <input v-model="warningInput" type="number" class="w-full h-8 p-2 border-2 border-black rounded-lg" />
              </div>
              <button @click="updateWarning" class="text-blue-500  mx-2 mt-2">
                <img class="w-12" src="@/assets/icons/update.svg " alt="">
              </button>
            </div>
          </CardBoxWidgetPlainWrap>

          <CardBoxWidgetPlainWrap label="Critical Limit:">
            <div class="flex flex-row">
              <div class="relative mt-2">
                <input v-model="criticalInput" type="number" class="w-full h-8 p-2 border-2 border-black rounded-lg" />
              </div>
              <button @click="updateCritical" class="text-blue-500 mx-2 mt-2">
                <img class="w-12" src="@/assets/icons/update.svg " alt="">
              </button>
            </div>
            
          </CardBoxWidgetPlainWrap>
          <DropDownMultiSelectPrimeVue :parameters="availableParameters" />
        </div>

        <BlurryHorizontalDivider />

        <div class="flex justify-normal">
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

        <CardBox class="mb-8">
          <div>
            <DyLineChartWithLimits :data="chartData" 
            :warningLimit="warningLimit"
            :criticalLimit="criticalLimit"
            class="h-96"
            @data-hovered="OnHoverCallBack" />
          </div>
        </CardBox>      

        <BlurryHorizontalDivider />
        <GraphLegend :data="hoverData"></GraphLegend>
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
