<script setup>
import {
  ref, watch, onMounted, onBeforeUnmount, defineProps, computed, defineEmits, nextTick,
} from 'vue';
import dygraph from 'dygraphs';

const chartContainer = ref(null);
const plotArea = ref(null);
const chart = ref(null);
const isZoomed = ref(false);
/** Preserve user zoom across limit/label updates when data file is unchanged */
const preservedWindow = ref(null);

const emit = defineEmits(['data-hovered']);

const props = defineProps({
  data: {
    type: Array,
    default: () => [
      [1685162998000, 50],
      [1685162998000 + 86400000, 75],
      [1685162998000 + 2 * 86400000, 100],
    ],
  },
  warningLimit: {
    type: Number,
    default: 100,
  },
  criticalLimit: {
    type: Number,
    default: 250,
  },
  /** false = continuous time-series line (pressure); true = step plot */
  stepPlot: {
    type: Boolean,
    default: true,
  },
});

const isTimeSeries = computed(() => !props.stepPlot);

function toChartDate(x) {
  if (typeof x === 'number') {
    return new Date(x);
  }
  const text = String(x).trim();
  if (!text) {
    return new Date(Number.NaN);
  }
  const isoLike = text.includes('T') ? text : text.replace(' ', 'T');
  return new Date(isoLike.includes('+') ? isoLike : `${isoLike}+05:30`);
}

const computedData = computed(() => {
  if (!props.data?.length) {
    return [];
  }
  return props.data
    .map(([timeValue, value]) => {
      const date = toChartDate(timeValue);
      const ms = date.getTime();
      if (!Number.isFinite(ms) || value == null || Number.isNaN(Number(value))) {
        return null;
      }
      return [date, Number(value), props.warningLimit, props.criticalLimit];
    })
    .filter(Boolean)
    .sort((a, b) => a[0].getTime() - b[0].getTime());
});

const dataFingerprint = computed(() => {
  const rows = computedData.value;
  if (!rows.length) {
    return 'empty';
  }
  const first = rows[0][0].getTime();
  const last = rows[rows.length - 1][0].getTime();
  return `${rows.length}:${first}:${last}:${props.warningLimit}:${props.criticalLimit}:${props.stepPlot}`;
});

function pad(n, len = 2) {
  return String(n).padStart(len, '0');
}

function formatAxisTime(ms, spanMs) {
  const d = new Date(ms);
  if (!Number.isFinite(ms)) {
    return '';
  }
  if (spanMs > 14 * 24 * 3600 * 1000) {
    return `${pad(d.getDate())}/${pad(d.getMonth() + 1)}/${String(d.getFullYear()).slice(-2)}`;
  }
  if (spanMs > 2 * 24 * 3600 * 1000) {
    return `${pad(d.getDate())}/${pad(d.getMonth() + 1)} ${pad(d.getHours())}:${pad(d.getMinutes())}`;
  }
  if (spanMs > 2 * 3600 * 1000) {
    return `${pad(d.getHours())}:${pad(d.getMinutes())}`;
  }
  if (spanMs > 5 * 1000) {
    return `${pad(d.getHours())}:${pad(d.getMinutes())}:${pad(d.getSeconds())}`;
  }
  return `${pad(d.getMinutes())}:${pad(d.getSeconds())}.${pad(d.getMilliseconds(), 3)}`;
}

function formatHoverTime(ms) {
  const d = new Date(ms);
  return d.toLocaleString('en-IN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour12: false,
  });
}

function getFullXRange() {
  if (!computedData.value.length) {
    return null;
  }
  const first = computedData.value[0][0].getTime();
  const last = computedData.value[computedData.value.length - 1][0].getTime();
  if (!Number.isFinite(first) || !Number.isFinite(last) || last <= first) {
    return null;
  }
  return [first, last];
}

