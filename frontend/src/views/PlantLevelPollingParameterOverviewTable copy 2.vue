<script setup>
import { computed, ref, onMounted, onBeforeMount, watch } from "vue";
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
import ProductionLine from "@/components/ProductionLine.vue";
import Machine from "@/components/Machine.vue";
import DropDownMultiSelectPrimeVue from "@/components/DropDownMultiSelectPrimeVue.vue";
import DropdownMultiCheckTest from "@/components/DropdownMultiCheckTest.vue";
import DataTablePrimeVue from "@/components/DataTablePrimeVue.vue";
import ParameterWithDropDown from "@/components/ParameterWithDropDown.vue";

const productionLines = ref([]);


//Importing Store Statements

import { usePlantPollingStore } from '@/stores/PlantLevelPollingStore'; 

const plantLevelPollingStore = usePlantPollingStore();

console.log("From polling");


const machineName = 'ams_mcv_450';

// let machineName =  computed(() => {
//   return plantLevelPollingStore.selectedMachine.name;
// });

const baseUrl = 'http://172.18.100.87:8000/api/v1/machines/';

// Using string interpolation
const url = `${baseUrl}${encodeURIComponent(machineName)}`;

const fetchData = () => {
  axios.get(url)
    .then(response => {
      const backendSections = response.data.sections;

      // Update specific fields of plantLevelPollingStore.sections based on backendSections
      backendSections.forEach(backendSection => {
        const section = plantLevelPollingStore.sections.find(
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

    try {
    axios.get('http://172.18.100.87:8000/api/v1/get_production_lines').then(response => {
      productionLines.value = response.data;
      console.log("production lines", response.data);
    }).catch(error => {});
    
  } catch (error) {
    console.error('Error fetching data:', error);
  }
};


onBeforeMount(async () => {
  console.log("Creating the polling");
  await plantLevelPollingStore.fetchAndUpdateAvailableMachines();
  machineSelectionbutton.value.label = plantLevelPollingStore.availableMachines[0];
  machineSelectionbutton.value.menu = plantLevelPollingStore.availableMachines.map(machine => ({ label: machine }));
  console.log("machineSelectionbutton", machineSelectionbutton.value);
});

onMounted(async () => {
  console.log("Mounting the polling");

  fetchData(); // Fetch data initially

  // Fetch data every 5 seconds
  setInterval(() => {
    fetchData();
  }, 5000);
});


const getGridColumnsClass = computed(() => {
  return (length) => {
    return `grid grid-cols-1 gap-6 lg:grid-cols-${length} mb-6`;
  };
});


const handleSelectedItemUpdate = (selectedItem) => {
  // Update the necessary property in the store using the imported Pinia store instance
  //plantLevelPollingStore.updateSelectedItem(selectedItem);
  console.log("Update from the parent");
  console.log(selectedItem);
  plantLevelPollingStore.$patch({
    selectedMachine: {
      name: selectedItem.label
    }
  })
};

</script>

<template>
  <LayoutAuthenticated>
    <SectionMain>
      <DropdownMultiCheckTest />
    </SectionMain>
  </LayoutAuthenticated>
</template>
