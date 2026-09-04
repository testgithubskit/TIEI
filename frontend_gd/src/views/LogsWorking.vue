<script setup>
import { ref, computed } from 'vue';
import { Table, Input, DatePicker, Button } from 'ant-design-vue';
import { SearchOutlined, DownloadOutlined } from '@ant-design/icons-vue';
import LayoutAuthenticatedSimple from '@/layouts/LayoutAuthenticatedSimple.vue';
import SectionMain from '@/components/SectionMain.vue';
import CardBox from '@/components/CardBox.vue';
import * as XLSX from 'xlsx';

// Sample data for machine disconnected time log
const disconnectedLogs = ref([
  { id: 1, machineId: 'M001', fromTime: '2024-07-03 10:00:00', toTime: '2024-07-03 11:30:00' },
  { id: 2, machineId: 'M002', fromTime: '2024-07-03 14:15:00', toTime: '2024-07-03 15:45:00' },
  { id: 3, machineId: 'M003', fromTime: '2024-07-04 09:30:00', toTime: '2024-07-04 10:15:00' },
 
]);

// Sample data for limit change log
const limitChangeLogs = ref([
  { id: 1, machineId: 'M001', changedBy: 'John Doe', changeTime: '2024-07-03 12:00:00', oldValue: 100, newValue: 120 },
  { id: 2, machineId: 'M002', changedBy: 'Jane Smith', changeTime: '2024-07-03 16:30:00', oldValue: 80, newValue: 90 },
  { id: 3, machineId: 'M003', changedBy: 'Bob Johnson', changeTime: '2024-07-04 11:00:00', oldValue: 150, newValue: 140 },
]);

// Column definitions for disconnected logs table
const disconnectedColumns = [
  { title: 'Machine ID', dataIndex: 'machineId', key: 'machineId', sorter: (a, b) => a.machineId.localeCompare(b.machineId) },
  { title: 'From Time', dataIndex: 'fromTime', key: 'fromTime', sorter: (a, b) => new Date(a.fromTime) - new Date(b.fromTime) },
  { title: 'To Time', dataIndex: 'toTime', key: 'toTime', sorter: (a, b) => new Date(a.toTime) - new Date(b.toTime) },
];

// Column definitions for limit change logs table
const limitChangeColumns = [
  { title: 'Machine ID', dataIndex: 'machineId', key: 'machineId', sorter: (a, b) => a.machineId.localeCompare(b.machineId) },
  { title: 'Changed By', dataIndex: 'changedBy', key: 'changedBy', sorter: (a, b) => a.changedBy.localeCompare(b.changedBy) },
  { title: 'Change Time', dataIndex: 'changeTime', key: 'changeTime', sorter: (a, b) => new Date(a.changeTime) - new Date(b.changeTime) },
  { title: 'Old Value', dataIndex: 'oldValue', key: 'oldValue', sorter: (a, b) => a.oldValue - b.oldValue },
  { title: 'New Value', dataIndex: 'newValue', key: 'newValue', sorter: (a, b) => a.newValue - b.newValue },
];

// Search and filter states
const disconnectedSearch = ref('');
const limitChangeSearch = ref('');
const dateRange = ref([]);

// Pagination state
const disconnectedPagination = ref({
  current: 1,
  pageSize: 5,
});

const limitChangePagination = ref({
  current: 1,
  pageSize: 5,
});

// Filter functions
const filterDisconnectedLogs = computed(() => {
  return disconnectedLogs.value.filter(log => 
    log.machineId.toLowerCase().includes(disconnectedSearch.value.toLowerCase()) &&
    (!dateRange.value || !dateRange.value.length || 
    (new Date(log.fromTime) >= dateRange.value[0] && new Date(log.toTime) <= dateRange.value[1]))
  );
});

