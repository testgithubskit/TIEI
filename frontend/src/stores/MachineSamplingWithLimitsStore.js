import { defineStore } from 'pinia';

import { backendApi } from '@/services/apiServices';

function subtractHours(date, hours) {
  date.setHours(date.getHours() - hours);
  return date;
}

export function pressureTimeToEpoch(value) {
  if (value == null || value === '') {
    return null;
  }
  if (typeof value === 'number' && Number.isFinite(value)) {
    return value;
  }

  const text = String(value).trim();
  if (/^\d+(\.\d+)?$/.test(text)) {
    const parsed = Number(text);
    return Number.isFinite(parsed) ? parsed : null;
  }

  const normalized = text.replace('T', ' ');
  const withTimezone = normalized.includes('+') ? normalized : `${normalized.replace(' ', 'T')}+05:30`;
  const parsedMs = Date.parse(withTimezone);
  return Number.isFinite(parsedMs) ? parsedMs : null;
}

export const useMachineSamplingWithLimitsStore = defineStore('machineSamplingWithLimits', {
  state: () => ({
    machine: 'T_H_OP150',
    parameterGroup: '',
    displayName: 'X',
    actualParameterName: 'ApcBatLow0Path1THOP150',
    isPressureMachine: false,
    pressureRangeLimits: {
      min: null,
      max: null,
    },
    selectedDates: {
      from: 1703058029000,
      to: 1703234429000,
    },
    chartData: [
      [1685162998000, 50],
      [1685162998000 + 86400000, 75],
      [1685162998000 + 86400000 + 86400000, 100],
      [1685162998000 + 86400000 + 86400000 + 86400000, 200],
    ],
    warningLimit: 100,
    criticalLimit: 300,
    alertMessage: '',
    chartFetchMessage: '',
    isSuccessMessage: false,
    hoverData: {
      xAxisLabel: 'Timestamp',
      xAxisValue: '2024-01-02',
      yAxisLabel: 'Temperature',
      yAxisValue: 60,
      xAxisUnits: 'DateTime',
      yAxisUnits: "'c",
    },
    lastSelectedParameter: null,
  }),
  getters: {
    isPressureContext(state) {
      const group = (state.parameterGroup || state.lastSelectedParameter?.parameterGroup || '').toUpperCase();
      const param = (state.actualParameterName || state.lastSelectedParameter?.actualParameterName || '').toUpperCase();
      return (
        state.isPressureMachine
        || state.lastSelectedParameter?.isPressureMachine === true
        || state.lastSelectedParameter?.is_pressure_machine === true
        || group === 'AIR_PRESSURE'
        || param === 'AIR_PRESSURE'
      );
    },
    pressureRangeSeconds(state) {
      const fromMs = Number(state.selectedDates.from);
      const toMs = Number(state.selectedDates.to);
      if (!Number.isFinite(fromMs) || !Number.isFinite(toMs)) {
        return null;
      }
      return (toMs - fromMs) / 1000;
    },
    isValidPressureTimeRange(state) {
      const rangeSeconds = this.pressureRangeSeconds;
      if (rangeSeconds == null) {
        return false;
      }
      const minSeconds = state.pressureRangeLimits.min ?? 1;
      const maxSeconds = state.pressureRangeLimits.max ?? 3;
      return rangeSeconds >= minSeconds && rangeSeconds <= maxSeconds;
    },
  },
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
    refreshPressureTimestamp(seconds = 3) {
      const currentTimestamp = Date.now();
      const minSeconds = this.pressureRangeLimits.min ?? 1;
      const maxSeconds = this.pressureRangeLimits.max ?? 3;
      const boundedSeconds = Math.min(Math.max(seconds, minSeconds), maxSeconds);
      this.selectedDates = {
        from: currentTimestamp - boundedSeconds * 1000,
        to: currentTimestamp,
      };
    },
    refreshPressureTimestampAround(latestEpochMs, seconds = 3) {
      const latest = pressureTimeToEpoch(latestEpochMs);
      if (!latest) {
        return;
      }
      const minSeconds = this.pressureRangeLimits.min ?? 1;
      const maxSeconds = this.pressureRangeLimits.max ?? 3;
      const boundedSeconds = Math.min(Math.max(seconds, minSeconds), maxSeconds);
      this.selectedDates = {
        from: latest - boundedSeconds * 1000,
        to: latest,
      };
    },
    normalizeInvertedPressureTimeRange() {
      const fromMs = Number(this.selectedDates.from);
      const toMs = Number(this.selectedDates.to);
      if (Number.isFinite(fromMs) && Number.isFinite(toMs) && fromMs > toMs) {
        this.selectedDates = {
          from: toMs,
          to: fromMs,
        };
      }
    },
    resolvePressureAnchorEpoch(details = null) {
      const source = details || this.lastSelectedParameter || {};
      return (
        pressureTimeToEpoch(source.latest_update_time_ms)
        || pressureTimeToEpoch(source.latest_update_time)
        || pressureTimeToEpoch(source.latest_update_time_ist)
      );
    },
    applyTimelineResponse(responseData) {
      this.chartData = responseData.chart_data;
      this.warningLimit = responseData.warning_limit;
      this.criticalLimit = responseData.critical_limit;
      this.hoverData.xAxisLabel = responseData.legend_data.x_axis_label;
      this.hoverData.yAxisLabel = responseData.legend_data.y_axis_label;
      this.hoverData.xAxisUnits = responseData.legend_data.x_axis_units;
      this.hoverData.yAxisUnits = responseData.legend_data.y_axis_units;

      if (responseData.min_range_seconds != null) {
        this.pressureRangeLimits.min = responseData.min_range_seconds;
      }
      if (responseData.max_range_seconds != null) {
        this.pressureRangeLimits.max = responseData.max_range_seconds;
      }
    },
    async fetchMachineParameterData() {
      const group = (this.parameterGroup || '').toUpperCase();
      const param = (this.actualParameterName || '').toUpperCase();
      if (this.isPressureContext || group === 'AIR_PRESSURE' || param === 'AIR_PRESSURE') {
        this.isPressureMachine = true;
        return this.fetchPressureMachineData();
      }

      const url = `/factory/machines/${encodeURIComponent(this.machine)}/parameters-mtlinki/${encodeURIComponent(this.actualParameterName)}?startTime=${encodeURIComponent(
        this.selectedDates.from
      )}&endTime=${encodeURIComponent(this.selectedDates.to)}`;

      try {
        const response = await backendApi.get(url);
        this.applyTimelineResponse(response.data);
        this.chartFetchMessage = response.data.message || '';
        this.alertMessage = 'Fetched Data';
        this.isSuccessMessage = true;
      } catch (error) {
        console.error('Error Fetching Data:', error);
        this.alertMessage = error.response?.data?.detail || 'Fetching failed. Please try again.';
        this.isSuccessMessage = false;
        this.chartData = [[0, 0]];
        this.warningLimit = 0;
        this.criticalLimit = 0;
      } finally {
        setTimeout(() => {
          this.alertMessage = '';
        }, 5000);
      }
    },
    async fetchPressureMachineData() {
      this.normalizeInvertedPressureTimeRange();

      const url = `/pressure/machines/${encodeURIComponent(this.machine)}/air-pressure?startTime=${encodeURIComponent(
        this.selectedDates.from
      )}&endTime=${encodeURIComponent(this.selectedDates.to)}`;

      try {
        const response = await backendApi.get(url);
        this.applyTimelineResponse(response.data);
        this.chartFetchMessage = response.data.message || '';
        this.alertMessage = response.data.message || 'Fetched Data';
        this.isSuccessMessage = true;
      } catch (error) {
        console.error('Error fetching pressure data:', error);
        this.alertMessage = error.response?.data?.detail || 'Fetching pressure data failed. Please try again.';
        this.isSuccessMessage = false;
        this.chartData = [[0, 0]];
        this.warningLimit = 0;
        this.criticalLimit = 0;
      } finally {
        setTimeout(() => {
          this.alertMessage = '';
        }, 5000);
      }
    },
    async updateLimits(setType, limitValue = null, append = null, referenceSignal = null) {
      if (this.isPressureContext) {
        this.alertMessage = 'Limit updates are not supported for air pressure machines.';
        this.isSuccessMessage = false;
        setTimeout(() => {
          this.alertMessage = '';
        }, 5000);
        return;
      }

      const url = `/factory/${this.parameterGroup}/${this.machine}/${this.actualParameterName}/`;
      const queryParams = {
        setType,
        limit: limitValue,
      };
      let requestBody;
      if (append !== null) {
        queryParams.append = append;
      }
      requestBody = referenceSignal !== null ? referenceSignal : [0];

      try {
        const token = localStorage.getItem('token');
        if (!token) {
          throw new Error('No token found');
        }

        const headers = {
          Authorization: `Bearer ${token}`,
        };

        const response = await backendApi.put(url, requestBody, {
          params: queryParams,
          headers,
        });

        console.log('Update Limits Response:', response.data);
        this.alertMessage = 'Limits updated successfully';
        if (setType === 'warning_limit') {
          this.warningLimit = limitValue;
        } else if (setType === 'critical_limit') {
          this.criticalLimit = limitValue;
        }
        this.isSuccessMessage = true;
      } catch (error) {
        console.error('Error updating limits:', error.response);
        if (error.response?.data?.detail) {
          this.alertMessage = `Update failed: ${error.response.data.detail}`;
        } else {
          this.alertMessage = 'Update failed. Please try again.';
        }
        this.isSuccessMessage = false;
      } finally {
        setTimeout(() => {
          this.alertMessage = '';
        }, 5000);
      }
    },
    setLastSelectedParameter(parameter) {
      this.lastSelectedParameter = parameter;
    },
    setMachineDetails(details) {
      this.machine = details.machine;
      this.actualParameterName = details.actualParameterName;
      this.parameterGroup = details.parameterGroup;
      const group = (details.parameterGroup || '').toUpperCase();
      const param = (details.actualParameterName || '').toUpperCase();
      this.isPressureMachine = (
        details.isPressureMachine === true
        || details.is_pressure_machine === true
        || group === 'AIR_PRESSURE'
        || param === 'AIR_PRESSURE'
      );
      if (this.isPressureMachine && details.displayName) {
        this.displayName = details.displayName;
      }
      if (this.isPressureMachine && details.initializePressureDates !== false) {
        const latest = this.resolvePressureAnchorEpoch(details);
        if (latest) {
          this.refreshPressureTimestampAround(latest, 3);
        } else {
          this.refreshPressureTimestamp(3);
        }
      }
    },
  },
});
