import {
  mdiAccountCircle,
  mdiMonitor,
  mdiCog,
  mdiEmail,
} from "@mdi/js";

export default [
  {
    icon: mdiMonitor,
    label: "Overview",
    to: "/managerialOverview"
   
  },
  {
    icon: mdiMonitor,
    label: "Maintenance",
    to: "/factory-level-polling/parameter-overview/grid"
   
  },

  {
    icon: mdiMonitor,
    label: "Activity",
    menu: [
      {
        label: "Parameter Activity",
        to: "/corrective-activity",
      },
      {
        label: "SparePart Activity",
        to: "/spare-corrective-activity",
      },
     
    ]

  },

  {
    icon: mdiMonitor,
    
        label: "Comparision",
        to: "/parameterComparision",
  },

  {
    icon: mdiMonitor,
    
        label: "Spare Part",
        to: "/factory-spare-part",
  },

  {
    icon: mdiMonitor,
    
        label: "Alarm Management",
        to: "/alarm-view",
  },
  {
    icon: mdiMonitor,
    label: "SPM",
    to: "/spm-overview",
  },
  // {
  //   icon: mdiMonitor,
  //   label: "SPM",
  //   to: "/spm-detail",
  // },
  // {
  //   icon: mdiMonitor,
    
  //       label: "SPM-Position",
  //       to: "/spm-detail-position",
  // },

  // {
  //   icon: mdiMonitor,
  //   label: "ParitoGraph",
  //   to: "/ParitoGraph",
  // },

  {
    icon: mdiMonitor,
    label: "Analytics",
    menu: [
      {
        label: "Machine Analytics",
        to: "/machine-analytics",
      },
      {
        label: "Parameter Analytics",
        to: "/parameter-analytics",
      },
      {
        label: "Maintenance Analytics",
        to: "/maintenance-analytics",
      },
      // {
      //   label: "Alarm Analytics",
      //   to: "/ParitoGraph",
      // },
    ]
  },

  {
    to: "/Logs",
    label: "Logs",
    icon: mdiAccountCircle,
  },
  
  {
    icon: mdiCog,
    label: "Configuration",
    requiresAdmin: true,
    menu: [
      {
        to: "/profile",
        label: "Users",
        icon: mdiAccountCircle,
        requiresAdmin: true,
      },
      {
        to: "/email-users",
        label: "Email Users",
        icon: mdiEmail,
        requiresAdmin: true,
      }
    ]
  }
];

export function filterMenuByRole(menuItems = [], role = localStorage.getItem('role')) {
  const isAdmin = role === 'admin';
  return menuItems
    .map((item) => {
      if (item.requiresAdmin && !isAdmin) {
        return null;
      }
      if (Array.isArray(item.menu)) {
        const children = item.menu.filter((child) => !child.requiresAdmin || isAdmin);
        if (!children.length) {
          return null;
        }
        return { ...item, menu: children };
      }
      return item;
    })
    .filter(Boolean);
}
