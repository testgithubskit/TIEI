<template>
  <LayoutAuthenticatedSimple class="bg-gray-100">
    <SectionMain>
      <div class="p-6">
        <!-- Header Section -->
        <div class="mb-6">
          <h1 class="text-2xl font-bold mb-4">Spare Parts Maintenance Activities</h1>
          <div class="flex items-center gap-4 bg-white p-4 rounded-lg shadow">
            <a-range-picker
              v-model:value="dateRange"
              class="w-80"
              :allow-clear="false"
              :disabled="store.loading"
            />
            <a-button 
              type="primary" 
              @click="searchActivities"
              :loading="store.loading"
            >
              Search
            </a-button>
          </div>
        </div>

        <!-- Error Alert -->
        <a-alert
          v-if="store.error"
          type="error"
          :message="store.error"
          class="mb-4"
          closable
          @close="store.error = null"
        />

        <!-- Pending Activities Section -->
        <div class="bg-white p-6 rounded-lg shadow mb-6">
          <h2 class="text-xl font-semibold mb-4">Pending Activities</h2>
          <a-table
            :columns="pendingColumns"
            :data-source="store.pendingActivities"
            :loading="store.loading"
            row-key="id"
            :scroll="{ x: 1200 }"
          >
            <template #priority="{ text }">
              <a-tag :color="getPriorityColor(text)">{{ text }}</a-tag>
            </template>
            <template #targetDate="{ text }">
              {{ formatDate(text) }}
            </template>
            <template #action="{ record }">
              <a-button 
                type="primary" 
                @click="showCompleteModal(record)"
                :disabled="store.loading"
              >
                Complete
              </a-button>
            </template>
          </a-table>
        </div>

        <!-- Completed Activities Section -->
        <div class="bg-white p-6 rounded-lg shadow">
          <h2 class="text-xl font-semibold mb-4">Activity History</h2>
          <a-table
            :columns="historyColumns"
            :data-source="store.completedActivities"
            :loading="store.loading"
            row-key="id"
            :scroll="{ x: 1200 }"
          >
            <template #priority="{ text }">
              <a-tag :color="getPriorityColor(text)">{{ text }}</a-tag>
            </template>
            <template #completionDate="{ text }">
              {{ formatDate(text) }}
            </template>
          </a-table>
        </div>

        <!-- Complete Activity Modal -->
        <a-modal
          v-model:visible="completeModalVisible"
          title="Complete Activity"
          :confirm-loading="store.loading"
          :maskClosable="false"
          @ok="handleModalOk"
          @cancel="handleModalCancel"
        >
          <a-form
            ref="formRef"
            :model="formState"
            layout="vertical"
          >
            <a-form-item
              name="completionDate"
              label="Completion Date"
              :rules="[{ required: true, message: 'Please select completion date' }]"
            >
              <a-date-picker 
                v-model:value="formState.completionDate"
                show-time 
                format="YYYY-MM-DD HH:mm:ss"
                class="w-full"
                :disabled="store.loading"
              />
            </a-form-item>
            <a-form-item
              name="correctiveMeasurement"
              label="Corrective Measurement"
              :rules="[{ required: true, message: 'Please enter corrective measurement' }]"
            >
              <a-textarea 
                v-model:value="formState.correctiveMeasurement"
                :rows="4"
                :disabled="store.loading"
                :maxlength="500"
                show-count
              />
            </a-form-item>
          </a-form>
        </a-modal>
      </div>
    </SectionMain>
  </LayoutAuthenticatedSimple>
</template>

<script setup>
import { ref, onMounted, reactive } from 'vue';
import { useSparePartsStore } from '@/stores/sparePartsStore';
import SectionMain from "@/components/SectionMain.vue";
import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";
import { message } from 'ant-design-vue';
import dayjs from 'dayjs';

const store = useSparePartsStore();
const dateRange = ref(null);
const completeModalVisible = ref(false);
const selectedActivity = ref(null);
const formRef = ref(null);
const formState = reactive({
  completionDate: null,
  correctiveMeasurement: '',
});

const formatDate = (date) => {
  if (!date) return '-';
  return dayjs(date).format('YYYY-MM-DD HH:mm:ss');
};

const pendingColumns = [
  { title: 'ID', dataIndex: 'id', key: 'id', width: 80 },
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
    title: 'Target Date', 
    dataIndex: 'target_date_of_completion', 
    key: 'target_date',
    slots: { customRender: 'targetDate' }
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
    slots: { customRender: 'action' }
  },
];

const historyColumns = [
  { title: 'ID', dataIndex: 'id', key: 'id', width: 80 },
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
    slots: { customRender: 'completionDate' }
  },
  { 
    title: 'Corrective Measurement', 
    dataIndex: 'corrective_measurement', 
    key: 'corrective_measurement',
    ellipsis: true 
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
  const [start, end] = dateRange.value;
  await store.fetchActivities(start.valueOf(), end.valueOf());
};

const showCompleteModal = (record) => {
  selectedActivity.value = record;
  formState.completionDate = dayjs();
  formState.correctiveMeasurement = record.corrective_measurement || '';
  completeModalVisible.value = true;
};

const handleModalCancel = () => {
  formRef.value?.resetFields();
  completeModalVisible.value = false;
  selectedActivity.value = null;
};

const handleModalOk = async () => {
  if (store.loading) return;

  try {
    await formRef.value?.validateFields();
    const completionData = {
      date_of_completion: formState.completionDate.format('YYYY-MM-DDTHH:mm:ss'),
      corrective_measurement: formState.correctiveMeasurement,
    };
    
    const success = await store.completeActivity(selectedActivity.value.id, completionData);
    if (success) {
      handleModalCancel();
    }
  } catch (error) {
    // Form validation error
    console.error('Validation failed:', error);
  }
};

const getPriorityColor = (priority) => {
  const colors = {
    'High': 'red',
    'Medium': 'orange',
    'Low': 'green',
    'Critical': 'magenta'
  };
  return colors[priority] || 'blue';
};

onMounted(() => {
  // Set default date range to last 7 days
  const end = dayjs();
  const start = dayjs().subtract(7, 'day');
  dateRange.value = [start, end];
  searchActivities();
});
</script>

<style scoped>
:deep(.ant-table-wrapper) {
  width: 100%;
}

:deep(.ant-tag) {
  font-size: 0.875rem;
  font-weight: 500;
}

:deep(.ant-form-item-required::before) {
  display: none !important;
}
</style>