function updateZoomState(minDate, maxDate) {
  const full = getFullXRange();
  if (!full) {
    isZoomed.value = false;
    preservedWindow.value = null;
    return;
  }
  const margin = Math.max(1, (full[1] - full[0]) * 0.002);
  const zoomed = minDate > full[0] + margin || maxDate < full[1] - margin;
  isZoomed.value = zoomed;
  preservedWindow.value = zoomed ? [minDate, maxDate] : null;
}

function niceTimeStep(spanMs, targetTicks) {
  const candidates = [
    1, 2, 5, 10, 20, 50, 100, 200, 500,
    1000, 2000, 5000, 10000, 15000, 30000,
    60000, 120000, 300000, 600000, 900000,
    1800000, 3600000, 2 * 3600000, 4 * 3600000, 6 * 3600000, 12 * 3600000,
    86400000, 2 * 86400000, 7 * 86400000,
  ];
  const ideal = spanMs / Math.max(targetTicks, 1);
  let best = candidates[candidates.length - 1];
  for (let i = 0; i < candidates.length; i += 1) {
    if (candidates[i] >= ideal) {
      best = candidates[i];
      break;
    }
  }
  return best;
}

function timeSeriesXTicker(min, max, pixels) {
  const span = max - min;
  if (!Number.isFinite(span) || span <= 0) {
    return [{ v: min, label: formatAxisTime(min, 0) }];
  }
  const targetTicks = Math.max(4, Math.min(8, Math.floor((pixels || 600) / 95)));
  const step = niceTimeStep(span, targetTicks);
  const first = Math.ceil(min / step) * step;
  const ticks = [];
  for (let t = first; t <= max + step * 0.001; t += step) {
    if (t < min - step * 0.001 || t > max + step * 0.001) {
      continue;
    }
    ticks.push({ v: t, label: formatAxisTime(t, span) });
  }
  if (ticks.length === 0) {
    ticks.push({ v: min, label: formatAxisTime(min, span) });
    ticks.push({ v: max, label: formatAxisTime(max, span) });
  }
  return ticks;
}

function buildOptions() {
  const timeSeries = isTimeSeries.value;
  return {
    labels: ['Date', 'Value', 'Warning Limit', 'Critical Limit'],
    strokeWidth: timeSeries ? 2.5 : 3,
    strokeBorderWidth: 1,
    fillGraph: true,
    fillAlpha: timeSeries ? 0.18 : 0.3,
    drawPoints: false,
    drawGrid: true,
    gridLineColor: timeSeries ? 'rgba(148, 163, 184, 0.28)' : 'rgba(148, 163, 184, 0.35)',
    animatedZooms: true,
    highlightCircleSize: timeSeries ? 5 : 4,
    axisLineWidth: 1.5,
    axisLineColor: 'rgb(51, 65, 85)',
    axisLabelFontSize: 11,
    stepPlot: props.stepPlot,
    // Use Dygraphs default drag / double-click zoom (do NOT override interactionModel)
    colors: [
      'rgb(5, 150, 105)',
      'rgb(245, 158, 11)',
      'rgb(239, 68, 68)',
    ],
    showLabelsOnHighlight: false,
    highlightCallback: handleHover,
    zoomCallback: (minDate, maxDate) => updateZoomState(minDate, maxDate),
    axes: {
      x: {
        pixelsPerLabel: timeSeries ? 95 : 70,
        ...(timeSeries ? { ticker: timeSeriesXTicker } : {}),
        axisLabelFormatter: (ms, gran, opts, dg) => {
          const range = dg?.xAxisRange?.();
          const span = range ? (range[1] - range[0]) : (getFullXRange()?.[1] - getFullXRange()?.[0]) || 0;
          return formatAxisTime(ms, span);
        },
        valueFormatter: (ms) => formatHoverTime(ms),
      },
      y: {
        axisLabelFormatter: (y) => String(Math.round(y * 100) / 100),
        valueFormatter: (y) => `${Math.round(y * 100) / 100} Pa`,
      },
    },
  };
}

