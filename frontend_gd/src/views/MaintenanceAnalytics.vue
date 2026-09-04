<script setup>
import { computed, ref, onMounted, watch } from "vue";
import { useMaintenanceAnalyticsStore } from '@/stores/MaintenanceStore';
import BarChartMultipleMaintenance from "@/components/Charts/BarChartMultipleMaintenance.vue";
import SectionMain from "@/components/SectionMain.vue";
import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";
import { 
  DatePicker, 
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
  ReloadOutlined
} from '@ant-design/icons-vue';
import dayjs from 'dayjs';

const { RangePicker } = DatePicker;
const { Content } = Layout;

const MaintenanceStore = useMaintenanceAnalyticsStore();
const dateRange = ref([]);
const isLoading = ref(true);
const chartLoading = ref(false);

const maintenanceData = computed(() => MaintenanceStore.maintenanceData);

const handleQuerySubmit = async () => {
  if (!dateRange.value || dateRange.value.length !== 2) {
    message.warning('Please select a valid date range');
    return;
  }
  
  chartLoading.value = true;
  try {
    await MaintenanceStore.fetchMaintenanceData();
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
    if (dateRange.value && dateRange.value.length === 2) {
      await MaintenanceStore.fetchMaintenanceData();
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
    MaintenanceStore.setDateRange(dates[0].valueOf(), dates[1].valueOf());
  }
};

onMounted(async () => {
  try {
    const now = dayjs();
    const oneHourAgo = now.subtract(1, 'hour');
    dateRange.value = [oneHourAgo, now];
    MaintenanceStore.setDateRange(oneHourAgo.valueOf(), now.valueOf());
  } catch (error) {
    message.error('Failed to initialize data');
  } finally {
    isLoading.value = false;
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
          <Spin :spinning="isLoading" tip="Loading...">
            <Card title="Maintenance Analytics" :bordered="false" class="analytics-card">
              <template #extra>
                <BarChartOutlined style="font-size: 24px; color: #1890ff;" />
              </template>
              <Space direction="vertical" size="middle" style="width: 100%">
                <Space wrap>
                  <RangePicker 
                    v-model:value="dateRange" 
                    @change="handleDateRangeChange"
                    :show-time="{ format: 'HH:mm' }"
                    format="YYYY-MM-DD HH:mm"
                    :placeholder="['Start Time', 'End Time']"
                    :disabled-date="disabledDate"
                  >
                    <template #suffixIcon><ClockCircleOutlined /></template>
                  </RangePicker>
                  <Tooltip title="Load data for selected date range">
                    <Button type="primary" @click="handleQuerySubmit" class="custom-button">
                      <template #icon><SearchOutlined /></template>
                      Search
                    </Button>
                  </Tooltip>
                  <Tooltip title="Refresh data">
                    <Button @click="refreshData" class="custom-button">
                      <template #icon><ReloadOutlined /></template>
                      Refresh
                    </Button>
                  </Tooltip>
                </Space>
                
                <Spin :spinning="chartLoading" tip="Loading chart data...">
                  <Card title="Operator vs Abnormality Count" :bordered="false" class="chart-card">
                    <template v-if="maintenanceData.length">
                      <BarChartMultipleMaintenance :data="maintenanceData" />
                    </template>
                    <template v-else>
                      <Empty description="No data available. Please select a date range, then click Search." />
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
</style>
