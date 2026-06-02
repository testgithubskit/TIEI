import { defineStore } from 'pinia';

import { backendApi } from '@/services/apiServices';

function subtractHours(date, hours) {
  date.setHours(date.getHours() - hours);
  return date;
}

export const useMachineSamplingWithLimitsStore = defineStore('machineSamplingWithLimits', {
  state: () => ({
    machine: 'T_H_OP150',
    parameterGroup: '',
    displayName: 'X',
    actualParameterName: 'ApcBatLow0Path1THOP150',
    selectedDates: {
      from: 1703058029000,
      to: 1703234429000,
    },
    chartData: [
      [1685162998000, 50], // Epoch timestamp and value
      [1685162998000 + 86400000, 75],
      [1685162998000 + 86400000 + 86400000, 100],
      [1685162998000 + 86400000 + 86400000 + 86400000, 200],
    ],
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
    },
    lastSelectedParameter: null,
  }),
  actions: {
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
      const url = `/factory/machines/${this.machine}/parameters-mtlinki/${this.actualParameterName}?startTime=${encodeURIComponent(
        this.selectedDates.from
      )}&endTime=${encodeURIComponent(this.selectedDates.to)}`;

      try {
        const response = await backendApi.get(url);
        const responseData = response.data;

        this.chartData = responseData.chart_data;
        this.warningLimit = responseData.warning_limit;
        this.criticalLimit = responseData.critical_limit;

        // Set the alert message for failure
        this.alertMessage = 'Fetched Data';
        this.isSuccessMessage = true;

        this.hoverData.xAxisLabel = responseData.legend_data.x_axis_label;
        this.hoverData.yAxisLabel = responseData.legend_data.y_axis_label;
        this.hoverData.xAxisUnits = responseData.legend_data.x_axis_units;
        this.hoverData.yAxisUnits = responseData.legend_data.y_axis_units;

      } catch (error) {
        console.error('Error Fetching Data:', error);

        // Set the alert message for failure
        this.alertMessage = 'Fetching Failed failed. Please try again.';
        this.isSuccessMessage = false;
        this.chartData = [[0, 0]];
        this.warningLimit = 0;
        this.criticalLimit = 0;
      } finally {
        // Set a timer to clear the alert after a few seconds
        setTimeout(() => {
          this.alertMessage = '';
        }, 5000);
      }
    },


    async fetchMachineParameterData() {
      const url = `/factory/machines/${this.machine}/parameters-mtlinki/${this.actualParameterName}?startTime=${encodeURIComponent(
        this.selectedDates.from
      )}&endTime=${encodeURIComponent(this.selectedDates.to)}`;

      try {
        const response = await backendApi.get(url);
        const responseData = response.data;

        this.chartData = responseData.chart_data;
        this.warningLimit = responseData.warning_limit;
        this.criticalLimit = responseData.critical_limit;

        // Set the alert message for failure
        this.alertMessage = 'Fetched Data';
        this.isSuccessMessage = true;

        this.hoverData.xAxisLabel = responseData.legend_data.x_axis_label;
        this.hoverData.yAxisLabel = responseData.legend_data.y_axis_label;
        this.hoverData.xAxisUnits = responseData.legend_data.x_axis_units;
        this.hoverData.yAxisUnits = responseData.legend_data.y_axis_units;

      } catch (error) {
        console.error('Error Fetching Data:', error);

        // Set the alert message for failure
        this.alertMessage = 'Fetching Failed failed. Please try again.';
        this.isSuccessMessage = false;
        this.chartData = [[0, 0]];
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
        // Retrieve the token from local storage
        const token = localStorage.getItem("token")
        if (!token) {
          throw new Error('No token found');
        }
    
        const headers = {
          Authorization: `Bearer ${token}`
        };
    
        const response = await backendApi.put(url, requestBody, {
          params: queryParams,
          headers: headers
        });
    
        const responseData = response.data;
    
        // Handle success
        console.log('Update Limits Response:', responseData);
    
        // Set the alert message for success
        this.alertMessage = 'Limits updated successfully';
        if (setType == "warning_limit") {
          this.warningLimit = limitValue;
        } else if (setType == "critical_limit") {
          this.criticalLimit = limitValue;
        }
    
        this.isSuccessMessage = true;
    
      } catch (error) {
        console.error('Error updating limits:', error.response);
         // Set the alert message for failure
    if (error.response && error.response.data && error.response.data.detail) {
      // Display the error message from the API response
      this.alertMessage = `Update failed: ${error.response.data.detail}`;
    } else {
      // Display a generic error message
      this.alertMessage = 'Update failed. Please try again.';
    }
    
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
    setLastSelectedParameter(parameter) {
      this.lastSelectedParameter = parameter;
      console.log("Setting Last Selected Parameter:", parameter);
    },
    setMachineDetails(details) {
      this.machine = details.machine;
      this.actualParameterName = details.actualParameterName;
      this.parameterGroup = details.parameterGroup;
      console.log("Setting Machine Details:", details);
    },
    // setLastSelectedParameter(parameter) {
    //   this.lastSelectedParameter = parameter;
    // },
  },
});