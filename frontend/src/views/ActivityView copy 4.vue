<script setup>
import { ref, onMounted, onBeforeMount, watch } from "vue";
import { Table, Input, DatePicker, Button, Switch, InputNumber, Select } from 'ant-design-vue';
// import 'ant-design-vue/dist/antd.css';

import SectionMain from "@/components/SectionMain.vue";
import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";
import BlurryHorizontalDivider from "@/components/BlurryHorizontalDivider.vue";
import TimePickerFlatEmitter from "@/components/TimePickerFlatEmitter.vue";
import BaseButton from "@/components/BaseButton.vue";
import * as XLSX from 'xlsx';

import Toastify from 'toastify-js';
import 'toastify-js/src/toastify.css';

import { useActivityStore } from '@/stores/ActivityStore';
import { useDatabaseName } from '@/stores/DatabaseName';

// State variables
const autoRefresh = ref(false);
const refreshInterval = ref(10);
const currentFilter = ref('BLOCK');
let refreshTimer;

const ActivityStoredata = useActivityStore();
const DatabaseName = useDatabaseName();

function subtractHours(date, hours) {
  date.setHours(date.getHours() - hours);
  return date;
}

const handleFromDateChange = (dateValue) => {
  ActivityStoredata.selectedDates.from = dateValue.value;
};

const handleToDateChange = (dateValue) => {
  ActivityStoredata.selectedDates.to = dateValue.value;
};

const daysSinceIdentification = (record) => {
  const identificationDate = new Date(record.date_of_identification);
  const currentDate = new Date();
  const timeDifference = currentDate.getTime() - identificationDate.getTime();
  const daysElapsed = Math.floor(timeDifference / (1000 * 3600 * 24));
  return daysElapsed;
};

const handleQuerySubmit = async () => {
  try {
    if (new Date(ActivityStoredata.selectedDates.to) < new Date(ActivityStoredata.selectedDates.from)) {
      Toastify({
        text: 'Please enter a valid date range.',
        duration: 3000,
        close: true,
        gravity: 'bottom',
        position: 'right',
        backgroundColor: 'red',
      }).showToast();
      return;
    }

    await ActivityStoredata.fetchActivityData();
    
    pendingData.value = ActivityStoredata.pendingData;
    completedData.value = ActivityStoredata.completedData;
    abnormalitySummary.value = ActivityStoredata.abnormalitySummary;

    Toastify({
      text: 'Data Fetched Successfully.',
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: 'green',
    }).showToast();
  } catch (error) {
    console.error('Error fetching and rendering data:', error);
    Toastify({
      text: 'Error fetching Data.',
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: 'red',
    }).showToast();
  }
};

const pendingData = ref([]);
const completedData = ref([]);
const abnormalitySummary = ref([]);

const handleEdit = (key, value, column) => {
  const index = pendingData.value.findIndex(item => item.key === key);
  if (index !== -1) {
    pendingData.value[index][column.dataIndex] = value;
    ActivityStoredata.saveEditedRowIds(key);
    
    Toastify({
      text: 'Please save after editing',
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: 'red',
    }).showToast();
  }
};

const saveEdit = async () => {
  if (ActivityStoredata.editedRowIds.length === 0) {
    Toastify({
      text: 'No Changes to Save',
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: 'red',
    }).showToast();
    return;
  }

  try {
    const editedRowsData = pendingData.value.filter(row => ActivityStoredata.editedRowIds.includes(row.key));

    const incompleteRows = editedRowsData.filter(row => {
      return row.status === 'Completed' && (!row.target_date_of_completion || !row.responsible_person_company_id);
    });

    if (incompleteRows.length > 0) {
      Toastify({
        text: 'Please enter values for Target Date of Completion or Responsible Person Company ID for rows marked as Completed.',
        duration: 5000,
        close: true,
        gravity: 'bottom',
        position: 'right',
        backgroundColor: 'red',
      }).showToast();
      return;
    }

    editedRowsData.forEach(row => {
      for (const [key, value] of Object.entries(row)) {
        if (value === null && key !== 'target_date_of_completion' && key !== 'responsible_person_company_id') {
          row[key] = '-';
        }
        if (value === "" && key == 'priority' ) {
          row[key] = 'C';
        }
      }
    });

    await ActivityStoredata.sendEdit(editedRowsData);
    ActivityStoredata.editedRowIds = [];

    Toastify({
      text: 'Changes saved successfully!',
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: 'green',
    }).showToast();

    await handleQuerySubmit();
  } catch (error) {
    console.error('Error saving edited data:', error);
    Toastify({
      text: 'Error saving changes. Please try again.',
      duration: 3000,
      close: true,
      gravity: 'bottom',
      position: 'right',
      backgroundColor: 'red',
    }).showToast();
  }
};

