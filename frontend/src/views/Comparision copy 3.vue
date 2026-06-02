<script setup>
import { ref, computed, onMounted, onUnmounted, watch, h } from 'vue';
import { Table, Input, Button, Modal, Select, InputNumber, Radio, message, Popconfirm, Tooltip } from 'ant-design-vue';
import { SearchOutlined, DownloadOutlined, PlusOutlined, EditOutlined, SaveOutlined, DeleteOutlined, InfoCircleOutlined } from '@ant-design/icons-vue';
import LayoutAuthenticatedSimple from '@/layouts/LayoutAuthenticatedSimple.vue';
import SectionMain from '@/components/SectionMain.vue';
import CardBox from '@/components/CardBox.vue';
import * as XLSX from 'xlsx';
import { useCompareParameters } from '../stores/CompareParameters.js';
import { debounce, uniq } from 'lodash';

const CompareParameters = useCompareParameters();

// State for comparison form
const isModalVisible = ref(false);
const comparisonForm = ref({
  parameterGroup: 'DYNAMIC_PARAMETERS',
  line: '',
  machineName: '',
  parameter1: '',
  parameter2: '',
  warningLimit: null,
  criticalLimit: null,
});

// Computed properties for form validation and dynamic options
const uniqueLines = computed(() => uniq(CompareParameters.lines));
const availableMachines = computed(() => uniq(CompareParameters.machinesByLine[comparisonForm.value.line] || []));
const availableParameters = computed(() => CompareParameters.parametersByMachine[comparisonForm.value.machineName] || []);
const isLineSelected = computed(() => comparisonForm.value.line !== '');
const isMachineSelected = computed(() => comparisonForm.value.machineName !== '');

// State for editable rows
const editableRows = ref({});

// Column definitions for comparison table
const comparisonColumns = [
  // { title: 'Time', dataIndex: 'time', key: 'time', sorter: (a, b) => new Date(a.time) - new Date(b.time) },
  { title: 'Line', dataIndex: 'line', key: 'line', sorter: (a, b) => a.line.localeCompare(b.line) },
  { title: 'Machine Name', dataIndex: 'machine_name', key: 'machine_name', sorter: (a, b) => a.machine_name.localeCompare(b.machine_name) },
  { title: 'Parameter Group', dataIndex: 'parameter_group_name', key: 'parameter_group_name', sorter: (a, b) => a.parameter_group_name.localeCompare(b.parameter_group_name) },
  { title: 'P1', dataIndex: 'machine_parameter1_name', key: 'machine_parameter1_name', sorter: (a, b) => a.machine_parameter1_name.localeCompare(b.machine_parameter1_name) },
  { title: 'P2', dataIndex: 'machine_parameter2_name', key: 'machine_parameter2_name', sorter: (a, b) => a.machine_parameter2_name.localeCompare(b.machine_parameter2_name) },
  { 
    title: 'Warning Limit',
    dataIndex: 'warning_limit', 
    key: 'warning_limit',
    sorter: (a, b) => a.warning_limit - b.warning_limit,
    customRender: ({ text, record }) => {
      if (editableRows.value[record.id]) {
        return h(InputNumber, {
          value: text,
          onChange: (value) => {
            record.warning_limit = value;
          },
          style: { width: '100%' }
        });
      }
      return text;
    }
  },
  { 
    title: 'Critical Limit',
    dataIndex: 'critical_limit', 
    key: 'critical_limit',
    sorter: (a, b) => a.critical_limit - b.critical_limit,
    customRender: ({ text, record }) => {
      if (editableRows.value[record.id]) {
        return h(InputNumber, {
          value: text,
          onChange: (value) => {
            record.critical_limit = value;
          },
          style: { width: '100%' }
        });
      }
      return text;
    }
  },
  { 
    title: 'Value1', 
    dataIndex: 'value_1', 
    key: 'value_1', 
    sorter: (a, b) => a.value_1 - b.value_1,
    customRender: ({ text, record }) => {
      return h(Tooltip, {
        title: record.time_1 ? `Time: ${new Date(record.time_1).toLocaleString()}` : 'Time not available',
      }, {
        default: () => text
      });
    }
  },
  { 
    title: 'Value2', 
    dataIndex: 'value_2', 
    key: 'value_2', 
    sorter: (a, b) => a.value_2 - b.value_2,
    customRender: ({ text, record }) => {
      return h(Tooltip, {
        title: record.time_2 ? `Time: ${new Date(record.time_2).toLocaleString()}` : 'Time not available',
      }, {
        default: () => text
      });
    }
  },
  { title: 'Difference', dataIndex: 'difference', key: 'difference', sorter: (a, b) => a.difference - b.difference },
  { 
    title: 'Condition', 
    dataIndex: 'parameter_condition_name', 
    key: 'parameter_condition_name', 
    sorter: (a, b) => a.parameter_condition_name.localeCompare(b.parameter_condition_name),
    customRender: ({ text }) => {
      const color = text === 'CRITICAL' ? 'red' : text === 'WARNING' ? 'orange' : 'green';
      return h('span', { style: { color } }, text);
    }
  },
  {
  title: 'Action',
  key: 'action',
  fixed: 'right',
  width: 120,
  customRender: ({ record }) => {
    if (editableRows.value[record.id]) {
      return h(Button, {
        onClick: () => handleSave(record),
        type: 'primary',
        size: 'small',
        icon: h(SaveOutlined),
        class: "bg-green-500 hover:bg-green-600 text-white",
      }, 'Save');
    }
    return h('div', [
      h(Button, {
        onClick: () => handleEdit(record),
        type: 'default',
        size: 'small',
        icon: h(EditOutlined),
        style: { marginRight: '8px' },
        class: "border border-blue-500 text-blue-500 hover:bg-blue-50",
      }),
      h(Popconfirm, {
        title: 'Are you sure you want to delete this item?',
        onConfirm: () => handleDelete(record.id),
        okText: 'Yes',
        cancelText: 'No',
        okButtonProps: {
          class: 'bg-red-500 hover:bg-red-600 text-white border-none',
        },
        cancelButtonProps: {
          class: 'border border-gray-300 text-gray-700 hover:border-gray-400 hover:text-gray-800',
        },
      }, [
        h(Button, {
          type: 'danger',
          size: 'small',
          icon: h(DeleteOutlined),
          class: "bg-red-500 hover:bg-red-600 text-white p-2"
        })
      ])
    ]);
  },
},
];
// Search and filter states
const comparisonSearch = ref('');

