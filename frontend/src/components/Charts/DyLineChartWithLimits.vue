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
const hoverTooltip = ref({
  visible: false,
  left: 0,
  top: 0,
  xText: '',
  yLines: [],
  canvasX: 0,
  canvasY: 0,
});

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
  seriesData: {
    type: Array,
    default: () => [],
  },
  externalLegend: {
    type: Array,
    default: () => [],
  },
  xAxisCaption: {
    type: String,
    default: '',
  },
  /** When true, scroll/zoom hint chips are hidden (parent can show them in its own header). */
  hideHints: {
    type: Boolean,
    default: false,
  },
  /** When true, removes outer chart border so parent panel lines can span full width. */
  borderless: {
    type: Boolean,
    default: false,
  },
  /** When false, warning/critical limit lines are not drawn. */
  showLimits: {
    type: Boolean,
    default: true,
  },
  /** Left-side Y axis caption (pressure compare UI). */
  yAxisLabel: {
    type: String,
    default: 'Pressure (Pa)',
  },
  /** Unit suffix used in hover tooltip / value formatter. */
  yAxisUnit: {
    type: String,
    default: 'Pa',
  },
});

const isTimeSeries = computed(() => !props.stepPlot);

const COMPARE_EPOCH_BASE = new Date(2000, 0, 1).getTime();

const comparisonPalette = [
  'rgb(37, 99, 235)',
  'rgb(147, 51, 234)',
  'rgb(219, 39, 119)',
];

function formatProcessedDateOnly(value) {
  if (value == null || value === '') {
    return '';
  }
  const text = String(value).trim();
  const iso = text.match(/^(\d{4}-\d{2}-\d{2})/);
  if (iso) {
    return iso[1];
  }
  const dmy = text.match(/^(\d{1,2}\/\d{1,2}\/\d{2,4})/);
  if (dmy) {
    return dmy[1];
  }
  if (text.includes(',')) {
    return text.split(',')[0].trim();
  }
  const parts = text.split(/\s+/);
  return parts[0] || text;
}

function formatProcessedTimeOnly(value) {
  if (value == null || value === '') {
    return '';
  }
  const text = String(value).trim();
  let timePart = '';
  if (text.includes(',')) {
    timePart = text.split(',').slice(1).join(',').trim();
  } else {
    const isoSplit = text.match(/^\d{4}-\d{2}-\d{2}[ T](.+)$/);
    if (isoSplit) {
      timePart = isoSplit[1].trim();
    } else {
      const parts = text.split(/\s+/);
      timePart = parts.length > 1 ? parts.slice(1).join(' ') : '';
    }
  }
  const hhmmss = timePart.match(/^(\d{1,2}:\d{2}(?::\d{2})?)/);
  return hhmmss ? hhmmss[1] : timePart.replace(/\.\d+.*$/, '');
}

const activeSeriesEntries = computed(() => {
  if (isTimeSeries.value && Array.isArray(props.seriesData) && props.seriesData.length > 0) {
    const filtered = props.seriesData
      .filter((entry) => Array.isArray(entry?.chart_data) && entry.chart_data.length > 0);
    let colorIdx = 0;
    const usedLabels = new Set();
    return filtered.map((entry) => {
      const isBaseline = !!entry.baseline;
      const processedTime = entry.processed_time || entry.label || '';
      const dateOnly = formatProcessedDateOnly(processedTime);
      const timeOnly = formatProcessedTimeOnly(processedTime);
      let label;
      let shortLabel;
      if (isBaseline) {
        label = dateOnly ? `BASELINE - ${dateOnly}` : 'BASELINE';
        shortLabel = label;
      } else {
        const runNumber = colorIdx + 1;
        // Unique Dygraph series names (same calendar day must not collide — duplicate
        // labels overwrite series color config and paint every run the same color).
        label = [dateOnly, timeOnly].filter(Boolean).join(' ') || `Run ${runNumber}`;
        if (usedLabels.has(label)) {
          label = `${label} (#${runNumber})`;
        }
        shortLabel = timeOnly ? `${dateOnly || 'Run'} ${timeOnly}` : label;
      }
      usedLabels.add(label);
      const color = isBaseline
        ? 'rgb(185, 28, 28)'
        : comparisonPalette[colorIdx++ % comparisonPalette.length];
      return {
        label,
        shortLabel,
        processedTime,
        baseline: isBaseline,
        color,
        chart_data: entry.chart_data,
        startMs: (() => {
          const first = entry.chart_data.find((row) => {
            const date = toChartDate(row?.[0]);
            return Number.isFinite(date.getTime());
          });
          if (!first) return null;
          return toChartDate(first[0]).getTime();
        })(),
      };
    });
  }

  return [{
    label: 'Value',
    shortLabel: 'Value',
    processedTime: '',
    baseline: false,
    color: 'rgb(5, 150, 105)',
    chart_data: props.data,
  }];
});