const exportData = (dataSource, fileName) => {
  const data = dataSource.map(item => [
    item.id,
    item.location,
    item.name,
    item.group_name,
    item.parameter_name,
    item.axis_name,
    item.date_of_identification,
    item.latest_occurrence,
    item.recent_value,
    item.warning_limit,
    item.critical_limit,
    daysSinceIdentification(item),
    item.target_date_of_completion,
    item.number_of_occurrences,
    item.condition,
    item.corrective_measurement,
    item.spare_required,
    item.support_needed,
    item.responsible_person_company_id,
    item.responsible_person_username,
    item.status,
    item.priority
  ]);

  data.unshift([
    'ID', 'Location', 'Name', 'Group Name', 'Parameter Name', 'Axis',
    'Date of Identification', 'Latest Occurrence', 'Recent Value',
    'Warning Limit', 'Critical Limit', 'Days Since Identification',
    'Target Date of Completion', 'Number of Occurrences', 'Condition',
    'Corrective Measurements', 'Spare Required', 'Support Needed',
    'Responsible Person Company ID', 'Responsible Person Name',
    'Status', 'Priority'
  ]);

  const ws = XLSX.utils.aoa_to_sheet(data);
  const wb = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(wb, ws, 'Sheet1');
  XLSX.writeFile(wb, fileName);
};

onBeforeMount(async () => {
  let tempEndDate = new Date();
  let tempStartDate = subtractHours(new Date(), 1);

  ActivityStoredata.selectedDates.from = tempStartDate.getTime();
  ActivityStoredata.selectedDates.to = tempEndDate.getTime();
});

onMounted(() => {
  handleQuerySubmit();
});

// Table columns
const summaryColumns = [
  { title: 'Line', dataIndex: 'line', key: 'line' },
  { title: 'Warning', dataIndex: 'WARNING', key: 'WARNING' },
  { title: 'Critical', dataIndex: 'CRITICAL', key: 'CRITICAL' },
  { title: 'Completed', dataIndex: 'COMPLETED', key: 'COMPLETED' },
];

