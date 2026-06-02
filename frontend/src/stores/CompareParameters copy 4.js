// src/stores/CompareParameters.js
import { defineStore } from 'pinia';
import { backendApi } from '@/services/apiServices';
import { message } from 'ant-design-vue';
import { h } from 'vue';
import { CheckCircleOutlined } from '@ant-design/icons-vue';  

export const useCompareParameters = defineStore('CompareParameters', {
  state: () => ({
    factoryLayout: null,
    comparisonData: [],
    historyData: [],
    isLoading: false,
    error: null,
  }),

  getters: {
    parameterGroups() {
      return [
        { value: 'DYNAMIC_PARAMETERS', label: 'Load' },
        { value: 'ENCODER_TEMPERATURE', label: 'Position' }
      ];
    },
    linesByParameterGroup: (state) => (parameterGroup) => {
      return state.factoryLayout?.all_group_details
        .find(group => group.group_name === parameterGroup)
        ?.group_details.map(line => line.line_name) || [];
    },
    machinesByLine: (state) => (parameterGroup, lineName) => {
      return state.factoryLayout?.all_group_details
        .find(group => group.group_name === parameterGroup)
        ?.group_details
        .find(line => line.line_name === lineName)
        ?.machines.map(machine => machine.machine_name) || [];
    },
    parametersByMachine: (state) => (parameterGroup, lineName, machineName) => {
      return state.factoryLayout?.all_group_details
        .find(group => group.group_name === parameterGroup)
        ?.group_details
        .find(line => line.line_name === lineName)
        ?.machines
        .find(machine => machine.machine_name === machineName)
        ?.parameters.map(param => ({
          value: param.actual_parameter_name,
          label: param.display_name
        })) || [];
    },
    formattedHistoryData() {
      return this.historyData.map(item => ({
        ...item,
        time: new Date(item.time).getTime(),
      }));
    },
  },

  actions: {
    async fetchFactoryLayout() {
      this.isLoading = true;
      this.error = null;
      try {
        const response = await backendApi.get('factory/layout');
        this.factoryLayout = response.data;
      } catch (error) {
        console.error('Error fetching factory layout:', error);
        this.error = 'Failed to fetch factory layout. Please try again later.';
        message.error(this.error);
      } finally {
        this.isLoading = false;
      }
    },

    async submitComparison(data) {
      this.isLoading = true;
      try {
        await backendApi.post('/parameter-comparison/', {
          line_name: data.line,
          machine_name: data.machineName,
          parameter_group_name: data.parameterGroup,
          machine_parameter1_name: data.parameter1,
          machine_parameter2_name: data.parameter2,
          warning_limit: data.warningLimit,   
          critical_limit: data.criticalLimit,
        });
        message.success('Saved the parameter comparison');
        await this.fetchComparisonData();
      } catch (error) {
        console.error('Error submitting comparison:', error);
        message.error('Failed to save the parameter comparison.');
      } finally {
        this.isLoading = false;
      }
    },

    async fetchComparisonData() {
      this.isLoading = true;
      try {
        const response = await backendApi.get('/getallparameter-comparison/');
        this.comparisonData = response.data;
      } catch (error) {
        console.error('Error fetching comparison data:', error);
        message.error('Failed to fetch comparison data.');
      } finally {
        this.isLoading = false;
      }
    },

    async updateComparison(id, data) {
      this.isLoading = true;
      try {
        const response = await backendApi.put(`/parameter-comparison/${id}`, data);
        // Check if the response contains a message, regardless of the status code
        if (response.data && response.data.message) {
          message.success({
            content: response.data.message,
            icon: () => h(CheckCircleOutlined, { style: 'color: #52c41a' })
          });
          await this.fetchComparisonData();
          return true; // Indicate success
        } else {
          throw new Error('Unexpected response from server');
        }
      } catch (error) {
        console.error('Error updating parameters:', error);
        message.error(error.response?.data?.message || error.message || 'Failed to update parameters');
        return false; // Indicate failure
      } finally {
        this.isLoading = false;
      }
    },

    async deleteComparison(id) {
      this.isLoading = true;
      try {
        const response = await backendApi.delete(`/parameter-comparison/${id}`);
        // Check if the response contains a message, regardless of the status code
        if (response.data && response.data.message) {
          message.success({
            content: response.data.message,
            icon: () => h(CheckCircleOutlined, { style: 'color: #52c41a' })
          });
          await this.fetchComparisonData();
          return true; // Indicate success
        } else {
          throw new Error('Unexpected response from server');
        }
      } catch (error) {
        console.error('Error deleting item:', error);
        message.error(error.response?.data?.message || error.message || 'Failed to delete item');
        return false; // Indicate failure
      } finally {
        this.isLoading = false;
      }
    },

    async fetchHistoryData(formData) {
      this.isLoading = true;
      try {
        const { machineName, parameter1, parameter2, fromDate, toDate } = formData;
        
        // Convert Date objects to ISO strings
        const fromDateString = fromDate.toISOString();
        const toDateString = toDate.toISOString();

        const response = await backendApi.get('/get-parameter-comparison-history/', {
          params: {
            machine_name: machineName,
            parameter1,
            parameter2,
            from_datetime: fromDateString,
            to_datetime: toDateString,
          },
        });
        this.historyData = response.data;
      } catch (error) {
        console.error('Error fetching history data:', error);
        message.error('Failed to fetch history data.');
        throw error;
      } finally {
        this.isLoading = false;
      }
    },
  },
});