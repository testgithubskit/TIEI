<script setup>
import { ref } from 'vue'
import BaseIcon from "@/components/BaseIcon.vue"

const props = defineProps({
  label: {
    type: String,
    required: true,
  },
  icon: {
    type: String,
    default: null,
  },
  small: Boolean,
})

const isAnimating = ref(false)

function animationStart() {
  isAnimating.value = true
}

function animationEnd() {
  isAnimating.value = false
}
</script>

<template>
  <div
    class="inline-flex items-center capitalize leading-none"
    :class="[small ? 'text-xs' : 'text-sm']"
  >
    <transition 
      name="label-transition"
      mode="out-in"
    >
      <span 
        :key="label"
        class="transition-all duration-500 ease-in-out transform"
        :class="{'text-lg': isAnimating}"
        @animationstart="animationStart"
        @animationend="animationEnd"
      >
        {{ label }}
      </span>
    </transition>
  </div>
</template>

<style scoped>
.label-transition-enter-active,
.label-transition-leave-active {
  transition: all .5s;
}
.label-transition-enter-from,
.label-transition-leave-to {
  opacity: 0;
  transform: scale(0.9);
}
.label-transition-enter-to,
.label-transition-leave-from {
  opacity: 1;
  transform: scale(1);
}
</style>
