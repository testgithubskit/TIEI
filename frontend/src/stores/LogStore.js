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
    },
    MachineNames: [],
    DisconnectionHistory: []
  }),

  actions: {
    async fetchLimitChangeLogs(fromTimestamp,toTimestamp) {
      const url = `/update-logs/by-time?start_time=${fromTimestamp}&end_time=${toTimestamp}`;
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
    },

    async fetchMachineNames() {
      const url = '/machines';
      try {
        const response = await backendApi.get(url);
        this.MachineNames = response.data.data;
        return this.MachineNames;
      } catch (error) {
        console.error('Error fetching machine names:', error);
        throw error;
      }
    },

    async fetchDisconnectionHistory(machineName, fromTimestamp, toTimestamp) {
      const url = `/factory/disconnection_history?l1name=${machineName}&from_timestamp=${fromTimestamp}&to_timestamp=${toTimestamp}`;
      try {
        const response = await backendApi.get(url);
        this.DisconnectionHistory = response.data.history;
        return this.DisconnectionHistory;
      } catch (error) {
        console.error('Error fetching disconnection history:', error);
        throw error;
      }
    }
  },
});