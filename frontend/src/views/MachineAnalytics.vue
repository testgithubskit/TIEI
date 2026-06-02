<script setup>
import { computed, ref, onMounted, watch } from "vue";
import { useBarChartStore } from '@/stores/BarGraph';
import BarChartMultiple from "@/components/Charts/BarChartMultiple.vue";
import SectionMain from "@/components/SectionMain.vue";
import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";
import { 
  DatePicker, 
  Select, 
  Button, 
  Card, 
  Spin, 
  message, 
  Layout, 
  Space,
  Tooltip,
  Empty
} from 'ant-design-vue';
import { 
  BarChartOutlined, 
  ClockCircleOutlined, 
  SearchOutlined, 
  ReloadOutlined,
  SettingOutlined
} from '@ant-design/icons-vue';
import dayjs from 'dayjs'; // Import dayjs for date handling

const { RangePicker } = DatePicker;
const { Content } = Layout;

const BarChartStore = useBarChartStore();
const dateRange = ref([]);
const isLoading = ref(true);
const chartLoading = ref(false);

const availableMachines = computed(() => BarChartStore.availableMachines);
const selectedMachine = ref(BarChartStore.selectedMachine);
const machineData = computed(() => BarChartStore.machineData);

const handleQuerySubmit = async () => {
  if (!selectedMachine.value) {
    message.warning('Please select a machine');
    return;
  }
  if (!dateRange.value || dateRange.value.length !== 2) {
    message.warning('Please select a valid date range');
    return;
  }
  
  chartLoading.value = true;
  try {
    await BarChartStore.fetchMachineData();
    message.success('Data loaded successfully');
  } catch (error) {
    message.error('Failed to load data');
  } finally {
    chartLoading.value = false;
  }
};

const refreshData = async () => {
  isLoading.value = true;
  try {
    await BarChartStore.fetchAvailableMachines();
    if (selectedMachine.value && dateRange.value && dateRange.value.length === 2) {
      await BarChartStore.fetchMachineData();
    }
    message.success('Data refreshed successfully');
  } catch (error) {
    message.error('Failed to refresh data');
  } finally {
    isLoading.value = false;
  }
};

const handleDateRangeChange = (dates) => {
  if (dates && dates.length === 2) {
    BarChartStore.setDateRange(dates[0].valueOf(), dates[1].valueOf());
    // Automatically trigger data fetch when both dates are selected
    handleQuerySubmit();
  }
};

onMounted(async () => {
  try {
    await BarChartStore.fetchAvailableMachines();
    const now = dayjs();
    const oneHourAgo = now.subtract(1, 'hour');
    dateRange.value = [oneHourAgo, now];
    BarChartStore.setDateRange(oneHourAgo.valueOf(), now.valueOf());
  } catch (error) {
    message.error('Failed to initialize data');
  } finally {
    isLoading.value = false;
  }
});

watch(selectedMachine, (newValue) => {
  if (newValue) {
    BarChartStore.setSelectedMachine(newValue);
  }
});

const disabledDate = (current) => {
  return current && current > dayjs().endOf('day');
};
</script>

<template>
   <LayoutAuthenticatedSimple>
    <SectionMain>
  <Layout>
    <Content class="site-layout-background" style="padding: 24px; min-height: 280px">
      <!-- <div class="text-3xl"> Analytics</div> -->
      <Spin :spinning="isLoading" tip="Loading...">
        <Card title="Machine Analytics" :bordered="false" class="analytics-card" >
          <template #extra>
            <BarChartOutlined style="font-size: 24px; color: #1890ff;" />
          </template>
          <Space direction="vertical" size="middle" style="width: 100%">
            <Space wrap>
              <Select
                v-model:value="selectedMachine"
                style="width: 200px"
                placeholder="Select a machine"
                :options="availableMachines.map(machine => ({ value: machine, label: machine }))"
                show-search
                :filter-option="(input, option) => option.label.toLowerCase().indexOf(input.toLowerCase()) >= 0"
              >
                <template #suffixIcon><SettingOutlined /></template>
              </Select>
              <RangePicker 
                v-model:value="dateRange" 
                @change="handleDateRangeChange"
                :showTime="{ format: 'HH:mm', needConfirm: false }"
                format="YYYY-MM-DD HH:mm"
                :placeholder="['Start Time', 'End Time']"
                :disabledDate="disabledDate"
                :defaultValue="[dayjs().subtract(1, 'hour'), dayjs()]"
              >
                <template #suffixIcon><ClockCircleOutlined /></template>
              </RangePicker>
              <Tooltip title="Load data for selected machine and date range">
                <Button type="primary" @click="handleQuerySubmit" class="custom-button">
                  <template #icon><SearchOutlined /></template>
                  Search
                </Button>
              </Tooltip>
              <Tooltip title="Refresh available machines and data">
                <Button @click="refreshData" class="custom-button">
                  <template #icon><ReloadOutlined /></template>
                  Refresh
                </Button>
              </Tooltip>
            </Space>
            
            <Spin :spinning="chartLoading" tip="Loading chart data...">
              <Card title="Machine vs Abnormality Count" :bordered="false" class="chart-card">
                <template v-if="machineData.length">
                  <BarChartMultiple :data="machineData" />
                </template>
                <template v-else>
                  <Empty description="No data available. Please select a machine and date range, then click Search." />
                </template>
              </Card>
            </Spin>
          </Space>
        </Card>
      </Spin>
    </Content>
  </Layout>
</SectionMain>
</LayoutAuthenticatedSimple>
</template>

<style scoped>
.site-layout-background {
  background: #f0f2f5;
}
.analytics-card {
  box-shadow: 0 1px 2px -2px rgba(0, 0, 0, 0.16), 0 3px 6px 0 rgba(0, 0, 0, 0.12), 0 5px 12px 4px rgba(0, 0, 0, 0.09);
}
.chart-card {
  margin-top: 16px;
}
.custom-button {
  background-color: #1890ff;
  border-color: #1890ff;
  color: white;
}
.custom-button:hover {
  background-color: #40a9ff;
  border-color: #40a9ff;
}

/* Updated styles for the RangePicker OK button */
:deep(.ant-picker-footer) .ant-btn-primary {
  background-color: #1890ff;
  border-color: #1890ff;
  color: white;
}

:deep(.ant-picker-footer) .ant-btn-primary:hover {
  background-color: #40a9ff;
  border-color: #40a9ff;
}

.ant-btn-primary {
  @apply bg-emerald-500 border-emerald-500 text-white hover:bg-emerald-600 hover:border-emerald-600 hover:scale-105 transition-all;
}

</style>
