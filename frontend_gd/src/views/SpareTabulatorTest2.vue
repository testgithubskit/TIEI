<script setup>
import { ref, onMounted,onBeforeMount} from "vue";
import { TabulatorFull as Tabulator } from 'tabulator-tables';
import 'tabulator-tables/dist/css/tabulator.min.css';
import 'tabulator-tables/dist/js/tabulator.min.js';

import SectionMain from "@/components/SectionMain.vue";
import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";
import BlurryHorizontalDivider from "@/components/BlurryHorizontalDivider.vue";
import BaseButton from "@/components/BaseButton.vue";

import Toastify from 'toastify-js';
import 'toastify-js/src/toastify.css';


import { useSparePartTabulatorStore } from '@/stores/SpareDetailTabulatorStore'; 

const sparePartTabulatorStore = useSparePartTabulatorStore();


// Add new state for table locking
const isTableLocked = ref(true);
let lockLabel = ref("Unlock");

// Add new state for table locking
const isTableDeleteLocked = ref(true);
let deleteLockLabel = ref("Unlock Delete");

// Function to toggle table lock state
const toggleTableLock = () => {
  isTableLocked.value = !isTableLocked.value;
  if (isTableLocked.value){
    lockLabel.value = "Unlock";
    tabulator.value.addColumn({title:"Age", field:"age"}, true, "name").then(function(column){
    console.log("added column");
})
.catch(function(error){
    console.log("Error adding column");
});
  }else{
    lockLabel.value = "Lock"
  }
};


const toggleDeleteLock = () => {
  isTableDeleteLocked.value = !isTableDeleteLocked.value;
  if (isTableDeleteLocked.value){
    tabulator.value.deleteColumn("delete");
    deleteLockLabel.value = "Unlock Delete";
    }else{
      tabulator.value.addColumn({title: 'Delete', field: 'delete', formatter:"rowSelection",
       titleFormatter:"rowSelection", headerSort:false, maxWidth: 70}, true).then(function(column){
      console.log("added column");
      deleteLockLabel.value = "Lock Delete";
    }).catch(function(error){
          console.log("Error adding column");
      });
  }
};


function subtractHours(date, hours) {
  date.setHours(date.getHours() - hours);
  return date;
}

const table = ref(null);
const tabulator = ref(null);
const tableData = ref([
  { s_no: 1, part_name: 'Part 1', current_count: 50, warning_limit: 101, critical_limit: 150},
  { s_no: 2, part_name: 'Part 1', current_count: 50, warning_limit: 101, critical_limit: 150},
  { s_no: 3, part_name: 'Part 1', current_count: 50, warning_limit: 101, critical_limit: 150},
  { s_no: 4, part_name: 'Part 1', current_count: 50, warning_limit: 101, critical_limit: 150},
  { s_no: 5, part_name: 'Part 1', current_count: 50, warning_limit: 101, critical_limit: 150}]);


const handleEditChange = (cell) => {
  const editedRow = cell.getRow().getData();
  const editedRowId = editedRow.id; // Assuming your row object has an 'id' property

  console.log("Edited row2222:", editedRowId);
  sparePartTabulatorStore.saveEditedRowIds(editedRowId);

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
  console.log("Saving edited rows:", sparePartTabulatorStore.editedRowIds);

  try {
    // Get the current data from Tabulator
    const editNewData = tabulator.value.getData();

    // Filter out the rows whose IDs match the editedRowIds
    const editedRowsData = editNewData.filter(row => sparePartTabulatorStore.editedRowIds.includes(row.id));

    // Log the data of the edited rows
    console.log("Edited rows data:", editedRowsData);

    // Send the edited rows data to the backend or perform any other logic here
    await sparePartTabulatorStore.sendEdit(editedRowsData);

    // Clear the edited row IDs array
    sparePartTabulatorStore.editedRowIds = [];

    // Show success toast
    Toastify({
      text: 'Changes saved successfully!',
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: 'green', // You can customize the background color for success
    }).showToast();
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


const saveDelete = async () => {
  console.log("test");
  let selectedData = tabulator.value.getSelectedData(); //get array of currently selected data.
  console.log("Selected rows:", selectedData);
  // Extract only the 'part_name' values and store in a new array
  let partNamesList = selectedData.map(row => row.part_name);
  console.log("Part Names List:", partNamesList);

  try {
  await sparePartTabulatorStore.deleteSpareParts(partNamesList);
  // Success - handle accordingly
} catch (error) {
  // Display toast notification or handle the error
  console.error('Delete Spare Part Error:', error.message);
  // Use your preferred method for displaying notifications here
  // Example using Toastify:
  Toastify({
    text: error.message,
    duration: 3000,
    close: true,
    gravity: 'bottom',
    position: 'right',
    backgroundColor: 'red',
  }).showToast();
}
};


const saveChanges = (row) => {
  console.log("Saved changes for row:", row.getData());
  // Implement your logic to save changes here
};


onBeforeMount(() => {
  console.log("before mount")
});

onMounted(() => {

  console.log("On mount");

  tabulator.value = new Tabulator(table.value, {
	      selectableRows: true,
        data: tableData.value, //link data to table
        reactiveData:true, //enable data reactivity
        layout: 'fitColumns',
        height: "500px",
        resizableColumns: true,
        columns: [
        { title: 'S.No', field: 's_no',minWidth: 70, maxWidth: 70},
        { title: 'Part Name', field: 'part_name',minWidth: 240 },
        { title: 'Current Count', field: 'current_count',minWidth: 180 },
        { title: 'Warning Limit', field: 'warning_limit',minWidth: 180},
        { title: 'Critical Limit', field: 'critical_limit',minWidth: 180 }
      ],
      });

});

</script>

<template >
  
  <LayoutAuthenticatedSimple class=" font-custom ">
    <SectionMain>
      <BlurryHorizontalDivider />

      <BlurryHorizontalDivider />

      <!-- Add "Unlock Table" button -->
      <div class="flex flex-row mt-2 h-8">
        <div class="w-2/4 flex justify-end">
          <BaseButton type="button" color="primary" :label="lockLabel" @click="toggleTableLock" />
        </div>
      </div>

      <div class="flex flex-row mt-2 h-8"><!-- Button to save edited rows -->
        <div class="w-2/4  flex justify-end ">
          <BaseButton type="button" color="success" label="Save Edited" @click="saveEdit" />
        </div>
      </div>

      <!-- Add "Unlock Table" button -->
      <div class="flex flex-row mt-2 h-8">
        <div class="w-2/4 flex justify-end">
          <BaseButton type="button" color="primary" :label="deleteLockLabel" @click="toggleDeleteLock" />
        </div>
      </div>

      <div class="flex flex-row mt-2 h-8"><!-- Button to save edited rows -->
        <div class="w-2/4  flex justify-end ">
          <BaseButton type="button" color="success" label="Save Delete" @click="saveDelete" />
        </div>
      </div>
      
      <BlurryHorizontalDivider />
      <div ref="table"></div>
      <BlurryHorizontalDivider />
      
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
}

.tabulator .tabulator-row:hover {
  background-color: #f9f9f9;
}

.tabulator .tabulator-cell {
    text-align: center; /* Center the text in cells */
  }

/* Add more custom styles as needed */

  /* Add more custom styles as needed */
</style>