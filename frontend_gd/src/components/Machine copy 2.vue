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
    danger: mdiTrendingDown,
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

const borderClass = computed(() => {
  return `mb-6 shadow-lg border-${props.borderSide}-emerald-600 border-${props.borderSide}-${props.borderThickness} hover:shadow-md`;
});

</script>

<template>
  <CardBox :class="borderClass" is-hoverable>
    <BaseLevel>
      <BaseLevel type="justify-center">
        <div class="text-center md:text-left overflow-hidden">
          <h4 class="text-lg truncate">
            {{ label }}
          </h4>
        </div>
      </BaseLevel>
      <PillTag :color="type" :label="parameterValue.toString()" :icon="pillIcon" />
    </BaseLevel>
  </CardBox>
</template>