const isCompareMode = computed(() => (
  isTimeSeries.value && activeSeriesEntries.value.length > 1
));

/** Pressure air-honing compare UI only (parent passes borderless only on that page). */
const isPressureCompareUi = computed(() => !!props.borderless);

/** Pressure overlays use elapsed time from each log start (never wall-clock dates). */
const useElapsedXAxis = computed(() => isPressureCompareUi.value);

const seriesLabels = computed(() => activeSeriesEntries.value.map((entry) => entry.label));
const seriesColors = computed(() => activeSeriesEntries.value.map((entry) => entry.color));

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

function buildElapsedSeriesPoints(entries) {
  return entries.map((entry) => {
    const points = entry.chart_data
      .map(([timeValue, value]) => {
        const date = toChartDate(timeValue);
        const ms = date.getTime();
        if (!Number.isFinite(ms) || value == null || Number.isNaN(Number(value))) {
          return null;
        }
        return { ms, value: Number(value) };
      })
      .filter(Boolean)
      .sort((a, b) => a.ms - b.ms);

    if (!points.length) {
      return [];
    }

    const startMs = points[0].ms;
    return points.map((point) => ({
      elapsed: point.ms - startMs,
      value: point.value,
    }));
  });
}

function interpolateElapsedValue(points, elapsed) {
  if (!points.length) {
    return null;
  }
  if (elapsed < points[0].elapsed || elapsed > points[points.length - 1].elapsed) {
    return null;
  }
  if (elapsed === points[0].elapsed) {
    return points[0].value;
  }
  if (elapsed === points[points.length - 1].elapsed) {
    return points[points.length - 1].value;
  }

  let lo = 0;
  let hi = points.length - 1;
  while (hi - lo > 1) {
    const mid = Math.floor((lo + hi) / 2);
    if (points[mid].elapsed <= elapsed) {
      lo = mid;
    } else {
      hi = mid;
    }
  }

  const left = points[lo];
  const right = points[hi];
  const span = right.elapsed - left.elapsed;
  if (span <= 0) {
    return left.value;
  }
  const ratio = (elapsed - left.elapsed) / span;
  return left.value + ((right.value - left.value) * ratio);
}

function buildAlignedElapsedRows(seriesPoints) {
  const maxElapsed = Math.max(0, ...seriesPoints.map((points) => (
    points.length ? points[points.length - 1].elapsed : 0
  )));
  if (!Number.isFinite(maxElapsed) || maxElapsed <= 0) {
    return [];
  }

  const densest = Math.max(...seriesPoints.map((points) => points.length), 2);
  const targetPoints = Math.max(120, Math.min(700, densest));
  const step = maxElapsed / (targetPoints - 1);
  const rows = [];

  for (let i = 0; i < targetPoints; i += 1) {
    const elapsed = i === targetPoints - 1 ? maxElapsed : (i * step);
    const values = seriesPoints.map((points) => interpolateElapsedValue(points, elapsed));
    rows.push([
      new Date(COMPARE_EPOCH_BASE + elapsed),
      ...values,
      ...(props.showLimits ? [props.warningLimit, props.criticalLimit] : []),
    ]);
  }
  return rows;
}

function getFullYRange() {
  const rows = computedData.value;
  if (!rows.length) {
    return null;
  }
  let minY = Number.POSITIVE_INFINITY;
  let maxY = Number.NEGATIVE_INFINITY;
  const seriesCount = activeSeriesEntries.value.length;

  rows.forEach((row) => {
    for (let i = 1; i <= seriesCount; i += 1) {
      const value = row[i];
      if (value == null || Number.isNaN(Number(value))) {
        continue;
      }
      const num = Number(value);
      if (num < minY) minY = num;
      if (num > maxY) maxY = num;
    }
  });

  if (props.showLimits) {
    [props.warningLimit, props.criticalLimit].forEach((limit) => {
      if (limit == null || Number.isNaN(Number(limit))) return;
      const num = Number(limit);
      if (num < minY) minY = num;
      if (num > maxY) maxY = num;
    });
  }

  if (!Number.isFinite(minY) || !Number.isFinite(maxY)) {
    return null;
  }

  const span = Math.max(maxY - minY, Math.abs(maxY) * 0.05, 0.1);
  const step = niceYStep(span);
  let minBound = Math.floor(minY / step) * step;
  let maxBound = Math.ceil(maxY / step) * step;
  if (maxBound <= minBound) {
    maxBound = minBound + step;
  }
  return [Number(minBound.toFixed(8)), Number(maxBound.toFixed(8))];
}

