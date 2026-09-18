import { createRouter, createWebHashHistory } from "vue-router";
import Home from "@/views/HomeView.vue";
import MachineLevelPolling from "@/views/MachineLevelPolling.vue";
import MachineLevelSamplingWithLimits from "@/views/MachineLevelSamplingWithLimits.vue";
import AirPressureSamplingView from "@/views/AirPressureSamplingView.vue";
import VibrationSamplingView from "@/views/VibrationSamplingView.vue";
import PlantLevelPollingKpi from "@/views/PlantLevelPollingKpi.vue";
import FactoryPollOverview from "@/views/FactoryPollOverview.vue";
import SparePollOverview from "@/views/SparePollOverview.vue";
import LoginView from "@/views/LoginView.vue"
import PlantLevelPollingParameterOverviewTable from "@/views/PlantLevelPollingParameterOverviewTable.vue";
import PlantLevelSamplingOverview from "@/views/PlantLevelSamplingOverview.vue";
import PlantLevelSamplingComparsion from "@/views/PlantLevelSamplingComparsion.vue";
import ManufacturingInformationSystem from "@/views/ManufacturingInformationSystem.vue";

import ActivityView from "@/views/ActivityView.vue";
import AlarmView from "@/views/AlarmView.vue";
import MachineAnalytics from "@/views/MachineAnalytics.vue";
import MaintenanceAnalytics from "@/views/MaintenanceAnalytics.vue";
import ParameterAnalytics from "@/views/ParameterAnalytics.vue";
import SpareTabulator from "@/views/SpareTabulator.vue";
import SpecialPurposeMachineDetail from "@/views/SpecialPurposeMachineDetail.vue";
import SpecialPurposeMachineDetailPostion from "@/views/SpecialPurposeMachineDetailPostion.vue";
import SpecialPurposeMachine from "@/views/SpecialPurposeMachine.vue";
import ManagerialOverview from "@/views/ManagerialOverview.vue";
import test from "@/views/test.vue";
import Logs from "@/views/Logs.vue";
import GraphicalOverview from "@/views/GraphicalOverview.vue";
import Comparision from "@/views/Comparision.vue";
import SparePartActivityView from "@/views/SparePartActivityView.vue";


