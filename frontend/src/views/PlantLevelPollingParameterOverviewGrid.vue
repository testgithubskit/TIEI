<script setup>
import { backendApi } from '@/services/apiServices';
import { computed, ref, onMounted, onBeforeMount, watch } from "vue";
import { useMainStore } from "@/stores/main";
import {
  mdiCoffeeMaker,
  mdiChartTimelineVariant,
  mdiGithub,
} from "@mdi/js";


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
const cycleTimeData = ref(null);
const isCycleTimeSelected = ref(false);


//Importing Store Statements

import { usePlantPollingParameterGridStore } from '@/stores/PlantPollingParameterGrid';

const plantPollingParamterGrid = usePlantPollingParameterGridStore();

console.log("From polling");


const machineName = 'ams_mcv_450';

const baseUrl = '/machines/';

// Using string interpolation
const url = `${baseUrl}${encodeURIComponent(machineName)}`;

const fetchData = () => {
    try {
    backendApi.get('/get_production_lines').then(response => {
      productionLines.value = response.data;
      console.log("production lines", productionLines.value);
    });

  } catch (error) {
    console.error('Error fetching data:', error);
  }
};

const fetchCycleTimeData = () => {
  try {
    backendApi.get('/cycle-time/factory-layout').then(response => {
      cycleTimeData.value = response.data;
      console.log("cycle time data", cycleTimeData.value);
    });
  } catch (error) {
    console.error('Error fetching cycle time data:', error);
  }
};

const handleMachineClick = (machineName) => {
  if (isCycleTimeSelected.value) {
    // Navigate to machine-level-sampling page with machine name
    window.location.href = `${window.location.origin}/tiei_dynamic/#/machine-level-sampling?machine=${encodeURIComponent(machineName)}&parameter=CYCLE_TIME`;
  }
};

onBeforeMount(async () => {
  console.log("Creating the polling");
  await plantPollingParamterGrid.fetchAndUpdateAvailableParameters();
  console.log("test", plantPollingParamterGrid.SelectedParmeter.availableParameters);
});

onMounted(async () => {
  console.log("Mounting the polling");

  fetchData(); // Fetch data initially

  // Fetch data every 5 seconds
  setInterval(() => {
    if (!isCycleTimeSelected.value) {
      fetchData();
    } else {
      fetchCycleTimeData();
    }
  }, 5000);
});


const handleSelectedParameterUpdate = async (selectedItem) => {
  // Update the necessary property in the store using the imported Pinia store instance
  //homeStore.updateSelectedItem(selectedItem);
  console.log("Update from the parent");
  console.log(selectedItem);
  if (selectedItem && selectedItem.value) {
    plantPollingParamterGrid.$patch({
      SelectedParmeter: {
        name: selectedItem.value
      }
    });
    console.log("plantSamplingOverviewStore.SelectedParmeter", plantPollingParamterGrid.SelectedParmeter.name);
  }
};

// Watch for parameter selection changes
watch(() => plantPollingParamterGrid.SelectedParmeter.name, (newParameter) => {
  console.log("Parameter changed to:", newParameter);
  isCycleTimeSelected.value = newParameter === 'CYCLE_TIME';

  if (isCycleTimeSelected.value) {
    fetchCycleTimeData();
  } else {
    cycleTimeData.value = null;
  }
});

</script>

<template>
  <LayoutAuthenticated>
    <SectionMain>

      <ParameterWithDropDown class="col-span-3"  :icon="mdiChartTimelineVariant" title="Parameter:" main>
          <!-- <DropDown @item-selected="handleSelectedParameterUpdate" :item="parameterSelectionbutton" /> -->

          <!-- <DropDownParameterPrimeVue @item-selected-update-parameter="handleSelectedParameterUpdate"
           :items="parameterDropdownProps.items" /> -->
           <DropdownSingleSelect
             :items="plantPollingParamterGrid.SelectedParmeter.availableParameters"
             @item-selected="handleSelectedParameterUpdate"
           />
      </ParameterWithDropDown>

      <!-- Cycle Time View -->
      <div v-if="isCycleTimeSelected && cycleTimeData" class="container mx-auto flex flex-col space-y-4">
        <div v-for="line in cycleTimeData.lines" :key="line.line_name" class="mb-4">
          <h3 class="text-lg font-semibold mb-2">{{ line.line_name }} - {{ line.line_state }}</h3>
          <div class="grid grid-cols-3 gap-4">
            <div
              v-for="machine in line.machines"
              :key="machine.machine_name"
              @click="handleMachineClick(machine.machine_name)"
              class="p-4 border rounded cursor-pointer hover:bg-gray-100"
              :class="{
                'border-red-500 bg-red-50': machine.machine_state === 'CRITICAL',
                'border-yellow-500 bg-yellow-50': machine.machine_state === 'WARNING',
                'border-green-500 bg-green-50': machine.machine_state === 'OK'
              }"
            >
              <h4 class="font-medium">{{ machine.machine_name }}</h4>
              <p class="text-sm">Cycle Time: {{ machine.parameter_value }}s</p>
              <p class="text-sm text-gray-600">State: {{ machine.machine_state }}</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Regular Parameter View -->
      <div v-else class="container mx-auto flex flex-col space-y-4">
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
