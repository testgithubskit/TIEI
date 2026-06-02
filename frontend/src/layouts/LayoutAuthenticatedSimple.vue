<script setup>
import { mdiForwardburger, mdiBackburger, mdiMenu } from "@mdi/js";
import { ref, onBeforeMount, computed } from "vue";
import { useRouter } from "vue-router";
import menuAside from "@/menuAside.js";
import menuNavBar from "@/menuNavBar.js";
import { useMainStore } from "@/stores/main.js";
import { useStyleStore } from "@/stores/style.js";
import BaseIcon from "@/components/BaseIcon.vue";
import FormControl from "@/components/FormControl.vue";
import NavBar from "@/components/NavBar.vue";
import NavBarItemPlain from "@/components/NavBarItemPlain.vue";
import AsideMenu from "@/components/AsideMenu.vue";
import FooterBar from "@/components/FooterBar.vue";
import Database from "@/components/Database.vue";
import { useDatabaseName } from '@/stores/DatabaseName';
import { Tooltip } from 'ant-design-vue';
import { RightCircleOutlined } from '@ant-design/icons-vue';

// ... existing code ...

const DatabaseName = useDatabaseName();
const plantName = ref('');

onBeforeMount(async () => {
  await DatabaseName.fetchSchemaName();
  plantName.value = computed(() => {
    if (DatabaseName.schemaName === "tiei_gd_plant_1") {
      return "GD PLANT";
    } else if (DatabaseName.schemaName === "tiei_sample_4") {
      return "TNGA PLANT";
    } else {
      return "Unknown Plant";
    }
  }).value;
});

// Compute the button text and link based on the schema name
const dashboardButton = computed(() => {
  if (DatabaseName.schemaName === "tiei_gd_plant_1") {
    return {
      text: "Open TNGA Dashboard",
      link: "http://10.82.126.73/tiei_dynamic/#/factory-level-polling/parameter-overview/grid"
    };
  } else if (DatabaseName.schemaName === "tiei_sample_4") {
    return {
      text: "Open GD Dashboard",
      link: "http://10.82.126.73/tiei_dynamic_gd/#/factory-level-polling/parameter-overview/grid"
    };
  } else {
    return {
      text: "Open Dashboard",
      link: "https://localhost:5173/tiei_dynamic/"
    };
  }
});

useMainStore().setUser({
  name: "CMTI Admin",
  email: "john@example.com",
  avatar:
    "https://avatars.dicebear.com/api/avataaars/example.svg?options[top][]=shortHair&options[accessoriesChance]=93",
});

const layoutAsidePadding = "xl:pl-0";

const styleStore = useStyleStore();

const router = useRouter();

const isAsideMobileExpanded = ref(false);
const isAsideLgActive = ref(false);

router.beforeEach(() => {
  isAsideMobileExpanded.value = false;
  isAsideLgActive.value = false;
});

const menuClick = (event, item) => {
  if (item.isToggleLightDark) {
    styleStore.setDarkMode();
  }
  if (item.label == "Logout"){
    console.log("yesssssssssssssssss")
    console.log("Logged out")
    localStorage.removeItem("token");
    // Redirect to the login page
     router.push("/");
  }
};
</script>

<template>
  <div
    :class="{
      dark: styleStore.darkMode,
      'overflow-hidden lg:overflow-visible': isAsideMobileExpanded,
    }"
  >
    <!-- Plant Name and Dashboard Button Overlay -->
    <div class="plant-name-overlay">
      <span>{{ plantName }}</span>
      <Tooltip :title="dashboardButton.text">
        <a
          :href="dashboardButton.link"
          target="_blank"
          rel="noopener noreferrer"
          class="dashboard-button"
        >
          {{ dashboardButton.text }}
          <RightCircleOutlined class="ml-2" />
        </a>
      </Tooltip>
    </div>
    

    <div
      :class="[layoutAsidePadding, { 'ml-60 lg:ml-0': isAsideMobileExpanded }]"
      class="min-h-screen w-screen transition-position lg:w-auto bg-gray-50 dark:bg-slate-800 dark:text-slate-100"
    >
      <NavBar
        :menu="menuNavBar"
        :class="[
          layoutAsidePadding,
          { 'ml-60 lg:ml-0': isAsideMobileExpanded },
        ]"
        @menu-click="menuClick"
      >
        <NavBarItemPlain
          display="flex lg:hidden"
          @click.prevent="isAsideMobileExpanded = !isAsideMobileExpanded"
        >
          <BaseIcon
            :path="isAsideMobileExpanded ? mdiBackburger : mdiForwardburger"
            size="24"
          />
        </NavBarItemPlain>
        <NavBarItemPlain
          display="hidden lg:flex"
          @click.prevent="isAsideLgActive = true"
        >
          <BaseIcon :path="mdiMenu" size="24" />
        </NavBarItemPlain>
      </NavBar>
      <AsideMenu
        :is-aside-mobile-expanded="isAsideMobileExpanded"
        :is-aside-lg-active="isAsideLgActive"
        :menu="menuAside"
        @menu-click="menuClick"
        @aside-lg-close-click="isAsideLgActive = false"
      />
      <slot />
      <FooterBar />
    </div>
  </div>
</template>

<style scoped>
.plant-name-overlay {
  position: fixed;
  top: 1.5rem;
  left: 50%;
  transform: translateX(-50%);
  background-color: rgba(36, 133, 95, 0.9); /* Blue with 90% opacity */
  color: white;
  padding: 0.25rem 1rem;
  border-radius: 9999px;
  font-weight: bold;
  font-size: 0.875rem;
  z-index: 50;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  display: flex;
  align-items: center;
  gap: 1rem;
}

.dashboard-button {
  background-color: rgba(255, 255, 255, 0.2);
  color: white;
  padding: 0.25rem 0.75rem;
  border-radius: 9999px;
  font-size: 0.75rem;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
}

.dashboard-button:hover {
  background-color: rgba(255, 255, 255, 0.3);
  transform: scale(1.05);
}
</style>
