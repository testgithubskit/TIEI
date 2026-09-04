import { defineStore } from 'pinia';
import { backendApi } from '@/services/apiServices';
import dayjs from 'dayjs';

export const useBarChartStore = defineStore('BarChart', {
  state: () => ({
    machineData: [],
    availableMachines: [],
    selectedMachine: "",
    selectedDates: {
      from: dayjs().subtract(24, 'hour').valueOf(),
      to: dayjs().valueOf(),
    },
    isLoading: false,
    error: null,
  }),

  actions: {
    async fetchMachineData() {
      this.isLoading = true;
      this.error = null;
      const url = `/factory/analytics/machines/${this.selectedMachine}?startTime=${this.selectedDates.from}&endTime=${this.selectedDates.to}`;
      try {
        const response = await backendApi.get(url);
        this.machineData = response.data.data;
      } catch (error) {
        console.error('Error fetching machine data:', error);
        this.error = 'Failed to fetch machine data';
        throw error;
      } finally {
        this.isLoading = false;
      }
    },

    async fetchAvailableMachines() {
      this.isLoading = true;
      this.error = null;
      const url = '/machines';
      try {
        const response = await backendApi.get(url);
        this.availableMachines = response.data.data;
        if (this.availableMachines.length > 0 && !this.selectedMachine) {
          this.selectedMachine = this.availableMachines[0];
        }
      } catch (error) {
        console.error('Error fetching available machines:', error);
        this.error = 'Failed to fetch available machines';
        throw error;
      } finally {
        this.isLoading = false;
      }
    },

    setSelectedMachine(machine) {
      this.selectedMachine = machine;
    },

    setDateRange(from, to) {
      this.selectedDates.from = from;
      this.selectedDates.to = to;
    },
  },
});
