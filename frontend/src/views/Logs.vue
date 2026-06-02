<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import { Table, Input, DatePicker, Button, Select, message, Spin } from 'ant-design-vue';
import { SearchOutlined, DownloadOutlined } from '@ant-design/icons-vue';
import LayoutAuthenticatedSimple from '@/layouts/LayoutAuthenticatedSimple.vue';
import SectionMain from '@/components/SectionMain.vue';
import CardBox from '@/components/CardBox.vue';
import * as XLSX from 'xlsx';
import { useLogStore } from '@/stores/LogStore';
import BlurryHorizontalDivider from "@/components/BlurryHorizontalDivider.vue";

const logStore = useLogStore();

// Refs for component state
const selectedMachine = ref(null);
const machineOptions = ref([]);
const disconnectionDateRange = ref([]);
const limitChangeDateRange = ref([]);
const disconnectedLogs = ref([]);
const limitChangeLogs = ref([]);
const disconnectedSearch = ref('');
const limitChangeSearch = ref('');
const isLoading = ref(false);

// Pagination state
const disconnectedPagination = ref({
  current: 1,
  pageSize: 10,
});

const limitChangePagination = ref({
  current: 1,
  pageSize: 10,
});

// Fetch all machine names
const fetchMachineNames = async () => {
  try {
    isLoading.value = true;
    await logStore.fetchMachineNames();
    machineOptions.value = logStore.MachineNames.map(machine => ({
      value: machine,
      label: machine
    }));
  } catch (error) {
    message.error('Failed to fetch machine names');
  } finally {
    isLoading.value = false;
  }
};

// Fetch disconnection history
const fetchDisconnectionHistory = async () => {
  if (!selectedMachine.value || !disconnectionDateRange.value || disconnectionDateRange.value.length !== 2) {
    message.warning('Please select a machine and date range');
    return;
  }

  // Convert to seconds epoch in IST (no UTC conversion needed)
  const fromTimestamp = Math.floor(disconnectionDateRange.value[0].valueOf() / 1000);
  const toTimestamp = Math.floor(disconnectionDateRange.value[1].valueOf() / 1000);

  try {
    isLoading.value = true;
    await logStore.fetchDisconnectionHistory(selectedMachine.value, fromTimestamp, toTimestamp);
    disconnectedLogs.value = logStore.DisconnectionHistory.map((log, index) => ({
      id: index + 1,
      parameterId: log.L1Name,
      fromTime: new Date(log.updatedate).toLocaleString(),
      toTime: new Date(log.enddate).toLocaleString(),
      timespan: log.timespan
    }));
  } catch (error) {
    message.error('Failed to fetch disconnection history');
  } finally {
    isLoading.value = false;
  }
};

// Fetch limit change logs
const fetchLimitChangeLogs = async () => {
  if (!limitChangeDateRange.value || limitChangeDateRange.value.length !== 2) {
    message.warning('Please select a date range for limit change logs');
    return;
  }

  // Convert to milliseconds epoch and adjust for UTC
  const fromDate = new Date(limitChangeDateRange.value[0]);
  const toDate = new Date(limitChangeDateRange.value[1]);
  console.log("To Date")
  console.log(toDate)
  
  const fromTimestamp = fromDate.valueOf() - (fromDate.getTimezoneOffset() * 60000);
  const toTimestamp = toDate.valueOf() - (toDate.getTimezoneOffset() * 60000);
  console.log("To Date after conversion")
  console.log(toTimestamp)

  try {
    isLoading.value = true;
    await logStore.fetchLimitChangeLogs(fromTimestamp, toTimestamp);
    limitChangeLogs.value = logStore.LimitChangeData.map((log, index) => ({
      id: index + 1,
      parameterId: log.parameter_name,
      changedBy: log.user,
      changeTime: new Date(log.date_changed).toLocaleString(),
      setType: log.set_type,
      oldValue: log.previous_limit,
      newValue: log.limit_value,
    }));
  } catch (error) {
    message.error('Failed to fetch limit change logs');
  } finally {
    isLoading.value = false;
  }
};

