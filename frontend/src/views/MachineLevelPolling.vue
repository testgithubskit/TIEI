<script setup>
import { computed, ref, onMounted, onBeforeMount, watch, onBeforeUnmount } from "vue";
import { useMainStore } from "@/stores/main";
import {
  mdiCoffeeMaker,
  mdiChartTimelineVariant,
  mdiGithub,
} from "@mdi/js";

import axios from 'axios';

import * as chartConfig from "@/components/Charts/chart.config.js";
import DropDown from "@/components/DropDown.vue";
import SectionMain from "@/components/SectionMain.vue";
import BaseButton from "@/components/BaseButton.vue";
import LayoutAuthenticated from "@/layouts/LayoutAuthenticated.vue";
import SectionTitleLineWithButton from "@/components/SectionTitleLineWithButton.vue";
import BlurryHorizontalDivider from "@/components/BlurryHorizontalDivider.vue";


//Importing Store Statements

import { useHomeStore } from '@/stores/homeStore'; 

const homeStore = useHomeStore();

const chartData = ref(null);

console.log("From polling");


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

const fillChartData = () => {
  chartData.value = chartConfig.sampleChartData();
};

const machineName = 'ams_mcv_450';

// let machineName =  computed(() => {
//   return homeStore.selectedMachine.name;
// });

const baseUrl = 'http://172.18.100.87:8000/api/v1/machines/';

// Using string interpolation
const url = `${baseUrl}${encodeURIComponent(machineName)}`;

const fetchData = () => {
  axios.get(url)
    .then(response => {
      const backendSections = response.data.sections;

      // Update specific fields of homeStore.sections based on backendSections
      backendSections.forEach(backendSection => {
        const section = homeStore.sections.find(
          section => section.sectionName === backendSection.sectionName
        );

        if (section) {
          backendSection.subSections.forEach(backendSubSection => {
            const subSection = section.subSections.find(
              subSection => subSection.subSectionName === backendSubSection.subSectionName
            );

            if (subSection) {
              backendSubSection.components.forEach(backendComponent => {
                const component = subSection.components.find(
                  component => component.label === backendComponent.label
                );

                if (component) {
                  // Update the value of the component
                  component.value = backendComponent.value;
                }
              });
            }
          });
        }
      });
      console.log("Updated Data");
    })
    .catch(error => {
      console.error('Error fetching data:', error);
    });
};


onBeforeMount(async () => {
  console.log("Creating the polling");
  await homeStore.fetchAndUpdateAvailableMachines();
  machineSelectionbutton.value.label = homeStore.availableMachines[0];
  machineSelectionbutton.value.menu = homeStore.availableMachines.map(machine => ({ label: machine }));
  console.log("machineSelectionbutton", machineSelectionbutton.value);
});

onMounted(async () => {
  console.log("Mounting the polling");

  // Fetch data initially
  fetchData();

  // Fetch data every 5 seconds
  const intervalId = setInterval(() => {
    fetchData();
  }, 5000);

  // Store the interval ID in a variable accessible to onBeforeUnmount
  // This is necessary to clear the interval when the component is unmounted
  // Otherwise, the interval will continue even after the component is destroyed
  // and may lead to memory leaks or unexpected behavior
  // You can store intervalId in the ref if needed in the component
  // or directly as a variable if you don't need to access it in the component
  // beyond this lifecycle hook.
  // For example, if you use a ref:
  // intervalIdRef.value = intervalId;

  // If you need access to intervalId in the component,
  // you can declare a ref at the top of your script setup and assign intervalId to it.

  // For example:
  // const intervalIdRef = ref(null);
  // intervalIdRef.value = intervalId;

  // Alternatively, you can use a simple variable to store the interval ID:
  // let intervalId;

  // Clear the interval when the component is unmounted
  onBeforeUnmount(() => {
    clearInterval(intervalId);
    console.log("Unmounting the polling");
  });
});

const mainStore = useMainStore();

const clientBarItems = computed(() => mainStore.clients.slice(0, 1));

const transactionBarItems = computed(() => mainStore.history);

const getGridColumnsClass = computed(() => {
  return (length) => {
    return `grid grid-cols-1 gap-6 lg:grid-cols-${length} mb-6`;
  };
});


const handleSelectedItemUpdate = (selectedItem) => {
  // Update the necessary property in the store using the imported Pinia store instance
  //homeStore.updateSelectedItem(selectedItem);
  console.log("Update from the parent");
  console.log(selectedItem);
  homeStore.$patch({
    selectedMachine: {
      name: selectedItem.label
    }
  })
};

</script>

<template>
  <LayoutAuthenticated>
    <SectionMain>
      <SectionTitleLineWithButton
        :icon="mdiChartTimelineVariant"
        title="Machine Name:"
        main
      >
      <DropDown @item-selected="handleSelectedItemUpdate" :item="machineSelectionbutton" />
      </SectionTitleLineWithButton>
      <!-- <TestButton /> -->
      <BlurryHorizontalDivider />
      <div
        v-for="Section in homeStore.sections"
        :key="Section.SectionName"
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
              :label="subSection.subSectionName"
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
              :parameterValue="component.value"
              :icon="component.icon"
              :borderSide="component.borderSide"
              :borderThickness="component.borderThickness"
            />
          </div>
        </div>
      
        <BlurryHorizontalDivider />

      </div>
      
      <BlurryHorizontalDivider />
    </SectionMain>
  </LayoutAuthenticated>
</template>
