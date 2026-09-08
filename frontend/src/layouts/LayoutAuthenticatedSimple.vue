<script setup>
import { mdiForwardburger, mdiBackburger, mdiMenu, mdiArrowLeft } from "@mdi/js";
import { ref, computed } from "vue";
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
import { useMachineSamplingWithLimitsStore } from '@/stores/MachineSamplingWithLimitsStore';

const samplingStore = useMachineSamplingWithLimitsStore();

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
  || String(route.path || '').includes('air-pressure-sampling')
  || String(route.name || '').toLowerCase().includes('machine level sampling')
  || String(route.name || '').toLowerCase().includes('air pressure sampling')
));

/** Layout back only for air-pressure / honing sampling — not other machines */
const isPressureSamplingPage = computed(() => (
  isMachineLevelSamplingPage.value && (
    !!samplingStore.isPressureContext
    || String(route.path || '').includes('air-pressure-sampling')
    || String(route.name || '').toLowerCase().includes('air pressure sampling')
  )
));

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
      <FooterBar v-if="!isPressureSamplingPage" />
    </div>
  </div>
</template>

