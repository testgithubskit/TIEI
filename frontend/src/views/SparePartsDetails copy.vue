<script setup>
import { computed, ref, onBeforeMount } from "vue";

import SectionMain from "@/components/SectionMain.vue";

import BaseButton from "@/components/BaseButton.vue";

import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";
import BlurryHorizontalDivider from "@/components/BlurryHorizontalDivider.vue";


import CardBoxWidgetPlainWrap from "@/components/CardBoxWidgetPlainWrap.vue";

//Importing Store Statements

import { useSparePartStore } from '@/stores/SpareDetailStore'; 
import { useRouter } from 'vue-router';


const machineSamplingWithLimitsStore = useSparePartStore();
const machineName = ref(machineSamplingWithLimitsStore.machine);
const cumulativePartCount = ref(machineSamplingWithLimitsStore.cumulativeCount);
console.log("intialization mount")
//console.log(machineSamplingWithLimitsStore.spareParts.map(function(sparetotal){ return sparetotal.total_Count }));

const currentPartCount = ref(machineSamplingWithLimitsStore.currentCount);
const partsData = ref([]);
const isLocked = ref(true);
const isAddingNewPart = ref(true);
const editingRowIndex = ref(-1);

const router = useRouter();

const handleBack = async () => {
  const routeObject = { name: 'Factory Level Polling Parameter Overview Grid', params: { groupName: machineSamplingWithLimitsStore.parameterGroup } };
  router.push(routeObject);
};

onBeforeMount(async () => {
  await machineSamplingWithLimitsStore.fetchSparePartData(machineSamplingWithLimitsStore.machine);

  // Update component data from the store
  machineName.value = machineSamplingWithLimitsStore.machine;
  cumulativePartCount.value = machineSamplingWithLimitsStore.cumulativeCount; // Update with actual cumulative part count from the store
  console.log("before mount")
  console.log(machineSamplingWithLimitsStore.spareParts.total_Count)
  currentPartCount.value = machineSamplingWithLimitsStore.currentCount; // Update with actual current part count from the store
  partsData.value = [...machineSamplingWithLimitsStore.spareParts];
});

const updateComponentData = async (machineName) => {
  await machineSamplingWithLimitsStore.fetchSparePartData(machineName);

  // Update component data from the store
  machineName.value = machineSamplingWithLimitsStore.machine;
  cumulativePartCount.value = machineSamplingWithLimitsStore.cumulativeCount; // Update with actual cumulative part count from the store
  currentPartCount.value = machineSamplingWithLimitsStore.currentCount; // Update with actual current part count from the store
  partsData.value = [...machineSamplingWithLimitsStore.spareParts];
};

const unlockTableButtonClick = () => {
  isLocked.value = !isLocked.value;

  if (isLocked.value) {
    editingRowIndex.value = -1; // Reset editing when locking the table
  }
};

const addPartButtonClick = () => {
  if (isLocked.value) {
    alert('Table is locked. Unlock the table to add a new part.');
  } else {
    if (isAddingNewPart.value) {
      const newPart = {
        id: partsData.value.length + 1,
        part_name: 'New Part',
        count: 0,
        warning_limit: 0,
        critical_limit: 0,
      };
      partsData.value.push(newPart);
      editingRowIndex.value = partsData.value.length - 1;
    } else {
      saveEditedPartData(partsData.value[editingRowIndex.value]);
      editingRowIndex.value = -1;
    }

    isAddingNewPart.value = !isAddingNewPart.value;
  }
};

const saveEditedPartData = (editedPart) => {
  // Update spare part data using the store action
  machineSamplingWithLimitsStore.updateSparePart(editedPart);
};

const replaceUnderscores = (inputString) => {
  if (typeof inputString !== 'string') {
    console.error('Input is not a string:', inputString);
    return inputString;
  }

  return inputString.replace(/_/g, ' ');
};

const resetCount = (part) => {
  // Reset the count to 0
  part.count = 0;
};


//Delete the button 

const deletePartButtonClick = (index) => {
  const deletedPart = partsData.value[index];
  
  // Remove the part from the array
  partsData.value.splice(index, 1);

  // Send the deleted data to the store for further processing
  machineSamplingWithLimitsStore.deleteSparePart(deletedPart);
};

//sort 

const sortOptions = {
  column: null,
  order: 1,
};

const sortBy = (column) => {
  if (sortOptions.column === column) {
    sortOptions.order *= -1;
  } else {
    sortOptions.column = column;
    sortOptions.order = 1;
  }

  // Sort the partsData array
  partsData.value.sort((a, b) => {
    const valueA = a[column];
    const valueB = b[column];

    if (typeof valueA === 'string' && typeof valueB === 'string') {
      return sortOptions.order * valueA.localeCompare(valueB);
    } else {
      return sortOptions.order * (valueA - valueB);
    }
  });
};

</script>

<template>
  <LayoutAuthenticatedSimple>
    <SectionMain>
      <!-- <BaseButton type="submit" color="infolightDark" label="Back" @click="handleBack" /> -->

      <div v-if="machineSamplingWithLimitsStore.alertMessage" 
      :class="{ 'alert': true, 'bg-emerald-500 border-black': machineSamplingWithLimitsStore.isSuccessMessage,
       'bg-red-600 border-black': !machineSamplingWithLimitsStore.isSuccessMessage }">
        {{ machineSamplingWithLimitsStore.alertMessage }}
      </div>

    <BlurryHorizontalDivider />

    <div class="flex space-x-4 justify-evenly mb-6">
    <CardBoxWidgetPlainWrap class=" font-mono font-bold text-xl text-emerald-600">{{ replaceUnderscores(machineName) }}</CardBoxWidgetPlainWrap> 
    <CardBoxWidgetPlainWrap class=" font-mono font-bold text-xl text-emerald-700">{{ replaceUnderscores(cumulativePartCount) }}</CardBoxWidgetPlainWrap> 
    <CardBoxWidgetPlainWrap class=" font-mono font-bold text-xl text-emerald-700">{{ replaceUnderscores(currentPartCount) }}</CardBoxWidgetPlainWrap> 
  </div>
  <!-- buttons -->
  <div class="flex flex-row justify-between">
    <button
  v-if="isLocked"
  class="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded"
  @click="unlockTableButtonClick"
