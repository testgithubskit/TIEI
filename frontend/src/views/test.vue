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


import CardBoxWidgetPlainWrap from "@/components/CardBoxWidgetPlainWrap.vue";

import ParitoChartCountJs from "../components/Charts/ParitoChartCountJs.vue";

import ParitoChartTimeSpanJs from "../components/Charts/ParitoChartTimeSpanJs.vue";

//Importing Store Statements

import { useMachineSamplingWithLimitsStore } from '@/stores/MachineSamplingWithLimitsStore'; 
import { useRouter } from 'vue-router';

const router = useRouter();

const machineSamplingWithLimitsStore = useMachineSamplingWithLimitsStore();


const warningInput = ref(machineSamplingWithLimitsStore.warningLimit);
const criticalInput = ref(machineSamplingWithLimitsStore.criticalLimit);

const updateWarning = () => {
  const warningLimit = parseFloat(warningInput.value);
  if (!isNaN(warningLimit)) {
    machineSamplingWithLimitsStore.updateLimits("warning_limit", warningLimit);
  }
};

const updateCritical = () => {
  const criticalLimit = parseFloat(criticalInput.value);
  if (!isNaN(criticalLimit)) {
    machineSamplingWithLimitsStore.updateLimits("critical_limit", criticalLimit);
  }
};


let chartData = computed(() => {
  return machineSamplingWithLimitsStore.chartData;
});

let warningLimit = computed(() => {
  return machineSamplingWithLimitsStore.warningLimit;
});

let criticalLimit = computed(() => {
  return machineSamplingWithLimitsStore.criticalLimit;
});

let hoverData = computed(() => {
  return machineSamplingWithLimitsStore.hoverData;
});

function subtractHours(date, hours) {
  date.setHours(date.getHours() - hours);

  return date;
}

let currentDate = new Date();

machineSamplingWithLimitsStore.selectedDates.to = currentDate.getTime();

let oneHourEarlier = subtractHours(currentDate, 1);
let formattedDateOneHourEarlier = oneHourEarlier.getTime();

machineSamplingWithLimitsStore.selectedDates.from = formattedDateOneHourEarlier;

const handleQuerySubmit = async () => {
  // Getting the Initial Latest Data from the backend - Start
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


function OnHoverCallBack(hoverData){
  console.log("hover parent");
  console.log(hoverData);
  let dateTime = convertEpochToLocal(hoverData[0]["xval"]);
  let newHoverData = {
      "xAxisValue": dateTime,
      "yAxisValue": hoverData[0]["yval"],
      "xAxisLabel": machineSamplingWithLimitsStore.hoverData.xAxisLabel,
      "yAxisLabel": machineSamplingWithLimitsStore.hoverData.yAxisLabel,
      "xAxisUnits": machineSamplingWithLimitsStore.hoverData.xAxisUnits,
      "yAxisUnits": machineSamplingWithLimitsStore.hoverData.yAxisUnits
    }
  machineSamplingWithLimitsStore.hoverData = newHoverData;
}

let chDa = [
    {
        "message": "abc 1",
        "total_count": 5
    },{
        "message": "abc 2",
        "total_count": 4
    },{
        "message": "abc 3",
        "total_count": 3
    },
    ];

let chDa2 = [
    {
        "message": "abc 1",
        "total_time": 10
    },{
        "message": "abc 2",
        "total_time": 8
    },{
        "message": "abc 3",
        "total_time": 5
    },
    ];
</script>

<template>
  <LayoutAuthenticatedSimple>
    <SectionMain>
      <div class="container mx-auto flex flex-col space-y-4">

        <CardBox class="mb-8">
          <div class="w-full">
            <ParitoChartCountJs class="w-full h-[60vh]" :data="chDa" />
          </div>
        </CardBox>      

        <CardBox class="mb-8">
          <div class="w-full">
            <ParitoChartTimeSpanJs class="w-full h-[60vh]" :data="chDa2" />
          </div>
        </CardBox>   

        <BlurryHorizontalDivider />
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

</style>../components/Charts/ParitoChartCountJs.vue
