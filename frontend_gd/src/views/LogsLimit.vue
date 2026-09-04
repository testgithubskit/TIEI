<script setup>
import { ref, computed, onMounted } from 'vue';
import { Table, Input, DatePicker, Button } from 'ant-design-vue';
import { SearchOutlined, DownloadOutlined } from '@ant-design/icons-vue';
import LayoutAuthenticatedSimple from '@/layouts/LayoutAuthenticatedSimple.vue';
import SectionMain from '@/components/SectionMain.vue';
import CardBox from '@/components/CardBox.vue';
import * as XLSX from 'xlsx';
import { useLogStore } from '@/stores/LogStore'; // Import the Log store

const logStore = useLogStore(); // Create an instance of the Log store

// Fetch limit change logs data
const fetchLimitChangeLogs = async () => {
  try {
    const response = await logStore.fetchLimitChangeLogs();
    limitChangeLogs.value = response.map((log, index) => ({
      id: index + 1,
      machineId: log.parameter_name,
      changedBy: log.user,
      changeTime: log.date_changed,
      oldValue: log.reference_signal[0], // Assuming the first value is the old value
      newValue: log.limit_value
    }));
  } catch (error) {
    console.error('Error fetching limit change logs:', error);
  }
};

onMounted(() => {
  fetchLimitChangeLogs();
});

// Sample data for machine disconnected time log (unchanged)
const disconnectedLogs = ref([
  { id: 1, machineId: 'M001', fromTime: '2024-07-03 10:00:00', toTime: '2024-07-03 11:30:00' },
  { id: 2, machineId: 'M002', fromTime: '2024-07-03 14:15:00', toTime: '2024-07-03 15:45:00' },
  { id: 3, machineId: 'M003', fromTime: '2024-07-04 09:30:00', toTime: '2024-07-04 10:15:00' },
]);

// Limit change logs data (now fetched from the store)
const limitChangeLogs = ref([]);

// Column definitions for disconnected logs table (unchanged)
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
const onDateRangeChange = async (dates) => {
  dateRange.value = dates;
  if (dates && dates.length === 2) {
    logStore.selectedDates.from = dates[0].valueOf();
    logStore.selectedDates.to = dates[1].valueOf();
    await fetchLimitChangeLogs();
  }
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
      <CardBox>
        <a-table
          :columns="disconnectedColumns"
          :data-source="filterDisconnectedLogs"
          :pagination="disconnectedPagination"
          @change="onDisconnectedPaginationChange"
        >
          <template #title>
            <h3>Disconnected Logs</h3>
          </template>
        </a-table>
      </CardBox>
      
      <CardBox>
        <a-table
          :columns="limitChangeColumns"
          :data-source="filterLimitChangeLogs"
          :pagination="limitChangePagination"
          @change="onLimitChangePaginationChange"
        >
          <template #title>
            <h3>Limit Change Logs</h3>
          </template>
        </a-table>
      </CardBox>
    </SectionMain>
  </LayoutAuthenticatedSimple>
</template>

<style>
/* The styles remain unchanged */
</style>
