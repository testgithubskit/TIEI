import { defineStore } from 'pinia';
import { backendApi } from '@/services/apiServices';

export const useSpecialPurposeMachineOverview = defineStore('SpecialPurposeMachineOverview', {
  state: () => ({
    SpmMachines: [
      { machineName: 'Laser Cladding A', status: 'OK' },
      { machineName: 'JOURNAL FINISH-GRINDING_JOP_105', status: 'OK' },
      { machineName: 'JOURNAL FINISH-GRINDING_JOP_130', status: 'CRITICAL' },
      { machineName: 'JOURNAL FINISH-GRINDING_JOP_140', status: 'CRITICAL' },
      { machineName: 'Laser Cladding B', status: 'OK' },
    ],
    selectedMachine: '' // Add selectedMachine property
  }),
  actions: {
    async fetchMachineParameterList() {
      const url = `/machine-parameters-with-states?machineName=${this.selectedMachine}`;

      try {
        const response = await backendApi.get(url);
        const responseData = response.data;
        this.availableParameters = responseData.data;
      } catch (error) {
        console.error('Error Fetching Data:', error);
        // Set the alert message for failure
        this.alertMessage = 'Fetching Failed. Please try again.';
        this.isSuccessMessage = false;
        this.seriesData = {};
      } finally {
        // Set a timer to clear the alert after a few seconds
        setTimeout(() => {
          this.alertMessage = '';
        }, 5000);
      }
    },
    setSelectedMachine(machineName) { // Add method to set selected machine
      this.selectedMachine = machineName;
    },

    async updateSpmMachines() {
      try {
        const response = await backendApi.get('/SPMmachines_2');
        const responseData = response.data;
        this.SpmMachines = responseData; // Update SpmMachines with data from the endpoint
      } catch (error) {
        console.error('Error Updating SpmMachines:', error);
        // Handle error if needed
      }
    },
  }
});