// Pagination state
const comparisonPagination = ref({
  current: 1,
  pageSize: 10,
  total: 0,
});

// Filter function for comparison data
const filteredComparisonData = computed(() => {
  if (!CompareParameters.comparisonData) return [];
  return CompareParameters.comparisonData.filter(item => 
    Object.entries(item).some(([key, val]) => 
      val && val.toString().toLowerCase().includes(comparisonSearch.value.toLowerCase())
    )
  );
});

// Watch for changes in filtered data to update pagination
watch(filteredComparisonData, (newVal) => {
  comparisonPagination.value.total = newVal.length;
});

const handleAddComparison = async () => {
  try {
    // Determine the actual parameter names based on the selected machine and parameter group
    const parameter1Name = CompareParameters.parametersByMachine[comparisonForm.value.machineName]?.find(param => param.internalName === comparisonForm.value.parameter1)?.name || '';
    const parameter2Name = CompareParameters.parametersByMachine[comparisonForm.value.machineName]?.find(param => param.internalName === comparisonForm.value.parameter2)?.name || '';

    // Update the comparison form with the correct parameter names
    const comparisonData = {
      ...comparisonForm.value,
      parameter1Name,
      parameter2Name,
    };

    await CompareParameters.submitComparison(comparisonData);
    isModalVisible.value = false;
    message.success('Comparison added successfully');
  } catch (error) {
    console.error('Error adding comparison:', error);
    message.error('Failed to add comparison');
  } finally {
    // Reset the form
    comparisonForm.value = {
      parameterGroup: 'DYNAMIC_PARAMETERS',
      line: '',
      machineName: '',
      parameter1: '',
      parameter2: '',
      warningLimit: null,
      criticalLimit: null,
    };
  }
};

const exportToExcel = () => {
  const worksheet = XLSX.utils.json_to_sheet(filteredComparisonData.value);
  const workbook = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(workbook, worksheet, 'Comparisons');
  XLSX.writeFile(workbook, 'Comparisons.xlsx');
};

// Debounced search function
const debouncedSearch = debounce((value) => {
  comparisonSearch.value = value;
}, 300);

// Refresh interval
let refreshInterval;

// Fetch data on component mount and start refresh interval
onMounted(async () => {
  await CompareParameters.fetchFactoryLayout();
  await CompareParameters.fetchComparisonData();
  refreshInterval = setInterval(() => {
    CompareParameters.fetchComparisonData();
  }, 10000); // Refresh every 50 seconds
});

// Clear interval on component unmount
onUnmounted(() => {
  if (refreshInterval) {
    clearInterval(refreshInterval);
  }
});

// Handle pagination change
const handleTableChange = (pagination) => {
  comparisonPagination.value = pagination;
};

// Handle edit button click
const handleEdit = (record) => {
  editableRows.value[record.id] = true;
};



// Handle save button click
const handleSave = async (record) => {
  const success = await CompareParameters.updateComparison(record.id, {
    warning_limit: record.warning_limit,
    critical_limit: record.critical_limit
  });
  if (success) {
    editableRows.value[record.id] = false;
  }
};

