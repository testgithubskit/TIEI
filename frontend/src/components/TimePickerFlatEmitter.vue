<script setup>
import { ref, watch, defineProps, defineEmits } from 'vue';
import flatPickr from 'vue-flatpickr-component';
import 'flatpickr/dist/flatpickr.css';

const props = defineProps({
  defaultDatetime: {
    type: [Date, String, Number],
    required: true,
  },
  type: {
    type: String,
    default: 'from',
  },
});

const emits = defineEmits(['date-change']);

const date = ref(props.defaultDatetime ? new Date(props.defaultDatetime) : new Date());
let syncingFromParent = false;

function toEpoch(value) {
  const ms = new Date(value).getTime();
  return Number.isFinite(ms) ? ms : null;
}

/** Parent can call this on Submit to read the picker value reliably */
function getEpoch() {
  return toEpoch(date.value);
}

defineExpose({ getEpoch });

watch(
  () => props.defaultDatetime,
  (newValue) => {
    if (newValue == null || newValue === '') {
      return;
    }
    const nextMs = toEpoch(newValue);
    const currentMs = toEpoch(date.value);
    if (nextMs == null || nextMs === currentMs) {
      return;
    }
    syncingFromParent = true;
    date.value = new Date(nextMs);
    queueMicrotask(() => {
      syncingFromParent = false;
    });
  },
  { immediate: true }
);

watch(date, (newValue) => {
  if (syncingFromParent) {
    return;
  }
  const epoch = toEpoch(newValue);
  if (epoch == null) {
    return;
  }
  emits('date-change', { type: props.type, value: epoch });
});

const configuration = {
  enableTime: true,
  enableSeconds: true,
  time_24hr: true,
  allowInput: true,
  dateFormat: 'Y-m-d H:i:S',
};
</script>

<template>
  <flat-pickr
    class="border-2 border-black rounded-lg"
    v-model="date"
    :config="configuration"
  />
</template>
