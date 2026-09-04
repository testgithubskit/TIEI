// src/stores/factoryOverviewStore.js
import { defineStore } from 'pinia';
import { backendApi } from '@/services/apiServices';

export const useFactoryOverviewStore = defineStore('factoryOverview', {
  state: () => ({
    rawData: [],
    formattedOverviewData: [],
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
        this.formattedOverviewData = [];
      } finally {
        this.isLoading = false;
      }
    },

    formatOverviewData() {
      const lines = ['BLOCK', 'CRANK', 'HEAD'];
      this.formattedOverviewData = lines.map(lineName => ({
        lineName: lineName.toLowerCase(),
        machines: this.getMachinesForLine(lineName)
      }));
    },

    getMachinesForLine(lineName) {
      const machinesMap = new Map();

      this.rawData.forEach(group => {
        group.group_details.forEach(line => {
          if (line.line_name === lineName) {
            line.machines.forEach(machine => {
              if (!machinesMap.has(machine.machine_name)) {
                machinesMap.set(machine.machine_name, {
                  machineName: machine.machine_name,
                  machineState: machine.machine_state,
                  parameterGroups: {}
                });
              }
              
              const machineData = machinesMap.get(machine.machine_name);
              machineData.parameterGroups[group.group_name] = machine.parameters.map(this.formatParameter);
            });
          }
        });
      });

      return Array.from(machinesMap.values());
    },

    formatParameter(param) {
      return {
        paramName: param.display_name,
        paramValue: param.parameter_value,
        paramState: param.parameter_state,
        lastUpdated: new Date(param.latest_update_time).toLocaleString()
      };
    },

    getAbnormalGroups(parameterGroups) {
      return Object.entries(parameterGroups)
        .filter(([_, params]) => params.some(p => p.paramState !== 'OK'))
        .map(([groupName, params]) => ({
          groupName,
          abnormalParams: params.filter(p => p.paramState !== 'OK')
        }));
    }
  }
});