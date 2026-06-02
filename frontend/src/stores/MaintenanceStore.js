import { defineStore } from 'pinia';
import { backendApi } from '@/services/apiServices';
import dayjs from 'dayjs';

export const useMaintenanceAnalyticsStore = defineStore('MaintenanceAnalytics', {
  state: () => ({
    maintenanceData: [],
    selectedDates: {
      from: dayjs().subtract(24, 'hour').valueOf(),
      to: dayjs().valueOf(),
    },
    isLoading: false,
    error: null,
  }),

  actions: {
    async fetchMaintenanceData() {
      this.isLoading = true;
      this.error = null;
      const url = `/factory/analytics/operators?startTime=${this.selectedDates.from}&endTime=${this.selectedDates.to}`;
      try {
        const response = await backendApi.get(url);
        this.maintenanceData = response.data.data;
      } catch (error) {
        console.error('Error fetching maintenance data:', error);
        this.error = 'Failed to fetch maintenance data';
        throw error;
      } finally {
        this.isLoading = false;
      }
    },

    setDateRange(from, to) {
      this.selectedDates.from = from;
      this.selectedDates.to = to;
    },
  },
});