function niceYStep(span) {
  if (!Number.isFinite(span) || span <= 0) return 1;
  const rough = span / 5;
  const pow = 10 ** Math.floor(Math.log10(rough));
  const normalized = rough / pow;
  let nice;
  if (normalized <= 1) nice = 1;
  else if (normalized <= 2) nice = 2;
  else if (normalized <= 5) nice = 5;
  else nice = 10;
  return nice * pow;
}

function formatYAxisLabel(value) {
  const num = Number(value);
  if (!Number.isFinite(num)) return '';
  const abs = Math.abs(num);
  if (abs >= 100) return String(Math.round(num));
  if (abs >= 10) return String(Math.round(num * 10) / 10);
  if (abs >= 1) return String(Math.round(num * 100) / 100);
  return String(Math.round(num * 1000) / 1000);
}

function formatYHoverValue(value) {
  const formatted = formatYAxisLabel(value);
  const unit = String(props.yAxisUnit || '').trim();
  return unit ? `${formatted} ${unit}` : formatted;
}

function pressureYTicker(min, max, pixels) {
  const ticks = [];
  if (!Number.isFinite(min) || !Number.isFinite(max) || max <= min) {
    return [{ v: min || 0, label: formatYAxisLabel(min || 0) }];
  }
  const span = max - min;
  const targetMax = Math.max(4, Math.min(8, Math.floor((pixels || 280) / 36)));
  let usedStep = niceYStep(span);
  if (span / usedStep > targetMax + 2) {
    usedStep = niceYStep(span / Math.max(targetMax - 1, 1));
  }
  for (let value = Math.ceil(min / usedStep) * usedStep; value <= max + usedStep * 0.001; value += usedStep) {
    ticks.push({ v: Number(value.toFixed(8)), label: formatYAxisLabel(value) });
  }
  if (!ticks.length) {
    ticks.push({ v: min, label: formatYAxisLabel(min) });
    ticks.push({ v: max, label: formatYAxisLabel(max) });
  }
  return ticks;
}

