import { defineStore } from 'pinia';

import { backendApi } from '@/services/apiServices';

function subtractHours(date, hours) {
  date.setHours(date.getHours() - hours);
  return date;
}



export const useSpecialPurposeMachineDetailStore = defineStore('SpecialPurposeMachineDetail', {
  state: () => ({
    machine: 'Laser Cladding A',
    selectedDates: {
      from: 1703058029000,
      to: 1703234429000,
    },

    chartData: [
      {
        param: 23,
        axis: 'process_cycle_running_seat_number',
        machine: 'Laser Cladding A',
        start_time: 1651222458000.0,
        stop_time: 1651225843600.0,
        data: [10, 20, 30, 40],
        timestamps: [1651222458000.0, 1651222458040.0, 1651222458080.0, 1651222458120.0],
        critical_limit: 0.0,
        warning_limit: 0.0
      },
      {
        param: 23,
        axis: 'process_cycle_running_seat_number',
        machine: 'Laser Cladding B',
        start_time: 1651222458000.0,
        stop_time: 1651225843600.0,
        data: [15, 25, 35, 45], // Modified data for Laser Cladding B
        timestamps: [1651222458000.0, 1651222458040.0, 1651222458080.0, 1651222458120.0],
        critical_limit: 0.0,
        warning_limit: 0.0
      },
      
    ],
    

    availableParameters: [
      {'name': 'temperature', 'item_state': 'OK'},
      {'name': 'pressure', 'item_state': 'WARNING'},
      {'name': 'temperature1', 'item_state': 'OK'},
      {'name': 'pressure1', 'item_state': 'WARNING'},
      {'name': 'temperature2', 'item_state': 'OK'},
      {'name': 'pressure3', 'item_state': 'WARNING'}
    ],
     // Modified to be an object
    seriesData: {},
    selectedParameters: [], 
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
    updateChartData(newData) {
      this.chartData = newData;
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
        console.log("Actual Parameters");
        console.log(this.selectedParameters);
    
        const chartDataArray = [];
    
        for (const param of this.selectedParameters) {
          const startTimeInSeconds = this.selectedDates.from / 1000; // Convert epoch to seconds
          const endTimeInSeconds = this.selectedDates.to / 1000; // Convert epoch to seconds
    
          const url = `/spm/real-time/${this.machine}/${param}?startTime=${encodeURIComponent(startTimeInSeconds)}&endTime=${encodeURIComponent(endTimeInSeconds)}`;
          const response = await backendApi.get(url);
    
          const responseData = response.data;
    
          const newDataObject = {
            param: responseData.param,
            axis: responseData.axis,
            machine: this.machine,
            start_time: responseData.start_time,
            stop_time: responseData.stop_time,
            data: responseData.data,
            timestamps: responseData.timestamps,
            critical_limit: responseData.critical_limit,
            warning_limit: responseData.warning_limit
          };
    
          chartDataArray.push(newDataObject);
        }
    
        this.chartData = chartDataArray;
    
        console.log("Updated Chart Data");
        console.log(this.chartData);
    
        // Set the alert message for success
        this.alertMessage = 'Fetched Data';
        this.isSuccessMessage = true;
      } catch (error) {
        console.error('Error Fetching Data:', error);
    
        // Set the alert message for failure
        this.alertMessage = 'Fetching Failed. Please try again.';
        this.isSuccessMessage = false;
        this.chartData = [];
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
        this.seriesData = {};
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
      } else {
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
        } else if (setType == "critical_limit"){
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