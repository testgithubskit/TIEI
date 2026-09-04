// src/stores/CompareParameters.js
import { defineStore } from 'pinia';
import { backendApi } from '@/services/apiServices';

export const useCompareParameters = defineStore('CompareParameters', {
  state: () => ({
    rawData: null,
    formattedData: {
      lines: [],
      machines: [],
      parameters: {}
    },
    isLoading: false,
    error: null
  }),

  actions: {
    async fetchAndFormatData() {
      this.isLoading = true;
      this.error = null;
      try {
        const response = await backendApi.get('factory/layout');
        this.rawData = response.data;
        this.formatData();
      } catch (error) {
        console.error('Error fetching data:', error);
        this.error = 'Failed to fetch data. Please try again later.';
        this.rawData = null;
        this.formattedData = { lines: [], machines: [], parameters: {} };
      } finally {
        this.isLoading = false;
      }
    },

    formatData() {
      if (!this.rawData || !this.rawData.all_group_details) return;

      const lines = [];
      const machines = [];
      const parameters = {};

      this.rawData.all_group_details.forEach(group => {
        group.group_details.forEach(lineDetail => {
          const lineName = lineDetail.line_name;
          lines.push(lineName);

          lineDetail.machines.forEach(machine => {
            const machineName = machine.machine_name;
            machines.push({ name: machineName, line: lineName });

            parameters[machineName] = {
              DYNAMIC_PARAMETERS: [],
              ENCODER_TEMPERATURE: []
            };

            machine.parameters.forEach(param => {
              const paramGroup = param.internal_parameter_name.startsWith('A0') ? 'DYNAMIC_PARAMETERS' : 'ENCODER_TEMPERATURE';
              parameters[machineName][paramGroup].push({
                name: param.display_name,
                internalName: param.internal_parameter_name,
              });
            });
          });
        });
      });

      this.formattedData = {
        lines: [...new Set(lines)],
        machines: machines,
        parameters: parameters
      };
    },

    getMachinesForLine(line) {
      return this.formattedData.machines.filter(machine => machine.line === line);
    },

    getParametersForMachine(machineName, group) {
      return this.formattedData.parameters[machineName]?.[group] || [];
    }
  }
});