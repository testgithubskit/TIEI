<template>
  <LayoutAuthenticatedSimple class="bg-gray-100 min-h-screen">
    <SectionMain>
      <div class="p-6 space-y-6">
        <!-- Header Section -->
        <div class="bg-white rounded-xl shadow-sm p-6">
          <h1 class="text-2xl font-bold mb-6 text-gray-800">Spare Parts Maintenance Activities</h1>
          <div class="flex flex-wrap items-center gap-4">
            <a-range-picker
              v-model:value="dateRange"
              class="w-80"
            />
            <CustomButton 
              type="primary" 
              @click="searchActivities"
              :disabled="!dateRange"
              icon="SearchIcon"
            >
              <SearchIcon class="h-4 w-4 mr-1" />
              Search
            </CustomButton>
          </div>
        </div>

        <!-- Error Alert -->
        <a-alert
          v-if="store.error"
          type="error"
          :message="store.error"
          class="mb-4"
          closable
          banner
          @close="store.error = null"
        />

        <!-- Pending Activities Section -->
        <div class="bg-white rounded-xl shadow-sm">
          <div class="p-6 border-b border-gray-100">
            <div class="flex items-center justify-between">
              <h2 class="text-xl font-semibold text-gray-800 flex items-center">
                Pending Activities
                <a-tag v-if="store.pendingActivities.length" class="ml-2">
                  {{ store.pendingActivities.length }}
                </a-tag>
                <a-tooltip title="Click on a cell to edit">
                  <EditIcon class="h-4 w-4 ml-2 text-gray-400" />
                </a-tooltip>
              </h2>
              <div class="flex gap-3">
                <CustomButton 
                  v-if="selectedRows.length"
                  type="success"
                  @click="showBulkCompleteModal"
                  icon="CheckIcon"
                >
                  <CheckIcon class="h-4 w-4 mr-1" />
                  Complete Selected ({{ selectedRows.length }})
                </CustomButton>
              </div>
            </div>
          </div>
          <div class="p-6">
            <a-table
              :columns="pendingColumns"
              :data-source="store.pendingActivities"
              row-key="id"
              :scroll="{ x: 1500 }"
              :row-selection="rowSelection"
              :loading="isLoading"
              bordered
            >
              <!-- Priority Column -->
              <template #priority="{ text, record }">
                <div v-if="editingCell.id === record.id && editingCell.field === 'priority'">
                  <a-select
                    v-model:value="editingCell.value"
                    style="width: 100%"
                    @blur="saveEdit(record)"
                    @change="saveEdit(record)"
                  >
                    <a-select-option value="Critical">Critical</a-select-option>
                    <a-select-option value="High">High</a-select-option>
                    <a-select-option value="Medium">Medium</a-select-option>
                    <a-select-option value="Low">Low</a-select-option>
                  </a-select>
                </div>
                <div v-else @click="startEdit(record, 'priority', text)">
                  <PriorityTag :priority="text" />
                </div>
              </template>

              <!-- Target Date Column -->
              <template #targetDate="{ text, record }">
                <div v-if="editingCell.id === record.id && editingCell.field === 'target_date_of_completion'">
                  <a-date-picker
                    v-model:value="editingCell.value"
                    style="width: 100%"
                    @ok="saveEdit(record)"
                    @blur="saveEdit(record)"
                  />
                </div>
                <div v-else @click="startEdit(record, 'target_date_of_completion', text)">
                  {{ formatDate(text) }}
                </div>
              </template>

              <!-- Spare Required Column -->
              <template #spareRequired="{ text, record }">
                <div v-if="editingCell.id === record.id && editingCell.field === 'spare_required'">
                  <a-input
                    v-model:value="editingCell.value"
                    @pressEnter="saveEdit(record)"
                    @blur="saveEdit(record)"
                    class="editable-cell"
                  />
                </div>
                <div v-else @click="startEdit(record, 'spare_required', text)">
                  {{ text }}
                </div>
              </template>

              <!-- Support Needed Column -->
              <template #supportNeeded="{ text, record }">
                <div v-if="editingCell.id === record.id && editingCell.field === 'support_needed'">
                  <a-input
                    v-model:value="editingCell.value"
                    @pressEnter="saveEdit(record)"
                    @blur="saveEdit(record)"
                    class="editable-cell"
                  />
                </div>
                <div v-else @click="startEdit(record, 'support_needed', text)">
                  {{ text }}
                </div>
              </template>

              <!-- Identification Date Column -->
              <template #identificationDate="{ text }">
                {{ formatDate(text) }}
              </template>

              <!-- Action Column -->
              <template #action="{ record }">
                <div class="flex gap-1">
                  <CustomButton 
                    type="primary" 
                    @click="showCompleteModal(record)"
                    size="small"
                    icon="CircleCheck"
                  >
                    <CircleCheck class="h-4 w-4" />
                  </CustomButton>
                  <a-tooltip title="Save Changes">
                    <CustomButton
                      v-if="hasChanges(record)"
                      type="success"
                      size="small"
                      icon="Save"
                      @click="saveChanges(record)"
                    >
                      <Save class="h-4 w-4" />
                    </CustomButton>
                  </a-tooltip>
                </div>
              </template>
            </a-table>
          </div>
        </div>

        <!-- History Section remains the same but with added columns -->
        <div class="bg-white rounded-xl shadow-sm">
          <div class="p-6 border-b border-gray-100">
            <h2 class="text-xl font-semibold text-gray-800">
              Activity History
              <a-tag v-if="store.completedActivities.length" class="ml-2">
                {{ store.completedActivities.length }}
              </a-tag>
            </h2>
          </div>
          <div class="p-6">
            <a-table
              :columns="historyColumns"
              :data-source="store.completedActivities"
              row-key="id"
              :scroll="{ x: 1500 }"
              :loading="isLoading"
              bordered
            >
              <!-- Template slots remain the same -->
            </a-table>
          </div>
        </div>

        <!-- Complete Activity Modal component remains the same -->
        <CompleteActivityModal
          v-model:visible="completeModalVisible"
          :selected-activities="selectedActivity ? [selectedActivity] : selectedRows"
          @ok="handleModalOk"
          @cancel="handleModalCancel"
        />
      </div>
    </SectionMain>
  </LayoutAuthenticatedSimple>