// Fetch disconnected machines
const fetchDisconnectedMachines = async () => {
  try {
    await logStore.fetchDisconnectedMachines();
  } catch (error) {
    console.error('Error fetching disconnected machines:', error);
  }
};

onMounted(() => {
  fetchMachineNames();
  fetchDisconnectedMachines();
  setInterval(fetchDisconnectedMachines, 5000);
});

// Column definitions
const disconnectedColumns = [
  { title: 'Machine ID', dataIndex: 'parameterId', key: 'parameterId', sorter: (a, b) => a.parameterId.localeCompare(b.parameterId) },
  { title: 'From Time', dataIndex: 'fromTime', key: 'fromTime', sorter: (a, b) => new Date(a.fromTime) - new Date(b.fromTime) },
  { title: 'To Time', dataIndex: 'toTime', key: 'toTime', sorter: (a, b) => new Date(a.toTime) - new Date(b.toTime) },
  { title: 'Timespan (seconds)', dataIndex: 'timespan', key: 'timespan', sorter: (a, b) => a.timespan - b.timespan }
];

const limitChangeColumns = [
  { title: 'Parameter Name', dataIndex: 'parameterId', key: 'parameterId', sorter: (a, b) => a.parameterId.localeCompare(b.parameterId) },
  { title: 'Changed By', dataIndex: 'changedBy', key: 'changedBy', sorter: (a, b) => a.changedBy.localeCompare(b.changedBy) },
  { title: 'Change Time', dataIndex: 'changeTime', key: 'changeTime', sorter: (a, b) => new Date(a.changeTime) - new Date(b.changeTime) },
  { title: 'Set Type', dataIndex: 'setType', key: 'setType', sorter: (a, b) => a.setType.localeCompare(b.setType) },
  { title: 'Old Value', dataIndex: 'oldValue', key: 'oldValue', sorter: (a, b) => a.oldValue - b.oldValue },
  { title: 'New Value', dataIndex: 'newValue', key: 'newValue', sorter: (a, b) => a.newValue - b.newValue },
];

// Filter functions
const filterDisconnectedLogs = computed(() => {
  return disconnectedLogs.value.filter(log => 
    log.parameterId.toLowerCase().includes(disconnectedSearch.value.toLowerCase())
  );
});

const filterLimitChangeLogs = computed(() => {
  return limitChangeLogs.value.filter(log => 
    log.parameterId.toLowerCase().includes(limitChangeSearch.value.toLowerCase()) ||
    log.changedBy.toLowerCase().includes(limitChangeSearch.value.toLowerCase())
  );
});

// Date range change handlers
const onDisconnectionDateRangeChange = (dates) => {
  disconnectionDateRange.value = dates;
};

const onLimitChangeDateRangeChange = (dates) => {
  limitChangeDateRange.value = dates;
};