><div class="flex ">
  <div><img src="/src/assets/open2.svg" alt="" class="h-6 "></div>
  <span>Unlock Table</span>
  </div>

</button>
<button
  v-else
  class="bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded"
  @click="unlockTableButtonClick"
>
<div class="flex ">
  <div><img src="/src/assets/lock2.svg" alt="" class="h-6 "></div>
  <span>Lock Table</span>
  </div>
</button>
      <div v-if="machineSamplingWithLimitsStore.alertMessage" 
        :class="{ 'alert': true, 'bg-emerald-500 border-black': machineSamplingWithLimitsStore.isSuccessMessage,
        'bg-red-600 border-black': !machineSamplingWithLimitsStore.isSuccessMessage }">
        {{ machineSamplingWithLimitsStore.alertMessage }}
      </div>

  

      <div >
        <button
          v-if="isAddingNewPart"
          class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
          @click="addPartButtonClick"
        >
        <div class="flex ">
  <div><img src="/src/assets/add1.svg" alt="" class="h-6 "></div>
  <span>Add Part</span>
  </div>
        </button>
        <button
          v-else
          class="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded"
          @click="addPartButtonClick"
        >
        <div class="flex ">
          <div><img src="/src/assets/save2.svg" alt="" class="h-6 "></div>
  <span>Save Part</span>
  </div>
        </button>
      </div>
  </div>
      

  <div class="overflow-x-auto rounded-lg">
    <table id="sparePartsTable" class="min-w-full bg-white border-collapse border border-gray-300 mt-4 rounded-lg">
      <!-- Table headers -->
      <thead>
        <tr class="bg-emerald-500 text-white rounded-lg">
          <th @click="sortBy('id')" class="border border-gray-300 px-4 py-2 cursor-pointer">
            Sl No.
            <img v-if="sortOptions.column === 'id'" :src="sortOptions.order === 1 ? sortAscIcon : sortDescIcon" alt="sort" />
          </th>
          <th @click="sortBy('part_name')" class="border border-gray-300 px-4 py-2 cursor-pointer">
            Part Name
            <img v-if="sortOptions.column === 'part_name'" :src="sortOptions.order === 1 ? sortAscIcon : sortDescIcon" alt="sort" />
          </th> <th @click="sortBy('count')" class="border border-gray-300 px-4 py-2 cursor-pointer">Current Count</th>
          <th @click="sortBy('warning_limit')" class="border border-gray-300 px-4 py-2 bg-yellow-300 cursor-pointer">Warning Limit</th>
          <th @click="sortBy('critical_limit')" class="border border-gray-300 px-4 py-2 cursor-pointer">Critical Limit</th>
        </tr>
      </thead>
    <tbody>
      <tr v-if="partsData.length === 0">
        <td colspan="5" class="border border-gray-400 px-4 py-2 text-center rounded-lg">Error fetching data from the backend</td>
      </tr>
      <tr
  v-for="(part, index) in partsData"
  :key="index"
  :class="{ 'bg-gray-200': !isLocked && editingRowIndex === index }"
>
  <td class="border border-gray-300 px-4 py-2 rounded-lg">{{ index + 1 }}</td>
  <td class="border border-gray-300 px-4 py-2 rounded-lg">
    <span v-if="isLocked">{{ part.part_name }}</span>
    <input
      v-else
      type="text"
      class="w-full bg-transparent rounded-lg"
      v-model="part.part_name"
      :readonly="isLocked | !isLocked"
    />
  </td>
  <td class="border border-gr
  ay-300 px-4 py-2 rounded-lg">
    <div class="flex flex-row">
      <input
      type="number"
      class="w-full bg-transparent rounded-lg"
      v-model="part.count"
      :readonly="isLocked"
      
    />
      <button
      v-if="!isLocked"
      class="bg-gray-500 hover:bg-gray-700 text-white font-bold py-1 px-2 rounded ml-2"
      @click="resetCount(part)"
    >
      Reset
    </button></div>
    
    <!-- Reset button, visible only when unlocked -->
    
  </td>
  <td class="border border-gray-300 px-4 py-2 rounded-lg">
    <input
      type="number"
      class="w-full bg-transparent rounded-lg"
      v-model="part.warning_limit"
      :readonly="isLocked"
    />
  </td>
  <td class="border border-gray-300 px-4 py-2 rounded-lg">
    <input
      type="number"
      class="w-full bg-transparent rounded-lg"
      v-model="part.critical_limit"
      :readonly="isLocked"
    />
  </td>
  <td class="border border-gray-300 px-4 py-2 rounded-lg">
    <button
      v-if="!isLocked"
      class="bg-red-500 hover:bg-red-700 text-white font-bold py-1 px-2 rounded"
      @click="deletePartButtonClick(index)"
    >
      Delete
    </button>
  </td>
</tr>
    </tbody>
  </table>
</div>

      <BlurryHorizontalDivider />
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
