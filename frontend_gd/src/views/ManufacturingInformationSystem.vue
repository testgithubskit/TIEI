<script setup>
import { ref, onBeforeMount, computed } from 'vue';
import Accordion from 'primevue/accordion';
import AccordionTab from 'primevue/accordiontab';
import SectionMain from "@/components/SectionMain.vue";
import LayoutAuthenticated from "@/layouts/LayoutAuthenticated.vue";
import DocumentCard from "@/components/DocumentCard.vue";
import UploadButtonPrimeVue from "@/components/UploadButtonPrimeVue.vue";


//Importing Store Statements

import { useManufacturingInformationSystemStore } from '@/stores/ManufacturingInformationSystemStore'; 

const manufacturingInformationSystemStore = useManufacturingInformationSystemStore();

const departments = computed(() => {
  return manufacturingInformationSystemStore.departments});

onBeforeMount(async () => {
  console.log("Creating the MIS");
  await manufacturingInformationSystemStore.fetchAndUpdateAvailableDocuments();
  console.log(manufacturingInformationSystemStore.departments)
});

</script>

<template>
  <LayoutAuthenticated>
    <SectionMain>

      <div class="flex items-center justify-center mb-8">
        <form class="flex">
          <input type="text" class="rounded-l-lg py-2 px-4 border-t mr-0 border-b border-l text-gray-800 border-gray-200 bg-white" placeholder="Enter Document Id">
          <button class="px-8 rounded-r-lg bg-blue-500 hover:bg-blue-700 text-white font-bold py-2">
            Set
          </button>
        </form>
        <UploadButtonPrimeVue />
      </div>
      <div class="flex flex-wrap -mx-4">
        <DocumentCard
        v-for="department in departments"
        :key="department.heading"
        :heading="department.heading"
        :items="department.items"
        :color="department.color"
      />
      </div>   

    </SectionMain>
  </LayoutAuthenticated>
</template>