function handleHover(event, x, points) {
  emit('data-hovered', points);
}

function resetZoom() {
  if (!chart.value) {
    return;
  }
  const full = getFullXRange();
  preservedWindow.value = null;
  isZoomed.value = false;
  chart.value.updateOptions({ dateWindow: full || null });
}

function getCanvasXFromEvent(event) {
  const el = chart.value?.mouseEventElement_ || chartContainer.value;
  if (!el) {
    return null;
  }
  return event.clientX - el.getBoundingClientRect().left;
}

/** Scroll-wheel zoom — separate from drag zoom; both use dateWindow */
function handleWheel(event) {
  if (!isTimeSeries.value || !chart.value) {
    return;
  }

  event.preventDefault();
  event.stopPropagation();

  const full = getFullXRange();
  if (!full) {
    return;
  }

  const range = chart.value.xAxisRange();
  if (!range) {
    return;
  }
  const [min, max] = range;
  const span = max - min;
  if (!Number.isFinite(span) || span <= 0) {
    return;
  }

  let center = min + span / 2;
  const canvasX = getCanvasXFromEvent(event);
  if (canvasX != null) {
    try {
      const dataX = chart.value.toDataXCoord(canvasX);
      if (Number.isFinite(dataX)) {
        center = Math.min(max, Math.max(min, dataX));
      }
    } catch {
      // midpoint
    }
  }

  const zoomIn = event.deltaY < 0;
  const factor = zoomIn ? 0.75 : 1.35;
  const fullSpan = full[1] - full[0];
  const minSpan = Math.max(fullSpan / 500, 80);
  const newSpan = Math.max(minSpan, Math.min(fullSpan, span * factor));
  const leftFrac = span > 0 ? (center - min) / span : 0.5;

  let newMin = center - leftFrac * newSpan;
  let newMax = newMin + newSpan;

  if (newMin < full[0]) {
    newMin = full[0];
    newMax = newMin + newSpan;
  }
  if (newMax > full[1]) {
    newMax = full[1];
    newMin = newMax - newSpan;
  }

  newMin = Math.max(full[0], newMin);
  newMax = Math.min(full[1], Math.max(newMin + minSpan, newMax));

  chart.value.updateOptions({ dateWindow: [newMin, newMax] });
  updateZoomState(newMin, newMax);
}

function bindWheelListeners() {
  const el = plotArea.value;
  if (!el) {
    return;
  }
  el.removeEventListener('wheel', handleWheel, true);
  el.addEventListener('wheel', handleWheel, { capture: true, passive: false });
}

function unbindWheelListeners() {
  const el = plotArea.value;
  if (!el) {
    return;
  }
  el.removeEventListener('wheel', handleWheel, true);
}

let lastFingerprint = '';

function syncChart() {
  if (!chartContainer.value || !computedData.value.length) {
    if (chart.value) {
      chart.value.destroy();
      chart.value = null;
    }
    isZoomed.value = false;
    preservedWindow.value = null;
    lastFingerprint = '';
    return;
  }

  const options = buildOptions();
  const full = getFullXRange();
  const fingerprint = dataFingerprint.value;
  const dataChanged = fingerprint !== lastFingerprint;
  lastFingerprint = fingerprint;

  if (chart.value) {
    const windowToApply = dataChanged
      ? full
      : (preservedWindow.value || full);

    if (dataChanged) {
      preservedWindow.value = null;
      isZoomed.value = false;
    }

    chart.value.updateOptions({
      file: computedData.value,
      dateWindow: windowToApply,
      ...options,
    });
    nextTick(() => bindWheelListeners());
    return;
  }

  chart.value = new dygraph(chartContainer.value, computedData.value, {
    ...options,
    ...(full ? { dateWindow: full } : {}),
  });
  isZoomed.value = false;
  preservedWindow.value = null;
  nextTick(() => bindWheelListeners());
}

