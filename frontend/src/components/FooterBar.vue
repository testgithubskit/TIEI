<script setup>
import { containerMaxW } from "@/config.js";
import BaseLevel from "@/components/BaseLevel.vue";
import JustboilLogo from "@/components/JustboilLogo.vue";
import CmtiLogo from "@/components/CmtiLogo.vue";

const year = new Date().getFullYear();
</script>

<template>
  <footer class="py-2 px-6" :class="containerMaxW">
    <BaseLevel>
      <div class="text-center md:text-left">
        <b
          >&copy;{{ year }},
          <a href="https://cmti.res.in/" target="_blank">cmti.res.in</a>.</b
        >
        <slot />
      </div>
      <div class="md:py-2">
        <a href="https://cmti.res.in/" target="_blank">
          <CmtiLogo class="w-auto h-8 md:h-6" />
        </a>
      </div>
    </BaseLevel>
  </footer>
</template>
