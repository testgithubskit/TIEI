<script setup>
import { computed, ref } from 'vue'
import { mdiCog } from "@mdi/js"
import CardBox from "@/components/CardBox.vue"
import NumberDynamic from "@/components/NumberDynamic.vue"
import BaseIcon from "@/components/BaseIcon.vue"
import BaseLevel from "@/components/BaseLevel.vue"
import PillTagTrend from "@/components/PillTagTrend.vue"
import BaseButton from "@/components/BaseButton.vue"

const props = defineProps({
  icon: {
    type: String,
    default: null,
  },
  label: {
    type: String,
    default: "label",
  },
  color: {
    type: String,
    default: "text-emerald-500",
  },
  parameterValue: {
    type: String,
    default: null,
  },
  borderSide:{
    type: String,
    default: "t"
  },
  borderThickness:{
    type: String,
    default: "8"
  }
})

const isAnimating = ref(false)

function animationStart() {
  isAnimating.value = true
}

function animationEnd() {
  isAnimating.value = false
}

const borderClass= computed(() => {
  return `border border-${props.borderSide}-emerald-600 border-${props.borderSide}-${props.borderThickness} hover:shadow-md transition-shadow duration-10`;
});

function replaceUnderscores(inputString) {
  if (inputString !== null){
    return inputString.replace(/_/g, ' ');
  }
  
}

</script>

<template>
  <CardBox :class="borderClass">
    <div class="overflow-hidden">
      <h3 class="text-sm leading-tight text-gray-500 dark:text-slate-400">
        {{ label }}
      </h3>
      <h1 
        :key="parameterValue"
        class="text-1xl leading-tight font-semibold transition-all duration-500 ease-in-out transform break-words"
        :class="{'text-lg': isAnimating}"
        @animationstart="animationStart"
        @animationend="animationEnd"
      >
        {{ replaceUnderscores(parameterValue) }}
      </h1>
      <slot></slot>
    </div>
    <BaseIcon
      v-if="icon"
      :path="icon"
      size="48"
      w=""
      h="h-16"
      :class="color"
    />
  </CardBox>
</template>

<style scoped>

.value-transition-enter-active,
.value-transition-leave-active {
  transition: all .5s;
}
.value-transition-enter-from,
.value-transition-leave-to {
  opacity: 0;
  transform: scale(0.9);
}
.value-transition-enter-to,
.value-transition-leave-from {
  opacity: 1;
  transform: scale(1);
}
</style>
