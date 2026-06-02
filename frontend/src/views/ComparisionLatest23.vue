<script setup>
import { ref, computed, onMounted, onUnmounted, watch } from 'vue';
import { Table, Input, Button, Modal, Select, InputNumber, Radio, message, Popconfirm, Tooltip, DatePicker, Spin } from 'ant-design-vue';
import { SearchOutlined, DownloadOutlined, PlusOutlined, EditOutlined, SaveOutlined, DeleteOutlined, InfoCircleOutlined, LineChartOutlined, CloseOutlined } from '@ant-design/icons-vue';
import LayoutAuthenticatedSimple from '@/layouts/LayoutAuthenticatedSimple.vue';
import SectionMain from '@/components/SectionMain.vue';
import CardBox from '@/components/CardBox.vue';
import * as XLSX from 'xlsx';
import { useCompareParameters } from '../stores/CompareParameters.js';
import { debounce } from 'lodash';
import * as echarts from 'echarts';
import { h } from 'vue';
import dayjs from 'dayjs';
// import moment from 'moment';

const CompareParameters = useCompareParameters();

// State for comparison form
const isModalVisible = ref(false);
const comparisonForm = ref({
  parameterGroup: '',
  line: '',
  machineName: '',
  parameter1: '',
  parameter2: '',
  warningLimit: null,
  criticalLimit: null,
});

