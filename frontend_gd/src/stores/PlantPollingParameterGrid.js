import { backendApi } from '@/services/apiServices';
import { defineStore } from 'pinia';


export const usePlantPollingParameterGridStore = defineStore('PlantPollingParameterGrid', {
  state: () => ({
    SelectedParmeter: {
      name: 'parameter_1',
      availableParameters: ['CYCLE_TIME']
    },
  }),
  actions: {

    async fetchAndUpdateAvailableParameters() {

      const url = `/machines/ams_mcv_450/parameters`;

      try {
        const response = await backendApi.get(url);
        console.log('Backend response:', response.data);
        const availableParameters = response.data.parameters || [];
        console.log('Parameters from backend:', availableParameters);
        // Add CYCLE_TIME to the available parameters if not already present
        if (!availableParameters.includes('CYCLE_TIME')) {
          availableParameters.push('CYCLE_TIME');
        }
        console.log('Available parameters after adding CYCLE_TIME:', availableParameters);
        this.SelectedParmeter.availableParameters = availableParameters;
        console.log('Set parameters in store:', this.SelectedParmeter.availableParameters);
      } catch (error) {
        console.error('Error fetching/updating available machines:', error);
        // Keep CYCLE_TIME even if API fails
        if (!this.SelectedParmeter.availableParameters.includes('CYCLE_TIME')) {
          this.SelectedParmeter.availableParameters.push('CYCLE_TIME');
        }
      }
    },
  },
});
