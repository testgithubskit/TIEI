<template>
  <a-modal
    :visible="visible"
    :title="modalTitle"
    :confirm-loading="loading"
    :maskClosable="false"
    @ok="handleOk"
    @cancel="handleCancel"
    class="complete-activity-modal"
    :okButtonProps="{
      class: 'custom-ok-button'
    }"
    :cancelButtonProps="{
      class: 'custom-cancel-button'
    }"
  >
    <!-- Rest of your form content remains the same -->
    <a-form
      ref="formRef"
      :model="formState"
      layout="vertical"
    >
      <div v-if="selectedActivities.length > 1" class="mb-4">
        <div class="p-4 bg-blue-50 rounded-lg">
          <div class="flex items-center">
            <InfoIcon class="h-5 w-5 text-blue-400 mr-2" />
            <span class="text-blue-700">
              Completing {{ selectedActivities.length }} activities in bulk
            </span>
          </div>
          <div class="mt-2 text-sm text-blue-600">
            The completion details below will be applied to all selected activities.
          </div>
        </div>
      </div>

      <a-form-item
        name="completionDate"
        label="Completion Date"
        :rules="[{ required: true, message: 'Please select completion date' }]"
      >
        <a-date-picker 
          v-model:value="formState.completionDate"
          format="YYYY-MM-DD"
          
          class="w-full "
          :disabled="loading"
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
          :disabled="loading"
          :maxlength="500"
          show-count
          class="w-full"
          :placeholder="textareaPlaceholder"
        />
      </a-form-item>

      <div v-if="selectedActivities.length === 1" class="mt-4 p-4 bg-gray-50 rounded-lg">
        <h4 class="font-medium text-gray-700 mb-2">Activity Details</h4>
        <div class="space-y-2 text-sm">
          <div class="flex justify-between">
            <span class="text-gray-600">ID:</span>
            <span class="font-medium">{{ selectedActivities[0].id }}</span>
          </div>
          <div class="flex justify-between">
            <span class="text-gray-600">Machine:</span>
            <span class="font-medium">{{ selectedActivities[0].machine_name }}</span>
          </div>
          <div class="flex justify-between">
            <span class="text-gray-600">Spare Part:</span>
            <span class="font-medium">{{ selectedActivities[0].spare_part_name }}</span>
          </div>
          <div class="flex justify-between">
            <span class="text-gray-600">Priority:</span>
            <PriorityTag :priority="selectedActivities[0].priority" />
          </div>
        </div>
      </div>
    </a-form>
  </a-modal>
</template>

<script setup>
import { ref, computed, reactive } from 'vue';
import dayjs from 'dayjs';
import { InfoIcon } from 'lucide-react';
import PriorityTag from './PriorityTag.vue';

const props = defineProps({
visible: Boolean,
loading: Boolean,
selectedActivities: {
  type: Array,
  default: () => []
}
});

const emit = defineEmits(['update:visible', 'ok', 'cancel']);

const formRef = ref(null);
const formState = reactive({
completionDate: dayjs(),
correctiveMeasurement: '',
});

const modalTitle = computed(() => {
if (props.selectedActivities.length > 1) {
  return `Complete ${props.selectedActivities.length} Activities`;
}
return 'Complete Activity';
});

const textareaPlaceholder = computed(() => {
if (props.selectedActivities.length > 1) {
  return 'Enter the corrective measurement that applies to all selected activities...';
}
return 'Enter the corrective measurement for this activity...';
});

const handleOk = async () => {
try {
  await formRef.value?.validateFields();
  emit('ok', {
    date_of_completion: formState.completionDate.format('YYYY-MM-DDTHH:mm:ss'),
    corrective_measurement: formState.correctiveMeasurement,
  });
} catch (error) {
  console.error('Validation failed:', error);
}
};

const handleCancel = () => {
formRef.value?.resetFields();
emit('update:visible', false);
emit('cancel');
};
</script>

<style>
/* Using global styles to ensure they take precedence */
.custom-ok-button {
background-color: #2563eb !important; /* blue-600 */
border-color: #2563eb !important;
color: white !important;
}

.custom-ok-button:hover {
background-color: #1d4ed8 !important; /* blue-700 */
border-color: #1d4ed8 !important;
}

.custom-cancel-button {
border-color: #d1d5db !important; /* gray-300 */
color: #374151 !important; /* gray-700 */
}

.custom-cancel-button:hover {
background-color: #f9fafb !important; /* gray-50 */
border-color: #9ca3af !important; /* gray-400 */
}

/* Additional modal styling */
.complete-activity-modal .ant-modal-content {
border-radius: 0.5rem;
}

.complete-activity-modal .ant-modal-header {
border-bottom: 1px solid #f3f4f6;
padding-bottom: 1rem;
}

.complete-activity-modal .ant-modal-footer {
border-top: 1px solid #f3f4f6;
padding-top: 1rem;
}

.complete-activity-modal .ant-btn {
border-radius: 0.5rem;
padding: 0.5rem 1rem;
font-weight: 500;
height: auto;
}
</style>