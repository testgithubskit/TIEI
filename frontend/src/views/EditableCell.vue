<!-- EditableCell.vue -->
<template>
    <div 
      :class="[
        'editable-cell relative group cursor-pointer transition-all duration-200',
        { 'editing': isEditing }
      ]"
    >
      <!-- View Mode -->
      <div 
        v-if="!isEditing" 
        @click="startEdit"
        class="p-3 hover:bg-gray-50 rounded-lg flex items-center justify-between"
      >
        <div class="flex items-center space-x-2">
          <slot name="display" :value="value">
            <span class="text-gray-900">{{ displayValue }}</span>
          </slot>
        </div>
        <a-button 
          type="text"
          size="small"
          class="edit-button opacity-0 group-hover:opacity-100 transition-opacity"
        >
          <template #icon>
            <EditIcon class="h-4 w-4 text-blue-600" />
          </template>
        </a-button>
      </div>
  
      <!-- Edit Mode -->
      <div v-else class="p-3 bg-blue-50 rounded-lg border-2 border-blue-200">
        <div class="space-y-3">
          <!-- Select Input -->
          <template v-if="type === 'select'">
            <a-select
              v-model:value="editValue"
              :options="options"
              class="w-full !rounded-lg"
              :disabled="loading"
              @blur="handleBlur"
            />
          </template>
  
          <!-- Date Input -->
          <template v-else-if="type === 'date'">
            <a-date-picker
              v-model:value="editValue"
              class="w-full !rounded-lg"
              :disabled="loading"
              format="YYYY-MM-DD"
              @ok="handleSave"
              @blur="handleBlur"
            />
          </template>
  
          <!-- Text Input -->
          <template v-else>
            <a-input
              v-model:value="editValue"
              class="w-full !rounded-lg"
              :disabled="loading"
              @pressEnter="handleSave"
              @blur="handleBlur"
            />
          </template>
  
          <!-- Action Buttons -->
          <div class="flex justify-end space-x-2">
            <a-button
              type="text"
              :disabled="loading"
              class="hover:bg-white/50 text-gray-600"
              @click="handleCancel"
            >
              <template #icon>
                <XIcon class="h-4 w-4" />
              </template>
              Cancel
            </a-button>
            <a-button
              type="primary"
              :loading="loading"
              class="custom-ok-button"
              @click="handleSave"
            >
              <template #icon>
                <CheckIcon v-if="!loading" class="h-4 w-4" />
              </template>
              Save
            </a-button>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, computed } from 'vue';
  import { EditIcon, CheckIcon, XIcon } from 'lucide-vue-next';
  import dayjs from 'dayjs';
  
  const props = defineProps({
    value: {
      type: [String, Number, Date],
      required: true
    },
    type: {
      type: String,
      default: 'text'
    },
    options: {
      type: Array,
      default: () => []
    },
    loading: {
      type: Boolean,
      default: false
    }
  });
  
  const emit = defineEmits(['update:value', 'save', 'cancel']);
  
  const isEditing = ref(false);
  const editValue = ref(props.value);
  
  // Format display value based on type
  const displayValue = computed(() => {
    if (props.type === 'date' && props.value) {
      return dayjs(props.value).format('YYYY-MM-DD');
    }
    if (props.type === 'select') {
      const option = props.options.find(opt => opt.value === props.value);
      return option ? option.label : props.value;
    }
    return props.value;
  });
  
  const startEdit = () => {
    editValue.value = props.value;
    isEditing.value = true;
  };
  
  const handleSave = async () => {
    if (props.loading) return;
    
    try {
      emit('save', editValue.value);
      isEditing.value = false;
    } catch (error) {
      console.error('Error saving:', error);
    }
  };
  
  const handleCancel = () => {
    isEditing.value = false;
    editValue.value = props.value;
    emit('cancel');
  };
  
  const handleBlur = () => {
    // Only cancel on blur if there's no value change
    if (editValue.value === props.value) {
      handleCancel();
    }
  };
  </script>
  
  <style scoped>
  .editable-cell {
    @apply transition-all duration-200;
  }
  
  .editable-cell.editing {
    @apply z-10 shadow-sm;
  }
  
  .custom-ok-button {
    @apply bg-blue-600 border-blue-600 text-white hover:bg-blue-700 hover:border-blue-700;
  }
  
  :deep(.ant-select),
  :deep(.ant-picker),
  :deep(.ant-input) {
    @apply rounded-lg border-2 border-transparent hover:border-blue-300 focus:border-blue-400 transition-colors;
  }
  
  :deep(.ant-select-selector),
  :deep(.ant-picker),
  :deep(.ant-input) {
    @apply !rounded-lg;
  }
  
  :deep(.ant-btn) {
    @apply rounded-lg flex items-center gap-2;
  }
  </style>