<script setup>
import { computed } from "vue";
import { mdiTrendingDown, mdiTrendingUp, mdiTrendingNeutral } from "@mdi/js";
import CardBox from "@/components/CardBox.vue";
import BaseLevel from "@/components/BaseLevel.vue";
import PillTag from "@/components/PillTag.vue";

const props = defineProps({
  icon: {
    type: String,
    default: null,
  },
  type: {
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
  borderSide:{
    type: String,
    default: "s"
  },
  borderThickness:{
    type: String,
    default: "4"
  },
  state: {
    type: String,
    default: null,
  }
});

const pillIcon = computed(() => {
  return {
    success: mdiTrendingUp,
    warning: mdiTrendingNeutral,
    danger: mdiTrendingDown,
    info: null,
  }["success"];
});

const borderColor = computed(() => {
  return {
    OK: "emerald-600",
    WARNING: "emerald-600",
    CRITICAL: "emerald-600",
  }[props.state];
});

const borderClass = computed(() => {
  return `mb-6 shadow-lg border-${props.borderSide}-${borderColor.value} border-${props.borderSide}-${props.borderThickness} hover:shadow-md`;
});

</script>

<template>
  <CardBox :class="borderClass" is-hoverable>
    <BaseLevel>
      <BaseLevel type="justify-center">
        <!-- <UserAvatar class="w-10 h-10 mr-6" :username="label" /> -->
        <div class="text-center md:text-left overflow-hidden">
          <h4 class="text-lg text-ellipsis">
            {{ label }}
          </h4>
        </div>
      </BaseLevel>
      <PillTag color="success" :label="parameterValue.toString()" :icon="pillIcon" />
    </BaseLevel>
  </CardBox>
</template>
