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

/** Default pressure window: last 60s (high-rate sensors). Max API window is 1 year. */
export const PRESSURE_DEFAULT_RANGE_SECONDS = 60;
export const PRESSURE_FALLBACK_MIN_SECONDS = 1;
export const PRESSURE_FALLBACK_MAX_SECONDS = 365 * 24 * 3600;

const SAMPLING_SESSION_KEY = 'machineSamplingWithLimitsSession';

function isRequestCanceled(error) {
  return (
    error?.code === 'ERR_CANCELED'
    || error?.name === 'CanceledError'
    || error?.name === 'AbortError'
    || error?.message === 'canceled'
  );
}

let pressureComparisonAbortController = null;

export const useMachineSamplingWithLimitsStore = defineStore('machineSamplingWithLimits', {
  state: () => ({
    machine: 'T_H_OP150',
    line: 'T&H Line',
    lineName: 'T&H Line',
    line_name: 'T&H Line',
    parameterGroup: '',
    displayName: 'X',
    actualParameterName: 'ApcBatLow0Path1THOP150',
    isPressureMachine: false,
    pressureRangeLimits: {
      min: PRESSURE_FALLBACK_MIN_SECONDS,
      max: PRESSURE_FALLBACK_MAX_SECONDS,
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
    pressureLogFiles: [],
    baselineLogFileId: null,
    selectedPressureLogFileIds: [],
    pressureComparisonSeries: [],
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
      const minSeconds = state.pressureRangeLimits.min ?? PRESSURE_FALLBACK_MIN_SECONDS;
      const maxSeconds = state.pressureRangeLimits.max ?? PRESSURE_FALLBACK_MAX_SECONDS;
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
    refreshPressureTimestamp(seconds = PRESSURE_DEFAULT_RANGE_SECONDS) {
      const currentTimestamp = Date.now();
      const minSeconds = this.pressureRangeLimits.min ?? PRESSURE_FALLBACK_MIN_SECONDS;
      const maxSeconds = this.pressureRangeLimits.max ?? PRESSURE_FALLBACK_MAX_SECONDS;
      const boundedSeconds = Math.min(Math.max(seconds, minSeconds), maxSeconds);
      this.selectedDates = {
        from: currentTimestamp - boundedSeconds * 1000,
        to: currentTimestamp,
      };
    },
    refreshPressureTimestampAround(latestEpochMs, seconds = PRESSURE_DEFAULT_RANGE_SECONDS) {
      const latest = pressureTimeToEpoch(latestEpochMs);
      if (!latest) {
        return;
      }
      const minSeconds = this.pressureRangeLimits.min ?? PRESSURE_FALLBACK_MIN_SECONDS;
      const maxSeconds = this.pressureRangeLimits.max ?? PRESSURE_FALLBACK_MAX_SECONDS;
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
    applyPressureComparisonResponse(responseData) {
      this.warningLimit = responseData.warning_limit;
      this.criticalLimit = responseData.critical_limit;
      this.baselineLogFileId = responseData.baseline_log_file_id ?? null;
      this.pressureComparisonSeries = Array.isArray(responseData.series) ? responseData.series : [];
      this.chartData = this.pressureComparisonSeries[0]?.chart_data || [];
      this.hoverData.xAxisLabel = responseData.legend_data?.x_axis_label || 'Timestamp';
      this.hoverData.yAxisLabel = responseData.legend_data?.y_axis_label || 'Pressure';
      this.hoverData.xAxisUnits = responseData.legend_data?.x_axis_units || 'DateTime';
      this.hoverData.yAxisUnits = responseData.legend_data?.y_axis_units || 'Pa';
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
      )}&endTime=${encodeURIComponent(this.selectedDates.to)}&maxPoints=3000`;

      try {
        const response = await backendApi.get(url);
        this.applyTimelineResponse(response.data);
        this.chartFetchMessage = response.data.message || '';
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
    async fetchPressureLogFiles(startDate, endDate) {
      const params = new URLSearchParams();
      if (startDate) {
        params.set('startDate', startDate);
      }
      if (endDate) {
        params.set('endDate', endDate);
      }

      const url = `/pressure/machines/${encodeURIComponent(this.machine)}/log-files${params.toString() ? `?${params.toString()}` : ''}`;

      try {
        const response = await backendApi.get(url);
        this.pressureLogFiles = Array.isArray(response.data.log_files) ? response.data.log_files : [];
        if (response.data.baseline_log_file_id !== undefined && response.data.baseline_log_file_id !== null) {
          this.baselineLogFileId = response.data.baseline_log_file_id;
        }
        if (response.data.warning_limit !== undefined && response.data.warning_limit !== null) {
          this.warningLimit = response.data.warning_limit;
        }
        if (response.data.critical_limit !== undefined && response.data.critical_limit !== null) {
          this.criticalLimit = response.data.critical_limit;
        }
        return response.data;
      } catch (error) {
        console.error('Error fetching pressure log files:', error);
        this.pressureLogFiles = [];
        throw error;
      }
    },
    async fetchPressureComparisonData(logFileIds = [], includeBaseline = true) {
      const query = new URLSearchParams();
      if (Array.isArray(logFileIds) && logFileIds.length > 0) {
        query.set('logFileIds', logFileIds.join(','));
      }
      query.set('includeBaseline', includeBaseline ? 'true' : 'false');
      query.set('maxPoints', '3000');

      const url = `/pressure/machines/${encodeURIComponent(this.machine)}/air-pressure-log-files?${query.toString()}`;

      if (pressureComparisonAbortController) {
        pressureComparisonAbortController.abort();
      }
      const controller = new AbortController();
      pressureComparisonAbortController = controller;

      try {
        const response = await backendApi.get(url, { signal: controller.signal });
        this.applyPressureComparisonResponse(response.data);
        this.chartFetchMessage = response.data.message || '';
        return response.data;
      } catch (error) {
        if (isRequestCanceled(error)) {
          return null;
        }
        console.error('Error fetching pressure comparison data:', error);
        this.chartData = [[0, 0]];
        this.pressureComparisonSeries = [];
        this.chartFetchMessage = error.response?.data?.detail || 'Fetching pressure comparison data failed.';
        throw error;
      } finally {
        if (pressureComparisonAbortController === controller) {
          pressureComparisonAbortController = null;
        }
      }
    },
    async updatePressureBaseline(logFileId) {
      const url = `/pressure/machines/${encodeURIComponent(this.machine)}/baseline-log-file?logFileId=${encodeURIComponent(logFileId)}`;
      const response = await backendApi.put(url);
      this.baselineLogFileId = response.data.baseline_log_file_id ?? logFileId;
      this.pressureLogFiles = this.pressureLogFiles.map((item) => ({
        ...item,
        baseline: item.log_file_id === this.baselineLogFileId,
      }));
      return response.data;
    },
    async clearPressureBaseline() {
      const url = `/pressure/machines/${encodeURIComponent(this.machine)}/baseline-log-file`;
      const response = await backendApi.delete(url);
      this.baselineLogFileId = null;
      this.pressureLogFiles = this.pressureLogFiles.map((item) => ({
        ...item,
        baseline: false,
        rmse: null,
        status: null,
      }));
      return response.data;
    },
    async updatePressureLimits(warningLimit, criticalLimit) {
      const params = new URLSearchParams();
      if (warningLimit !== undefined && warningLimit !== null && warningLimit !== '') {
        params.set('warningLimit', warningLimit);
      }
      if (criticalLimit !== undefined && criticalLimit !== null && criticalLimit !== '') {
        params.set('criticalLimit', criticalLimit);
      }
      const url = `/pressure/machines/${encodeURIComponent(this.machine)}/limits?${params.toString()}`;
      const response = await backendApi.put(url);
      if (response.data.warning_limit !== undefined) {
        this.warningLimit = response.data.warning_limit;
      }
      if (response.data.critical_limit !== undefined) {
        this.criticalLimit = response.data.critical_limit;
      }
      this.alertMessage = response.data.message || 'Limits updated successfully';
      this.isSuccessMessage = true;
      setTimeout(() => {
        this.alertMessage = '';
      }, 4000);
      return response.data;
    },
    async updateLimits(setType, limitValue = null, append = null, referenceSignal = null) {
      if (this.isPressureContext) {
        const warning = setType === 'warning_limit' ? limitValue : this.warningLimit;
        const critical = setType === 'critical_limit' ? limitValue : this.criticalLimit;
        try {
          return await this.updatePressureLimits(warning, critical);
        } catch (error) {
          this.alertMessage = error.response?.data?.detail || 'Update failed. Please try again.';
          this.isSuccessMessage = false;
          setTimeout(() => {
            this.alertMessage = '';
          }, 5000);
          throw error;
        }
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
      this.persistSamplingSession();
    },
    persistSamplingSession() {
      try {
        const payload = {
          machine: this.machine,
          parameterGroup: this.parameterGroup,
          displayName: this.displayName,
          actualParameterName: this.actualParameterName,
          isPressureMachine: this.isPressureMachine,
          lineName: this.lineName,
          line_name: this.line_name,
          line: this.line,
          selectedDates: { ...this.selectedDates },
          lastSelectedParameter: this.lastSelectedParameter,
        };
        sessionStorage.setItem(SAMPLING_SESSION_KEY, JSON.stringify(payload));
      } catch (error) {
        console.warn('Unable to persist sampling session', error);
      }
    },
    restoreSamplingSession() {
      try {
        const raw = sessionStorage.getItem(SAMPLING_SESSION_KEY);
        if (!raw) {
          return false;
        }
        const payload = JSON.parse(raw);
        if (!payload?.machine) {
          return false;
        }
        this.machine = payload.machine;
        this.parameterGroup = payload.parameterGroup || '';
        this.displayName = payload.displayName || this.displayName;
        this.actualParameterName = payload.actualParameterName || this.actualParameterName;
        this.isPressureMachine = !!payload.isPressureMachine;
        if (payload.lineName || payload.line_name || payload.line) {
          const line = payload.lineName || payload.line_name || payload.line;
          this.lineName = line;
          this.line_name = line;
          this.line = line;
        }
        if (payload.selectedDates?.from && payload.selectedDates?.to) {
          this.selectedDates = {
            from: Number(payload.selectedDates.from),
            to: Number(payload.selectedDates.to),
          };
        }
        if (payload.lastSelectedParameter) {
          this.lastSelectedParameter = payload.lastSelectedParameter;
        }
        return true;
      } catch (error) {
        console.warn('Unable to restore sampling session', error);
        return false;
      }
    },
    setMachineDetails(details) {
      this.machine = details.machine;
      this.actualParameterName = details.actualParameterName;
      this.parameterGroup = details.parameterGroup;
      if (details.lineName || details.line_name || details.line) {
        const line = details.lineName || details.line_name || details.line;
        this.lineName = line;
        this.line_name = line;
        this.line = line;
      }
      const group = (details.parameterGroup || '').toUpperCase();
      const param = (details.actualParameterName || '').toUpperCase();
      this.isPressureMachine = (
        details.isPressureMachine === true
        || details.is_pressure_machine === true
        || group === 'AIR_PRESSURE'
        || param === 'AIR_PRESSURE'
      );
      if (this.isPressureMachine) {
        const signalName = details.displayName
          || details.signal_name
          || details.signalName
          || '';
        if (signalName) {
          this.displayName = signalName;
        }
      } else if (details.displayName) {
        this.displayName = details.displayName;
      }
      if (this.isPressureMachine && details.initializePressureDates !== false) {
        const latest = this.resolvePressureAnchorEpoch(details);
        if (latest) {
          this.refreshPressureTimestampAround(latest, PRESSURE_DEFAULT_RANGE_SECONDS);
        } else {
          this.refreshPressureTimestamp(PRESSURE_DEFAULT_RANGE_SECONDS);
        }
      }
      this.lastSelectedParameter = {
        ...details,
        machine: this.machine,
        actualParameterName: this.actualParameterName,
        parameterGroup: this.parameterGroup,
        displayName: this.displayName,
        lineName: this.lineName,
        line_name: this.line_name,
        line: this.line,
        isPressureMachine: this.isPressureMachine,
        is_pressure_machine: this.isPressureMachine,
      };
      this.persistSamplingSession();
    },
  },
});
