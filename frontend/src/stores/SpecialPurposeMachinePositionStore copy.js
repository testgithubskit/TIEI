import { defineStore } from 'pinia';

import { backendApi } from '@/services/apiServices';

function subtractHours(date, hours) {
  date.setHours(date.getHours() - hours);
  return date;
}

export const useSpecialPurposeMachinePositionStore = defineStore('SpecialPurposeMachinePosition', {
  state: () => ({
    machine: 'Laser Cladding A',

    
    selectedDates: {
      from: 1703058029000,
      to: 1703234429000,
    },
    availableParameters: [
    {'name': 'temperature', 'item_state': 'OK'},
    {'name': 'pressure', 'item_state': 'WARNING'},
    {'name': 'temperature1', 'item_state': 'OK'},
    {'name': 'pressure1', 'item_state': 'WARNING'},
    {'name': 'temperature2', 'item_state': 'OK'},
    {'name': 'pressure3', 'item_state': 'WARNING'}],

    seriesData: {},
    
    selectedParameters: [],
    selectedParts: [], 
    warningLimit: 100,
    criticalLimit: 300,
    alertMessage: '', // New property for alert message
    isSuccessMessage: false,
    hoverData: {
      "xAxisLabel": "Timestamp",
      "xAxisValue": "2024-01-02",
      "yAxisLabel": "Temperature",
      "yAxisValue": 60,
      "xAxisUnits": "DateTime",
      "yAxisUnits": "'c"
    }
  }),
  actions: {
    handleSearch(){

    },






// Function to update selected parts when the user submits
updateSelectedParts(parts) {
  this.selectedParts = parts;
},

    setSelectedParameters(parameters) {
      this.selectedParameters = parameters;
    },
    setSelectedMachine(machine) {
      this.machine = machine;
    },
    refreshTimestamp() {
      const currentTimestamp = Date.now();
      const oneHourAgo = subtractHours(new Date(currentTimestamp), 1).getTime();
      this.selectedDates = {
        from: oneHourAgo,
        to: currentTimestamp,
      };
    },
    async fetchMachineParameterData() {
      try {
        const partPromises = this.selectedParts.map(async part => {
          const parameterPromises = this.selectedParameters.map(async param => {
            const url = `/spm/laser/${this.machine}/real-time?part_number=${part}&parameter_name=${param}`;
            const response = await backendApi.get(url);
            return { parameter: param, data: response.data };
          });
          const parameterData = await Promise.all(parameterPromises);
          return { part: part, parameters: parameterData };
        });
        const partData = await Promise.all(partPromises);
    
        const updatedSeriesData = partData.map(part => {
          const partObject = {
            Partname: part.part,
            Parameters: part.parameters.map(parameter => ({
              ParameterName: parameter.parameter,
              Data: parameter.data
            }))
          };
          return partObject;
        });
    
        console.log("Updated Series Data:");
        console.log(updatedSeriesData);
    
        this.seriesData = updatedSeriesData;
    
        // Set the alert message for success
        this.alertMessage = 'Fetched Data';
        this.isSuccessMessage = true;
      } catch (error) {
        console.error('Error Fetching Data:', error);
    
        // Set the alert message for failure
        this.alertMessage = 'Fetching Failed. Please try again.';
        this.isSuccessMessage = false;
        this.seriesData = [];
      } finally {
        // Set a timer to clear the alert after a few seconds
        setTimeout(() => {
          this.alertMessage = '';
        }, 5000);
      }
    },
    async fetchMachineParameterList() {
      const url = `/machine-parameters-with-states?machineName=${this.machine}`;

      try {
        const response = await backendApi.get(url);
        const responseData = response.data;

        this.availableParameters = responseData.data;

      } catch (error) {
        console.error('Error Fetching Data:', error);

        // Set the alert message for failure
        this.alertMessage = 'Fetching Failed failed. Please try again.';
        this.isSuccessMessage = false;
        this.seriesData = [[0, 0]];
        this.warningLimit = 0;
        this.criticalLimit = 0;
      } finally {
        // Set a timer to clear the alert after a few seconds
        setTimeout(() => {
          this.alertMessage = '';
        }, 5000);
      }
    },
    
    async updateLimits(setType, limitValue = null, append = null, referenceSignal = null) {
      const url = `/factory/${this.parameterGroup}/${this.machine}/${this.actualParameterName}/`;
      let queryParams = {
        setType: setType,
        limit: limitValue
      };
      let requestBody;
      // Conditionally include the requestBody if referenceSignal is not null
      if (append !== null) {
        queryParams.append = append;
      }// Conditionally include the requestBody if referenceSignal is not null

      if (referenceSignal !== null) {
        requestBody = referenceSignal;
      }else{
        requestBody = [0];
      }
      console.log(queryParams);

      try {
        const response = await backendApi.put(url,requestBody, { params: queryParams});
        const responseData = response.data;

        // Handle success
        console.log('Update Limits Response:', responseData);

        // Set the alert message for success
        this.alertMessage = 'Limits updated successfully';
        if (setType == "warning_limit"){
          this.warningLimit = limitValue;
        }else if (setType == "critical_limit"){
          this.criticalLimit = limitValue;
        }

        this.isSuccessMessage = true;

      } catch (error) {
        console.error('Error updating limits:', error);

        // Set the alert message for failure
        this.alertMessage = 'Update failed. Please try again.';
        this.isSuccessMessage = false;
      } finally {
        // Set a timer to clear the alert after a few seconds
        setTimeout(() => {
          this.alertMessage = '';
        }, 5000);
      }
    },
  },
});
