import { defineStore } from 'pinia';
import { backendApi } from '@/services/apiServices';

export const useLogStore = defineStore('Logs', {
  state: () => ({
    selectedDates: {
      from: 1719912119000,
      to: 1721985719000,
    },
    User: "",
    LimitChangeData: [],
    DisconnectedMachines: {
      Head: [],
      Block: [],
      Crank: []
    }
  }),

  actions: {
    async fetchLimitChangeLogs() {
      const url = `/update-logs/by-time?start_time=${this.selectedDates.from}&end_time=${this.selectedDates.to}`;
      try {
        const response = await backendApi.get(url);
        this.LimitChangeData = response.data;
        return this.LimitChangeData;
      } catch (error) {
        console.error('Error fetching limit change logs:', error);
        throw error;
      }
    },

    async fetchDisconnectedMachines() {
      const url = 'factory/disconnected_machines';
      try {
        const response = await backendApi.get(url);
        this.DisconnectedMachines = response.data;
        return this.DisconnectedMachines;
      } catch (error) {
        console.error('Error fetching disconnected machines:', error);
        throw error;
      }
    }
  },
});