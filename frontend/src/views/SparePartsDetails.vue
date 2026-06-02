<script setup>
import { computed, ref, onBeforeMount } from "vue";

import SectionMain from "@/components/SectionMain.vue";
import BaseButton from "@/components/BaseButton.vue";
import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";
import BlurryHorizontalDivider from "@/components/BlurryHorizontalDivider.vue";
import CardBoxWidgetPlainWrap from "@/components/CardBoxWidgetPlainWrap.vue";

// Importing Store Statements
import { useSparePartStore } from '@/stores/SpareDetailStore'; 
import { useRouter } from 'vue-router';

const sparePartStore = useSparePartStore();
const machineName = ref(sparePartStore.machine);
const cumulativePartCount = ref(sparePartStore.cumulativeCount);
const currentPartCount = ref(sparePartStore.currentCount);
const partsData = ref([]);
const isLocked = ref(true);
const editingRowIndex = ref(-1);
const editedData = ref([]); // Track edited data



const router = useRouter();

const handleBack = async () => {
  const routeObject = { name: 'Factory Level Polling Parameter Overview Grid', params: { groupName: sparePartStore.parameterGroup } };
  router.push(routeObject);
};

onBeforeMount(async () => {
  await sparePartStore.fetchSparePartData(sparePartStore.machine);

  // Update component data from the store
  machineName.value = sparePartStore.machine;
  cumulativePartCount.value = sparePartStore.cumulativeCount;
  currentPartCount.value = sparePartStore.currentCount;
  partsData.value = [...sparePartStore.spareParts];
});

const unlockTableButtonClick = () => {
  if (!isLocked.value && hasUnsavedChanges()) {
    console.log("unlocktabel")
    console.log(!isLocked.value)
    const confirmSave = confirm("There are unsaved changes. Do you want to save them?");
    if (confirmSave) {
      saveChangesButtonClick(); // Save changes if confirmed
    } else {
      // If not confirmed, revert changes
      partsData.value = editedData.value.map(data => ({ ...data }));
    }
  }
  // Toggle lock status regardless of confirmation
  isLocked.value = !isLocked.value;
  editingRowIndex.value = -1;
};

const hasUnsavedChanges = () => {
  console.log("hasUnsavedChanges")
  console.log(editedData.value.length)
  return editedData.value.length > 0;

};

const getEditedRows = () => {
  return partsData.value.filter(part => part.isDirty);
};

const addPartButtonClick = () => {
  if (isLocked.value) {
    alert('Table is locked. Unlock the table to add a new part.');
  } else {
    const newPart = {
      id: null,
      part_name: 'New Part',
      count: 0,
      warning_limit: 0,
      critical_limit: 0,
      isDirty: true,
    };
    partsData.value.push(newPart);
    editedData.value.push(newPart); // Track newly added part
    editingRowIndex.value = partsData.value.length - 1;
  }
};


const saveEditedPartData = (editedPart) => {
  // Update spare part data using the store action
  sparePartStore.updateSparePart(editedPart);
  
  editedPart.isDirty = false; // Mark part as saved
  const index = partsData.value.findIndex(part => part.id === editedPart.id);
  if (index !== -1) {
    // Replace the existing part with the edited part
    partsData.value.splice(index, 1, editedPart);
    // Track the edited part
    editedData.value.push(editedPart);
  }
};

const saveChangesButtonClick = () => {
  editedData.value.forEach(part => {
    if (part.id) {
      sparePartStore.updateSparePart(part);
    } else {
      sparePartStore.addNewSparePart(part);
    }
  });
  partsData.value.forEach(part => part.isDirty = false);
  editedData.value = []; // Clear tracked changes
};


const deletePartButtonClick = (index) => {
  const deletedPart = partsData.value[index];
  partsData.value.splice(index, 1);
  if (deletedPart.id) {
    sparePartStore.deleteSparePart(deletedPart);
  }
};

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


const replaceUnderscores = (inputString) => {
  if (typeof inputString !== 'string') {
    console.error('Input is not a string:', inputString);
    return inputString;
  }

  return inputString.replace(/_/g, ' ');
};
</script>

<template>
  <LayoutAuthenticatedSimple>
    <SectionMain>
      <!-- <BaseButton type="submit" color="infolightDark" label="Back" @click="handleBack" /> -->

      <div v-if="sparePartStore.alertMessage" 
        :class="{ 'alert': true, 'bg-emerald-500 border-black': sparePartStore.isSuccessMessage,
        'bg-red-600 border-black': !sparePartStore.isSuccessMessage }">
        {{ sparePartStore.alertMessage }}
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
        >
          <div class="flex">
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

        <div>
          <button
            class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
            @click="addPartButtonClick"
          >
            <div class="flex">
              <div><img src="/src/assets/add1.svg" alt="" class="h-6 "></div>
              <span>Add Part</span>
            </div>
          </button>
          <button
            class="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded"
            @click="saveChangesButtonClick"
          >
            <div class="flex">
              <div><img src="" alt="" class="h-6 "></div>
              <span>Save Changes</span>
            </div>
          </button>
        </div>
      </div>

      <div class="overflow-x-auto rounded-lg">
        <table id="sparePartsTable" class="min-w-full bg-white border-collapse border border-gray-300 mt-4 rounded-lg">
          <!-- Table headers -->
          <thead>
            <tr class="bg-emerald-500 text-white rounded-lg">
              <th class="border border-gray-300 px-4 py-2 cursor-pointer">
                Sl No.
              </th>
              <th class="border border-gray-300 px-4 py-2 cursor-pointer">
                Part Name
              </th> 
              <th class="border border-gray-300 px-4 py-2 cursor-pointer">
                Current Count
              </th>
              <th class="border border-gray-300 px-4 py-2 bg-yellow-300 cursor-pointer">
                Warning Limit
              </th>
              <th class="border border-gray-300 px-4 py-2 cursor-pointer">
                Critical Limit
              </th>
              <th class="border border-gray-300 px-4 py-2 cursor-pointer">
                Actions
              </th>
            </tr>
          </thead>
          <tbody>
            <tr v-if="partsData.length === 0">
              <td colspan="6" class="border border-gray-400 px-4 py-2 text-center rounded-lg">Error fetching data from the backend</td>
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
                  @change="saveEditedPartData(part)"
                />
              </td>
              <td class="border border-gray-300 px-4 py-2 rounded-lg">
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
                  </button>
                </div>
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
