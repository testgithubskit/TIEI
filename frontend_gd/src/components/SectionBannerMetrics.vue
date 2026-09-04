<script setup>
import { mdiGithub } from "@mdi/js";
import BaseButton from "@/components/BaseButton.vue";
import SectionBanner from "@/components/SectionBanner.vue";
import { gradientBgPinkRed } from "@/colors";
</script>

<template>
  <SectionBanner :class="gradientBgPinkRed" class="h-24 my-10 shadow-xl font-semibold">
    <h1 class="text-3xl text-white">
      Energy Metrics
    </h1>
  </SectionBanner>
</template>
