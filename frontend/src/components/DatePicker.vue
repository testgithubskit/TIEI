<!-- SFC file -->
<script setup>

import { ref } from 'vue';
import VueTailwindDatepicker from 'vue-tailwind-datepicker';
import { useMachineSamplingStore } from '@/stores/MachineSamplingStore';

const MachineSamplingStore = useMachineSamplingStore();
const formatter = ref({
  date: 'DD MMM YYYY',
  month: 'MMM'
});

// List of dates to be disabled
const disabledDates = ['2023-05-23', '2023-05-24', '2023-05-25'];

const dDate = (date) => {
  // Check if the given date exists in the disabledDates array
  return disabledDates.includes(date.toISOString().split('T')[0]);
};

</script>

<template>

<div class="w-1/2 mx-auto">
  <vue-tailwind-datepicker
    :formatter="formatter"
    :disable-date="dDate"
    as-single
    use-range
    separator="   |  TO  |   "
    overlay
    v-model="MachineSamplingStore.selectedMachine.selectedDates"
  />
</div>

</template>
