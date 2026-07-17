<script setup>
import { mdiForwardburger, mdiBackburger, mdiMenu, mdiArrowLeft } from "@mdi/js";
import { ref, onBeforeMount, computed } from "vue";
import { useRouter, useRoute } from "vue-router";
import menuAside from "@/menuAside.js";
import menuNavBar from "@/menuNavBar.js";
import { useMainStore } from "@/stores/main.js";
import { useStyleStore } from "@/stores/style.js";
import { useNavigationHistoryStore } from "@/stores/navigationHistoryStore";
import BaseIcon from "@/components/BaseIcon.vue";
import FormControl from "@/components/FormControl.vue";
import NavBar from "@/components/NavBar.vue";
import NavBarItemPlain from "@/components/NavBarItemPlain.vue";
import AsideMenu from "@/components/AsideMenu.vue";
import FooterBar from "@/components/FooterBar.vue";
import Database from "@/components/Database.vue";
import { useDatabaseName } from '@/stores/DatabaseName';
import { useMachineSamplingWithLimitsStore } from '@/stores/MachineSamplingWithLimitsStore';

const DatabaseName = useDatabaseName();
const samplingStore = useMachineSamplingWithLimitsStore();

onBeforeMount(async () => {
  await DatabaseName.fetchSchemaName();
});

const currentPlant = computed(() => {
  if (DatabaseName.schemaName === 'tiei_gd_plant_1') return 'GD';
  if (DatabaseName.schemaName === 'tiei_sample_5') return 'TNGA';
  return 'TNGA';
});

function buildPlantGridUrl(plantKey) {
  const host = window.location.hostname || '10.82.126.73';
  const protocol = window.location.protocol || 'http:';
  if (plantKey === 'GD') {
    return `${protocol}//${host}/tiei_dynamic_gd/#/factory-level-polling/parameter-overview/grid`;
  }
  return `${protocol}//${host}/tiei_dynamic/#/factory-level-polling/parameter-overview/grid`;
}

function switchPlant(target) {
  if (!target || target === currentPlant.value) return;
  window.location.assign(buildPlantGridUrl(target));
}

useMainStore().setUser({
  name: "CMTI Admin",
  email: "john@example.com",
  avatar:
    "https://avatars.dicebear.com/api/avataaars/example.svg?options[top][]=shortHair&options[accessoriesChance]=93",
});

const layoutAsidePadding = "xl:pl-0";

const styleStore = useStyleStore();

const router = useRouter();
const route = useRoute();
const navigationHistoryStore = useNavigationHistoryStore();

const isMachineLevelSamplingPage = computed(() => (
  String(route.path || '').includes('machine-level-sampling')
  || String(route.name || '').toLowerCase().includes('machine level sampling')
));

/** Layout back + hide plant toggle only for air-pressure / honing sampling — not other machines */
const isPressureSamplingPage = computed(() => (
  isMachineLevelSamplingPage.value && !!samplingStore.isPressureContext
));

const showPlantToggle = computed(() => !isPressureSamplingPage.value);

const handleSamplingBack = () => {
  const previous = navigationHistoryStore.history.length
    ? navigationHistoryStore.history[navigationHistoryStore.history.length - 1]
    : null;

  const candidate = previous?.fullPath || previous?.path || '';
  const isLoginLike = (
    !candidate
    || candidate === '/'
    || candidate === '/#/'
    || String(candidate).toLowerCase().includes('login')
  );
  const isSelf = candidate.includes('machine-level-sampling');

  if (!isLoginLike && !isSelf) {
    navigationHistoryStore.removeLastRoute();
    router.push(candidate);
    return;
  }

  const params = route.query || {};
  const isPressure = (
    String(params.parameter || '').toLowerCase().includes('pressure')
    || String(params.machine || '').toLowerCase().includes('rough')
    || String(params.machine || '').toLowerCase().includes('finish')
  );
  if (isPressure) {
    router.push('/managerialOverview');
    return;
  }
  router.push('/factory-level-polling/parameter-overview/grid');
};

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
    <div v-if="showPlantToggle" class="plant-toggle-overlay" role="group" aria-label="Plant switch">
      <button
        type="button"
        class="plant-toggle-btn"
        :class="{ 'is-active': currentPlant === 'TNGA' }"
        :disabled="currentPlant === 'TNGA'"
        title="TNGA Plant"
        @click="switchPlant('TNGA')"
      >
        TNGA Plant
      </button>
      <button
        type="button"
        class="plant-toggle-btn"
        :class="{ 'is-active': currentPlant === 'GD' }"
        :disabled="currentPlant === 'GD'"
        title="GD Plant"
        @click="switchPlant('GD')"
      >
        GD Plant
      </button>
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
        <NavBarItemPlain
          v-if="isPressureSamplingPage"
          display="flex"
          @click.prevent="handleSamplingBack"
        >
          <BaseIcon :path="mdiArrowLeft" size="24" class="text-green-600" />
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
.plant-toggle-overlay {
  position: fixed;
  top: 1.25rem;
  left: 50%;
  transform: translateX(-50%);
  background-color: rgba(36, 133, 95, 0.95);
  color: white;
  padding: 3px;
  border-radius: 9999px;
  z-index: 50;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
  display: inline-flex;
  align-items: stretch;
  gap: 2px;
}

.plant-toggle-btn {
  border: none;
  background: transparent;
  color: rgba(255, 255, 255, 0.75);
  padding: 0.35rem 0.9rem;
  border-radius: 9999px;
  font-weight: 800;
  font-size: 0.8rem;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  cursor: pointer;
  line-height: 1.1;
  transition: background 0.15s ease, color 0.15s ease;
  white-space: nowrap;
}

.plant-toggle-btn.is-active {
  background: rgba(255, 255, 255, 0.95);
  color: rgb(22, 101, 52);
  cursor: default;
}

.plant-toggle-btn:not(.is-active):hover {
  background: rgba(255, 255, 255, 0.18);
  color: white;
}

.plant-toggle-btn:disabled {
  cursor: default;
}
</style>