const pendingColumns = [
  { title: 'ID', dataIndex: 'id', key: 'id', sorter: true },
  { title: 'Location', dataIndex: 'location', key: 'location', sorter: true },
  { title: 'Name', dataIndex: 'name', key: 'name', sorter: true },
  { title: 'Group Name', dataIndex: 'group_name', key: 'group_name', sorter: true },
  { title: 'Parameter Name', dataIndex: 'parameter_name', key: 'parameter_name', sorter: true },
  { title: 'Axis', dataIndex: 'axis_name', key: 'axis_name', sorter: true },
  { title: 'Date of Identification', dataIndex: 'date_of_identification', key: 'date_of_identification', sorter: true },
  { title: 'Latest Occurrence', dataIndex: 'latest_occurrence', key: 'latest_occurrence', sorter: true },
  { title: 'Recent Value', dataIndex: 'recent_value', key: 'recent_value', sorter: true },
  { title: 'Warning Limit', dataIndex: 'warning_limit', key: 'warning_limit', sorter: true },
  { title: 'Critical Limit', dataIndex: 'critical_limit', key: 'critical_limit', sorter: true },
  { 
    title: 'Days Since Identification', 
    key: 'days_since_identification', 
    customRender: ({ record }) => daysSinceIdentification(record),
    sorter: (a, b) => daysSinceIdentification(a) - daysSinceIdentification(b),
  },
  { 
    title: 'Target Date of Completion', 
    dataIndex: 'target_date_of_completion', 
    key: 'target_date_of_completion',
    sorter: true,
    customRender: ({ text, record, index, column }) => {
      return h(DatePicker, {
        value: text,
        onChange: (date, dateString) => handleEdit(record.key, dateString, column)
      });
    }
  },
  { title: 'Number of Occurrences', dataIndex: 'number_of_occurrences', key: 'number_of_occurrences', sorter: true },
  { title: 'Condition', dataIndex: 'condition', key: 'condition', sorter: true },
  { 
    title: 'Corrective Measurements', 
    dataIndex: 'corrective_measurement', 
    key: 'corrective_measurement',
    customRender: ({ text, record, index, column }) => {
      return h(Input, {
        value: text,
        onChange: (e) => handleEdit(record.key, e.target.value, column)
      });
    }
  },
  { 
    title: 'Spare Required', 
    dataIndex: 'spare_required', 
    key: 'spare_required',
    customRender: ({ text, record, index, column }) => {
      return h(Input, {
        value: text,
        onChange: (e) => handleEdit(record.key, e.target.value, column)
      });
    }
  },
  { 
    title: 'Support Needed', 
    dataIndex: 'support_needed', 
    key: 'support_needed',
    customRender: ({ text, record, index, column }) => {
      return h(Input, {
        value: text,
        onChange: (e) => handleEdit(record.key, e.target.value, column)
      });
    }
  },
  { 
    title: 'Responsible Person Company ID', 
    dataIndex: 'responsible_person_company_id', 
    key: 'responsible_person_company_id',
    customRender: ({ text, record, index, column }) => {
      return h(Input, {
        value: text,
        onChange: (e) => handleEdit(record.key, e.target.value, column)
      });
    }
  },
  { title: 'Responsible Person Name', dataIndex: 'responsible_person_username', key: 'responsible_person_username', sorter: true },
  { 
    title: 'Status', 
    dataIndex: 'status', 
    key: 'status',
    sorter: true,
    customRender: ({ text, record, index, column }) => {
      return h(Select, {
        value: text,
        style: { width: '120px' },
        onChange: (value) => handleEdit(record.key, value, column)
      }, [
        h(Select.Option, { value: 'Pending' }, 'Pending'),
        h(Select.Option, { value: 'Completed' }, 'Completed')
      ]);
    }
  },
  { 
    title: 'Priority', 
    dataIndex: 'priority', 
    key: 'priority',
    sorter: true,
    customRender: ({ text, record, index, column }) => {
      return h(Select, {
        value: text,
        style: { width: '120px' },
        onChange: (value) => handleEdit(record.key, value, column)
      }, [
        h(Select.Option, { value: 'A' }, 'A'),
        h(Select.Option, { value: 'B' }, 'B'),
        h(Select.Option, { value: 'C' }, 'C')
      ]);
    }
  },
];
const completedColumns = [
  { title: 'ID', dataIndex: 'id', key: 'id', sorter: true },
  { title: 'Location', dataIndex: 'location', key: 'location', sorter: true },
  { title: 'Name', dataIndex: 'name', key: 'name', sorter: true },
  { title: 'Group Name', dataIndex: 'group_name', key: 'group_name', sorter: true },
  { title: 'Parameter Name', dataIndex: 'parameter_name', key: 'parameter_name', sorter: true },
  { title: 'Axis', dataIndex: 'axis_name', key: 'axis_name', sorter: true },
  { title: 'Date of Identification', dataIndex: 'date_of_identification', key: 'date_of_identification', sorter: true },
  { title: 'Latest Occurrence', dataIndex: 'latest_occurrence', key: 'latest_occurrence', sorter: true },
  { title: 'Recent Value', dataIndex: 'recent_value', key: 'recent_value', sorter: true },
  { title: 'Warning Limit', dataIndex: 'warning_limit', key: 'warning_limit', sorter: true },
  { title: 'Critical Limit', dataIndex: 'critical_limit', key: 'critical_limit', sorter: true },
  { 
    title: 'Days Since Identification', 
    key: 'days_since_identification', 
    customRender: ({ record }) => daysSinceIdentification(record),
    sorter: (a, b) => daysSinceIdentification(a) - daysSinceIdentification(b),
  },
  { title: 'Target Date of Completion', dataIndex: 'target_date_of_completion', key: 'target_date_of_completion', sorter: true },
  { title: 'Actual Date of Completion', dataIndex: 'actual_date_of_completion', key: 'actual_date_of_completion', sorter: true },
  { title: 'Number of Occurrences', dataIndex: 'number_of_occurrences', key: 'number_of_occurrences', sorter: true },
  { title: 'Condition', dataIndex: 'condition', key: 'condition', sorter: true },
  { title: 'Corrective Measurements', dataIndex: 'corrective_measurement', key: 'corrective_measurement' },
  { title: 'Spare Required', dataIndex: 'spare_required', key: 'spare_required' },
  { title: 'Support Needed', dataIndex: 'support_needed', key: 'support_needed' },
  { title: 'Responsible Person Company ID', dataIndex: 'responsible_person_company_id', key: 'responsible_person_company_id' },
  { title: 'Responsible Person Name', dataIndex: 'responsible_person_username', key: 'responsible_person_username', sorter: true },
  { title: 'Status', dataIndex: 'status', key: 'status', sorter: true },
  { title: 'Priority', dataIndex: 'priority', key: 'priority', sorter: true },
];
// Watch for changes in autoRefresh
watch(autoRefresh, (newValue) => {
  if (newValue) {
    startAutoRefresh();
  } else {
    cancelAutoRefresh();
  }
});
</script>

