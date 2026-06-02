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
              <h2 class="text-xl font-semibold text-gray-800">
                Pending Activities
                <a-tag v-if="store.pendingActivities.length" class="ml-2">
                  {{ store.pendingActivities.length }}
                </a-tag>
              </h2>
              <div class="flex gap-3">
                <CustomButton 
                  v-if="selectedRows.length"
                  type="success"
                  @click="showBulkCompleteModal"
                  
                  icon="CheckIcon"
                >
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
              :scroll="{ x: 1200 }"
              :row-selection="rowSelection"
            >
              <template #priority="{ text }">
                <PriorityTag :priority="text" />
              </template>
              <template #targetDate="{ text }">
                {{ formatDate(text) }}
              </template>
              <template #action="{ record }">
                <CustomButton 
                  type="primary" 
                  @click="showCompleteModal(record)"
                 
                  size="small"
                  icon="CheckCircleIcon"
                >
                  Complete
                </CustomButton>
              </template>
            </a-table>
          </div>
        </div>

        <!-- Completed Activities Section -->
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
              :scroll="{ x: 1200 }"
            >
              <template #priority="{ text }">
                <PriorityTag :priority="text" />
              </template>
              <template #completionDate="{ text }">
                {{ formatDate(text) }}
              </template>
              <template #correctiveMeasurement="{ text }">
                <a-tooltip :title="text">
                  <span class="line-clamp-2">{{ text }}</span>
                </a-tooltip>
              </template>
            </a-table>
          </div>
        </div>

        <!-- Complete Activity Modal -->
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
import { ref, onMounted, computed } from 'vue';
import { useSparePartsStore } from '@/stores/sparePartsStore';
import SectionMain from "@/components/SectionMain.vue";
import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";
import { message } from 'ant-design-vue';
import dayjs from 'dayjs';
import { SearchIcon, CheckIcon, CheckCircleIcon } from 'lucide-react';
import PriorityTag from './PriorityTag.vue';
import CustomButton from './CustomButton.vue';
import CompleteActivityModal from './CompleteActivityModal.vue';

const store = useSparePartsStore();
const dateRange = ref(null);
const completeModalVisible = ref(false);
const selectedActivity = ref(null);
const selectedRows = ref([]);
const isLoading = ref(false);

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
    filters: [
      { text: 'Critical', value: 'Critical' },
      { text: 'High', value: 'High' },
      { text: 'Medium', value: 'Medium' },
      { text: 'Low', value: 'Low' },
    ],
    onFilter: (value, record) => record.priority === value,
  },
  { 
    title: 'Target Date', 
    dataIndex: 'target_date_of_completion', 
    key: 'target_date',
    slots: { customRender: 'targetDate' },
    sorter: (a, b) => new Date(a.target_date_of_completion) - new Date(b.target_date_of_completion),
  },
  { 
    title: 'Responsible Person', 
    dataIndex: 'responsible_person_username', 
    key: 'responsible_person' 
  },
  {
    title: 'Action',
    key: 'action',
    width: 120,
    fixed: 'right',
    slots: { customRender: 'action' }
  },
];

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