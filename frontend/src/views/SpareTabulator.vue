<script setup>
import { ref, onMounted,onBeforeMount, watch, computed} from "vue";
import { TabulatorFull as Tabulator } from 'tabulator-tables';
import 'tabulator-tables/dist/css/tabulator.min.css';
import 'tabulator-tables/dist/js/tabulator.min.js';

import SectionMain from "@/components/SectionMain.vue";
import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";
import BlurryHorizontalDivider from "@/components/BlurryHorizontalDivider.vue";
import BaseButton from "@/components/BaseButton.vue";

import CardBoxWidgetPlainWrap from "@/components/CardBoxWidgetPlainWrap.vue";

import Toastify from 'toastify-js';
import 'toastify-js/src/toastify.css';

import { useSparePartDetailStore } from '@/stores/SparePartDetailStore'; 
import { useRouter } from 'vue-router';

const router = useRouter();


const sparePartDetailStore = useSparePartDetailStore();


const handleQuerySubmit = async () => {
    try {
    await sparePartDetailStore.fetchSpareData();
    console.log("Data fetched successfully for machine:", selectedMachine.value);
    console.log("Fetched data:", sparePartDetailStore.spareParts);
    tabulator.value.setData(sparePartDetailStore.spareParts);
    Toastify({
        text: 'Data Fetched Succesfully.',
        duration: 3000,
        close: true,
        gravity: 'bottom',
        position: 'right',
        backgroundColor: 'green',
      }).showToast();
  } catch (error) {
    console.error('Error fetching and rendering data:', error);
    Toastify({
        text: 'Error fetching Data.',
        duration: 3000,
        close: true,
        gravity: 'bottom',
        position: 'right',
        backgroundColor: 'red',
      }).showToast();
  }
};


const deleteMode = ref(false);
const table = ref(null);
const tabulator = ref(null);
const tableData = ref([]);


let currentCount = computed(() => {
  return sparePartDetailStore.currentCount.toString();
});


let cumulativeCount = computed(() => {
  return sparePartDetailStore.cumulativeCount.toString();
});


let selectedMachine = computed(() => {
  return sparePartDetailStore.selectedMachine;
});


const handleEditChange = (cell) => {
    
  const editedRow = cell.getRow().getData();
  const editedRowId = editedRow.id; // Assuming your row object has an 'id' property
  sparePartDetailStore.saveEditedRowIds(editedRowId);

  // Show a toast notification
  Toastify({
    text: 'Please save after editing',
    duration: 3000, // Display duration in milliseconds
    close: true,
    gravity: 'bottom', // Other gravity options: 'top', 'bottom', 'left', 'right'
    position: 'right', // Other position options: 'left', 'right', 'center'
    backgroundColor: 'red',
  }).showToast();
};


const saveEdit = async () => {
  if (sparePartDetailStore.editedRowIds.length === 0){
    // Show error toast
    Toastify({
      text: 'No Changes to Save',
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: 'red', // You can customize the background color for error
    }).showToast();
    return
  }

  try {

    // Clear the edited row IDs array
    await sparePartDetailStore.updateModifiedData();
    toggleDeleteMode();
    await handleQuerySubmit();
    // Show success toast
    Toastify({
      text: 'Changes saved successfully!',
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: 'green', // You can customize the background color for success
    }).showToast();

    // await handleQuerySubmit();
    // console.log("refreshing Data");
  } catch (error) {
    console.error('Error saving edited data:', error);

    // Show error toast
    Toastify({
      text: 'Error saving changes. Please try again.',
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: 'red', // You can customize the background color for error
    }).showToast();
  }
};


onBeforeMount(() => {
  console.log("before mount")
})


