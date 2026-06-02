import { defineStore } from 'pinia';
import { backendApi } from '@/services/apiServices';

export const useMaintenanceAnalytics = defineStore('MaintenanceAnalytics', {
  state: () => ({
    MaintenanceAnalytics: [],
    availableMaintenances: ["T_H_OP100B", "T_H_OP100"],
    selectedMaintenance: "T_H_OP100B",
    selectedDates: {
      from: 1703058029000,
      to: 1703234429000,
    },
  }),

  actions: {
    async fetchMaintenanceAnalytics() {
      const url = `/factory/analytics/machines/${this.selectedMaintenance}?startTime=${this.selectedDates.from}&endTime=${this.selectedDates.to}`;
      try {
        const response = await backendApi.get(url);
        this.MaintenanceAnalytics = response.data.data; 
        console.log("Fetched Machine Data");
        console.log(this.MaintenanceAnalytics);

      } catch (error) {
        console.error('Error fetching machine data:', error);
        throw error;
      }
    },

    async fetchAvailableMaintenances() {
      const url = '/maintenance-operators'; // Use the new URL

      try {
        const response = await backendApi.get(url);
        this.availableMaintenances = response.data.data.username; // Update availableMachines state
      } catch (error) {
        console.error('Error fetching available machines:', error);
        throw error;
      }
    }
  },
});
