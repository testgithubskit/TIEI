import { defineStore } from 'pinia';

export const useNavigationHistoryStore = defineStore('navigationHistory', {
  state: () => ({
    history: [],
  }),
  actions: {
    addToHistory(route) {
      // Store a plain snapshot — reactive RouteLocation can become unusable / point to "/"
      const snapshot = {
        path: route?.path || '',
        fullPath: route?.fullPath || route?.path || '',
        name: route?.name || null,
      };
      if (!snapshot.path || snapshot.path === '/' || String(snapshot.path).toLowerCase().includes('login')) {
        console.warn('Skipped adding login/root route to history:', snapshot);
        return;
      }
      this.history.push(snapshot);
      console.log("Added to history:", snapshot);
    },
    getPreviousRoute() {
      const previousRoute = this.history.length > 1 ? this.history[this.history.length - 2] : null;
      console.log("Getting previous route:", previousRoute);
      return previousRoute;
    },
    removeLastRoute() {
      const removedRoute = this.history.pop();
      console.log("Removed last route:", removedRoute);
    },
    clearHistory() {
      this.history = [];
      console.log("Cleared history");
    },
  },
});
