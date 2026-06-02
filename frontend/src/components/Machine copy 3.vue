<script setup>
import { computed } from "vue";
import { mdiTrendingDown, mdiTrendingUp, mdiTrendingNeutral } from "@mdi/js";
import CardBox from "@/components/CardBox.vue";
import BaseLevel from "@/components/BaseLevel.vue";
import PillTag from "@/components/PillTag.vue";
import BaseIcon from "@/components/BaseIcon.vue"; // Import the BaseIcon component

const props = defineProps({
  machineState: {
    type: String,
    default: null,
  },
  label: {
    type: String,
    default: null,
  },
  parameterValue: {
    type: Number,
    default: null,
  },
  borderSide: {
    type: String,
    default: "s",
  },
  borderThickness: {
    type: String,
    default: "4",
  },
});

const pillIcon = computed(() => {
  return {
    success: mdiTrendingUp,
    warning: mdiTrendingNeutral,
    critical: mdiTrendingDown,
    info: null,
  }[props.type];
});

const color = computed(() => {
  return {
    normal: "text-emerald-600",
    warning: "text-yellow-500",
    critical: "text-red-600",
    info: null,
  }[props.machineState];
});

const borderColor = computed(() => {
  return {
    normal: "emerald-600",
    warning: "yellow-600",
    critical: "red-600",
    info: null,
  }[props.machineState];
});


const borderClass = computed(() => {
  return `mb-6 shadow-lg border-${props.borderSide} border-${borderColor.value} border-${props.borderSide}-${props.borderThickness} hover:shadow-md`;
});

</script>

<template>
  <CardBox :class="borderClass" is-hoverable>
    <BaseLevel class="flex flex-col">
      <div class="order-1">meow</div>
      <div>{{props.parameterValue}}</div>
      <!-- <PillTag :color="type" :label="parameterValue.toString()" :icon="pillIcon" class="order-2" /> -->
    </BaseLevel>
  </CardBox>
</template>