<template>
  <LayoutAuthenticatedSimple class="font-custom">
    <SectionMain>
      <div class="container mx-auto flex flex-col space-y-4">
        <BlurryHorizontalDivider class="mb-4" />
        <BlurryHorizontalDivider class="mt-4" />
        
        <div class="grid grid-cols-3 gap-2">
          <div>
            <label class="block mb-2 text-gray-700">From</label>
            <TimePickerFlatEmitter :defaultDatetime="subtractHours(new Date(), 1)" type="from" @date-change="handleFromDateChange" />
          </div>

          <div>
            <label class="block mb-2 text-gray-700">To</label>
            <TimePickerFlatEmitter :defaultDatetime="new Date()" type="to" @date-change="handleToDateChange" />
          </div>

          <div class="mt-8">
            <BaseButton type="submit" color="info" label="Submit" @click="handleQuerySubmit" />
          </div>
        </div>
      
        <BlurryHorizontalDivider class="mt-8"/>
        <div class="auto-refresh-container p-4 mt-4 flex items-center space-x-4">
    <label for="auto-toggle" class="mr-2">Auto</label>
    <a-switch v-model:checked="autoRefresh" />

    <div v-if="autoRefresh" class="flex items-center space-x-2">
      <label for="refresh-interval" class="mr-2">Set Interval</label>
      <a-input-number
        id="refresh-interval"
        v-model:value="refreshInterval"
        :min="1"
        :max="60"
        style="width: 60px"
      />
      <a-button type="primary" @click="setRefreshInterval">Set Interval</a-button>
    </div>

    <div v-if="autoRefresh" class="flex flex-col ml-6">
      <p class="text-sm bg-gray-200 hover:bg-gray-300 border border-gray-400 rounded-md px-3 py-1.5 cursor-pointer">
        Current filter: {{ currentFilter }}
      </p>
    </div>
  </div>

  <BlurryHorizontalDivider class="mt-8"/>

  <div class="w-2/4 flex justify-start">
    <p class="font-semibold text-3xl font-custom text-yellow-500 mb-8 mt-8">Abnormal Activity Summary</p>
  </div>
  <a-table :columns="summaryColumns" :data-source="abnormalitySummary" :pagination="false" />

  <BlurryHorizontalDivider />
  
  <div class="flex flex-row mt-8 h-8">
    <div class="w-2/4 flex justify-start">
      <p class="font-semibold text-3xl font-custom text-yellow-500">Pending Activity View</p>
    </div>
  </div>

  <div class="w-full flex justify-normal space-x-4 mb-4">
    <a-button type="primary" @click="saveEdit">Save Edited</a-button>
    <a-button type="primary" @click="() => exportData(pendingData, 'pending_data.xlsx')">Export Pending Data</a-button>
  </div>

  <a-table
    :columns="pendingColumns"
    :data-source="pendingData"
    :row-key="record => record.id"
    :pagination="{ pageSize: 10 }"
    :scroll="{ x: 'max-content' }"
  >
    <template #headerCell="{ column }">
      <template v-if="column.key === 'operation'">
        <span>operation</span>
      </template>
    </template>

    <template #bodyCell="{ column, record }">
      <template v-if="column.key === 'operation'">
        <a-space size="small">
          <a @click="handleEdit(record.key)">Edit</a>
        </a-space>
      </template>
    </template>
  </a-table>

  <BlurryHorizontalDivider />

  <div class="w-2/4 flex justify-center mt-8 mb-4">
    <p class="font-semibold text-3xl font-custom text-emerald-600">Completed Activity View</p>
  </div>

  <div class="w-full flex justify-end mb-4">
    <a-button type="primary" @click="() => exportData(completedData, 'completed_data.xlsx')">Export Completed Data</a-button>
  </div>

  <a-table
    :columns="completedColumns"
    :data-source="completedData"
    :row-key="record => record.id"
    :pagination="{ pageSize: 10 }"
    :scroll="{ x: 'max-content' }"
  />

  <BlurryHorizontalDivider />
</div>
</SectionMain>
</LayoutAuthenticatedSimple>
</template>

<style>
/* You can keep your custom styles here if needed */
</style>