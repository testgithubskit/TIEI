<script setup>
import { ref } from "vue";
import { mdiClose, mdiDotsVertical } from "@mdi/js";
import { containerMaxW } from "@/config.js";
import BaseIcon from "@/components/BaseIcon.vue";
import NavBarMenuList from "@/components/NavBarMenuList.vue";
import NavBarItemPlain from "@/components/NavBarItemPlain.vue";
import CmtiLogo from "@/components/CmtiLogo.vue";

defineProps({
  menu: {
    type: Array,
    required: true,
  },
});

const emit = defineEmits(["menu-click"]);

const menuClick = (event, item) => {
  emit("menu-click", event, item);
};

const isMenuNavBarActive = ref(false);
</script>

<template>
  <nav
    class="top-0 inset-x-0 fixed bg-gray-50 h-14 z-30 transition-position w-screen lg:w-auto dark:bg-slate-800"
  >
    <div class="flex lg:items-stretch" :class="containerMaxW">
      <div class="flex flex-1 items-stretch h-14">
        <slot />
      </div>
      <div class="flex-none items-stretch flex h-14 lg:hidden">
        <NavBarItemPlain
          @click.prevent="isMenuNavBarActive = !isMenuNavBarActive"
        >
          <BaseIcon
            :path="isMenuNavBarActive ? mdiClose : mdiDotsVertical"
            size="24"
          />
        </NavBarItemPlain>
      </div>
      
      <div class="md:py-2">
        <a href="https://cmti.res.in/" target="_blank">
          <CmtiLogo class="w-auto h-8 md:h-6" />
        </a>
      </div>
    </div>
  </nav>
</template>
