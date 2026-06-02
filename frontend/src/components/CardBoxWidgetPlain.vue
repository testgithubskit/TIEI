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
    default: "dummyText",
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
</script>

<template>
  <CardBox :class="borderClass">
    <BaseLevel mobile>
      <div >
        <h3 class="text-lg leading-tight text-gray-500 dark:text-slate-400">
          {{ label }}
        </h3>
        <transition 
          name="value-transition"
          mode="out-in"
        >
          <h1 
            :key="parameterValue"
            class="text-3xl leading-tight font-semibold transition-all duration-500 ease-in-out transform"
            :class="{'text-lg': isAnimating}"
            @animationstart="animationStart"
            @animationend="animationEnd"
          >
            {{ parameterValue }}
          </h1>
        </transition>
      </div>
      <BaseIcon
        v-if="icon"
        :path="icon"
        size="48"
        w=""
        h="h-16"
        :class="color"
      />
    </BaseLevel>
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