const filterLimitChangeLogs = computed(() => {
  return limitChangeLogs.value.filter(log => 
    (log.machineId.toLowerCase().includes(limitChangeSearch.value.toLowerCase()) ||
    log.changedBy.toLowerCase().includes(limitChangeSearch.value.toLowerCase())) &&
    (!dateRange.value || !dateRange.value.length || 
    (new Date(log.changeTime) >= dateRange.value[0] && new Date(log.changeTime) <= dateRange.value[1]))
  );
});

// Date range change handler
const onDateRangeChange = (dates) => {
  dateRange.value = dates;
};

// Pagination change handlers
const onDisconnectedPaginationChange = (pagination) => {
  disconnectedPagination.value = pagination;
};

const onLimitChangePaginationChange = (pagination) => {
  limitChangePagination.value = pagination;
};

// Export functions
const exportToExcel = (data, filename) => {
  const worksheet = XLSX.utils.json_to_sheet(data);
  const workbook = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(workbook, worksheet, 'Sheet1');
  XLSX.writeFile(workbook, `${filename}.xlsx`);
};

const exportDisconnectedLogs = () => {
  exportToExcel(filterDisconnectedLogs.value, 'DisconnectedLogs');
};

const exportLimitChangeLogs = () => {
  exportToExcel(filterLimitChangeLogs.value, 'LimitChangeLogs');
};
</script>

<template>
  <LayoutAuthenticatedSimple>
    <SectionMain>
      <div class="container mx-auto px-4 py-8">
        <h1 class="text-3xl font-semibold text-emerald-700 mb-6">Logs</h1>
        
        <!-- Date Range Filter -->
        <div class="mb-6">
          <DatePicker.RangePicker
            v-model:value="dateRange"
            @change="onDateRangeChange"
            class="w-full sm:w-64"
          />
        </div>

        <!-- Machine Disconnected Time Log -->
        <div class="mb-10">
          <div class="flex justify-between items-center mb-3">
            <h2 class="text-xl font-semibold text-emerald-600">Machine Disconnected Time Log</h2>
            <Button @click="exportDisconnectedLogs">
              <template #icon><DownloadOutlined /></template>
              Export to Excel
            </Button>
          </div>
          <Input
            v-model:value="disconnectedSearch"
            placeholder="Search Machine ID"
            class="mb-3 w-full sm:w-64"
          >
            <template #prefix>
              <SearchOutlined />
            </template>
          </Input>
          <CardBox class="overflow-x-auto">
            <Table
              :columns="disconnectedColumns"
              :dataSource="filterDisconnectedLogs"
              :rowKey="record => record.id"
              :pagination="disconnectedPagination"
              @change="onDisconnectedPaginationChange"
              class="w-full"
              :scroll="{ x: 'max-content' }"
            />
          </CardBox>
        </div>

        <!-- Limit Change Log -->
        <div>
          <div class="flex justify-between items-center mb-3">
            <h2 class="text-xl font-semibold text-emerald-600">Limit Change Log</h2>
            <Button  @click="exportLimitChangeLogs">
              <template #icon><DownloadOutlined /></template>
              Export to Excel
            </Button>
          </div>
          <Input
            v-model:value="limitChangeSearch"
            placeholder="Search Machine ID or Changed By"
            class="mb-3 w-full sm:w-64"
          >
            <template #prefix>
              <SearchOutlined />
            </template>
          </Input>
          <CardBox class="overflow-x-auto">
            <Table
              :columns="limitChangeColumns"
              :dataSource="filterLimitChangeLogs"
              :rowKey="record => record.id"
              :pagination="limitChangePagination"
              @change="onLimitChangePaginationChange"
              class="w-full"
              :scroll="{ x: 'max-content' }"
            />
          </CardBox>
        </div>
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

.ant-picker {
  @apply border-emerald-300 focus:border-emerald-500 focus:ring focus:ring-emerald-200 focus:ring-opacity-50;
}

.ant-btn-primary {
  @apply bg-emerald-500 border-emerald-500 text-white hover:bg-emerald-600 hover:border-emerald-600;
}
</style>