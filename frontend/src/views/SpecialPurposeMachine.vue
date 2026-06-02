<script setup>
import { computed, ref, onBeforeMount } from "vue";

import SectionMain from "@/components/SectionMain.vue";

import BaseButton from "@/components/BaseButton.vue";

import LayoutAuthenticatedSimple from "@/layouts/LayoutAuthenticatedSimple.vue";
import BlurryHorizontalDivider from "@/components/BlurryHorizontalDivider.vue";



import CardBoxWidgetPlainWrap from "@/components/CardBoxWidgetPlainWrap.vue";

//Importing Store Statements

import { useSpecialPurposeMachineOverview } from '@/stores/SpecialPurposeMachineOverview'; 
import { useSpecialPurposeMachineDetailStore } from '@/stores/SpecialPurposeMachineDetailStore'; 
import { useSpecialPurposeMachinePositionStore } from '@/stores/SpecialPurposeMachinePositionStore'; 
import { useRouter } from 'vue-router';

const router = useRouter();

const specialPurposeMachineOverview = useSpecialPurposeMachineOverview();
const specialPurposeMachineDetailStore = useSpecialPurposeMachineDetailStore();
const specialPurposeMachinePositionStore = useSpecialPurposeMachinePositionStore();


const handleBack = async () => {
  const routeObject = { name: 'Factory Level Polling Parameter Overview Grid',
   params: { groupName: specialPurposeMachineDetailStore.parameterGroup } };
  router.push(routeObject);
};


onBeforeMount(async () => {
  console.log("sampling on mount");
  specialPurposeMachineOverview.updateSpmMachines();
});

const handleCardClick = (machineName) => {
  specialPurposeMachineDetailStore.machine = machineName;
  specialPurposeMachinePositionStore.machine = machineName;
  router.push('/spm-detail');
};




</script>

<template>
  <LayoutAuthenticatedSimple>
    <SectionMain>
      <div class="container mx-auto flex flex-col space-y-4">
        <div class="w-16 h-8">
          <!-- <BaseButton type="submit" color="infolightDark" label="Back" @click="handleBack" /> -->
        </div>
        <div v-if="specialPurposeMachineDetailStore.alertMessage" 
          :class="{ 'alert': true, 'bg-emerald-500 border-black': specialPurposeMachineDetailStore.isSuccessMessage,
          'bg-red-600 border-black': !specialPurposeMachineDetailStore.isSuccessMessage }">
          {{ specialPurposeMachineDetailStore.alertMessage }}
        </div>
        <BlurryHorizontalDivider />
        <!-- Display machine information Start -->
        <div class="grid grid-cols-1 gap-6 lg:grid-cols-5 mb-6">
          <CardBoxWidgetPlainWrap v-for="machine in specialPurposeMachineOverview.SpmMachines"
            :key="machine.machineName"
            :label="machine.machineName"
            :parameter-value="machine.status"
            :style="{ color: machine.status === 'OK' ? 'green' : 'red' }"
            @click="() => handleCardClick(machine.machineName)">
          </CardBoxWidgetPlainWrap>
        </div>
        
      </div>
    </SectionMain>
  </LayoutAuthenticatedSimple>
</template>

<style scoped>
/* Tailwind CSS classes for animation */
@keyframes slideIn {
  from {
    transform: translateX(100%);
  }
  to {
    transform: translateX(0);
  }
}

/* Add your alert styles here */
.alert {
  @apply fixed top-10 left-1/2 transform -translate-x-1/2 text-white p-2 rounded-md border z-50;
  animation: slideIn 0.5s ease-out;
}
</style>
