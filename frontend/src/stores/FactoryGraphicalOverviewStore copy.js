// src/stores/factoryOverviewStore.js
import { defineStore } from 'pinia';
import { backendApi } from '@/services/apiServices';

export const useFactoryOverviewStore = defineStore('factoryOverview', {
  state: () => ({
    rawData: [],
    formattedOverviewData: {
      lines: [],
      machines: []
    },
    isLoading: false,
    error: null
  }),

  actions: {
    async fetchAndFormatData() {
      this.isLoading = true;
      this.error = null;
      try {
        const response = await backendApi.get('/factory/layout');
        this.rawData = response.data.all_group_details;
        this.formatOverviewData();
      } catch (error) {
        console.error('Error fetching data:', error);
        this.error = 'Failed to fetch data. Please try again later.';
        this.rawData = [];
        this.formattedOverviewData = { lines: [], machines: [] };
      } finally {
        this.isLoading = false;
      }
    },

    formatOverviewData() {
      const linesMap = new Map();
      const machinesMap = new Map();

      this.rawData.forEach(group => {
        group.group_details.forEach(line => {
          // Update line data
          if (!linesMap.has(line.line_name)) {
            linesMap.set(line.line_name, {
              lineName: line.line_name,
              totalMachines: 0,
              abnormalMachines: 0
            });
          }
          const lineData = linesMap.get(line.line_name);

          line.machines.forEach(machine => {
            lineData.totalMachines++;
            if (machine.machine_state !== 'OK') {
              lineData.abnormalMachines++;
            }

            // Update machine data
            if (!machinesMap.has(machine.machine_name)) {
              machinesMap.set(machine.machine_name, {
                machineName: machine.machine_name,
                machineState: machine.machine_state,
                abnormalParameters: []
              });
            }
            const machineData = machinesMap.get(machine.machine_name);

            machine.parameters.forEach(param => {
              if (param.parameter_state !== 'OK') {
                machineData.abnormalParameters.push({
                  paramName: param.display_name,
                  actualParamName: param.actual_parameter_name,
                  paramValue: param.parameter_value,
                  paramState: param.parameter_state,
                  lastUpdated: new Date(param.latest_update_time).toLocaleString()
                });
              }
            });
          });
        });
      });

      this.formattedOverviewData = {
        lines: Array.from(linesMap.values()),
        machines: Array.from(machinesMap.values())
      };
    },

    getAbnormalParametersForMachine(machineName) {
      const machine = this.formattedOverviewData.machines.find(m => m.machineName === machineName);
      return machine ? machine.abnormalParameters : [];
    }
  }
});