const routes = [
  {
    // Document title tag
    // We combine it with defaultDocumentTitle set in `src/main.js` on router.afterEach hook
    meta: {
      title: "Dashboard",
      requiresAuth: true,
    },
    path: "/dashboard",
    name: "dashboard",
    component: Home,
  },
  {
    // Document title tag
    // We combine it with defaultDocumentTitle set in `src/main.js` on router.afterEach hook
    meta: {
      title: "Dashboard",
      requiresAuth: true,
    },
    path: "/spm-overview",
    name: "Spm Overview",
    component: SpecialPurposeMachine,
  },
  {
    // Document title tag
    // We combine it with defaultDocumentTitle set in `src/main.js` on router.afterEach hook
    meta: {
      title: "Dashboard",
      requiresAuth: true,
    },
    path: "/spm-detail",
    name: "Spm Detail",
    component: SpecialPurposeMachineDetail,
  },
  {
    // Document title tag
    // We combine it with defaultDocumentTitle set in `src/main.js` on router.afterEach hook
    meta: {
      title: "Dashboard",
      requiresAuth: true,
    },
    path: "/spm-detail-position",
    name: "Spm Detail Position",
    component: SpecialPurposeMachineDetailPostion,
  },

  {
    // Document title tag
    // We combine it with defaultDocumentTitle set in `src/main.js` on router.afterEach hook
    meta: {
      title: "Dashboard",
      requiresAuth: true,
    },
    path: "/corrective-activity",
    name: "Corrective Activity",
    component: ActivityView,
  },

  {
    // Document title tag
    // We combine it with defaultDocumentTitle set in `src/main.js` on router.afterEach hook
    meta: {
      title: "Dashboard",
      requiresAuth: true,
    },
    path: "/spare-corrective-activity",
    name: "SparePart Corrective Activity",
    component: SparePartActivityView,
  },

  {
    // Document title tag
    // We combine it with defaultDocumentTitle set in `src/main.js` on router.afterEach hook
    meta: {
      title: "SpareView",
      requiresAuth: true,
    },
    path: "/spare-part-detail-view",
    name: "Spare Part Detail View",
    component: SpareTabulator,
  },
  {
    // Document title tag
    // We combine it with defaultDocumentTitle set in `src/main.js` on router.afterEach hook
    meta: {
      title: "Spare Part",
      requiresAuth: true,
    },
    path: "/factory-spare-part",
    name: "Spare Part",
    component: SparePollOverview,
  },
  {
    // Document title tag
    // We combine it with defaultDocumentTitle set in `src/main.js` on router.afterEach hook
    meta: {
      title: "Machine-Polling",
      requiresAuth: true,
    },
    path: "/machine-level-polling",
    name: "Machine Level Polling",
    component: MachineLevelPolling,
  },

  {
    meta: {
      title: "Machine-Sampling",
      requiresAuth: true,
    },
    path: "/alarm-view",
    name: "Alarm View",
    component: AlarmView,
  },
  {
    meta: {
      title: "Machine-Sampling",
      requiresAuth: true,
    },
    path: "/test",
    name: "test View",
    component: test,
  },

  {
    meta: {
      title: "Machine-Sampling",
      requiresAuth: true,
    },
    path: "/machine-level-sampling",
    name: "Machine Level Sampling",
    component: MachineLevelSamplingWithLimits,
  },
  {
    meta: {
      title: "Air-Pressure-Sampling",
      requiresAuth: true,
    },
    path: "/air-pressure-sampling",
    name: "Air Pressure Sampling",
    component: AirPressureSamplingView,
  },
  {
    meta: {
      title: "Vibration-Sampling",
      requiresAuth: true,
    },
    path: "/vibration-sampling",
    name: "Vibration Sampling",
    component: VibrationSamplingView,
  },

  {
    // meta: {
    //   title: "Plant-Polling-Kpi-Overview",
    //   requiresAuth: true,
    // },
    path: "/plant-level-polling/kpi-overview",
    name: "Plant Level Polling Kpi Overview",
    component: PlantLevelPollingKpi,
  },

  {
    meta: {
      title: "Factory-Polling-Parameter-Overview-Grid",
      requiresAuth: true,
    },
    path: "/factory-level-polling/parameter-overview/grid:groupName?",
    name: "Factory Level Polling Parameter Overview Grid",
    component: FactoryPollOverview,
  },
  {
    meta: {
      title: "Plant-Polling-Parameter-Overview-Table",
      requiresAuth: true,
    },
    path: "/plant-level-polling/parameter-overview/table",
    name: "Plant Level Polling parameter Overview Table",
    component: PlantLevelPollingParameterOverviewTable,
  },
  {
    meta: {
      title: "Plant-Sampling-Kpi",
      requiresAuth: true,
    },
    path: "/plant-level-sampling/kpi",
    name: "Plant Level Sampling KPI",
    component: PlantLevelSamplingOverview,
  },
  {
    meta: {
      title: "Plant-Sampling-Comparsion",
      requiresAuth: true,
    },
    path: "/plant-level-sampling/comparsion",
    name: "Plant Level Sampling Comparsion",
    component: PlantLevelSamplingComparsion,
  },
  {
    meta: {
      title: "Manufacturing-Information-System",
      requiresAuth: true,
    },
    path: "/manufacturing-information-system",
    name: "Manufacturing Information System",
    component: ManufacturingInformationSystem,
  },

  {
    meta: {
      title: "Manufacturing-Information-System",
      requiresAuth: true,
    },
    path: "/machine-analytics",
    name: "Machine-Analytics",
    component: MachineAnalytics,
  },

  {
    meta: {
      title: "Manufacturing-Information-System",
      requiresAuth: true,
    },
    path: "/maintenance-analytics",
    name: "Maintenance Analytics",
    component: MaintenanceAnalytics,
  },

  {
    meta: {
      title: "Manufacturing-Information-System",
      requiresAuth: true,
    },
    path: "/parameter-analytics",
    name: "Parameter Analytics",
    component: ParameterAnalytics,
  },
  {
    meta: {
      title: "Manufacturing-Information-System",
      requiresAuth: true,
    },
    path: "/managerialOverview",
    name: "managerial Overview",
    component: ManagerialOverview,
  },
  {
    meta: {
      title: "Manufacturing-Information-System",
      requiresAuth: true,
    },
    path: "/graphicalOverview",
    name: "Graphical Overview",
    component: GraphicalOverview,
  },
  {
    meta: {
      title: "Manufacturing-Information-System",
      requiresAuth: true,
    },
    path: "/parameterComparision",
    name: "Parameter Comparision",
    component: Comparision,
  },
  {
    // Document title tag
    // We combine it with defaultDocumentTitle set in `src/main.js` on router.afterEach hook
    // meta: {
    //   title: "Dashboard",
    //   requiresAuth: true,
    // },
    path: "/Logs",
    name: "Logs",
    component: Logs,
  },

  {
    // // meta: {
    // //   title: "Forms",
    // //   requiresAuth: true,
    // // },
    path: "/forms",
    name: "forms",
    component: () => import("@/views/FormsView.vue"),
  },
  {
    meta: {
      title: "Profile",
      requiresAuth: true,
    },
    path: "/profile",
    name: "profile",
    component: () => import("@/views/ProfileView.vue"),
  },
  {
    meta: {
      title: "Email Users",
      requiresAuth: true,
    },
    path: "/email-users",
    name: "email-users",
    component: () => import("@/views/EmailUserView.vue"),
  },

  {
    meta: {
      title: "Ui",
      
    },
    path: "/ui",
    name: "ui",
    component: () => import("@/views/UiView.vue"),
  },
  {
    meta: {
      title: "Responsive layout",
    },
    path: "/responsive",
    name: "responsive",
    component: () => import("@/views/ResponsiveView.vue"),
  },
  {
    // meta: {
    //   title: "Login",
    // },
    path: "/",
    name: "login",
    component: LoginView,
  },
  {
    meta: {
      title: "Error",
    },
    path: "/error",
    name: "error",
    component: () => import("@/views/ErrorView.vue"),
  },
];

const router = createRouter({
  history: createWebHashHistory(),
  routes,
  scrollBehavior(to, from, savedPosition) {
    return savedPosition || { top: 0 };
  },
});

// Navigation guard to check authentication status before navigating to protected routes
router.beforeEach((to, from, next) => {
  const isAuthenticated = !!localStorage.getItem("token");

  if (to.meta.requiresAuth && !isAuthenticated) {
    // Redirect to the login page if trying to access a protected route without authentication
    // alert("Not authenticated Please Login")
    next("/");
  } else {
    // Proceed to the next route
    next();
  }
});

export default router;