// Watch for changes in limitChangeDateRange
watch(limitChangeDateRange, () => {
  if (limitChangeDateRange.value && limitChangeDateRange.value.length === 2) {
    fetchLimitChangeLogs();
  }
});

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
      <div class="px-4 py-8">
        <h1 class="text-3xl font-semibold text-emerald-700 mb-6">Logs</h1>
        
        <!-- Machines Overview -->
        <div class="mb-20 ">
          <h2 class="text-2xl  font-semibold text-emerald-600 mb-4">Real-Time Machines Overview</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 ">
            <div v-for="(machines, line) in logStore.DisconnectedMachines" :key="line" 
                 class="bg-white rounded-xl shadow-lg p-4">
              <h3 class="text-lg font-bold mb-3 text-emerald-600">{{ line }}</h3>
              <div class="max-h-60 overflow-y-auto pr-2">
                <div class="grid grid-cols-2 sm:grid-cols-5 gap-3">
                  <div v-for="machine in machines" :key="machine.L1Name" 
                       class="p-3 rounded-lg shadow-md text-center transition-all duration-300 hover:shadow-xl"
                       :class="{
                         'bg-red-100 hover:bg-red-200': machine.value === true || machine.value === 'true',
                         'bg-green-100 hover:bg-green-200': machine.value === false || machine.value === 'false'
                       }">
                    <p class="font-semibold text-xs" 
                       :class="{
                         'text-red-700': machine.value === true || machine.value === 'true',
                         'text-green-700': machine.value === false || machine.value === 'false'
                       }">
                      {{ machine.L1Name }}
                    </p>
                    <!-- <p class="text-xs mt-1" 
                       :class="{
                         'text-red-500': machine.value === true || machine.value === 'true',
                         'text-green-500': machine.value === false || machine.value === 'false'
                       }">
                      {{ machine.value === true || machine.value === 'true' ? 'Disconnected' : 'Connected' }}
                    </p> -->
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <BlurryHorizontalDivider />
        
        

        <!-- Machine Disconnected Time Log -->
        <div class="mb-20">
          <div class="flex justify-between items-center mb-3">
            <h2 class="text-xl font-semibold text-emerald-600">Machine Disconnected Time Log</h2>
            <Button class="bg-emerald-500 text-white hover:scale-105 transition-all" @click="exportDisconnectedLogs">
              <template #icon><DownloadOutlined /></template>
              Export to Excel
            </Button>
          </div>
          <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
            <Select
              v-model:value="selectedMachine"
              :options="machineOptions"
              placeholder="Select Machine"
              show-search
              :filter-option="(input, option) => option.label.toLowerCase().indexOf(input.toLowerCase()) >= 0"
              class="w-full"
            />
            <DatePicker.RangePicker
              v-model:value="disconnectionDateRange"
              @change="onDisconnectionDateRangeChange"
              class="w-full"
            />
            <Button @click="fetchDisconnectionHistory" type="primary" class="w-full">
              Fetch Disconnection History
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
            <Spin :spinning="isLoading">
              <Table
                :columns="disconnectedColumns"
                :dataSource="filterDisconnectedLogs"
                :rowKey="record => record.id"
                :pagination="disconnectedPagination"
                @change="onDisconnectedPaginationChange"
                class="w-full"
                :scroll="{ x: 'max-content' }"
              />
            </Spin>
          </CardBox>
        </div>

        <BlurryHorizontalDivider />

        <!-- Limit Change Log -->
        <div>
          <div class="flex justify-between items-center mb-3">
            <h2 class="text-xl font-semibold text-emerald-600">Limit Change Log</h2>
            <Button class="bg-emerald-500 text-white hover:scale-105 transition-all" @click="exportLimitChangeLogs">
              <template #icon><DownloadOutlined /></template>
              Export to Excel
            </Button>
          </div>
          <div class="mb-4">
            <DatePicker.RangePicker
              v-model:value="limitChangeDateRange"
              @change="onLimitChangeDateRangeChange"
              class="w-full sm:w-64"
            />
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
            <Spin :spinning="isLoading">
              <Table
                :columns="limitChangeColumns"
                :dataSource="filterLimitChangeLogs"
                :rowKey="record => record.id"
                :pagination="limitChangePagination"
                @change="onLimitChangePaginationChange"
                class="w-full"
                :scroll="{ x: 'max-content' }"
              />
            </Spin>
          </CardBox>
        </div>
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

.ant-picker {
  @apply border-emerald-300 focus:border-emerald-500 focus:ring focus:ring-emerald-200 focus:ring-opacity-50;
}

.ant-btn-primary {
  @apply bg-emerald-500 border-emerald-500 text-white hover:bg-emerald-600 hover:border-emerald-600;
}

.ant-select:not(.ant-select-customize-input) .ant-select-selector {
  @apply border-emerald-300 focus:border-emerald-500 focus:ring focus:ring-emerald-200 focus:ring-opacity-50;
}

.ant-select-focused:not(.ant-select-disabled).ant-select:not(.ant-select-customize-input) .ant-select-selector {
  @apply border-emerald-500 shadow-none;
}
</style>