// src/stores/factoryOverviewStore.js
import { defineStore } from 'pinia';
import { backendApi } from '@/services/apiServices';

export const useFactoryOverviewStore = defineStore('factoryOverview', {
  state: () => ({
    rawData: [],
    formattedOverviewData: {
      lines: [],
      machines: []
    },
    isLoading: false,
    error: null
  }),

  actions: {
    async fetchAndFormatData() {
      this.isLoading = true;
      this.error = null;
      try {
        const response = await backendApi.get('/factory/new_layout_mtlinki');
        this.rawData = response.data.lines;
        this.formatOverviewData();
      } catch (error) {
        console.error('Error fetching data:', error);
        this.error = 'Failed to fetch data. Please try again later.';
        this.rawData = [];
        this.formattedOverviewData = { lines: [], machines: [] };
      } finally {
        this.isLoading = false;
      }
    },

    formatOverviewData() {
      const machinesSet = new Set();

      this.formattedOverviewData.lines = this.rawData.map(line => {
        line.machines.forEach(machine => machinesSet.add(machine));
        return line;
      });

      this.formattedOverviewData.machines = Array.from(machinesSet);
    },

    getAbnormalParametersForMachine(machineName) {
      const machine = this.formattedOverviewData.machines.find(m => m.machine_name === machineName);
      return machine ? machine.parameters.filter(p => p.parameter_state !== 'OK') : [];
    }
  }
});