const computedData = computed(() => {
  if (!activeSeriesEntries.value.length) {
    return [];
  }

  if (useElapsedXAxis.value) {
    const seriesPoints = buildElapsedSeriesPoints(activeSeriesEntries.value);
    // Align series onto one elapsed grid so multi-line overlays stay continuous/clear.
    return buildAlignedElapsedRows(seriesPoints);
  }

  return activeSeriesEntries.value[0].chart_data
    .map(([timeValue, value]) => {
      const date = toChartDate(timeValue);
      const ms = date.getTime();
      if (!Number.isFinite(ms) || value == null || Number.isNaN(Number(value))) {
        return null;
      }
      return props.showLimits
        ? [date, Number(value), props.warningLimit, props.criticalLimit]
        : [date, Number(value)];
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
  const yRange = getFullYRange();
  return `${rows.length}:${first}:${last}:${props.warningLimit}:${props.criticalLimit}:${props.stepPlot}:${props.showLimits}:${useElapsedXAxis.value}:${seriesLabels.value.join('|')}:${yRange ? yRange.join(',') : ''}`;
});

function pad(n, len = 2) {
  return String(n).padStart(len, '0');
}

function formatAxisTime(ms, spanMs) {
  const d = new Date(ms);
  if (!Number.isFinite(ms)) {
    return '';
  }
  const datePart = `${pad(d.getDate())}/${pad(d.getMonth() + 1)}/${String(d.getFullYear()).slice(-2)}`;
  const timePart = `${pad(d.getHours())}:${pad(d.getMinutes())}:${pad(d.getSeconds())}`;
  if (spanMs > 14 * 24 * 3600 * 1000) {
    return `${pad(d.getDate())}/${pad(d.getMonth() + 1)}/${String(d.getFullYear()).slice(-2)}`;
  }
  if (spanMs > 2 * 24 * 3600 * 1000) {
    return `${datePart}\n${pad(d.getHours())}:${pad(d.getMinutes())}`;
  }
  return `${datePart}\n${timePart}`;
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

function formatElapsedNumber(value, maxDecimals = 1) {
  const rounded = Number(value.toFixed(maxDecimals));
  if (Number.isInteger(rounded)) {
    return String(rounded);
  }
  return String(rounded);
}

function formatElapsedSeconds(ms) {
  const elapsedMs = ms - COMPARE_EPOCH_BASE;
  if (!Number.isFinite(elapsedMs) || elapsedMs < 0) {
    return '0 s';
  }
  if (elapsedMs >= 60000) {
    return `${formatElapsedNumber(elapsedMs / 60000, 1)} min`;
  }
  if (elapsedMs >= 1000) {
    return `${formatElapsedNumber(elapsedMs / 1000, 1)} s`;
  }
  if (elapsedMs === 0) {
    return '0 s';
  }
  return `${formatElapsedNumber(elapsedMs / 1000, 2)} s`;
}

function compareModeXTicker(min, max, pixels) {
  const span = max - min;
  if (!Number.isFinite(span) || span <= 0) {
    return [{ v: min, label: formatElapsedSeconds(min) }];
  }
  const targetTicks = Math.max(5, Math.min(9, Math.floor((pixels || 600) / 85)));
  const step = niceTimeStep(span, targetTicks);
  const first = Math.ceil(min / step) * step;
  const ticks = [];
  for (let t = first; t <= max + step * 0.001; t += step) {
    ticks.push({ v: t, label: formatElapsedSeconds(t) });
  }
  if (!ticks.length) {
    ticks.push({ v: min, label: formatElapsedSeconds(min) });
    ticks.push({ v: max, label: formatElapsedSeconds(max) });
  }
  return ticks;
}

function getCustomInteractionModel() {
  const model = Object.assign({}, dygraph.defaultInteractionModel);
  const origMouseDown = model.mousedown;
  
  model.mousedown = function(event, g, context) {
    if (event.button === 1) { // Middle click
      event.preventDefault();
      const mockEvent = new MouseEvent('mousedown', {
        bubbles: event.bubbles,
        cancelable: event.cancelable,
        clientX: event.clientX,
        clientY: event.clientY,
        button: 0,
        buttons: 1,
        shiftKey: true,
        view: window,
      });
      document.body.style.cursor = 'move';
      origMouseDown(mockEvent, g, context);
    } else {
      origMouseDown(event, g, context);
    }
  };
  
  const origMouseUp = model.mouseup;
  model.mouseup = function(event, g, context) {
    if (context.isPanning) {
      document.body.style.cursor = 'default';
    }
    origMouseUp(event, g, context);
  };
  
  return model;
}

function buildOptions() {
  const pressureUi = isPressureCompareUi.value;
  const elapsedAxis = useElapsedXAxis.value;
  const includeLimits = props.showLimits;
  const multiSeries = activeSeriesEntries.value.length > 1;
  const labels = includeLimits
    ? ['Date', ...seriesLabels.value, 'Warning Limit', 'Critical Limit']
    : ['Date', ...seriesLabels.value];

  // All non-pressure parameters: original Dygraph look (do not change)
  if (!pressureUi) {
    return {
      labels: includeLimits
        ? ['Date', 'Value', 'Warning Limit', 'Critical Limit']
        : ['Date', 'Value'],
      strokeWidth: 3,
      fillGraph: true,
      fillAlpha: 0.3,
      drawPoints: false,
      drawGrid: false,
      animatedZooms: true,
      highlightCircleSize: 4,
      axisLineWidth: 4,
      axisLineColor: 'black',
      stepPlot: true,
      colors: includeLimits
        ? ['rgb(5, 150, 105)', 'rgb(255, 153, 51)', 'rgb(255, 0, 0)']
        : ['rgb(5, 150, 105)'],
      showLabelsOnHighlight: false,
      highlightCallback: handleHover,
    };
  }

  const baseSeriesConfig = Object.fromEntries(
    seriesLabels.value.map((label, index) => {
      const isBaseline = !!activeSeriesEntries.value[index]?.baseline;
      return [label, {
        strokeWidth: isBaseline ? 3.2 : (multiSeries ? 1.5 : 1.8),
        drawPoints: false,
        color: seriesColors.value[index],
        fillGraph: false,
      }];
    })
  );
  const colors = includeLimits
    ? [...seriesColors.value, 'rgb(245, 158, 11)', 'rgb(239, 68, 68)']
    : [...seriesColors.value];
  const limitSeriesConfig = includeLimits
    ? {
      'Warning Limit': {
        strokePattern: [8, 4],
        strokeWidth: 1.4,
        fillGraph: false,
      },
      'Critical Limit': {
        strokePattern: [6, 3],
        strokeWidth: 1.4,
        fillGraph: false,
      },
    }
    : {};
  const yRange = getFullYRange();
  const hasBaselineSeries = activeSeriesEntries.value.some((entry) => !!entry.baseline);

  return {
    labels,
    strokeWidth: hasBaselineSeries ? 3.2 : (multiSeries ? 1.5 : 1.8),
    strokeBorderWidth: 0,
    fillGraph: false,
    fillAlpha: 0,
    drawPoints: false,
    connectSeparatedPoints: false,
    drawGrid: true,
    gridLineColor: '#cbd5e1',
    gridLineWidth: 1,
    gridLinePattern: [4, 4],
    animatedZooms: true,
    highlightCircleSize: 3,
    axisLineWidth: 1,
    axisLineColor: '#94a3b8',
    axisLabelFontSize: 11,
    xLabelHeight: elapsedAxis ? 28 : 52,
    stepPlot: props.stepPlot,
    colors,
    legend: 'never',
    labelsSeparateLines: true,
    showLabelsOnHighlight: false,
    interactionModel: getCustomInteractionModel(),
    highlightCallback: handleHover,
    unhighlightCallback: hideHoverTooltip,
    zoomCallback: (minDate, maxDate) => updateZoomState(minDate, maxDate),
    underlayCallback: (ctx, area) => {
      ctx.save();
      ctx.fillStyle = '#ffffff';
      ctx.fillRect(area.x, area.y, area.w, area.h);
      ctx.restore();
    },
    series: {
      ...baseSeriesConfig,
      ...limitSeriesConfig,
    },
    axes: {
      x: {
        pixelsPerLabel: 72,
        drawGrid: true,
        ticker: elapsedAxis ? compareModeXTicker : timeSeriesXTicker,
        axisLabelFormatter: (ms, gran, opts, dg) => {
          if (elapsedAxis) {
            return formatElapsedSeconds(ms);
          }
          const range = dg?.xAxisRange?.();
          const span = range ? (range[1] - range[0]) : (getFullXRange()?.[1] - getFullXRange()?.[0]) || 0;
          return formatAxisTime(ms, span);
        },
        valueFormatter: (ms) => (
          elapsedAxis ? formatElapsedSeconds(ms) : formatHoverTime(ms)
        ),
      },
      y: {
        drawGrid: true,
        pixelsPerLabel: 36,
        ...(yRange ? { valueRange: yRange, independentTicks: true, ticker: pressureYTicker } : {}),
        axisLabelFormatter: (y) => formatYAxisLabel(y),
        valueFormatter: (y) => formatYHoverValue(y),
      },
    },
  };
}

function hideHoverTooltip() {
  hoverTooltip.value.visible = false;
}

function handleHover(event, x, points) {
  emit('data-hovered', points || []);

  if (!isPressureCompareUi.value || !Array.isArray(points) || !points.length) {
    hideHoverTooltip();
    return;
  }

  const xText = useElapsedXAxis.value
    ? formatElapsedSeconds(x)
    : formatHoverTime(x);

  const yLines = points
    .filter((point) => (
      point
      && point.name
      && !String(point.name).includes('Limit')
      && point.yval != null
      && !Number.isNaN(Number(point.yval))
    ))
    .map((point) => {
      let seriesColor = 'rgb(15, 23, 42)';
      if (chart.value) {
        const props = chart.value.getPropertiesForSeries(point.name);
        if (props && props.color) {
          seriesColor = props.color;
        }
      }
      return {
        label: point.name,
        value: formatYHoverValue(point.yval),
        color: seriesColor,
      };
    });

  if (!yLines.length) {
    hideHoverTooltip();
    return;
  }

  let canvasX = 0;
  let canvasY = 0;

  let left = 12;
  let top = 12;
  if (event && plotArea.value && chartContainer.value) {
    const plotRect = plotArea.value.getBoundingClientRect();
    const canvasRect = chartContainer.value.getBoundingClientRect();
    
    const mouseX = event.clientX - plotRect.left;
    const mouseY = event.clientY - plotRect.top;

    const validPoints = points.filter((p) => p.canvasx != null && !Number.isNaN(p.canvasx));
    if (validPoints.length > 0) {
      const offsetX = canvasRect.left - plotRect.left;
      const offsetY = canvasRect.top - plotRect.top;
      
      canvasX = validPoints[0].canvasx + offsetX;
      
      let minDiff = Infinity;
      let snappedY = validPoints[0].canvasy;
      
      for (const p of validPoints) {
        if (p.canvasy != null && !Number.isNaN(p.canvasy) && !String(p.name).includes('Limit')) {
          const pMouseY = p.canvasy + offsetY;
          const diff = Math.abs(pMouseY - mouseY);
          if (diff < minDiff) {
            minDiff = diff;
            snappedY = p.canvasy;
          }
        }
      }
      canvasY = snappedY + offsetY;
    } else {
      canvasX = mouseX;
      canvasY = mouseY;
    }

    left = Math.min(Math.max(8, mouseX + 14), Math.max(8, plotRect.width - 240));
    top = Math.min(Math.max(8, mouseY + 14), Math.max(8, plotRect.height - (70 + yLines.length * 24)));
  }

  hoverTooltip.value = {
    visible: true,
    left,
    top,
    xText,
    yLines,
    canvasX,
    canvasY,
  };
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
  if (!isPressureCompareUi.value || !chart.value) {
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
  nextTick(() => {
    bindWheelListeners();
    setupResizeObserver();
    try {
      chart.value?.resize();
    } catch (_) {
      // ignore
    }
  });
}

onMounted(() => {
  watch(dataFingerprint, () => {
    syncChart();
  }, { immediate: true });
  nextTick(() => {
    bindWheelListeners();
    setupResizeObserver();
  });
});

let resizeObserver = null;

function setupResizeObserver() {
  const target = plotArea.value || chartContainer.value;
  if (!target || typeof ResizeObserver === 'undefined') {
    return;
  }
  resizeObserver?.disconnect();
  resizeObserver = new ResizeObserver(() => {
    if (!chart.value) return;
    try {
      chart.value.resize();
    } catch (_) {
      // chart may be mid-destroy
    }
  });
  resizeObserver.observe(target);
}

onBeforeUnmount(() => {
  unbindWheelListeners();
  if (resizeObserver) {
    resizeObserver.disconnect();
    resizeObserver = null;
  }
  if (chart.value) {
    chart.value.destroy();
    chart.value = null;
  }
});
</script>

<template>
  <!-- Original simple chart for every non-pressure parameter -->
  <div
    v-if="!isPressureCompareUi"
    ref="chartContainer"
    class="dygraph-chart-simple"
  />

  <!-- Pressure / air-honing compare UI only -->
  <div
    v-else
    class="dygraph-chart-panel dygraph-chart-panel--pressure"
  >
    <div
      v-if="!hideHints || externalLegend.length || isZoomed || activeSeriesEntries.length > 0"
      class="dygraph-chart-toolbar"
      :class="{ 'dygraph-chart-toolbar--legend-only': hideHints }"
    >
      <div v-if="!hideHints" class="dygraph-chart-hints">
        <span class="dygraph-hint-chip">Scroll — zoom in / out</span>
        <span class="dygraph-hint-chip">Drag — select range</span>
        <span class="dygraph-hint-chip">Shift+Drag — pan</span>
        <span class="dygraph-hint-chip">Double-click / Reset — full view</span>
      </div>
      <div class="dygraph-toolbar-right">
        <div v-if="externalLegend.length" class="dygraph-external-legend">
          <span
            v-for="item in externalLegend"
            :key="item.label"
            class="dygraph-legend-item"
          >
            <span
              class="dygraph-legend-item__marker"
              :class="{ 'dygraph-legend-item__marker--line': item.dashed }"
              :style="item.dashed ? { borderColor: item.color } : { backgroundColor: item.color }"
            />
            <span class="dygraph-legend-item__label">{{ item.label }}</span>
          </span>
        </div>
        <div v-else-if="activeSeriesEntries.length > 0" class="dygraph-series-chips">
          <span
            v-for="(entry, index) in activeSeriesEntries"
            :key="entry.label"
            class="dygraph-series-chip"
          >
            <span
              class="dygraph-series-chip__dot"
              :style="{ backgroundColor: seriesColors[index] }"
            />
            {{ entry.shortLabel }}
          </span>
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
    </div>

    <div class="dygraph-chart-body">
      <div class="dygraph-y-label">
        {{ yAxisLabel }}
      </div>
      <div
        ref="plotArea"
        class="dygraph-chart-plot-area dygraph-chart-plot-area--wheel"
      >
        <div ref="chartContainer" class="dygraph-chart-canvas" />
        
        <!-- Crosshairs -->
        <div
          v-if="hoverTooltip.visible"
          class="dygraph-crosshair-x"
          :style="{ left: `${hoverTooltip.canvasX}px` }"
        />
        <div
          v-if="hoverTooltip.visible"
          class="dygraph-crosshair-y"
          :style="{ top: `${hoverTooltip.canvasY}px` }"
        />

        <div
          v-if="hoverTooltip.visible"
          class="dygraph-custom-tooltip"
          :style="{ left: `${hoverTooltip.left}px`, top: `${hoverTooltip.top}px` }"
        >
          <div class="dygraph-custom-tooltip__meta">
            <div class="dygraph-custom-tooltip__meta-row">
              <span class="dygraph-custom-tooltip__meta-key">Elapsed</span>
              <span class="dygraph-custom-tooltip__meta-val">{{ hoverTooltip.xText }}</span>
            </div>
          </div>
            <div
              v-for="(line, idx) in hoverTooltip.yLines"
              :key="idx"
              class="dygraph-custom-tooltip__row"
            >
              <div class="dygraph-custom-tooltip__swatch" :style="{ backgroundColor: line.color }" />
              <div class="dygraph-custom-tooltip__key">{{ line.label }}</div>
              <div class="dygraph-custom-tooltip__val">{{ line.value }}</div>
            </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* Original non-pressure chart — no extra borders / custom fonts */
.dygraph-chart-simple {
  width: 100%;
  min-height: 360px;
  height: 440px;
}

/* Pressure compare UI only */
.dygraph-chart-panel--pressure {
  width: 100%;
  height: 100%;
  min-height: 280px;
  display: flex;
  flex-direction: column;
  border: none;
  box-shadow: none;
  background: transparent;
}

.dygraph-chart-toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
  flex-wrap: wrap;
  padding: 6px 10px;
  border-bottom: 1px solid rgb(226, 232, 240);
  background: rgb(248, 250, 252);
}

.dygraph-chart-toolbar--legend-only {
  justify-content: flex-end;
  border-bottom: none;
  background: transparent;
  padding: 2px 4px 6px;
}

.dygraph-toolbar-right {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: flex-end;
  gap: 8px;
  margin-left: auto;
}

.dygraph-external-legend {
  display: flex;
  flex-wrap: wrap;
  justify-content: flex-end;
  gap: 10px;
  max-width: 520px;
}

.dygraph-legend-item {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  font-size: 10px;
  font-weight: 700;
  color: rgb(51, 65, 85);
}

.dygraph-legend-item__marker {
  width: 10px;
  height: 10px;
  display: inline-block;
  flex-shrink: 0;
}

.dygraph-legend-item__marker--line {
  width: 16px;
  height: 0;
  border-top: 2px dashed;
  background: transparent !important;
}

.dygraph-legend-item__label {
  max-width: 280px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.dygraph-chart-hints {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.dygraph-hint-chip {
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  color: #64748b;
  background: #ffffff;
  border: 1px solid #cbd5e1;
  border-radius: 2px;
  padding: 3px 8px;
  white-space: nowrap;
  font-family: 'Manrope', sans-serif;
}

.dygraph-reset-btn {
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  color: #0284c7;
  background: #f0f9ff;
  border: 1px solid #bae6fd;
  border-radius: 2px;
  padding: 4px 8px;
  cursor: pointer;
  font-family: 'Manrope', sans-serif;
  transition: all 0.15s ease;
}

.dygraph-reset-btn:hover {
  background: #e0f2fe;
}

.dygraph-series-chips {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.dygraph-series-chip {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  color: #64748b;
  background: #f8fafc;
  border: 1px solid #cbd5e1;
  border-radius: 2px;
  padding: 4px 8px;
  font-family: 'Manrope', sans-serif;
}

.dygraph-series-chip__dot {
  width: 10px;
  height: 10px;
  border-radius: 2px;
  display: inline-block;
}

.dygraph-chart-body {
  display: flex;
  align-items: stretch;
  min-height: 0;
  padding: 2px 8px 4px 2px;
  flex: 1;
}

.dygraph-y-label {
  writing-mode: vertical-rl;
  transform: rotate(180deg);
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: #64748b;
  text-align: center;
  padding: 8px 4px;
  flex-shrink: 0;
  font-family: 'Manrope', sans-serif;
}

.dygraph-chart-plot-area {
  position: relative;
  flex: 1;
  min-width: 0;
  min-height: 0;
  border: 1px solid #e2e8f0;
  border-radius: 3px;
  background: #ffffff;
  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.05);
  box-sizing: border-box;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  padding: 4px 6px 4px 4px;
}

.dygraph-chart-plot-area--wheel {
  cursor: crosshair;
}

.dygraph-chart-canvas {
  width: 100%;
  flex: 1;
  min-height: 0;
  height: 100%;
  box-sizing: border-box;
  border-radius: 3px;
  background: #ffffff;
}

.dygraph-crosshair-x {
  position: absolute;
  top: 0;
  bottom: 0;
  width: 1px;
  border-left: 1px dashed #94a3b8;
  pointer-events: none;
  z-index: 20;
}

.dygraph-crosshair-y {
  position: absolute;
  left: 0;
  right: 0;
  height: 1px;
  border-top: 1px dashed #94a3b8;
  pointer-events: none;
  z-index: 20;
}

.dygraph-custom-tooltip {
  position: absolute;
  z-index: 30;
  min-width: 210px;
  max-width: 320px;
  padding: 10px 12px;
  background: rgba(255, 255, 255, 0.98);
  border: 1px solid #cbd5e1;
  border-radius: 3px;
  box-shadow: 0 10px 25px -5px rgba(15, 23, 42, 0.1);
  pointer-events: none;
}

.dygraph-custom-tooltip__meta {
  padding-bottom: 8px;
  margin-bottom: 8px;
  border-bottom: 1px solid rgb(203, 213, 225);
}

.dygraph-custom-tooltip__meta-row {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: 12px;
  margin-top: 4px;
}

.dygraph-custom-tooltip__meta-row:first-child {
  margin-top: 0;
}

.dygraph-custom-tooltip__meta-key {
  font-family: 'Manrope', sans-serif;
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  color: rgb(100, 116, 139);
}

.dygraph-custom-tooltip__meta-val {
  font-family: 'JetBrains Mono', 'Roboto Mono', monospace;
  font-size: 12px;
  font-weight: 800;
  color: rgb(15, 23, 42);
  font-variant-numeric: tabular-nums;
  white-space: nowrap;
}

.dygraph-custom-tooltip__row {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-top: 6px;
}

.dygraph-custom-tooltip__row:first-of-type {
  margin-top: 0;
}

.dygraph-custom-tooltip__swatch {
  width: 9px;
  height: 9px;
  flex-shrink: 0;
  border-radius: 2px;
}

.dygraph-custom-tooltip__key {
  font-family: 'Manrope', sans-serif;
  flex: 1;
  min-width: 0;
  font-size: 11px;
  font-weight: 700;
  color: rgb(51, 65, 85);
  line-height: 1.25;
  word-break: break-word;
}

.dygraph-custom-tooltip__val {
  font-family: 'JetBrains Mono', 'Roboto Mono', monospace;
  font-size: 12px;
  font-weight: 800;
  color: rgb(15, 23, 42);
  white-space: nowrap;
  font-variant-numeric: tabular-nums;
}

.dygraph-chart-panel--pressure :deep(.dygraph-axis-label-x) {
  font-family: 'JetBrains Mono', 'Roboto Mono', monospace;
  font-size: 11px;
  font-weight: 800;
  color: rgb(30, 41, 59);
  white-space: pre-line;
  line-height: 1.25;
  text-align: center;
  padding-top: 4px;
}

.dygraph-chart-panel--pressure :deep(.dygraph-axis-label-y) {
  font-family: 'JetBrains Mono', 'Roboto Mono', monospace;
  font-size: 11px;
  font-weight: 800;
  color: rgb(30, 41, 59);
}

.dygraph-chart-panel--pressure :deep(.dygraph-legend) {
  display: none;
}
</style>
