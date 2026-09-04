<script setup>
import { computed, ref, onMounted, onBeforeMount, watch } from "vue";
import {
  mdiChartTimelineVariant,
  mdiGithub,
} from "@mdi/js";

import SectionMain from "@/components/SectionMain.vue";
import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";
import SectionTitleLineWithButton from "@/components/SectionTitleLineWithButton.vue";
import BaseButton from "@/components/BaseButton.vue";
import BlurryHorizontalDivider from "@/components/BlurryHorizontalDivider.vue";
import ProductionLine from "@/components/ProductionLine.vue";
import ParameterWithDropDown from "@/components/ParameterWithDropDown.vue";
import StatefulDropdownSingleSelect from "@/components/StatefulDropdownSingleSelect.vue";

import { useSparePartStore } from '@/stores/SpareDetailStore'; 

const sparePartStore = useSparePartStore();


//Importing Store Statements

import { useFactoryPollOverviewStore } from '@/stores/PartGridStore'; 

import { useMachineSamplingWithLimitsStore } from '@/stores/MachineSamplingWithLimitsStore'; 

import { useRouter } from 'vue-router';

const router = useRouter();

const machineSamplingWithLimitsStore = useMachineSamplingWithLimitsStore();

const factoryPollOverviewGridStore = useFactoryPollOverviewStore();

let initialSelectedParameter = ref(null);

let groupDataIndex = computed(() => {
  return factoryPollOverviewGridStore.groupData.findIndex(group => group.group_name === factoryPollOverviewGridStore.SelectedParmeter.item_name);
});

let selectedParameterGroupInfo = computed(() => {
  return factoryPollOverviewGridStore.groupData[groupDataIndex.value];
});

const groupCount = computed(() => {
  const selectedGroup = factoryPollOverviewGridStore.groupData.find(group => group.group_name === factoryPollOverviewGridStore.SelectedParmeter.item_name);

  if (selectedGroup) {
    return selectedGroup.count;
  }

  // Default count if the group is not found
  return {
    OK: 0,
    WARNING: 0,
    CRITICAL: 0,
  };
});

const totalMachines = computed(() => { 
  return groupCount.value.OK + groupCount.value.WARNING + groupCount.value.CRITICAL;
});

const getGridColumnsClass = computed(() => {
  return (length) => {
    return `grid grid-cols-3 gap-6 lg:grid-cols-${length} mb-6`;
  };
});

let availableParameters = ref(factoryPollOverviewGridStore.availableParameters);


const combinedLabel = (subSectionName) => {
  return `${subSectionName} : ${totalMachines.value}`;
};


onBeforeMount(async () => {
  let groupNameFromRoute = router.currentRoute.value.params.groupName || null;
  await factoryPollOverviewGridStore.fetchInitialPageData();
  if (groupNameFromRoute !== null) {
  // Your code here if the variable is not null
  factoryPollOverviewGridStore.setSelectedGroup(groupNameFromRoute);
  let groupDetails = factoryPollOverviewGridStore.getGroupDetail(groupNameFromRoute);
  let informalGroupName = groupNameFromRoute.split('_').map(part => part.charAt(0).toUpperCase() + part.slice(1)).join(' ');
  let selectedGroupDetails = {"label": informalGroupName, "state": groupDetails.groupState, "value": groupNameFromRoute};
  initialSelectedParameter.value = selectedGroupDetails;
} else{
  // Your code here if the variable is not null
  const defaultGroupName = "APC_BATTERY";
  factoryPollOverviewGridStore.setSelectedGroup(defaultGroupName);
  let groupDetails = factoryPollOverviewGridStore.getGroupDetail(defaultGroupName);
  let informalGroupName = defaultGroupName.split('_').map(part => part.charAt(0).toUpperCase() + part.slice(1)).join(' ');
  let selectedGroupDetails = {"label": informalGroupName, "state": groupDetails.groupState, "value": defaultGroupName};
  initialSelectedParameter.value = selectedGroupDetails;
}
});

onMounted(async () => {
  // fetchData(); // Fetch data initially

  // // Fetch data every 5 seconds
  // setInterval(() => {
  //   fetchData();
  // }, 5000);
  //await factoryPollOverviewGridStore.fetchInitialPageData();
});


const handleSelectedParameterUpdate = async (selectedItem) => {

  if (selectedItem !== null){
    let newSelectedParameter = { item_name: selectedItem.value, item_state: selectedItem.state };

  //await factoryPollOverviewGridStore.updateGroupData(selectedItem.value);
    factoryPollOverviewGridStore.SelectedParmeter = newSelectedParameter;

  }
};

watch(() => factoryPollOverviewGridStore.availableParameters, (newAvailableParameters) => {
  availableParameters.value = newAvailableParameters;
});

const handleMachineParameterClick = async (clickedParameter) => {
  // Perform any necessary actions with the updated parameters
  machineSamplingWithLimitsStore.machine = clickedParameter.machineName;
  machineSamplingWithLimitsStore.actualParameterName = clickedParameter.actualParameterName;;

  machineSamplingWithLimitsStore.parameterGroup = factoryPollOverviewGridStore.SelectedParmeter.item_name;

  machineSamplingWithLimitsStore.refreshTimestamp();
  await machineSamplingWithLimitsStore.fetchMachineParameterData();
  sparePartStore.machine = clickedParameter.machineName;
  router.push('/SparePartsDetails');
};

</script>

<template>
  
  <LayoutAuthenticatedSimple>
    <SectionMain>
      <ParameterWithDropDown class="col-span-3"  :icon="mdiChartTimelineVariant" title="Parameter:" main>
           <StatefulDropdownSingleSelect 
           @item-selected-update-parameter="handleSelectedParameterUpdate" 
           :items="availableParameters"
           :defaultSelectedItem="initialSelectedParameter" />
      </ParameterWithDropDown>
      <BlurryHorizontalDivider />
      <div
        v-for="Section in factoryPollOverviewGridStore.sections"
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
      <div class="container mx-auto flex flex-col space-y-4">
        <ProductionLine
        
          v-for="line in selectedParameterGroupInfo.group_details"
          :key="line.line_name"
          :lineName="line.line_name"
          :lineState="line.line_state"
          :machines="line.machines"
          :count = "line.count"
          @machine-parameter-clicked="handleMachineParameterClick"
        >
        </ProductionLine>
      </div>
    </SectionMain>
  </LayoutAuthenticatedSimple>
</template>
