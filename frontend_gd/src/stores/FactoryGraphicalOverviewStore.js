// src/stores/FactoryOverviewStore.js
import { defineStore } from 'pinia';
import { backendApi } from '@/services/apiServices';

export const useFactoryOverviewStore = defineStore('factoryOverview', {
  state: () => ({
    formattedOverviewData: {
      lines: []
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
        this.formattedOverviewData = response.data;
      } catch (error) {
        console.error('Error fetching data:', error);
        this.error = 'Failed to fetch data. Please try again later.';
        this.formattedOverviewData = { lines: [] };
      } finally {
        this.isLoading = false;
      }
    }
  }
});