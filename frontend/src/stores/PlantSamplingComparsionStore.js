import { defineStore } from 'pinia';
import axios from 'axios';


function subtractHours(date, hours) {
  date.setHours(date.getHours() - hours);

  return date;
}

export const usePlantSamplingComparsionStore = defineStore('PlantSamplingComparsion', {
  state: () => ({
    selectedMachines: {
      names: ['Machine 1'],
      parameters: {
        SelectedParmeter: "Parameter 1",
        availableParameters: ['Parameter 1', 'Parameter 2', 'Parameter 3']
      },
      selectedDatesDict: {
        from: '07-07-2023 16:09:53',
        to: '07-07-2023 15:09:53'
      }
    },
    availableMachines: ['Machine 1', 'Machine 2', 'Machine 3'],
  }),
  actions: {

    async fetchAndUpdateAvailableMachines() {
      const url = 'http://172.18.100.87:8000/api/v1/machines/';
      console.log("from actions");
      try {
        console.log(1);
        const response = await axios.get(url);
        console.log(2);
        const machines = response.data.machines;
        console.log('Available machines:', machines);
        this.availableMachines= machines;
        console.log(this.availableMachines);
        console.log(3);
        return machines;
      } catch (error) {
        console.error('Error fetching/ updating available machines:', error);
        throw error;
      }
    },

    async fetchAndUpdateAvailableParameters() {
      const machineName = this.selectedMachines.names[0];
  
      const url = `http://172.18.100.87:8000/api/v1/machines/${machineName}/parameters`;
  
      try {
        const response = await axios.get(url);
        const availableParameters = response.data.parameters;
        console.log('Available parameters:', availableParameters);
        this.selectedMachines.parameters.availableParameters = availableParameters;
        console.log('Set parameters:', this.selectedMachines.parameters.availableParameters);
      } catch (error) {
        console.error('Error fetching/updating available machines:', error);
        throw error;
      }
    },

    setSelectedMachine(machine) {
      this.selectedMachine.name = machine;
    }
  },
});
