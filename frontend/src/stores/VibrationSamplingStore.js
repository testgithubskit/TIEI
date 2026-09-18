import { defineStore } from 'pinia';
import { backendApi } from '@/services/apiServices';

const SESSION_KEY = 'vibrationSamplingSession';

export const VIBRATION_PARAMETERS = [
  { key: 'contact_temperature', label: 'Contact Temperature', unit: '°C' },
  { key: 'v_peak_x', label: 'V Peak X', unit: 'mm/s' },
  { key: 'v_peak_y', label: 'V Peak Y', unit: 'mm/s' },
  { key: 'v_peak_z', label: 'V Peak Z', unit: 'mm/s' },
  { key: 'v_rms_x', label: 'V RMS X', unit: 'mm/s' },
  { key: 'v_rms_y', label: 'V RMS Y', unit: 'mm/s' },
  { key: 'v_rms_z', label: 'V RMS Z', unit: 'mm/s' },
];

export const useVibrationSamplingStore = defineStore('vibrationSampling', {
  state: () => ({
    machine: '',
    port: '',
    lineName: '',
    selectedParameter: 'v_rms_x',
    availableParameters: [...VIBRATION_PARAMETERS],
    ports: [],
    warningLimit: null,
    criticalLimit: null,
    logFiles: [],
    baselineLogFileId: null,
    selectedLogFileIds: [],
    comparisonSeries: [],
    chartData: [[0, 0]],
    chartFetchMessage: '',
    hoverData: {
      xAxisLabel: 'Timestamp',
      xAxisValue: '',
      yAxisLabel: 'V RMS X',
      yAxisValue: '',
      xAxisUnits: 'DateTime',
      yAxisUnits: 'mm/s',
    },
    lastSelected: null,
  }),
  getters: {
    selectedParameterMeta(state) {
      return (
        state.availableParameters.find((item) => item.key === state.selectedParameter)
        || VIBRATION_PARAMETERS.find((item) => item.key === state.selectedParameter)
        || VIBRATION_PARAMETERS[4]
      );
    },
  },
  actions: {
    setContext(details = {}) {
      this.machine = details.machine || details.machine_name || this.machine;
      this.port = details.port || details.port_name || details.signal_name || details.displayName || this.port;
      this.lineName = details.lineName || details.line_name || details.line || this.lineName;
      if (details.selectedParameter) {
        this.selectedParameter = details.selectedParameter;
      }
      if (details.warningLimit != null && details.warningLimit !== '') {
        this.warningLimit = Number(details.warningLimit);
      }
      if (details.criticalLimit != null && details.criticalLimit !== '') {
        this.criticalLimit = Number(details.criticalLimit);
      }
      this.lastSelected = {
        machine: this.machine,
        port: this.port,
        lineName: this.lineName,
        selectedParameter: this.selectedParameter,
        warningLimit: this.warningLimit,
        criticalLimit: this.criticalLimit,
      };
      this.persistSession();
    },
    persistSession() {
      try {
        sessionStorage.setItem(SESSION_KEY, JSON.stringify({
          machine: this.machine,
          port: this.port,
          lineName: this.lineName,
          selectedParameter: this.selectedParameter,
          warningLimit: this.warningLimit,
          criticalLimit: this.criticalLimit,
          lastSelected: this.lastSelected,
        }));
      } catch (error) {
        console.warn('Unable to persist vibration sampling session', error);
      }
    },
    restoreSession() {
      try {
        const raw = sessionStorage.getItem(SESSION_KEY);
        if (!raw) return false;
        const payload = JSON.parse(raw);
        this.machine = payload.machine || '';
        this.port = payload.port || '';
        this.lineName = payload.lineName || '';
        this.selectedParameter = payload.selectedParameter || 'v_rms_x';
        if (payload.warningLimit != null) this.warningLimit = payload.warningLimit;
        if (payload.criticalLimit != null) this.criticalLimit = payload.criticalLimit;
        this.lastSelected = payload.lastSelected || null;
        return true;
      } catch (error) {
        console.warn('Unable to restore vibration sampling session', error);
        return false;
      }
    },
    async fetchLogFiles(startDate = '', endDate = '') {
      const params = new URLSearchParams();
      if (startDate) params.set('startDate', startDate);
      if (endDate) params.set('endDate', endDate);
      if (this.port) params.set('port', this.port);
      const url = `/vibration/machines/${encodeURIComponent(this.machine)}/log-files${params.toString() ? `?${params}` : ''}`;
      const response = await backendApi.get(url);
      this.logFiles = Array.isArray(response.data.log_files) ? response.data.log_files : [];
      this.baselineLogFileId = response.data.baseline_log_file_id ?? null;
      this.warningLimit = response.data.warning_limit ?? this.warningLimit;
      this.criticalLimit = response.data.critical_limit ?? this.criticalLimit;
      this.ports = Array.isArray(response.data.ports) ? response.data.ports : this.ports;
      if (Array.isArray(response.data.available_parameters) && response.data.available_parameters.length) {
        this.availableParameters = response.data.available_parameters;
      }
      return response.data;
    },
    async updateLimits(warningLimit, criticalLimit) {
      const query = new URLSearchParams();
      if (warningLimit != null && warningLimit !== '') query.set('warningLimit', warningLimit);
      if (criticalLimit != null && criticalLimit !== '') query.set('criticalLimit', criticalLimit);
      const url = `/vibration/machines/${encodeURIComponent(this.machine)}/limits?${query.toString()}`;
      const response = await backendApi.put(url);
      this.warningLimit = response.data.warning_limit ?? warningLimit;
      this.criticalLimit = response.data.critical_limit ?? criticalLimit;
      return response.data;
    },
    async fetchComparison(logFileIds = [], includeBaseline = true) {
      const query = new URLSearchParams();
      query.set('port', this.port);
      query.set('parameter', this.selectedParameter);
      if (Array.isArray(logFileIds) && logFileIds.length > 0) {
        query.set('logFileIds', logFileIds.join(','));
      }
      query.set('includeBaseline', includeBaseline ? 'true' : 'false');
      query.set('maxPoints', '3000');
      const url = `/vibration/machines/${encodeURIComponent(this.machine)}/comparison?${query.toString()}`;
      const response = await backendApi.get(url);
      this.warningLimit = response.data.warning_limit ?? this.warningLimit;
      this.criticalLimit = response.data.critical_limit ?? this.criticalLimit;
      this.baselineLogFileId = response.data.baseline_log_file_id ?? null;
      this.comparisonSeries = Array.isArray(response.data.series) ? response.data.series : [];
      this.chartData = this.comparisonSeries[0]?.chart_data || [[0, 0]];
      this.chartFetchMessage = response.data.message || '';
      this.hoverData.xAxisLabel = response.data.legend_data?.x_axis_label || 'Timestamp';
      this.hoverData.yAxisLabel = response.data.legend_data?.y_axis_label || this.selectedParameterMeta.label;
      this.hoverData.xAxisUnits = response.data.legend_data?.x_axis_units || 'DateTime';
      this.hoverData.yAxisUnits = response.data.legend_data?.y_axis_units || this.selectedParameterMeta.unit;
      if (Array.isArray(response.data.available_parameters) && response.data.available_parameters.length) {
        this.availableParameters = response.data.available_parameters;
      }
      return response.data;
    },
    async updateBaseline(logFileId) {
      const url = `/vibration/machines/${encodeURIComponent(this.machine)}/baseline-log-file?logFileId=${encodeURIComponent(logFileId)}`;
      const response = await backendApi.put(url);
      this.baselineLogFileId = response.data.baseline_log_file_id ?? logFileId;
      this.logFiles = this.logFiles.map((item) => ({
        ...item,
        baseline: item.log_file_id === this.baselineLogFileId,
      }));
      return response.data;
    },
    async clearBaseline() {
      const url = `/vibration/machines/${encodeURIComponent(this.machine)}/baseline-log-file`;
      const response = await backendApi.delete(url);
      this.baselineLogFileId = null;
      this.logFiles = this.logFiles.map((item) => ({ ...item, baseline: false }));
      return response.data;
    },
  },
});