</template>

<script setup>
import { ref, onMounted, computed, reactive } from 'vue';
import { useSparePartsStore } from '@/stores/sparePartsStore';
import SectionMain from "@/components/SectionMain.vue";
import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";
import { message } from 'ant-design-vue';
import dayjs from 'dayjs';
import PriorityTag from './PriorityTag.vue';
import CustomButton from './CustomButton.vue';
import CompleteActivityModal from './CompleteActivityModal.vue';
import { Save, CircleCheck, SearchIcon, CheckIcon, EditIcon } from 'lucide-vue-next';

const store = useSparePartsStore();
const dateRange = ref(null);
const completeModalVisible = ref(false);
const selectedActivity = ref(null);
const selectedRows = ref([]);
const isLoading = ref(false);
const editingCell = reactive({
  id: null,
  field: null,
  value: null
});

// Track changes for each record
const changedRecords = ref(new Map());

// Enhanced columns definition with new fields
const pendingColumns = [
  { 
    title: 'ID', 
    dataIndex: 'id', 
    key: 'id', 
    width: 80,
    fixed: 'left'
  },
  { title: 'Location', dataIndex: 'location', key: 'location' },
  { title: 'Machine', dataIndex: 'machine_name', key: 'machine_name' },
  { title: 'Spare Part', dataIndex: 'spare_part_name', key: 'spare_part_name' },
  { 
    title: 'Priority', 
    dataIndex: 'priority', 
    key: 'priority',
    slots: { customRender: 'priority' },
    width: 120,
  },
  { 
    title: 'Target Date', 
    dataIndex: 'target_date_of_completion', 
    key: 'target_date',
    slots: { customRender: 'targetDate' },
    width: 150,
  },
  {
    title: 'Spare Required',
    dataIndex: 'spare_required',
    key: 'spare_required',
    slots: { customRender: 'spareRequired' },
  },
  {
    title: 'Support Needed',
    dataIndex: 'support_needed',
    key: 'support_needed',
    slots: { customRender: 'supportNeeded' },
  },
  {
    title: 'Identification Date',
    dataIndex: 'date_of_identification',
    key: 'identification_date',
    slots: { customRender: 'identificationDate' },
    width: 150,
  },
  { 
    title: 'Responsible Person', 
    dataIndex: 'responsible_person_username', 
    key: 'responsible_person',
  },
  {
    title: 'Action',
    key: 'action',
    width: 160,
    fixed: 'right',
    slots: { customRender: 'action' }
  },
];

