<template>
  <LayoutAuthenticatedSimple class="font-custom">
    <SectionMain>
      <div class="container mx-auto flex flex-col space-y-4">
        <BlurryHorizontalDivider class="mb-4" />

        <!-- Date filters -->
        <div class="grid grid-cols-3 gap-2">
          <div>
            <label class="block mb-2 text-gray-700">From</label>
            <TimePickerFlatEmitter :defaultDatetime="new Date(activityStore.selectedDates.from)" type="from" @date-change="handleFromDateChange" />
          </div>
          <div>
            <label class="block mb-2 text-gray-700">To</label>
            <TimePickerFlatEmitter :defaultDatetime="new Date(activityStore.selectedDates.to)" type="to" @date-change="handleToDateChange" />
          </div>
          <div class="mt-8">
            <BaseButton type="submit" color="info" label="Submit" @click="fetchData" />
          </div>
        </div>

        <BlurryHorizontalDivider class="mt-8" />

        <!-- Abnormality Summary -->
        <div class="w-full">
          <h2 class="font-semibold text-3xl font-custom text-yellow-500 mb-4">Abnormality Summary</h2>
          <EasyDataTable
            :headers="summaryHeaders"
            :items="activityStore.abnormalitySummary"
          />
        </div>

        <BlurryHorizontalDivider class="mt-8" />

        <!-- Pending Activity View -->
        <div class="w-full flex justify-between items-center">
          <h2 class="font-semibold text-3xl font-custom text-yellow-500 mb-4">Pending Activity View</h2>
          <BaseButton type="button" color="success" label="Export Pending Data" @click="exportPendingData" />
        </div>

        <div class="flex justify-between items-center mb-4">
          <input v-model="searchField" placeholder="Search..." class="p-2 border rounded" />
          <div>
            <select v-model="sortBy" class="p-2 border rounded">
              <option value="date_of_identification">Date of Identification</option>
              <option value="name">Name</option>
              <option value="status">Status</option>
            </select>
            <select v-model="sortType" class="p-2 border rounded">
              <option value="asc">Ascending</option>
              <option value="desc">Descending</option>
            </select>
          </div>
        </div>

        <EasyDataTable
          :headers="headers"
          :items="filteredPendingData"
          @click:row="editItem"
        >
          <template #item-status="item">
            <select v-model="item.status" @change="updateItemStatus(item)">
              <option value="Pending">Pending</option>
              <option value="Completed">Completed</option>
            </select>
          </template>
        </EasyDataTable>

        <BlurryHorizontalDivider class="mt-8" />

        <!-- Completed Activity View -->
        <div class="w-full flex justify-between items-center">
          <h2 class="font-semibold text-3xl font-custom text-emerald-600 mb-4">Completed Activity View</h2>
          <BaseButton type="button" color="success" label="Export Completed Data" @click="exportCompletedData" />
        </div>

        <EasyDataTable
          :headers="headers"
          :items="filteredCompletedData"
        />

      </div>
    </SectionMain>

    <Modal :show="showEditModal" @close="closeEditModal">
  <template #header>
    <h3>Edit Item</h3>
  </template>
  <template #body>
    <form @submit.prevent="saveEditedItem">
      <!-- Add form fields for editing item details -->
      <div v-for="field in editableFields" :key="field">
        <label :for="field">{{ field }}</label>
        <input :id="field" v-model="editingItem[field]" />
      </div>
    </form>
  </template>
  <template #footer>
    <BaseButton type="button" color="success" label="Save" @click="saveEditedItem" />
    <BaseButton type="button" color="danger" label="Cancel" @click="closeEditModal" />
  </template>
</Modal>
  </LayoutAuthenticatedSimple>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import EasyDataTable from 'vue3-easy-data-table';
import 'vue3-easy-data-table/dist/style.css';
import { useActivityStore } from '@/stores/ActivityStore';
import SectionMain from "@/components/SectionMain.vue";
import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";
import BlurryHorizontalDivider from "@/components/BlurryHorizontalDivider.vue";
import TimePickerFlatEmitter from "@/components/TimePickerFlatEmitter.vue";
import BaseButton from "@/components/BaseButton.vue";
import Modal from "@/components/Modal.vue";
import * as XLSX from 'xlsx';

