<script setup>
import { ref, computed } from 'vue';
import { Table, Input, DatePicker } from 'ant-design-vue';
import { SearchOutlined } from '@ant-design/icons-vue';

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
</script>

<template>
  <div class="container mx-auto p-4">
    <h1 class="text-2xl font-bold mb-4">Logs</h1>
    
    <!-- Date Range Filter -->
    <div class="mb-4">
      <DatePicker.RangePicker
        v-model:value="dateRange"
        @change="onDateRangeChange"
        class="w-64"
      />
    </div>

    <!-- Machine Disconnected Time Log -->
    <div class="mb-8">
      <h2 class="text-xl font-semibold mb-2">Machine Disconnected Time Log</h2>
      <Input
        v-model:value="disconnectedSearch"
        placeholder="Search Machine ID"
        class="mb-2 w-64"
      >
        <template #prefix>
          <SearchOutlined />
        </template>
      </Input>
      <Table
        :columns="disconnectedColumns"
        :dataSource="filterDisconnectedLogs"
        :rowKey="record => record.id"
        :pagination="{ pageSize: 5 }"
        class="w-full"
      />
    </div>

    <!-- Limit Change Log -->
    <div>
      <h2 class="text-xl font-semibold mb-2">Limit Change Log</h2>
      <Input
        v-model:value="limitChangeSearch"
        placeholder="Search Machine ID or Changed By"
        class="mb-2 w-64"
      >
        <template #prefix>
          <SearchOutlined />
        </template>
      </Input>
      <Table
        :columns="limitChangeColumns"
        :dataSource="filterLimitChangeLogs"
        :rowKey="record => record.id"
        :pagination="{ pageSize: 5 }"
        class="w-full"
      />
    </div>
  </div>
</template>

<style>
/* You can add any additional styles here if needed */
</style>