// Inside your onMounted or wherever you initialize the tabulator
onMounted(() => {
  // Define the columns array dynamically based on deleteMode
  const columns = deleteMode.value ? [
    { 
      title: "", 
      formatter: "rowSelection", 
      cellEdited: handleCellEdit,
      align: "center", 
      headerSort: false, 
      cellClick: function(e, cell) {
        cell.getRow().toggleSelect();
      },
      width: 50, 
      cssClass: "checkbox-column",
      headerCssClass: "checkbox-column-header"
    },
    { title: 'Id', field: 'id', minWidth: 10},
    { title: 'Part Name', field: 'part_name', minWidth: 240,},
    { title: 'Current Count', field: 'count', minWidth: 180,editor:"input",cellEdited: handleEditChange },
    { title: 'Warning Limit', field: 'warning_limit', minWidth: 180,editor:"input",cellEdited: handleEditChange },
    { title: 'Critical Limit', field: 'critical_limit', minWidth: 180,editor:"input",cellEdited: handleEditChange }
  ] : [
    // When deleteMode is false, exclude the checkbox column
    { title: 'Id', field: 'id', minWidth: 10},
    { title: 'Part Name', field: 'part_name', minWidth: 240 },
    { title: 'Current Count', field: 'count', minWidth: 180, cellEdited: handleEditChange },
    { title: 'Warning Limit', field: 'warning_limit', minWidth: 18, cellEdited: handleEditChange },
    { title: 'Critical Limit', field: 'critical_limit', minWidth: 180 , cellEdited: handleEditChange}
  ];

  // Initialize the Tabulator with the dynamically generated columns
  tabulator.value = new Tabulator(table.value, {
    data: tableData.value,
    reactiveData: true,
    layout: 'fitColumns',
    height: "500px",
    resizableColumns: true,
    columns: columns,
    editable:true,
    // cellEdited: handleCellEdit,
  });
  
  handleQuerySubmit();
});


watch(() => sparePartDetailStore.spareParts, (newSparePartsValue) => {
  console.log("Watchers");
  console.log(newSparePartsValue);
});


// Watch for changes in deleteMode and update the columns accordingly
watch(deleteMode, (newValue) => {
  // Dynamically update the columns based on the new value of deleteMode
  const columns = newValue ? [
    { 
      title: "", 
      formatter: "rowSelection", 
      align: "center", 
      headerSort: false, 
      cellClick: function(e, cell) {
        cell.getRow().toggleSelect();
      },
      width: 50, 
      cssClass: "checkbox-column",
      headerCssClass: "checkbox-column-header",
    //   cellEdited: handleCellEdit,
    },
    { title: 'Part Name', field: 'part_name', minWidth: 240 },
    { title: 'Current Count', field: 'count', minWidth: 180,editor:"input",cellEdited: handleEditChange },
    { title: 'Warning Limit', field: 'warning_limit', minWidth: 180,editor:"input",cellEdited: handleEditChange},
    { title: 'Critical Limit', field: 'critical_limit', minWidth: 180,editor:"input",cellEdited: handleEditChange}
  ] : [
    // When deleteMode is false, exclude the checkbox column
    { title: 'Part Name', field: 'part_name', minWidth: 240 },
    { title: 'Current Count', field: 'count', minWidth: 180,cellEdited: handleEditChange },
    { title: 'Warning Limit', field: 'warning_limit', minWidth: 180,cellEdited: handleEditChange },
    { title: 'Critical Limit', field: 'critical_limit', minWidth: 180,cellEdited: handleEditChange }
  ];

  // Update the columns of the existing Tabulator instance
  tabulator.value.setColumns(columns);
});


// State variable to control the visibility of the modal
const showAddPartModal = ref(false);

// Object to store new part data
const newPart = ref({
  part_name: '',
  reference_part_number:0,
  warning_limit: 0,
  critical_limit: 0
});

// Store instance
// const sparePartDetailStore = useSpareTable();

// Function to open the modal
const openAddPartModal = () => {
  showAddPartModal.value = true;
};

// Function to close the modal
const closeAddPartModal = () => {
  showAddPartModal.value = false;
};

