import { defineStore } from 'pinia';

export const useNavigationHistoryStore = defineStore('navigationHistory', {
  state: () => ({
    history: [],
  }),
  actions: {
    addToHistory(route) {
      this.history.push(route);
      console.log("Added to history:", route);
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