const handleDelete = async (id) => {
  await CompareParameters.deleteComparison(id);
  // No need to do anything here, as the store action will handle
  // both success and error cases, including refreshing the data
};

    // Custom row class for highlighting
    const rowClassName = (record) => {
      if (record.parameter_condition_name === 'CRITICAL') {
        return 'bg-red-100 hover:bg-red-200';
      } else if (record.parameter_condition_name === 'WARNING') {
        return 'bg-yellow-100 hover:bg-yellow-200';
      }
      return '';
    };

    // Function to determine if form is valid
    const isFormValid = computed(() => {
      return comparisonForm.value.line &&
             comparisonForm.value.machineName &&
             comparisonForm.value.parameter1 &&
             comparisonForm.value.parameter2 &&
             comparisonForm.value.warningLimit !== null &&
             comparisonForm.value.criticalLimit !== null;
    });
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
          @input="debouncedSearch($event.target.value)"
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
      @change="handleTableChange"
      :rowClassName="rowClassName"
      class="w-full"
      :scroll="{ x: 'max-content' }"
    >
      <template #headerCell="{ column }">
        <template v-if="column.key === 'warning_limit'">
          <span>
            Warning Limit
            <Tooltip title="The threshold for warning condition">
              <InfoCircleOutlined style="margin-left: 5px" />
            </Tooltip>
          </span>
        </template>
        <template v-else-if="column.key === 'critical_limit'">
          <span>
            Critical Limit
            <Tooltip title="The threshold for critical condition">
              <InfoCircleOutlined style="margin-left: 5px" />
            </Tooltip>
          </span>
        </template>
        <template v-else>
          {{ column.title }}
        </template>
      </template>
    </Table>
        </CardBox>

        <Modal
    v-model:visible="isModalVisible"
    title="Add Comparison"
    @ok="handleAddComparison"
    :okButtonProps="{ disabled: !isFormValid, class: 'bg-blue-500 hover:bg-blue-600 text-white' }"
    :cancelButtonProps="{ class: 'border border-gray-300 hover:border-gray-400' }"
    okText="Add"
    cancelText="Cancel"
    width="600px"
  >
          <div class="space-y-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Parameter Group</label>
              <Radio.Group v-model:value="comparisonForm.parameterGroup" button-style="solid" class="w-full">
                <Radio.Button value="DYNAMIC_PARAMETERS" class="w-1/2 text-center">Load</Radio.Button>
                <Radio.Button value="ENCODER_TEMPERATURE" class="w-1/2 text-center">Position</Radio.Button>
              </Radio.Group>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Line</label>
              <Select
                v-model:value="comparisonForm.line"
                style="width: 100%"
                placeholder="Select a line"
                show-search
                :filter-option="(input, option) => option.value.toLowerCase().indexOf(input.toLowerCase()) >= 0"
              >
                <Select.Option v-for="line in uniqueLines" :key="line" :value="line">
                  {{ line }}
                </Select.Option>
              </Select>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Machine Name</label>
              <Select
                v-model:value="comparisonForm.machineName"
                style="width: 100%"
                placeholder="Select a machine"
                :disabled="!isLineSelected"
                show-search
                :filter-option="(input, option) => option.value.toLowerCase().indexOf(input.toLowerCase()) >= 0"
              >
                <Select.Option v-for="machine in availableMachines" :key="machine" :value="machine">
                  {{ machine }}
                </Select.Option>
              </Select>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Parameter 1</label>
              <Select
                v-model:value="comparisonForm.parameter1"
                style="width: 100%"
                placeholder="Select parameter 1"
                :disabled="!isMachineSelected"
                show-search
                :filter-option="(input, option) => option.children.toLowerCase().indexOf(input.toLowerCase()) >= 0"
              >
                <Select.Option v-for="param in availableParameters" :key="param.internalName" :value="param.internalName">
                  {{ param.name }}
                </Select.Option>
              </Select>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Parameter 2</label>
              <Select
                v-model:value="comparisonForm.parameter2"
                style="width: 100%"
                placeholder="Select parameter 2"
                :disabled="!isMachineSelected"
                show-search
                :filter-option="(input, option) => option.children.toLowerCase().indexOf(input.toLowerCase()) >= 0"
              >
                <Select.Option v-for="param in availableParameters" :key="param.internalName" :value="param.internalName">
                  {{ param.name }}
                </Select.Option>
              </Select>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Warning Limit</label>
              <InputNumber v-model:value="comparisonForm.warningLimit" style="width: 100%" />
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Critical Limit</label>
              <InputNumber v-model:value="comparisonForm.criticalLimit" style="width: 100%" />
            </div>
          </div>
        </Modal>
      </div>
    </SectionMain>
  </LayoutAuthenticatedSimple>
</template>

<style scoped>
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

.ant-btn-danger {
  @apply bg-red-500 border-red-500 text-white hover:bg-red-600 hover:border-red-600;
}

.ant-btn {
  @apply transition-colors duration-300;
}
</style>