import { backendApi } from '@/services/apiServices';
import { defineStore } from 'pinia';


export const usePlantSamplingOverviewStore = defineStore('PlantSamplingOverview', {
  state: () => ({
    SelectedParmeter: {
      name: 'parameter_1',
      availableParameters: ['parameter_1', 'parameter_2', 'parameter_3'],
      selectedDatesDict: {
        from: '07-07-2023 16:09:53',
        to: '07-07-2023 15:09:53'
      }
    },
  }),
  actions: {

    async fetchAndUpdateAvailableParameters() {
  
      const url = `/machines/ams_mcv_450/parameters`;
  
      try {
        const response = await backendApi.get(url);
        const availableParameters = response.data.parameters;
        console.log('Available parameters:', availableParameters);
        this.SelectedParmeter.availableParameters = availableParameters;
        console.log('Set parameters:', this.SelectedParmeter.availableParameters);
      } catch (error) {
        console.error('Error fetching/updating available machines:', error);
        throw error;
      }
    },
  },
});
