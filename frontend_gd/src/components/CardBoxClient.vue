<script setup>
import { computed } from "vue";
import { mdiTrendingDown, mdiTrendingUp, mdiTrendingNeutral } from "@mdi/js";
import CardBox from "@/components/CardBox.vue";
import BaseLevel from "@/components/BaseLevel.vue";
import PillTag from "@/components/PillTag.vue";
import UserAvatar from "@/components/UserAvatar.vue";

const props = defineProps({
  name: {
    type: String,
    required: true,
  },
  login: {
    type: String,
    required: true,
  },
  date: {
    type: String,
    required: true,
  },
  progress: {
    type: Number,
    default: 0,
  },
  text: {
    type: String,
    default: null,
  },
  type: {
    type: String,
    default: null,
  },
  type: {
    type: String,
    default: null,
  },
});

const pillType = computed(() => {
  if (props.type) {
    return props.type;
  }

  if (props.progress) {
    if (props.progress >= 60) {
      return "success";
    }
    if (props.progress >= 40) {
      return "warning";
    }

    return "danger";
  }

  return "info";
});

const pillIcon = computed(() => {
  return {
    success: mdiTrendingUp,
    warning: mdiTrendingNeutral,
    danger: mdiTrendingDown,
    info: null,
  }[pillType.value];
});

const pillText = computed(() => props.text ?? `${props.progress}%`);
</script>

<template>
  <CardBox class="mb-6 last:mb-0 shadow-lg border-s-emerald-600 border-s-4 hover:shadow-md" is-hoverable>
    <BaseLevel>
      <BaseLevel type="justify-center">
        <UserAvatar class="w-10 h-10 mr-6" :username="name" />
        <div class="text-center md:text-left overflow-hidden">
          <h4 class="text-lg text-ellipsis">
            {{ name }}
          </h4>
        </div>
      </BaseLevel>
      <PillTag :color="pillType" :label="pillText" :icon="pillIcon" />
    </BaseLevel>
  </CardBox>
</template>
