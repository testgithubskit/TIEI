<script setup>
import { computed, ref, onMounted, watch } from "vue";
import { useParameterAnalytics } from '@/stores/parameterAnalytics';
import BarChartMultipleParameter from "@/components/Charts/BarChartMultipleParameter.vue";
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
import dayjs from 'dayjs';

const { RangePicker } = DatePicker;
const { Content } = Layout;

const ParameterStore = useParameterAnalytics();
const dateRange = ref([]);
const isLoading = ref(true);
const chartLoading = ref(false);

const availableParameters = computed(() => ParameterStore.availableParameters);
const selectedParameter = ref(ParameterStore.selectedParameter);
const parameterData = computed(() => ParameterStore.ParameterData);

const handleQuerySubmit = async () => {
  if (!selectedParameter.value) {
    message.warning('Please select a parameter');
    return;
  }
  if (!dateRange.value || dateRange.value.length !== 2) {
    message.warning('Please select a valid date range');
    return;
  }
  
  chartLoading.value = true;
  try {
    await ParameterStore.fetchParameterData();
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
    await ParameterStore.fetchAvailableParameters();
    if (selectedParameter.value && dateRange.value && dateRange.value.length === 2) {
      await ParameterStore.fetchParameterData();
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
    ParameterStore.setDateRange(dates[0].valueOf(), dates[1].valueOf());
  }
};

const handleParameterChange = (value) => {
  ParameterStore.setSelectedParameter(value);
};

onMounted(async () => {
  try {
    await ParameterStore.fetchAvailableParameters();
    const now = dayjs();
    const oneHourAgo = now.subtract(1, 'hour');
    dateRange.value = [oneHourAgo, now];
    ParameterStore.setDateRange(oneHourAgo.valueOf(), now.valueOf());
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
            <Card title="Parameter Analytics" :bordered="false" class="analytics-card">
              <template #extra>
                <BarChartOutlined style="font-size: 24px; color: #1890ff;" />
              </template>
              <Space direction="vertical" size="middle" style="width: 100%">
                <Space wrap>
                  <Select
                    v-model:value="selectedParameter"
                    style="width: 200px"
                    placeholder="Select a parameter"
                    :options="availableParameters.map(param => ({ value: param, label: param }))"
                    show-search
                    :filter-option="(input, option) => option.label.toLowerCase().indexOf(input.toLowerCase()) >= 0"
                    @change="handleParameterChange"
                  >
                    <template #suffixIcon><SettingOutlined /></template>
                  </Select>
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
                  <Tooltip title="Load data for selected parameter and date range">
                    <Button type="primary" @click="handleQuerySubmit" class="custom-button">
                      <template #icon><SearchOutlined /></template>
                      Search
                    </Button>
                  </Tooltip>
                  <Tooltip title="Refresh available parameters and data">
                    <Button @click="refreshData" class="custom-button">
                      <template #icon><ReloadOutlined /></template>
                      Refresh
                    </Button>
                  </Tooltip>
                </Space>
                
                <Spin :spinning="chartLoading" tip="Loading chart data...">
                  <Card title="Parameter vs Abnormality Count" :bordered="false" class="chart-card">
                    <template v-if="parameterData.length">
                      <BarChartMultipleParameter :data="parameterData" />
                    </template>
                    <template v-else>
                      <Empty description="No data available. Please select a parameter and date range, then click Search." />
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
