<script setup>
import { ref, watch, defineProps, defineEmits } from 'vue';
import flatPickr from 'vue-flatpickr-component';
import 'flatpickr/dist/flatpickr.css';

const { defaultDatetime, type } = defineProps(['defaultDatetime', 'type']);
const emits = defineEmits();

const date = ref(defaultDatetime);

// Watcher to emit an event when the date value changes
watch(date, (newValue) => {
  let dateInEpoch = new Date(newValue).getTime();
  emits('date-change', { type, value: dateInEpoch });
});

const configuration = {
  enableTime: true,
  defaultDate: defaultDatetime,
  enableSeconds: true,
};

</script>

<template>
  <flat-pickr class="border-2 border-black rounded-lg" v-model="date" :config="configuration" />
</template>
