<script setup>
  import { ref, watch, defineProps } from 'vue';
  import flatPickr from 'vue-flatpickr-component';
  import 'flatpickr/dist/flatpickr.css';

  import { useMachineSamplingStore } from '@/stores/MachineSamplingStore';
import { mdiConsoleNetwork } from '@mdi/js';

  const props = defineProps({
    defaultDatetime: {
      type: Date,
      default: new Date(),
    },
    type: {
      type: String,
      default: 'from',
      validator: (value) => ['from', 'to'].includes(value),
    },
  });

  const date = ref(props.defaultDatetime);
  const machineSamplingStore = useMachineSamplingStore();

  updateSelectedDate(date.value);

  const configuration = {
    enableTime: true,
    defaultDate: props.defaultDatetime,
    enableSeconds: true,
  };

  // Watcher to log changes in the date value
  watch(date, (newValue, oldValue) => {
    let dateInEpoch = new Date(newValue).getTime();
    console.log('Date changed:', dateInEpoch);
    console.log('Date changed TypeOf :', typeof(dateInEpoch));
    updateSelectedDate(dateInEpoch);
  });

  function updateSelectedDate(newValue) {
    if (props.type === 'from') {
      machineSamplingStore.selectedMachine.selectedDatesDict.from = newValue;
      console.log("new value", typeof(newValue));
    } else if (props.type === 'to') {
      machineSamplingStore.selectedMachine.selectedDatesDict.to = newValue;
    }
  }
</script>

<template>
  <flat-pickr class="border-2 border-black rounded-lg" v-model="date" :config="configuration" />
</template>