// Function to start editing a cell
const startEdit = (record, field, value) => {
  editingCell.id = record.id;
  editingCell.field = field;
  editingCell.value = field === 'target_date_of_completion' ? dayjs(value) : value;
};

// Function to save edit
const saveEdit = async (record) => {
  if (!editingCell.value) return;

  let value = editingCell.value;
  if (editingCell.field === 'target_date_of_completion') {
    value = value.format('YYYY-MM-DD');
  }

  // Immediately update the record locally in the data source
  const index = store.pendingActivities.findIndex(item => item.id === record.id);
  if (index > -1) {
    store.pendingActivities[index] = { ...store.pendingActivities[index], [editingCell.field]: value };
  }

  // Store the change (tracking unsaved changes separately)
  if (!changedRecords.value.has(record.id)) {
    changedRecords.value.set(record.id, {});
  }
  changedRecords.value.get(record.id)[editingCell.field] = value;

  // Reset editing state
  editingCell.id = null;
  editingCell.field = null;
  editingCell.value = null;
};

// Function to check if record has unsaved changes
const hasChanges = (record) => {
  return changedRecords.value.has(record.id);
};

// Function to save all changes for a record
const saveChanges = async (record) => {
  if (!changedRecords.value.has(record.id)) return;

  try {
    isLoading.value = true;
    const changes = changedRecords.value.get(record.id);
    
    await store.updateActivity(record.id, changes);
    
    changedRecords.value.delete(record.id);
    message.success('Changes saved successfully');
  } catch (error) {
    console.error('Error saving changes:', error);
    message.error('Failed to save changes');
  } finally {
    isLoading.value = false;
  }
};
// Computed property for row selection
const rowSelection = computed(() => ({
  selectedRowKeys: selectedRows.value.map(row => row.id),
  onChange: (selectedRowKeys, selectedRecords) => {
    selectedRows.value = selectedRecords;
  },
  getCheckboxProps: () => ({
    disabled: isLoading.value
  })
}));

const formatDate = (date) => {
  if (!date) return '-';
  return dayjs(date).format('YYYY-MM-DD HH:mm:ss');
};

// const pendingColumns = [
//   { 
//     title: 'ID', 
//     dataIndex: 'id', 
//     key: 'id', 
//     width: 80,
//     fixed: 'left'
//   },
//   { title: 'Location', dataIndex: 'location', key: 'location' },
//   { title: 'Machine', dataIndex: 'machine_name', key: 'machine_name' },
//   { title: 'Spare Part', dataIndex: 'spare_part_name', key: 'spare_part_name' },
//   { 
//     title: 'Priority', 
//     dataIndex: 'priority', 
//     key: 'priority',
//     slots: { customRender: 'priority' },
//     filters: [
//       { text: 'Critical', value: 'Critical' },
//       { text: 'High', value: 'High' },
//       { text: 'Medium', value: 'Medium' },
//       { text: 'Low', value: 'Low' },
//     ],
//     onFilter: (value, record) => record.priority === value,
//   },
//   { 
//     title: 'Target Date', 
//     dataIndex: 'target_date_of_completion', 
//     key: 'target_date',
//     slots: { customRender: 'targetDate' },
//     sorter: (a, b) => new Date(a.target_date_of_completion) - new Date(b.target_date_of_completion),
//   },
//   { 
//     title: 'Responsible Person', 
//     dataIndex: 'responsible_person_username', 
//     key: 'responsible_person' 
//   },
//   {
//     title: 'Action',
//     key: 'action',
//     width: 120,
//     fixed: 'right',
//     slots: { customRender: 'action' }
//   },
// ];

