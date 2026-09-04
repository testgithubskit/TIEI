<script setup>
import { ref, computed, onMounted } from 'vue';
import { Table, Input, DatePicker, Button, Modal, Select, InputNumber } from 'ant-design-vue';
import { SearchOutlined, DownloadOutlined, PlusOutlined } from '@ant-design/icons-vue';
import LayoutAuthenticatedSimple from '@/layouts/LayoutAuthenticatedSimple.vue';
import SectionMain from '@/components/SectionMain.vue';
import CardBox from '@/components/CardBox.vue';
import * as XLSX from 'xlsx';


import { useCompareParameters } from '../stores/CompareParameters.js';

const CompareParameters = useCompareParameters();


// Sample data for lines, machines, and parameters
const lines = ['Line A', 'Line B', 'Line C'];
const machinesByLine = {
  'Line A': ['Machine A1', 'Machine A2', 'Machine A3'],
  'Line B': ['Machine B1', 'Machine B2', 'Machine B3'],
  'Line C': ['Machine C1', 'Machine C2', 'Machine C3'],
};
const loadPositions = ['Load 1', 'Load 2', 'Position 1', 'Position 2'];
const parameters = ['Temperature', 'Pressure', 'Speed', 'Voltage', 'Current'];

// State for comparison form
const isModalVisible = ref(false);
const comparisonForm = ref({
  line: '',
  machineName: '',
  loadOrPosition: '',
  parameter1: '',
  parameter2: '',
  warningLimit: null,
  criticalLimit: null,
});

// Computed properties for form validation and dynamic options
const availableMachines = computed(() => machinesByLine[comparisonForm.value.line] || []);
const isLineSelected = computed(() => comparisonForm.value.line !== '');
const isMachineSelected = computed(() => comparisonForm.value.machineName !== '');
const isLoadPositionSelected = computed(() => comparisonForm.value.loadOrPosition !== '');

// Sample data for comparison table
const comparisonData = ref([
  { id: 1, line: 'Line A', machineName: 'Machine A1', loadOrPosition: 'Load 1', parameter1: 'Temperature', parameter2: 'Pressure', warningLimit: 80, criticalLimit: 90 },
  { id: 2, line: 'Line B', machineName: 'Machine B2', loadOrPosition: 'Position 2', parameter1: 'Speed', parameter2: 'Voltage', warningLimit: 100, criticalLimit: 120 },
  { id: 3, line: 'Line C', machineName: 'Machine C3', loadOrPosition: 'Load 2', parameter1: 'Current', parameter2: 'Temperature', warningLimit: 50, criticalLimit: 60 },
]);

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
  // Here you would typically send the data to your backend
  // For now, we'll just add it to our local data
  comparisonData.value.push({
    id: comparisonData.value.length + 1,
    ...comparisonForm.value
  });
  isModalVisible.value = false;
  // Reset form
  comparisonForm.value = {
    line: '',
    machineName: '',
    loadOrPosition: '',
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
          v-model:value="comparisonSearch"
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
        >
          <div class="space-y-4">
            <div>
              <label class="block text-sm font-medium text-gray-700">Line</label>
              <Select
                v-model:value="comparisonForm.line"
                style="width: 100%"
                placeholder="Select a line"
              >
                <Select.Option v-for="line in lines" :key="line" :value="line">
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
              >
                <Select.Option v-for="machine in availableMachines" :key="machine" :value="machine">
                  {{ machine }}
                </Select.Option>
              </Select>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700">Load/Position</label>
              <Select
                v-model:value="comparisonForm.loadOrPosition"
                style="width: 100%"
                placeholder="Select load or position"
                :disabled="!isMachineSelected"
              >
                <Select.Option v-for="item in loadPositions" :key="item" :value="item">
                  {{ item }}
                </Select.Option>
              </Select>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700">Parameter 1</label>
              <Select
                v-model:value="comparisonForm.parameter1"
                style="width: 100%"
                placeholder="Select parameter 1"
                :disabled="!isLoadPositionSelected"
              >
                <Select.Option v-for="param in parameters" :key="param" :value="param">
                  {{ param }}
                </Select.Option>
              </Select>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700">Parameter 2</label>
              <Select
                v-model:value="comparisonForm.parameter2"
                style="width: 100%"
                placeholder="Select parameter 2"
                :disabled="!isLoadPositionSelected"
              >
                <Select.Option v-for="param in parameters" :key="param" :value="param">
                  {{ param }}
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
</style>