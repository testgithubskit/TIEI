<script setup>
import { computed, ref, onMounted } from "vue";
import { useMainStore } from "@/stores/main";
import {
  mdiAccountMultiple,
  mdiCartOutline,
  mdiChartTimelineVariant,
  mdiMonitorCellphone,
  mdiReload,
  mdiGithub,
  mdiChartPie,
} from "@mdi/js";
import * as chartConfig from "@/components/Charts/chart.config.js";
import LineChart from "@/components/Charts/LineChart.vue";
import LineChartEc from "@/components/Charts/LineChartEc.vue";
import LineChartApex from "@/components/Charts/LineChartApex.vue";
import LineChartDyGraph from "@/components/Charts/LineChartDyGraph.vue";
import PieChartEc from "@/components/Charts/PieChartEc.vue";
import BarChartDrillEc from "@/components/Charts/BarChartDrillEc.vue";
import BarChartEc from "@/components/Charts/BarChartEc.vue";
import DropDown from "@/components/DropDown.vue";
import TestButton from "@/components/TestButton.vue";
import GanttChart from "@/components/Charts/other_charts/GanttChart.vue";
import GanttChartCustom from "@/components/Charts/other_charts/GanttChartCustom.vue";
import SectionMain from "@/components/SectionMain.vue";
import CardBoxWidget from "@/components/CardBoxWidget.vue";
import CardBoxWidgetPlain from "@/components/CardBoxWidgetPlain.vue";
import CardBoxWidgetNumerical from "@/components/CardBoxWidgetNumerical.vue";
import CardBox from "@/components/CardBox.vue";
import TableSampleClients from "@/components/TableSampleClients.vue";
import NotificationBar from "@/components/NotificationBar.vue";
import BaseButton from "@/components/BaseButton.vue";
import CardBoxTransaction from "@/components/CardBoxTransaction.vue";
import CardBoxClient from "@/components/CardBoxClient.vue";
import CardBoxMetric from "@/components/CardBoxMetric.vue";
import LayoutAuthenticated from "@/layouts/LayoutAuthenticated.vue";
import SectionTitleLineWithButton from "@/components/SectionTitleLineWithButton.vue";
import SectionBannerStarOnGitHub from "@/components/SectionBannerStarOnGitHub.vue";
import SectionBannerMetrics from "@/components/SectionBannerMetrics.vue";
import BlurryHorizontalDivider from "@/components/BlurryHorizontalDivider.vue";


//Importing Store Statements

import { useHomeStore } from '@/stores/homeStore'; 

const homeStore = useHomeStore();

const chartData = ref(null);

const fillChartData = () => {
  chartData.value = chartConfig.sampleChartData();
};

onMounted(() => {
  fillChartData();
});

const mainStore = useMainStore();

const clientBarItems = computed(() => mainStore.clients.slice(0, 1));

const transactionBarItems = computed(() => mainStore.history);

const getGridColumnsClass = computed(() => {
  return (length) => {
    return `grid grid-cols-1 gap-6 lg:grid-cols-${length} mb-6`;
  };
});

</script>

<template>
  <LayoutAuthenticated>
    <SectionMain>
      <SectionTitleLineWithButton
        :icon="mdiChartTimelineVariant"
        title="Machine Name:"
        main
      >
      <DropDown />
      </SectionTitleLineWithButton>
      <TestButton />
      <BlurryHorizontalDivider />
      
      <SectionTitleLineWithButton :icon="mdiChartPie" title="Trends overview">
        <BaseButton
          :icon="mdiReload"
          color="whiteDark"
          @click="fillChartData"
        />
      </SectionTitleLineWithButton>

      <CardBox class="mb-6">
        <div>
          <PieChartEc class="h-96" />
        </div>
      </CardBox>

      <CardBox class="mb-6">
        <div>
          <BarChartDrillEc class="h-96" />
        </div>
      </CardBox>

      <CardBox class="mb-6">
        <div>
          <BarChartEc class="h-96" />
        </div>
      </CardBox>

      <CardBox>
        <div v-if="chartData">
          <LineChartDyGraph class="h-96" />
        </div>
      </CardBox>

      <CardBox class="mb-6">
        <div>
          <GanttChart class="h-96" />
        </div>
      </CardBox>

      <CardBox class="mb-6">
        <div>
          <GanttChartCustom class="h-96" />
        </div>
      </CardBox>

      <SectionTitleLineWithButton :icon="mdiAccountMultiple" title="Clients" />

      <NotificationBar color="info" :icon="mdiMonitorCellphone">
        <b>Responsive table.</b> Collapses on mobile
      </NotificationBar>

      <CardBox has-table>
        <TableSampleClients />
      </CardBox>
    </SectionMain>
  </LayoutAuthenticated>
</template>