onMounted(() => {
  watch(dataFingerprint, () => {
    syncChart();
  }, { immediate: true });
  nextTick(() => bindWheelListeners());
});

onBeforeUnmount(() => {
  unbindWheelListeners();
  if (chart.value) {
    chart.value.destroy();
    chart.value = null;
  }
});
</script>

<template>
  <div
    class="dygraph-chart-panel"
    :class="{ 'dygraph-chart-panel--time-series': isTimeSeries }"
  >
    <div v-if="isTimeSeries" class="dygraph-chart-toolbar">
      <div class="dygraph-chart-hints">
        <span class="dygraph-hint-chip">Scroll — zoom in / out</span>
        <span class="dygraph-hint-chip">Drag — select range</span>
        <span class="dygraph-hint-chip">Double-click / Reset — full view</span>
      </div>
      <button
        v-if="isZoomed"
        type="button"
        class="dygraph-reset-btn"
        @click="resetZoom"
      >
        Reset zoom
      </button>
    </div>

    <div class="dygraph-chart-body">
      <div v-if="isTimeSeries" class="dygraph-y-label">Pressure (Pa)</div>
      <div
        ref="plotArea"
        class="dygraph-chart-plot-area"
        :class="{ 'dygraph-chart-plot-area--wheel': isTimeSeries }"
      >
        <div ref="chartContainer" class="dygraph-chart-canvas" />
      </div>
    </div>
  </div>
</template>

<style scoped>
.dygraph-chart-panel {
  width: 100%;
  min-height: 360px;
}

.dygraph-chart-panel--time-series {
  border: 1px solid rgb(226, 232, 240);
  border-radius: 12px;
  background: linear-gradient(180deg, rgb(248, 250, 252) 0%, rgb(255, 255, 255) 48%);
  box-shadow: 0 1px 3px rgba(15, 23, 42, 0.06);
  overflow: hidden;
}

.dygraph-chart-toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  flex-wrap: wrap;
  padding: 10px 14px;
  border-bottom: 1px solid rgb(226, 232, 240);
  background: rgba(255, 255, 255, 0.85);
}

.dygraph-chart-hints {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.dygraph-hint-chip {
  font-size: 11px;
  font-weight: 600;
  color: rgb(51, 65, 85);
  background: rgb(241, 245, 249);
  border: 1px solid rgb(226, 232, 240);
  border-radius: 999px;
  padding: 4px 10px;
  white-space: nowrap;
}

.dygraph-reset-btn {
  font-size: 12px;
  font-weight: 700;
  color: rgb(3, 105, 161);
  background: rgb(224, 242, 254);
  border: 1px solid rgb(125, 211, 252);
  border-radius: 8px;
  padding: 6px 12px;
  cursor: pointer;
}

.dygraph-reset-btn:hover {
  background: rgb(186, 230, 253);
}

.dygraph-chart-body {
  display: flex;
  align-items: stretch;
  min-height: 400px;
  padding: 8px 12px 28px 4px;
}

.dygraph-y-label {
  writing-mode: vertical-rl;
  transform: rotate(180deg);
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.04em;
  color: rgb(100, 116, 139);
  text-align: center;
  padding: 8px 2px;
  flex-shrink: 0;
}

.dygraph-chart-plot-area {
  flex: 1;
  min-width: 0;
  min-height: 380px;
}

.dygraph-chart-plot-area--wheel {
  cursor: crosshair;
}

.dygraph-chart-canvas {
  width: 100%;
  height: 100%;
  min-height: 380px;
}

.dygraph-chart-panel :deep(.dygraph-axis-label-x) {
  font-size: 11px;
  font-weight: 600;
  color: rgb(51, 65, 85);
  white-space: nowrap;
}

.dygraph-chart-panel :deep(.dygraph-axis-label-y) {
  font-size: 11px;
  font-weight: 500;
  color: rgb(71, 85, 105);
}

.dygraph-chart-panel :deep(.dygraph-legend) {
  display: none;
}
</style>