const activityStore = useActivityStore();


// const showEditModal = ref(false);
// const editingItem = ref(null);
// const editableFields = ['status', 'corrective_measurement', 'spare_required', 'support_needed', 'responsible_person_company_id', 'target_date_of_completion'];

// const closeEditModal = () => {
//   showEditModal.value = false;
//   editingItem.value = null;
// };

// const saveEditedItem = async () => {
//   activityStore.saveEditedRowIds(editingItem.value.id);
//   closeEditModal();
//   // Add logic to save the edited item
// };

const headers = [
  { text: 'ID', value: 'id' },
  { text: 'Location', value: 'location' },
  { text: 'Name', value: 'name' },
  { text: 'Group Name', value: 'group_name' },
  { text: 'Parameter Name', value: 'parameter_name' },
  { text: 'Date of Identification', value: 'date_of_identification' },
  { text: 'Latest Occurrence', value: 'latest_occurrence' },
  { text: 'Status', value: 'status' },
];

const summaryHeaders = [
  { text: 'Line', value: 'line' },
  { text: 'Warning', value: 'WARNING' },
  { text: 'Critical', value: 'CRITICAL' },
  { text: 'Completed', value: 'COMPLETED' },
];

const searchField = ref('');
const sortBy = ref('date_of_identification');
const sortType = ref('desc');

const showEditModal = ref(false);
const editingItem = ref(null);
const editableFields = ['status', 'corrective_measurement', 'spare_required', 'support_needed', 'responsible_person_company_id', 'target_date_of_completion'];

const fetchData = async () => {
  try {
    await activityStore.fetchActivityData();
  } catch (error) {
    console.error('Error fetching data:', error);
  }
};

const updateItemStatus = async (item) => {
  activityStore.saveEditedRowIds(item.id);
};

const editItem = (item) => {
  editingItem.value = { ...item };
  showEditModal.value = true;
};

const closeEditModal = () => {
  showEditModal.value = false;
  editingItem.value = null;
};

const saveEditedItem = async () => {
  await activityStore.saveEditedRow(editingItem.value);
  closeEditModal();
  fetchData();
};

const exportData = (items, fileName) => {
  const worksheet = XLSX.utils.json_to_sheet(items);
  const workbook = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(workbook, worksheet, 'Sheet1');
  XLSX.writeFile(workbook, fileName);
};

const exportPendingData = () => exportData(activityStore.pendingData, 'pending_activities.xlsx');
const exportCompletedData = () => exportData(activityStore.completedData, 'completed_activities.xlsx');

const handleFromDateChange = (dateValue) => {
  if (dateValue && dateValue.value && dateValue.value instanceof Date) {
    activityStore.selectedDates.from = dateValue.value.getTime();
  }
};

const handleToDateChange = (dateValue) => {
  if (dateValue && dateValue.value && dateValue.value instanceof Date) {
    activityStore.selectedDates.to = dateValue.value.getTime();
  }
};

const filteredPendingData = computed(() => {
  return activityStore.pendingData.filter(item => item.name.toLowerCase().includes(searchField.value.toLowerCase()))
    .sort((a, b) => {
      const sortOrder = sortType.value === 'asc' ? 1 : -1;
      if (a[sortBy.value] < b[sortBy.value]) return -sortOrder;
      if (a[sortBy.value] > b[sortBy.value]) return sortOrder;
      return 0;
    });
});

const filteredCompletedData = computed(() => {
  return activityStore.completedData.filter(item => item.name.toLowerCase().includes(searchField.value.toLowerCase()))
    .sort((a, b) => {
      const sortOrder = sortType.value === 'asc' ? 1 : -1;
      if (a[sortBy.value] < b[sortBy.value]) return -sortOrder;
      if (a[sortBy.value] > b[sortBy.value]) return sortOrder;
      return 0;
    });
});

onMounted(fetchData);
</script>

<style scoped>
/* Add any additional styles if needed */
</style>
