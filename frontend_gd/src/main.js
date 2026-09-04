import { createApp } from "vue";
import { createPinia } from "pinia";

import App from "./App.vue";
import router from "./router";
import { useMainStore } from "@/stores/main.js";
import { useStyleStore } from "@/stores/style.js";
import { darkModeKey, styleKey } from "@/config.js";

import ganttastic from '@infectoone/vue-ganttastic'
import VueTailwindDatepicker from 'vue-tailwind-datepicker'
import PrimeVue from 'primevue/config';
import CanvasJSChart from '@canvasjs/vue-charts';
import Button from "primevue/button"
import Tooltip from 'primevue/tooltip';
import InputText from 'primevue/inputtext';
import Antd from 'ant-design-vue';
// import 'ant-design-vue/dist/antd.css';
import Vue3EasyDataTable from 'vue3-easy-data-table';
import 'vue3-easy-data-table/dist/style.css';

import VTooltip from 'v-tooltip';
// // import 'v-tooltip/dist/v-tooltip.css';

import "./css/main.css";

import 'primevue/resources/themes/aura-light-green/theme.css'
import { library } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import { faCog } from '@fortawesome/free-solid-svg-icons'
// import { library } from '@fortawesome/fontawesome-svg-core'
// import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import { faCheckCircle, faExclamationTriangle, faTimesCircle, faExclamationCircle } from '@fortawesome/free-solid-svg-icons'
import { useNavigationHistoryStore } from '@/stores/navigationHistoryStore';

library.add(faCog)
library.add(faCheckCircle, faExclamationTriangle, faTimesCircle, faExclamationCircle)

/* Init Pinia */
const pinia = createPinia();

/* Create Vue app */
const app = createApp(App);
app.use(router).use(pinia).use(PrimeVue).use(VTooltip).use(Antd).mount("#app");
app.component('Button', Button);
app.directive('tooltip', Tooltip);
app.component('EasyDataTable', Vue3EasyDataTable);
app.component('font-awesome-icon', FontAwesomeIcon);

/* Init Pinia stores */
const mainStore = useMainStore(pinia);
const styleStore = useStyleStore(pinia);

/* Fetch sample data */
console.log("Fetching the clients data")
mainStore.fetch("clients");
mainStore.fetch("history");

/* App style */
styleStore.setStyle(localStorage[styleKey] ?? "basic");

/* Dark mode */
if (
  (!localStorage[darkModeKey] &&
    window.matchMedia("(prefers-color-scheme: dark)").matches) ||
  localStorage[darkModeKey] === "1"
) {
  styleStore.setDarkMode(true);
}

/* Default title tag */
const defaultDocumentTitle = "Dashboard";

/* Set document title from route meta */
router.afterEach((to) => {
  document.title = to.meta?.title
    ? `${to.meta.title} — ${defaultDocumentTitle}`
    : defaultDocumentTitle;
});



// ... other imports and setup

router.beforeEach((to, from, next) => {
  const navigationHistoryStore = useNavigationHistoryStore();
  navigationHistoryStore.addToHistory(from);
  next();
});
