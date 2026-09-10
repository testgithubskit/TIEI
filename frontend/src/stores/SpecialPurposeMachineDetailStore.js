import { defineStore } from 'pinia';

import { backendApi } from '@/services/apiServices';

function subtractHours(date, hours) {
  date.setHours(date.getHours() - hours);
  return date;
}

const SPM_MACHINE_KEY = 'spm.selectedMachine';
const SPM_RETURN_KEY = 'spm.returnTo';

function readStoredValue(key, fallback = '') {
  try {
    return localStorage.getItem(key) || sessionStorage.getItem(key) || fallback;
  } catch {
    return fallback;
  }
}

function writeStoredValue(key, value) {
  try {
    if (value) {
      localStorage.setItem(key, value);
      sessionStorage.setItem(key, value);
    }
  } catch {
    /* ignore quota / private mode */
  }
}

export const useSpecialPurposeMachineDetailStore = defineStore('SpecialPurposeMachineDetail', {
  state: () => ({
    machine: readStoredValue(SPM_MACHINE_KEY, 'Laser Cladding A'),
    returnPath: readStoredValue(SPM_RETURN_KEY, ''),
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
    pendingParameter: '',
    actualParameterName: '',
    warningLimit: 100,
    criticalLimit: 300,
    alertMessage: '',
    chartEmptyMessage: '',
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
      if (!machine) return;
      this.machine = machine;
      writeStoredValue(SPM_MACHINE_KEY, machine);
    },
    setReturnPath(path) {
      const next = path || '';
      this.returnPath = next;
      writeStoredValue(SPM_RETURN_KEY, next);
    },
    resolveBackPath() {
      const stored = this.returnPath || readStoredValue(SPM_RETURN_KEY, '');
      const isInvalid = (path) => (
        !path
        || path === '/'
        || path === '/#/'
        || String(path).toLowerCase().includes('login')
        || String(path).includes('spm-detail')
      );
      if (!isInvalid(stored)) return stored;
      return '/spm-overview';
    },
    setPendingParameter(parameterName) {
      this.pendingParameter = parameterName || '';
    },
    refreshTimestamp() {
      const currentTimestamp = Date.now();
      const oneHourAgo = subtractHours(new Date(currentTimestamp), 1).getTime();
      this.selectedDates = {
        from: oneHourAgo,
        to: currentTimestamp,
      };
    },
    async fetchMachineParameterData(showToast = false) {
      this.chartEmptyMessage = '';
      try {
        const chartDataArray = [];

        for (const param of this.selectedParameters) {
          const startTimeInSeconds = this.selectedDates.from / 1000;
          const endTimeInSeconds = this.selectedDates.to / 1000;

          const url = `/spm/real-time/${this.machine}/${param}?startTime=${encodeURIComponent(startTimeInSeconds)}&endTime=${encodeURIComponent(endTimeInSeconds)}`;
          const response = await backendApi.get(url);
          const responseData = response.data;

          chartDataArray.push({
            param: responseData.param,
            axis: responseData.axis,
            machine: this.machine,
            start_time: responseData.start_time,
            stop_time: responseData.stop_time,
            data: responseData.data,
            timestamps: responseData.timestamps,
            critical_limit: responseData.critical_limit,
            warning_limit: responseData.warning_limit
          });
        }

        this.chartData = chartDataArray;
        if (showToast) {
          this.alertMessage = 'Fetched Data';
          this.isSuccessMessage = true;
        }
      } catch (error) {
        console.error('Error Fetching Data:', error);
        this.chartData = [];
        const status = error.response?.status;
        const detail = error.response?.data?.detail;
        const detailText = Array.isArray(detail)
          ? detail.map((item) => item.msg || item).join(' ')
          : String(detail || '');

        if (status === 404 || /no data/i.test(detailText)) {
          this.chartEmptyMessage = 'No data for the selected time range.';
          this.alertMessage = showToast ? 'No data for the selected time range.' : '';
          this.isSuccessMessage = false;
        } else if (status === 400) {
          this.chartEmptyMessage = detailText || 'Invalid time range.';
          this.alertMessage = this.chartEmptyMessage;
          this.isSuccessMessage = false;
        } else {
          this.chartEmptyMessage = detailText || 'Unable to load timeline data.';
          this.alertMessage = this.chartEmptyMessage;
          this.isSuccessMessage = false;
        }
      } finally {
        if (this.alertMessage) {
          setTimeout(() => {
            this.alertMessage = '';
          }, 5000);
        }
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
        this.alertMessage = error.response?.data?.detail || 'Could not load parameter list.';
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
      const parameterName = this.actualParameterName
        || this.selectedParameters?.[0]
        || this.pendingParameter;
      if (!parameterName) {
        this.alertMessage = 'Select a parameter before updating limits.';
        this.isSuccessMessage = false;
        setTimeout(() => {
          this.alertMessage = '';
        }, 5000);
        return;
      }

      const token = localStorage.getItem('token');
      if (!token) {
        this.alertMessage = 'Not authenticated. Please log in again.';
        this.isSuccessMessage = false;
        setTimeout(() => {
          this.alertMessage = '';
        }, 5000);
        return;
      }

      const url = `/spm/parameters_limit/${encodeURIComponent(parameterName)}`;
      const queryParams = {
        setType,
        limit: limitValue,
      };
      if (append !== null) {
        queryParams.append = append;
      }
      const requestBody = referenceSignal !== null ? referenceSignal : [0];

      try {
        const response = await backendApi.put(url, requestBody, {
          params: queryParams,
          headers: {
            Authorization: `Bearer ${token}`,
          },
        });
        console.log('Update Limits Response:', response.data);

        this.alertMessage = 'Limits updated successfully';
        if (setType === 'warning_limit') {
          this.warningLimit = limitValue;
        } else if (setType === 'critical_limit') {
          this.criticalLimit = limitValue;
        }
        this.availableParameters = (this.availableParameters || []).map((item) => (
          item.name === parameterName
            ? {
              ...item,
              warning_limit: setType === 'warning_limit' ? limitValue : item.warning_limit,
              critical_limit: setType === 'critical_limit' ? limitValue : item.critical_limit,
            }
            : item
        ));
        this.isSuccessMessage = true;
      } catch (error) {
        console.error('Error updating limits:', error);
        const detail = error.response?.data?.detail;
        this.alertMessage = detail || 'Update failed. Please try again.';
        this.isSuccessMessage = false;
      } finally {
        setTimeout(() => {
          this.alertMessage = '';
        }, 5000);
      }
    },
  },
});