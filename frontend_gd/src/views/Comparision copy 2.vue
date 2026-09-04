<script setup>
import { ref, computed, onMounted } from 'vue';
import { Table, Input, Button, Modal, Select, InputNumber, Switch, Spin } from 'ant-design-vue';
import { SearchOutlined, DownloadOutlined, PlusOutlined } from '@ant-design/icons-vue';
import LayoutAuthenticatedSimple from '@/layouts/LayoutAuthenticatedSimple.vue';
import SectionMain from '@/components/SectionMain.vue';
import CardBox from '@/components/CardBox.vue';
import * as XLSX from 'xlsx';
import { useCompareParameters } from '../stores/CompareParameters.js';
import debounce from 'lodash/debounce';

const CompareParameters = useCompareParameters();

// State for comparison form
const isModalVisible = ref(false);
const comparisonForm = ref({
  line: '',
  machineName: '',
  isLoadSelected: true,
  parameter1: '',
  parameter2: '',
  warningLimit: null,
  criticalLimit: null,
});

// Computed properties for form validation and dynamic options
const availableLines = computed(() => CompareParameters.formattedData.lines);
const availableMachines = computed(() => {
  return CompareParameters.getMachinesForLine(comparisonForm.value.line);
});
const availableParameters = computed(() => {
  if (!comparisonForm.value.machineName) return [];
  const dynamicParams = CompareParameters.getParametersForMachine(comparisonForm.value.machineName, 'DYNAMIC_PARAMETERS');
  const encoderParams = CompareParameters.getParametersForMachine(comparisonForm.value.machineName, 'ENCODER_TEMPERATURE');
  return comparisonForm.value.isLoadSelected ? dynamicParams : encoderParams;
});

const isLineSelected = computed(() => comparisonForm.value.line !== '');
const isMachineSelected = computed(() => comparisonForm.value.machineName !== '');

// Sample data for comparison table (you'll replace this with actual data from your API)
const comparisonData = ref([]);

// Column definitions for comparison table
const comparisonColumns = [
  { title: 'Line', dataIndex: 'line', key: 'line', sorter: (a, b) => a.line.localeCompare(b.line) },
  { title: 'Machine Name', dataIndex: 'machineName', key: 'machineName', sorter: (a, b) => a.machineName.localeCompare(b.machineName) },
  { title: 'Load/Position', dataIndex: 'loadOrPosition', key: 'loadOrPosition', sorter: (a, b) => a.loadOrPosition.localeCompare(b.loadOrPosition) },
  { title: 'Parameter 1', dataIndex: 'parameter1', key: 'parameter1', sorter: (a, b) => a.parameter1.localeCompare(b.parameter1) },
  { title: 'Parameter 2', dataIndex: 'parameter2', key: 'parameter2', sorter: (a, b) => a.parameter2.localeCompare(b.parameter2) },
  { title: 'Warning Limit', dataIndex: 'warningLimit', key: 'warningLimit', sorter: (a, b) => a.warningLimit - b.warningLimit },
  { title: 'Critical Limit', dataIndex: 'criticalLimit', key: 'criticalLimit', sorter: (a, b) => a.criticalLimit - b.criticalLimit },
];

// Search and filter states
const comparisonSearch = ref('');

// Pagination state
const comparisonPagination = ref({
  current: 1,
  pageSize: 5,
});

// Filter function for comparison data
const filteredComparisonData = computed(() => {
  return comparisonData.value.filter(item => 
    item.line.toLowerCase().includes(comparisonSearch.value.toLowerCase()) ||
    item.machineName.toLowerCase().includes(comparisonSearch.value.toLowerCase()) ||
    item.loadOrPosition.toLowerCase().includes(comparisonSearch.value.toLowerCase()) ||
    item.parameter1.toLowerCase().includes(comparisonSearch.value.toLowerCase()) ||
    item.parameter2.toLowerCase().includes(comparisonSearch.value.toLowerCase())
  );
});

// Function to handle form submission
const handleAddComparison = () => {
  console.log('Submitted comparison:', comparisonForm.value);
  comparisonData.value.push({
    id: comparisonData.value.length + 1,
    line: comparisonForm.value.line,
    machineName: comparisonForm.value.machineName,
    loadOrPosition: comparisonForm.value.isLoadSelected ? 'Load' : 'Position',
    parameter1: comparisonForm.value.parameter1,
    parameter2: comparisonForm.value.parameter2,
    warningLimit: comparisonForm.value.warningLimit,
    criticalLimit: comparisonForm.value.criticalLimit,
  });
  isModalVisible.value = false;
  resetForm();
};

// Function to reset the form
const resetForm = () => {
  comparisonForm.value = {
    line: '',
    machineName: '',
    isLoadSelected: true,
    parameter1: '',
    parameter2: '',
    warningLimit: null,
    criticalLimit: null,
  };
};

// Export function
const exportToExcel = () => {
  const worksheet = XLSX.utils.json_to_sheet(filteredComparisonData.value);
  const workbook = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(workbook, worksheet, 'Comparisons');
  XLSX.writeFile(workbook, 'Comparisons.xlsx');
};

// Fetch data on component mount
onMounted(async () => {
  await CompareParameters.fetchAndFormatData();
});

// Debounced search function
const debouncedSearch = debounce((value) => {
  comparisonSearch.value = value;
}, 300);

// Handler for Load/Position switch change
const handleLoadPositionChange = () => {
  comparisonForm.value.parameter1 = '';
  comparisonForm.value.parameter2 = '';
};

</script>

