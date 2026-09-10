<script setup>
import { onBeforeMount } from "vue";
import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";
import { useSpecialPurposeMachineOverview } from '@/stores/SpecialPurposeMachineOverview';
import { useSpecialPurposeMachineDetailStore } from '@/stores/SpecialPurposeMachineDetailStore';
import { useSpecialPurposeMachinePositionStore } from '@/stores/SpecialPurposeMachinePositionStore';
import { useRouter, useRoute } from 'vue-router';

const router = useRouter();
const route = useRoute();
const specialPurposeMachineOverview = useSpecialPurposeMachineOverview();
const specialPurposeMachineDetailStore = useSpecialPurposeMachineDetailStore();
const specialPurposeMachinePositionStore = useSpecialPurposeMachinePositionStore();

onBeforeMount(async () => {
  specialPurposeMachineOverview.updateSpmMachines();
});

function formatMachineName(name) {
  return String(name || '').replace(/_/g, ' ');
}

function statusClass(status) {
  const value = String(status || '').toUpperCase();
  if (value === 'OK') return 'is-ok';
  if (value === 'WARNING') return 'is-warning';
  if (value === 'CRITICAL') return 'is-critical';
  return 'is-unknown';
}

const handleCardClick = (machineName) => {
  specialPurposeMachineDetailStore.setSelectedMachine(machineName);
  specialPurposeMachineDetailStore.setPendingParameter('');
  specialPurposeMachineDetailStore.setReturnPath(route.fullPath || '/spm-overview');
  specialPurposeMachinePositionStore.machine = machineName;
  router.push({
    name: 'Spm Detail',
    query: { machine: machineName },
  });
};
</script>

<template>
  <LayoutAuthenticatedSimple>
    <section class="spm-overview-page px-4 py-4 flex flex-col overflow-hidden">
      <div
        v-if="specialPurposeMachineDetailStore.alertMessage"
        :class="{
          'alert': true,
          'bg-emerald-500 border-black': specialPurposeMachineDetailStore.isSuccessMessage,
          'bg-red-600 border-black': !specialPurposeMachineDetailStore.isSuccessMessage
        }"
      >
        {{ specialPurposeMachineDetailStore.alertMessage }}
      </div>

      <div class="flex-shrink-0 mb-4">
        <h1 class="text-xl font-black tracking-wide text-slate-800 dark:text-slate-100">
          Special Purpose Machines
        </h1>
        <p class="text-sm text-slate-500 dark:text-slate-400 mt-1">
          Select a machine to view live parameters and timeline.
        </p>
      </div>

      <div class="spm-overview-grid">
        <button
          v-for="machine in specialPurposeMachineOverview.SpmMachines"
          :key="machine.machineName"
          type="button"
          class="spm-machine-card"
          :class="statusClass(machine.status)"
          @click="handleCardClick(machine.machineName)"
        >
          <span class="spm-machine-name">{{ formatMachineName(machine.machineName) }}</span>
          <span class="spm-machine-status">{{ machine.status }}</span>
        </button>
      </div>
    </section>
  </LayoutAuthenticatedSimple>
</template>

<style scoped>
.spm-overview-page {
  height: 100%;
  width: 100%;
  box-sizing: border-box;
}

.spm-overview-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 16px;
  align-content: start;
  min-height: 0;
  overflow: auto;
  position: relative;
  z-index: 1;
}

.spm-machine-card {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  min-height: 120px;
  padding: 16px 18px;
  text-align: left;
  border-radius: 14px;
  border: 1px solid #e2e8f0;
  background: #ffffff;
  box-shadow: 0 1px 2px rgba(15, 23, 42, 0.06);
  border-top-width: 6px;
}
.spm-machine-card:hover {
  transform: translateY(-1px);
  box-shadow: 0 6px 16px rgba(15, 23, 42, 0.08);
}
.spm-machine-card.is-ok { border-top-color: #22c55e; }
.spm-machine-card.is-warning { border-top-color: #f59e0b; }
.spm-machine-card.is-critical { border-top-color: #ef4444; }
.spm-machine-card.is-unknown { border-top-color: #94a3b8; }

.spm-machine-name {
  font-size: 15px;
  font-weight: 800;
  line-height: 1.25;
  color: #0f172a;
  overflow-wrap: anywhere;
}

.spm-machine-status {
  margin-top: 12px;
  font-size: 18px;
  font-weight: 900;
  letter-spacing: 0.04em;
  text-transform: uppercase;
}
.is-ok .spm-machine-status { color: #16a34a; }
.is-warning .spm-machine-status { color: #d97706; }
.is-critical .spm-machine-status { color: #dc2626; }

.dark .spm-machine-card {
  background: #1e293b;
  border-color: #334155;
}
.dark .spm-machine-name { color: #f8fafc; }

@keyframes slideIn {
  from { transform: translateX(100%); }
  to { transform: translateX(0); }
}
.alert {
  @apply fixed top-10 left-1/2 transform -translate-x-1/2 text-white p-2 rounded-md border z-50;
  animation: slideIn 0.5s ease-out;
}
</style>
