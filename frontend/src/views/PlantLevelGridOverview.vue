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
import DropDownParameterPrimeVue from "@/components/DropDownParameterPrimeVue.vue";
import ParameterWithDropDown from "@/components/ParameterWithDropDown.vue";
import DropdownMultiCheckTest from "@/components/DropdownMultiCheckTest.vue";
import DropdownSingleSelect from "@/components/DropdownSingleSelect.vue";

const productionLines = ref([]);


//Importing Store Statements

import { usePlantPollingParameterGridStore } from '@/stores/PlantPollingParameterGrid'; 

const plantPollingParamterGrid = usePlantPollingParameterGridStore();

console.log("From polling");


const machineName = 'ams_mcv_450';

const baseUrl = 'http://172.18.100.87:8000/api/v1/machines/';

// Using string interpolation
const url = `${baseUrl}${encodeURIComponent(machineName)}`;

const fetchData = () => {
    try {
    axios.get('http://172.18.100.87:8000/api/v1/get_production_lines').then(response => {
      productionLines.value = response.data;
      console.log("production lines", productionLines.value);
    });
    
  } catch (error) {
    console.error('Error fetching data:', error);
  }
};


onBeforeMount(async () => {
  console.log("Creating the polling");
  await plantPollingParamterGrid.fetchAndUpdateAvailableParameters();
  parameterDropdownProps.value.items = plantPollingParamterGrid.SelectedParmeter.availableParameters;
  console.log("test", parameterDropdownProps.value.items);
});

onMounted(async () => {
  console.log("Mounting the polling");

  fetchData(); // Fetch data initially

  // Fetch data every 5 seconds
  setInterval(() => {
    fetchData();
  }, 5000);
});


const handleSelectedParameterUpdate = async (selectedItem) => {
  // Update the necessary property in the store using the imported Pinia store instance
  //homeStore.updateSelectedItem(selectedItem);
  console.log("Update from the parent");
  console.log(selectedItem);
  plantPollingParamterGrid.$patch({
    SelectedParmeter: {
      name: selectedItem.value
    }
  });
  console.log("plantSamplingOverviewStore.SelectedParmeter", plantPollingParamterGrid.SelectedParmeter.name);
};

const parameterDropdownProps = ref({
  items: []
});

</script>

<template>
  <LayoutAuthenticated>
    <SectionMain>
      <ParameterWithDropDown class="col-span-3"  :icon="mdiChartTimelineVariant" title="Parameter:" main>
          <!-- <DropDown @item-selected="handleSelectedParameterUpdate" :item="parameterSelectionbutton" /> -->
          
          <!-- <DropDownParameterPrimeVue @item-selected-update-parameter="handleSelectedParameterUpdate"
           :items="parameterDropdownProps.items" /> -->
           <DropdownSingleSelect />
      </ParameterWithDropDown>
      <div class="container mx-auto flex flex-col space-y-4">
        <ProductionLine
          v-for="line in productionLines"
          :key="line.id"
          :lineName="line.name"
          :lineState="line.state"
        >
          <Machine
            v-for="machine in line.machines"
            :key="machine.id"
            :label="machine.name"
            :machineState="machine.state"
            :parameterValue="machine.parameter"
          />
        </ProductionLine>
      </div>
    </SectionMain>
  </LayoutAuthenticated>
</template>
