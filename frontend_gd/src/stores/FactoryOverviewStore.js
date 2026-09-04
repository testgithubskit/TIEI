// src/stores/factoryOverviewStore.js
import { defineStore } from 'pinia';
import { backendApi } from '@/services/apiServices';

const FACTORY_OVERVIEW_CACHE_KEY = 'managerialOverview:lastSuccessfulResponse';

const readCachedOverview = () => {
  try {
    return JSON.parse(sessionStorage.getItem(FACTORY_OVERVIEW_CACHE_KEY) || 'null');
  } catch {
    return null;
  }
};

export const useFactoryOverviewStore = defineStore('factoryOverview', {
  state: () => {
    const cached = readCachedOverview();
    return {
      rawData: cached?.rawData || [],
      formattedOverviewData: cached?.formattedOverviewData || {
        lines: [],
        machines: []
      },
      isLoading: false,
      lastUpdatedAt: cached?.lastUpdatedAt || null,
      error: null
    };
  },

  actions: {
    async fetchAndFormatData() {
      // Prevent overlapping requests when polling is faster than the endpoint.
      if (this.isLoading) return false;

      this.isLoading = true;
      this.error = null;
      try {
        const response = await backendApi.get('/factory/new_layout_mtlinki');
        this.rawData = response.data.lines;
        this.formatOverviewData();
        this.lastUpdatedAt = Date.now();
        try {
          sessionStorage.setItem(FACTORY_OVERVIEW_CACHE_KEY, JSON.stringify({
            rawData: this.rawData,
            formattedOverviewData: this.formattedOverviewData,
            lastUpdatedAt: this.lastUpdatedAt
          }));
        } catch {
          // Continue with the in-memory cache if browser storage is unavailable.
        }
        return true;
      } catch (error) {
        console.error('Error fetching data:', error);
        this.error = 'Failed to fetch data. Please try again later.';
        // Preserve the last successful response while a refresh fails.
        return false;
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