// Function to add a new part
const addNewPart = async () => {
  try {
    newPart.value.reference_part_number = sparePartDetailStore.cumulativeCount;

    await sparePartDetailStore.addNewPart(newPart.value);
    // Call the store function to add a new part
  
    // Close the modal after successful submission
    closeAddPartModal();
    
    handleQuerySubmit();
  } catch (error) {
    console.error('Error adding new part:', error);
    // Handle error
  }
};


// Function to toggle delete mode
const toggleDeleteMode = () => {
  
  deleteMode.value = !deleteMode.value;
};


const deleteSelectedParts = async () => {
  
  let numberOfSelectedItems = tabulator.value.getSelectedData().length;
  
  if (numberOfSelectedItems != 0){
  sparePartDetailStore.deletedParts =  tabulator.value.getSelectedData().map(row => row.part_name);
  try {
    await sparePartDetailStore.deletePart();
    toggleDeleteMode();
    await handleQuerySubmit();
    // Show success toast
    Toastify({
      text: 'Part Deleted.',
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: 'green', // You can customize the background color for success
    }).showToast();
    
  } catch (error) {
    // Show error toast
    Toastify({
      text: 'Error saving changes. Please try again.',
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: 'red', // You can customize the background color for error
    }).showToast();
  }
  } else {
    Toastify({
      text: 'No items selected to delete.',
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: 'red', // You can customize the background color for error
    }).showToast();

  }
};

const handleTableClick = () => {
  if (!deleteMode.value) {
    Toastify({
      text: 'Please unlock the table to edit.',
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: 'red',
    }).showToast();
  }
};


const handleBack = async () => {
  console.log("going back");
  router.push('factory-spare-part');
};

</script>

<template >
  
  <LayoutAuthenticatedSimple class=" font-custom ">
    <SectionMain>
      <div class="container mx-auto flex flex-col space-y-4">

        <div class="w-16 h-8">
          <!-- <BaseButton type="submit" color="infolightDark" label="Back" @click="handleBack" /> -->
        </div>
        <BlurryHorizontalDivider />
        <div class="grid grid-cols-1 gap-6 lg:grid-cols-5 mb-6">
          <CardBoxWidgetPlainWrap 
          label="Machine Name"
          :parameter-value="selectedMachine">
          </CardBoxWidgetPlainWrap>
          <CardBoxWidgetPlainWrap 
          label="Current Count"
          :parameter-value="currentCount">
          </CardBoxWidgetPlainWrap>
          <CardBoxWidgetPlainWrap 
          label="Cumulative Count"
          :parameter-value="cumulativeCount">
          </CardBoxWidgetPlainWrap>
          <div class="mt-8">
              <BaseButton type="submit" color="info" label="Refresh" @click="handleQuerySubmit" />
          </div>
        </div>            
      
        <BlurryHorizontalDivider class="mt-8"/>
        
        <div class="flex flex-row mt-8 h-8"><!-- Button to save edited rows -->
          <div class="w-2/4 flex justify-start">
            <p class="font-semibold text-3xl font-custom text-yellow-500  ">Available Spare Parts </p>
          </div>
        </div>

        <!-- Filter options -->
        <div class="w-full flex justify-normal space-x-4">

          <div class="mt-8">
            
            <BaseButton type="submit" color="info" label="AddPart" @click="openAddPartModal" />
          </div>
          <div class="w-2/4  flex justify-end h-18 items-end">
            <BaseButton type="button" color="success" label="Save Edited" @click="saveEdit" />
          </div>

          <div class="mt-8">
            <BaseButton type="submit" color="info" :label="deleteMode ?'Lock Table': 'Unlock Table'" @click="toggleDeleteMode" />
          </div>

        <div class="mt-8">
          <BaseButton type="submit" color="danger" label="Delete" @click="deleteSelectedParts" />
        </div>

        <div class="mt-8">
            <!-- <BaseButton type="button" color="info" :label="editableRows ? 'Lock Edit' : 'Unlock Edit'" @click="toggleEditableRows" /> -->
        </div>

      </div>

        <div ref="table" @click="handleTableClick"></div>
          <BlurryHorizontalDivider />
        </div>

      <!-- Popup/modal for adding a new part -->
  <div v-if="showAddPartModal" class="fixed inset-0 flex items-center justify-center bg-gray-500 bg-opacity-50">
    <div class="bg-white p-8 rounded-lg">
      <h2 class="text-2xl font-semibold mb-4">Add New Part</h2>
      <div class="mb-4">
        <label for="partName" class="block mb-2 text-gray-700">Part Name:</label>
        <input id="partName" v-model="newPart.part_name" class="bg-slate-50 text-black border rounded-lg shadow" type="text" placeholder="Enter part name" />
      </div>
      <div class="mb-4">
        <label for="warningLimit" class="block mb-2 text-gray-700">Warning Limit:</label>
        <input id="warningLimit" v-model="newPart.warning_limit" class="bg-slate-50 text-black border rounded-lg shadow" type="number" placeholder="Enter warning limit" />
      </div>
      <div class="mb-4">
        <label for="criticalLimit" class="block mb-2 text-gray-700">Critical Limit:</label>
        <input id="criticalLimit" v-model="newPart.critical_limit" class="bg-slate-50 text-black border rounded-lg shadow" type="number" placeholder="Enter critical limit" />
      </div>
      <div class="flex justify-end">
        <BaseButton type="submit" color="success" label="Submit" @click="addNewPart" />
        <BaseButton type="button" color="danger" label="Cancel" @click="closeAddPartModal" />
      </div>
    </div>
    </div>
    </SectionMain>
  </LayoutAuthenticatedSimple>
