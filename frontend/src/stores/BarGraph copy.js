import { defineStore } from 'pinia';
import { backendApi } from '@/services/apiServices';

export const useBarChart = defineStore('BarChart', {
  
  state: () => ({
    machineData: [],
    selectedDates: {
      from: 98099,
      to: 78909,
    },
    availableMachines: [''],
    
    
  }),
  actions: {
    async fetchMachineData(machineName, startTime, endTime) {
      const url = `/factory/analytics/machines/${machineName}?startTime=${startTime}&endTime=${endTime}`;
      try {
        const response = await backendApi.get(url);
        this.machineData = response.data.data;
        console.log("this is inside the store")
        console.log(machineName)
        return this.machineData;

      } catch (error) {
        console.error('Error fetching machine data:', error);
        throw error;
      }
    },
    async fetchAvailableMachines() { // Add method to fetch available machines
      const url = 'http://172.18.100.87:8000/api/v1/machines';
      try {
        const response = await backendApi.get(url);
        this.availableMachines = response.data; // Access 'data' property to get the list of machines
        console.log("inside the store")
        console.log(this.availableMachines)
      } catch (error) {
        console.error('Error fetching available machines:', error);
        throw error;
      }
    },
  },

});