// State for history modal
const isHistoryModalVisible = ref(false);
// const historyChart = ref(null);
// const historyDateRange = ref([]);
// const isLoading = ref(false);

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
    width: 200,
    customRender: ({ record }) => {
      return h('div', [
        h(Button, {
          type: 'primary',
          size: 'small',
          class: "border border-blue-500 text-blue-500 hover:bg-blue-50",
          onClick: () => handleViewHistory(record),
          style: { marginRight: '8px', display: 'inline-flex', alignItems: 'center', justifyContent: 'center' }
        }, [h(LineChartOutlined), 'History']),
        h(Button, {
          onClick: () => handleEdit(record),
          type: 'default',
          size: 'small',
          icon: h(EditOutlined),
          style: { marginRight: '8px', display: 'inline-flex', alignItems: 'center', justifyContent: 'center' },
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
            class: "bg-red-500 hover:bg-red-600 text-white p-2",
            style: { display: 'inline-flex', alignItems: 'center', justifyContent: 'center' }
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
      parameterGroup: '',
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



    // Computed properties for dynamic options
// Computed properties for dynamic options
const parameterGroups = computed(() => CompareParameters.parameterGroups);
const lines = computed(() => CompareParameters.linesByParameterGroup(comparisonForm.value.parameterGroup));
const machines = computed(() => CompareParameters.machinesByLine(comparisonForm.value.parameterGroup, comparisonForm.value.line));
const parameters = computed(() => CompareParameters.parametersByMachine(comparisonForm.value.parameterGroup, comparisonForm.value.line, comparisonForm.value.machineName));

// Watch for changes in form selections to reset dependent fields
watch(() => comparisonForm.value.parameterGroup, () => {
  comparisonForm.value.line = '';
  comparisonForm.value.machineName = '';
  comparisonForm.value.parameter1 = '';
  comparisonForm.value.parameter2 = '';
});

watch(() => comparisonForm.value.line, () => {
  comparisonForm.value.machineName = '';
  comparisonForm.value.parameter1 = '';
  comparisonForm.value.parameter2 = '';
});

watch(() => comparisonForm.value.machineName, () => {
  comparisonForm.value.parameter1 = '';
  comparisonForm.value.parameter2 = '';
});

// // Computed property for history form validation
// const isHistoryFormValid = computed(() => {
//   const { machineName, parameter1, parameter2, fromDate, toDate } = CompareParameters.historyForm;
//   return machineName && parameter1 && parameter2 && fromDate && toDate;
// });

// Methods for history modal
const showHistoryModal = () => {
  isHistoryModalVisible.value = true;
};

// const handleHistoryFormSubmit = async () => {
//   if (isHistoryFormValid.value) {
//     await CompareParameters.fetchHistoryData();
//     renderHistoryChart();
//   }
// };

// const renderHistoryChart = () => {
//   if (!historyChart.value) return;

//   const chartInstance = echarts.init(historyChart.value);
//   const option = {
//     title: {
//       text: 'Parameter Comparison History',
//     },
//     tooltip: {
//       trigger: 'axis',
//     },
//     legend: {
//       data: [CompareParameters.historyForm.parameter1, CompareParameters.historyForm.parameter2],
//     },
//     xAxis: {
//       type: 'time',
//       axisLabel: {
//         formatter: (value) => format(new Date(value), 'yyyy-MM-dd HH:mm'),
//       },
//     },
//     yAxis: {
//       type: 'value',
//     },
//     series: [
//       {
//         name: CompareParameters.historyForm.parameter1,
//         type: 'line',
//         data: CompareParameters.formattedHistoryData.map(item => [item.time, item.value_1]),
//       },
//       {
//         name: CompareParameters.historyForm.parameter2,
//         type: 'line',
//         data: CompareParameters.formattedHistoryData.map(item => [item.time, item.value_2]),
//       },
//     ],
//   };

//   chartInstance.setOption(option);
// };

// Watch for changes in the history data
watch(() => CompareParameters.historyData, () => {
  renderHistoryChart();
});

// Add this to your onMounted
onMounted(() => {
  // ... existing onMounted code
  window.addEventListener('resize', renderHistoryChart);
});

// Add this to your onUnmounted
onUnmounted(() => {
  // ... existing onUnmounted code
  window.removeEventListener('resize', renderHistoryChart);
});


// Add these refs for the custom input values
const customMachineName = ref('');
const customParameter1 = ref('');
const customParameter2 = ref('');

const isHistoryFormValid = computed(() => {
  const { machineName, parameter1, parameter2, fromDate, toDate } = CompareParameters.historyForm;
  return machineName && parameter1 && parameter2 && fromDate && toDate;
});

const handleHistoryFormSubmit = async () => {
  if (isHistoryFormValid.value) {
    const formData = {
      ...CompareParameters.historyForm,
      // No need to modify fromDate and toDate here, as they will be handled in the store
    };
    await CompareParameters.fetchHistoryData(formData);
    renderHistoryChart();
  }
};
// Add these methods to handle custom input
const handleCustomMachineNameInput = (value) => {
  customMachineName.value = value;
  CompareParameters.updateHistoryForm({ machineName: value });
};

const handleCustomParameter1Input = (value) => {
  customParameter1.value = value;
  CompareParameters.updateHistoryForm({ parameter1: value });
};

const handleCustomParameter2Input = (value) => {
  customParameter2.value = value;
  CompareParameters.updateHistoryForm({ parameter2: value });
};

const { Option } = Select;

const selectedComparison = ref(null);
const historyChart = ref(null);
const historyDateRange = ref(null);
const isLoading = ref(false);

const handleViewHistory = (record) => {
  selectedComparison.value = record;
  // Don't reset the date range here
};

const fetchAndRenderHistoryChart = async () => {
  if (!selectedComparison.value || !historyDateRange.value || !historyDateRange.value[0] || !historyDateRange.value[1]) {
    message.error('Please select a valid date range');
    return;
  }

  const formData = {
    machineName: selectedComparison.value.machine_name,
    parameter1: selectedComparison.value.machine_parameter1_name_actual,
    parameter2: selectedComparison.value.machine_parameter2_name_actual,
    fromDate: historyDateRange.value[0].format('YYYY-MM-DD HH:mm:ss'),
    toDate: historyDateRange.value[1].format('YYYY-MM-DD HH:mm:ss'),
  };

  isLoading.value = true;
  try {
    await CompareParameters.fetchHistoryData(formData);
    renderHistoryChart();
  } catch (error) {
    console.error('Error fetching history data:', error);
    message.error('No data available for the selected date range. Please try a different range.');
  } finally {
    isLoading.value = false;
  }
};

const renderHistoryChart = () => {
  if (!historyChart.value || !selectedComparison.value) return;

  const chartInstance = echarts.init(historyChart.value);
  
  const { parameter1Data, parameter2Data } = CompareParameters.formattedHistoryData;

  if (parameter1Data.length === 0 || parameter2Data.length === 0) {
    chartInstance.setOption({
      title: {
        text: 'No Data Available',
        left: 'center',
        top: 'center'
      },
      graphic: [
        {
          type: 'group',
          left: 'center',
          top: 'center',
          children: [
            {
              type: 'text',
              z: 100,
              left: 0,
              top: 20,
              style: {
                fill: '#999',
                text: 'Please select a different date range',
                font: '14px Microsoft YaHei'
              }
            }
          ]
        }
      ]
    });
    return;
  }

  const option = {
    title: {
      text: 'Parameter Comparison History',
      left: 'center'
    },
    tooltip: {
      trigger: 'axis',
      formatter: function(params) {
        const time = new Date(params[0].data[0]).toLocaleString();
        let result = `${time}<br/>`;
        params.forEach(param => {
          result += `${param.seriesName}: ${param.data[1]}<br/>`;
        });
        return result;
      }
    },
    legend: {
      data: [parameter1Data[0].parameterName, parameter2Data[0].parameterName],
      bottom: 0
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '10%',
      containLabel: true
    },
    xAxis: {
      type: 'time',
      boundaryGap: false
    },
    yAxis: {
      type: 'value'
    },
    series: [
      {
        name: parameter1Data[0].parameterName,
        type: 'line',
        data: parameter1Data.map(item => [item.time, item.value])
      },
      {
        name: parameter2Data[0].parameterName,
        type: 'line',
        data: parameter2Data.map(item => [item.time, item.value])
      }
    ]
  };

  chartInstance.setOption(option);
};




// Watch for changes in the history data
watch(() => CompareParameters.historyData, () => {
  renderHistoryChart();
});

// Add this to your onMounted
onMounted(() => {
  // ... existing onMounted code
  window.addEventListener('resize', renderHistoryChart);
});

// Add this to your onUnmounted
onUnmounted(() => {
  // ... existing onUnmounted code
  window.removeEventListener('resize', renderHistoryChart);
});
</script>

<template>
  <LayoutAuthenticatedSimple>
    <SectionMain>
      <div class="container mx-auto px-4 py-8">
        <h1 class="text-3xl font-semibold text-emerald-700 mb-6">Parameter Comparisons</h1>
        
        <div class="mb-6 flex justify-between items-center">
          <Button @click="isModalVisible = true" type="primary" class="bg-emerald-500 ">
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

        <CardBox class="overflow-x-auto mb-6">
          <Table
            :columns="comparisonColumns"
            :dataSource="filteredComparisonData"
            :rowKey="record => record.id"
            :pagination="comparisonPagination"
            @change="handleTableChange"
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

        <div v-if="selectedComparison" class="mb-6">
          <h2 class="text-2xl font-semibold text-emerald-700 mb-4">{{ selectedComparison.machine_name }} History</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
            <div>
              <span class="font-medium">Parameter 1:</span> {{ selectedComparison.machine_parameter1_name }}
            </div>
            <div>
              <span class="font-medium">Parameter 2:</span> {{ selectedComparison.machine_parameter2_name }}
            </div>
            <div class="md:col-span-2">
              <label class="block text-sm font-medium text-gray-700 mb-1">Date Range</label>
              <DatePicker.RangePicker
                v-model:value="historyDateRange"
                style="width: 100%"
                :show-time="{ format: 'HH:mm' }"
                format="YYYY-MM-DD HH:mm"
                :disabled-date="(current) => current && current > dayjs().endOf('day')"
                :placeholder="['Start Date', 'End Date']"
              />
            </div>
          </div>
          <div class="flex justify-end mb-4">
            <Button 
              type="primary" 
              @click="fetchAndRenderHistoryChart" 
              :disabled="!historyDateRange || !historyDateRange[0] || !historyDateRange[1] || isLoading"
              class="bg-emerald-500 hover:bg-emerald-600 text-white font-bold py-2 px-4 rounded"
            >
              <template #icon><Spin v-if="isLoading" /></template>
              {{ isLoading ? 'Loading...' : 'Update Graph' }}
            </Button>
          </div>
          <div 
            ref="historyChart" 
            class="w-full h-[500px] border border-gray-200 rounded-lg shadow-lg"
          ></div>
        </div>
        <div v-else class="text-center text-gray-500 my-8">
          Select a comparison from the table to view its history
        </div>

        <Modal
          v-model:visible="isModalVisible"
          title="Add Comparison"
          @ok="handleAddComparison"
          :okButtonProps="{ disabled: !isFormValid, class: 'bg-emerald-500 hover:bg-emerald-600 text-white' }"
          :cancelButtonProps="{ class: 'border border-gray-300 hover:border-gray-400' }"
          okText="Add"
          cancelText="Cancel"
          width="600px"
        >
          <div class="space-y-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Parameter Group</label>
              <Select
                v-model:value="comparisonForm.parameterGroup"
                style="width: 100%"
                placeholder="Select a parameter group"
              >
                <Select.Option v-for="group in parameterGroups" :key="group.value" :value="group.value">
                  {{ group.label }}
                </Select.Option>
              </Select>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Line</label>
              <Select
                v-model:value="comparisonForm.line"
                style="width: 100%"
                placeholder="Select a line"
                :disabled="!comparisonForm.parameterGroup"
              >
                <Select.Option v-for="line in lines" :key="line" :value="line">
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
                :disabled="!comparisonForm.line"
              >
                <Select.Option v-for="machine in machines" :key="machine" :value="machine">
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
                :disabled="!comparisonForm.machineName"
              >
                <Select.Option v-for="param in parameters" :key="param.value" :value="param.value">
                  {{ param.label }}
                </Select.Option>
              </Select>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Parameter 2</label>
              <Select
                v-model:value="comparisonForm.parameter2"
                style="width: 100%"
                placeholder="Select parameter 2"
                :disabled="!comparisonForm.machineName"
              >
                <Select.Option v-for="param in parameters" :key="param.value" :value="param.value">
                  {{ param.label }}
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

.ant-modal-body {
  max-height: 80vh;
  overflow-y: auto;
}

.ant-table-row-hover {
  @apply bg-emerald-50;
}

.ant-table-row-selected {
  @apply bg-emerald-100;
}
</style>