<template>
  <LayoutAuthenticatedSimple>
    <SectionMain>
      <div class="container mx-auto px-4 py-8">
        <h1 class="text-3xl font-semibold text-emerald-700 mb-6">Parameter Comparisons</h1>
        
        <div class="mb-6 flex justify-between items-center">
          <Button @click="isModalVisible = true" type="primary" class="bg-emerald-500">
            <template #icon><PlusOutlined /></template>
            Add Comparison
          </Button>
          <Button @click="exportToExcel" class="bg-emerald-500 text-white">
            <template #icon><DownloadOutlined /></template>
            Export to Excel
          </Button>
        </div>

        <Input
          :value="comparisonSearch"
          @input="debouncedSearch($event.target.value)"
          placeholder="Search comparisons"
          class="mb-3 w-full sm:w-64"
        >
          <template #prefix>
            <SearchOutlined />
          </template>
        </Input>

        <CardBox class="overflow-x-auto">
          <Table
            :columns="comparisonColumns"
            :dataSource="filteredComparisonData"
            :rowKey="record => record.id"
            :pagination="comparisonPagination"
            class="w-full"
            :scroll="{ x: 'max-content' }"
          />
        </CardBox>

        <Modal
          v-model:visible="isModalVisible"
          title="Add Comparison"
          @ok="handleAddComparison"
          :okButtonProps="{ disabled: !isMachineSelected }"
          width="600px"
        >
          <Spin :spinning="CompareParameters.isLoading">
            <div class="space-y-4">
              <div>
                <label class="block text-sm font-medium text-gray-700">Line</label>
                <Select
                  v-model:value="comparisonForm.line"
                  style="width: 100%"
                  placeholder="Select a line"
                  show-search
                  :filter-option="(input, option) => 
                    option.value.toLowerCase().indexOf(input.toLowerCase()) >= 0"
                >
                  <Select.Option v-for="line in availableLines" :key="line" :value="line">
                    {{ line }}
                  </Select.Option>
                </Select>
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700">Machine Name</label>
                <Select
                  v-model:value="comparisonForm.machineName"
                  style="width: 100%"
                  placeholder="Select a machine"
                  :disabled="!isLineSelected"
                  show-search
                  :filter-option="(input, option) => 
                    option.value.toLowerCase().indexOf(input.toLowerCase()) >= 0"
                >
                  <Select.Option v-for="machine in availableMachines" :key="machine.name" :value="machine.name">
                    {{ machine.name }}
                  </Select.Option>
                </Select>
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700">Load/Position</label>
                <Switch
                  v-model:checked="comparisonForm.isLoadSelected"
                  :disabled="!isMachineSelected"
                  checked-children="Load"
                  un-checked-children="Position"
                  class="bg-emerald-500"
                  @change="handleLoadPositionChange"
                />
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700">Parameter 1</label>
                <Select
                  v-model:value="comparisonForm.parameter1"
                  style="width: 100%"
                  placeholder="Select parameter 1"
                  :disabled="!isMachineSelected"
                  show-search
                  :filter-option="(input, option) => 
                    option.value.toLowerCase().indexOf(input.toLowerCase()) >= 0"
                >
                  <Select.Option v-for="param in availableParameters" :key="param.name" :value="param.name">
                    {{ param.name }}
                  </Select.Option>
                </Select>
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700">Parameter 2</label>
                <Select
                  v-model:value="comparisonForm.parameter2"
                  style="width: 100%"
                  placeholder="Select parameter 2"
                  :disabled="!isMachineSelected"
                  show-search
                  :filter-option="(input, option) => 
                    option.value.toLowerCase().indexOf(input.toLowerCase()) >= 0"
                >
                  <Select.Option v-for="param in availableParameters" :key="param.name" :value="param.name">
                    {{ param.name }}
                  </Select.Option>
                </Select>
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700">Warning Limit</label>
                <InputNumber v-model:value="comparisonForm.warningLimit" style="width: 100%" />
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700">Critical Limit</label>
                <InputNumber v-model:value="comparisonForm.criticalLimit" style="width: 100%" />
              </div>
            </div>
          </Spin>
        </Modal>
      </div>
    </SectionMain>
  </LayoutAuthenticatedSimple>
</template>

<style>
.ant-table-wrapper {
  @apply bg-white shadow-sm rounded-lg overflow-hidden;
}

.ant-table-thead > tr > th {
  @apply bg-emerald-50 text-emerald-700 font-semibold;
}

.ant-table-tbody > tr > td {
  @apply border-b border-emerald-100;
}

.ant-table-tbody > tr:hover > td {
  @apply bg-emerald-50;
}

.ant-pagination-item-active {
  @apply border-emerald-500 bg-emerald-500 text-white;
}

.ant-input-affix-wrapper {
  @apply border-emerald-300 focus:border-emerald-500 focus:ring focus:ring-emerald-200 focus:ring-opacity-50;
}

.ant-btn-primary {
  @apply bg-emerald-500 border-emerald-500 text-white hover:bg-emerald-600 hover:border-emerald-600 hover:scale-105 transition-all;
}

.ant-select:not(.ant-select-disabled):hover .ant-select-selector {
  @apply border-emerald-500;
}

.ant-select-focused:not(.ant-select-disabled).ant-select:not(.ant-select-customize-input) .ant-select-selector {
  @apply border-emerald-500 shadow-none;
}

.ant-switch-checked {
  @apply bg-emerald-500;
}

.ant-modal-content {
  @apply rounded-lg;
}

.ant-modal-header {
  @apply bg-emerald-50 rounded-t-lg;
}

.ant-modal-title {
  @apply text-emerald-700;
}

.ant-modal-footer {
  @apply bg-gray-50 rounded-b-lg;
}

.ant-input-number {
  @apply w-full;
}

.ant-input-number:hover {
  @apply border-emerald-500;
}

.ant-input-number-focused {
  @apply border-emerald-500 shadow-none;
}
</style>