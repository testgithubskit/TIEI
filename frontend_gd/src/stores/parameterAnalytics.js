import { defineStore } from 'pinia';
import { backendApi } from '@/services/apiServices';
import dayjs from 'dayjs';

export const useParameterAnalytics = defineStore('ParameterAnalytics', {
  state: () => ({
    ParameterData: [],
    availableParameters: [],
    selectedParameter: "",
    parameterGroup: "", // Add this line
    selectedDates: {
      from: dayjs().subtract(24, 'hour').valueOf(),
      to: dayjs().valueOf(),
    },
    isLoading: false,
    error: null,
  }),

  actions: {
    async fetchParameterData() {
      this.isLoading = true;
      this.error = null;
      const url = `/factory/analytics/machines/${this.parameterGroup}?startTime=${this.selectedDates.from}&endTime=${this.selectedDates.to}`;
      try {
        const response = await backendApi.get(url);
        this.ParameterData = response.data.data;
      } catch (error) {
        console.error('Error fetching parameter data:', error);
        this.error = 'Failed to fetch parameter data';
        throw error;
      } finally {
        this.isLoading = false;
      }
    },

    async fetchAvailableParameters() {
      this.isLoading = true;
      this.error = null;
      const url = '/parameter_groups';
      try {
        const response = await backendApi.get(url);
        this.availableParameters = response.data.data;
        if (this.availableParameters.length > 0 && !this.selectedParameter) {
          this.setSelectedParameter(this.availableParameters[0]);
        }
      } catch (error) {
        console.error('Error fetching available parameters:', error);
        this.error = 'Failed to fetch available parameters';
        throw error;
      } finally {
        this.isLoading = false;
      }
    },

    setSelectedParameter(parameter) {
      this.selectedParameter = parameter;
      this.parameterGroup = parameter; // Add this line
    },

    setDateRange(from, to) {
      this.selectedDates.from = from;
      this.selectedDates.to = to;
    },
  },
});