const historyColumns = [
  { 
    title: 'ID', 
    dataIndex: 'id', 
    key: 'id', 
    width: 80,
    fixed: 'left'
  },
  { title: 'Location', dataIndex: 'location', key: 'location' },
  { title: 'Machine', dataIndex: 'machine_name', key: 'machine_name' },
  { title: 'Spare Part', dataIndex: 'spare_part_name', key: 'spare_part_name' },
  { 
    title: 'Priority', 
    dataIndex: 'priority', 
    key: 'priority',
    slots: { customRender: 'priority' }
  },
  { 
    title: 'Completion Date', 
    dataIndex: 'date_of_completion', 
    key: 'completion_date',
    slots: { customRender: 'completionDate' },
    sorter: (a, b) => new Date(a.date_of_completion) - new Date(b.date_of_completion),
  },
  { 
    title: 'Corrective Measurement', 
    dataIndex: 'corrective_measurement', 
    key: 'corrective_measurement',
    slots: { customRender: 'correctiveMeasurement' }
  },
  { 
    title: 'Responsible Person', 
    dataIndex: 'responsible_person_username', 
    key: 'responsible_person' 
  },
];

const searchActivities = async () => {
  if (!dateRange.value) {
    message.warning('Please select a date range');
    return;
  }
  
  try {
    isLoading.value = true;
    selectedRows.value = []; // Clear selection when searching
    
    const [start, end] = dateRange.value;
    await store.fetchActivities(start.valueOf(), end.valueOf());
    
    if (store.error) {
      message.error('Failed to fetch activities');
    }
  } catch (error) {
    console.error('Error fetching activities:', error);
    message.error('An error occurred while fetching activities');
  } finally {
    isLoading.value = false;
  }
};

const showCompleteModal = (record) => {
  selectedActivity.value = record;
  selectedRows.value = [];
  completeModalVisible.value = true;
};

const showBulkCompleteModal = () => {
  selectedActivity.value = null;
  completeModalVisible.value = true;
};

const handleModalCancel = () => {
  completeModalVisible.value = false;
  selectedActivity.value = null;
  selectedRows.value = [];
};

const handleModalOk = async (completionData) => {
  if (isLoading.value) return;

  try {
    isLoading.value = true;
    const activities = selectedActivity.value ? [selectedActivity.value] : selectedRows.value;
    
    // Create an array of promises for all activities
    const promises = activities.map(activity => 
      store.completeActivity(activity.id, completionData)
    );
    
    // Wait for all completion requests to finish
    await Promise.all(promises);
    
    // Refresh the activities list
    await searchActivities();
    
    handleModalCancel();
    message.success(`Successfully completed ${activities.length} ${activities.length === 1 ? 'activity' : 'activities'}`);
  } catch (error) {
    console.error('Error completing activities:', error);
    message.error('Failed to complete activities');
  } finally {
    isLoading.value = false;
  }
};

onMounted(() => {
  const end = dayjs();
  const start = dayjs().subtract(7, 'day');
  dateRange.value = [start, end];
  searchActivities();
});
</script>

<style>
/* Existing styles remain the same */
/* Add styles for editable cells */
.editable-cell {
  position: relative !important;
  padding: 5px 12px !important;
  cursor: pointer !important;
  border-radius: 8px !important;
}

.editable-cell:hover {
  background-color: #f5f5f5 !important;
  border-radius: 4px !important;
}

/* Additional styling for the table */
.ant-table-bordered .ant-table-cell {
  transition: background-color 0.3s !important;
}

.ant-table-row:hover .ant-table-cell {
  background-color: #f5f5f5 !important;
}

</style>