</template>

<style>
  /* Import Tabulator CSS globally */
  @import 'tabulator-tables/dist/css/tabulator.min.css';

  /* Your global styles here, including Tailwind or custom styles */

  /* Override specific Tabulator styles */
  .tabulator {
  /* Your existing styles here */
  background-color: #ffffff;
  border-style: solid;
  border-color: rgb(179, 179, 179);
  border-width: 2px;
  border-radius: 10px;
  padding: 6px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.tabulator .tabulator-tableholder {
  border-width: 2px;
  border-radius: 6px;
}

.tabulator .tabulator-header {
  background-color: #ffffff;
  color: #fdfdfd;
  border-width: 2px;
  border-radius: 6px;
}

.tabulator .tabulator-header .tabulator-col {
  background-color: #000000;
  height: 50px;
  align-items: center;
  justify-content: center;
  font-size: 20px;
  font-size: 20px;
  /* Add this line */
}

.tabulator .tabulator-header .tabulator-col:hover {
  background-color: #00000000;
  color: #ffffff;
  font-size: medium;
  border-bottom: 2px solid #ffffff; /* Add this line */
}

.tabulator .tabulator-row {
  background-color: #ffffff;
  height: 60px; /* Adjust the height as needed */
  line-height: 60px; /* Add this line */
  border-bottom: 2px solid #ececec; /* Add this line for horizontal lines between rows */
  font-size: 20px;
  font-size: 20px;
}

div.tabulator-frozen.tabulator-cell {
  background-color: #ffffff;
  height: 60px; /* Adjust the height as needed */
  line-height: 60px; /* Add this line */
  border: 2px solid #ececec; /* Add this line for horizontal lines between rows */
  font-size: 20px;
  font-size: 20px;
}

.tabulator .tabulator-row:hover {
  background-color: #f9f9f9;
}

.tabulator .tabulator-cell {
    text-align: center; /* Center the text in cells */
  }

/* Add more custom styles as needed */

  /* Add more custom styles as needed */
</style>@/stores/SparePartDetailStore