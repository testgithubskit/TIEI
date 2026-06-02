<script setup>
import { computed, onMounted, onBeforeMount, onBeforeUnmount, ref} from "vue";
import {
  mdiChartTimelineVariant,
  mdiGithub,
} from "@mdi/js";

import SectionMain from "@/components/SectionMain.vue";
import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";
import SectionTitleLineWithButton from "@/components/SectionTitleLineWithButton.vue";
import BaseButton from "@/components/BaseButton.vue";
import BlurryHorizontalDivider from "@/components/BlurryHorizontalDivider.vue";
import ProductionLineWithSingleMachine from "@/components/ProductionLineWithSingleMachine.vue";


//Importing Store Statements

import { useSparePollStore } from '@/stores/SparePollStore'; 

import { useSparePartDetailStore } from '@/stores/SparePartDetailStore'; 


const sparePartDetailStore = useSparePartDetailStore();


import { useRouter } from 'vue-router';

const router = useRouter();

let isLoading = ref(false);

const sparePollStore = useSparePollStore();


let selectedParameterGroupInfo = computed(() => {
  return sparePollStore.spareData;
});

const groupCount = computed(() => {
  return sparePollStore.spareData.count;
});

const totalMachines = computed(() => { 
  return groupCount.value.OK + groupCount.value.WARNING + groupCount.value.CRITICAL;
});

const getGridColumnsClass = computed(() => {
  return (length) => {
    return `grid grid-cols-3 gap-6 lg:grid-cols-${length} mb-6`;
  };
});



const combinedLabel = (subSectionName) => {
  return `${subSectionName} : ${totalMachines.value}`;
};


onBeforeMount(async () => {
  await sparePollStore.fetchInitialPageData();
});


onMounted(async () => {
  // Create a variable to store the interval ID
  let intervalId;

  // Set up the interval and store the ID
  intervalId = setInterval(() => {
    isLoading.value = true; // Set loading to true before fetching data
    sparePollStore.updateStateData();
    setTimeout(() => {
      isLoading.value = false; // Set loading to false after 1 second
    }, 2000);
  }, 10000);

  onBeforeUnmount(() => {
    console.log("Clearing");
    // Clear the interval when the component is unmounting
    clearInterval(intervalId);
  });

});


const handleMachineParameterClick = async (clickedParameter) => {
  // Perform any necessary actions with the updated parameters
  // machineSamplingWithLimitsStore.machine = clickedParameter.machineName;
  // machineSamplingWithLimitsStore.actualParameterName = clickedParameter.actualParameterName;;

  // machineSamplingWithLimitsStore.parameterGroup = sparePollStore.SelectedParmeter.item_name;

  // machineSamplingWithLimitsStore.refreshTimestamp();
  // await machineSamplingWithLimitsStore.fetchMachineParameterData();
  // router.push('/machine-level-sampling');
  console.log('emit from');
  console.log(clickedParameter);
  sparePartDetailStore.selectedMachine = clickedParameter;
  router.push('/spare-part-detail-view');

};

</script>

<template>
  <LayoutAuthenticatedSimple>
    <SectionMain>
      <div class="container mx-auto flex flex-col space-y-4">
        <div class="w-8 h-8">
          <!-- Add your loading SVG icon here -->
          <img v-if="isLoading" src="@\assets\gifs\loading.gif" alt="Loading...">
        </div>
        <div
        v-for="Section in sparePollStore.sections"
        :key="Section.sectionName"
        >

          <div
            v-for="subSection in Section.subSections"
            :key="subSection.subSectionName"
          >
            <SectionTitleLineWithButton
            :icon="mdiChartTimelineVariant"
            :title="Section.sectionName"
            main
            >
              <BaseButton
                href="https://cmti.res.in/"
                target="_blank"
                :icon="mdiGithub"
                :label="combinedLabel(subSection.subSectionName)"
                color="contrast"
                rounded-full
                small
              />
            </SectionTitleLineWithButton>

            <div :class="getGridColumnsClass(subSection.components.length)">
              <component
                v-for="component in subSection.components"
                :is="component.type"
                :key="component.label"
                :label="component.label"
                :parameterValue="groupCount[component.label]"
                :icon="component.icon"
                :borderSide="component.borderSide"
                :borderThickness="component.borderThickness"
                :state="component.state"
              />
            </div>
          </div>
        
          <BlurryHorizontalDivider />

      </div>
      </div>
      
      <div class="container mx-auto flex flex-col space-y-4">
        <ProductionLineWithSingleMachine
          v-for="line in selectedParameterGroupInfo.group_details"
          :key="line.line_name"
          :lineName="line.line_name"
          :lineState="line.line_state"
          :machines="line.machines"
          :count = "line.count"
          @machine-parameter-clicked="handleMachineParameterClick"
        >
        </ProductionLineWithSingleMachine>
      </div>
    </SectionMain>
  </LayoutAuthenticatedSimple>
</template>
