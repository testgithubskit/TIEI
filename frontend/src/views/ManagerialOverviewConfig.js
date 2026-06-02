// ==========================================================
// ISOMETRIC DESIGN CONFIGURATION FOR FACTORY OVERVIEW
// ==========================================================
export const CONFIG = {
  // ── Typography ──────────────────────────────────────────
  // Google Fonts URL to load (set to '' to skip loading)
  fontUrl: 'https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@400;500;600;700;800&family=Manrope:wght@300;400;500;600;700;800&display=swap',
  // Font family stack for this screen
  fontFamily: "'Manrope', sans-serif",
  // Premium condensed font family stack for tooltips
  tooltipFontFamily: "'Barlow Condensed', sans-serif",

  // ── Tile Geometry ───────────────────────────────────────
  tileWidth: 140,   // Width of each isometric tile cell in pixels
  tileHeight: 70,   // Height of each isometric tile cell in pixels

  // ── Infinite Grid ───────────────────────────────────────
  gridMin: -100,
  gridMax: 100,

  // ── Origin ──────────────────────────────────────────────
  originX: 540,
  originY: 150,

  // ── Grid Line & Border Styling ──────────────────────────
  gridLineColor: 'rgba(148, 163, 184, 0.12)',
  gridLineWidth: 1.0,
  gridBorderColor: '#000000', // Configurable grid border outline color
  gridBorderWidth: 2.0,       // Configurable grid border outline width

  // ── Machine Layout ──────────────────────────────────────
  machineSpacing: 1.0,    // Spacing factor between machines along a row
  lineGap: 1,             // Empty grid cells between production lines
  machinesPerRow: 10,     // Wrap to next row after this many machines

  // ── Initial Skeleton (machines per line before backend loads) ──
  // Used to render placeholder shimmering machines while API loads
  // Array index maps to line index: [line0, line1, line2, ...]
  defaultLineMachines: [7, 14, 38],

  // ── Hover Interaction ───────────────────────────────────
  hoverScale: 1.15,       // Scale factor on hover

  // ── View Fitting ────────────────────────────────────────
  viewPadding: 80,        // Padding around auto-fit bounding box (SVG units)

  // ── Machine Image Sizing & Anchoring ────────────────────
  machineWidth: 75,
  machineHeight: 75,
  machineAnchorYPercent: 0.30,

  // ── Coordinate Offsets ──────────────────────────────────
  machineGridUOffset: 0.5,
  machineGridVOffset: 0.5,
  machinePixelOffsetX: 0,
  machinePixelOffsetY: 0,

  // ── State Color Filters (CSS filter applied to machine SVG) ──
  useFilters: true,
  stateFilters: {
    OK: '',

    WARNING: 'sepia(0.25) saturate(1.4) hue-rotate(0deg) brightness(1.02)',

    CRITICAL: 'sepia(0.35) saturate(1.8) hue-rotate(320deg) brightness(0.94)',

    DISCONNECTED: 'grayscale(0.85) contrast(0.80) saturate(0.1)',

    UNKNOWN: 'grayscale(0.7) opacity(0.7)'
  },

  // ── Status Colors (tooltips, left panel badges, dots) ───
  statusColors: {
    'OK': { bg: '#ecfdf5', text: '#047857', dot: '#34d399', border: '#a7f3d0' },
    'WARNING': { bg: '#fffbeb', text: '#b45309', dot: '#fbbf24', border: '#fde68a' },
    'CRITICAL': { bg: '#fef2f2', text: '#dc2626', dot: '#f87171', border: '#fecaca' },
    'DISCONNECTED': { bg: '#f1f5f9', text: '#64748b', dot: '#94a3b8', border: '#cbd5e1' }
  },

  // ── Tooltip Styling ─────────────────────────────────────
  tooltipFontSize: 10.5,
  tooltipPaddingX: 8,
  tooltipPaddingY: 4,
  tooltipOffsetY: 22,      // Distance above the machine image
  tooltipArrowSize: 5,     // Height of the triangle arrow
  tooltipCornerRadius: 0,  // Corner radius (0 for sharp corners)
  tooltipBgColor: '#090d16', // Configurable tooltip background color
  tooltipTextColor: '#ffffff', // Configurable tooltip font text color

  // ── Production Line Label Customization ──────────────────
  lineLabelSettings: {
    fontSize: 28,
    fontWeight: '900',
    letterSpacing: '1.5px',
    textColor: '#ffffff',      // Default text color
    bgColor: '#000000',        // Default background capsule color
    borderColor: '#ffffff',    // Default border outline color
    borderWidth: 2,            // Default border outline width
    box: true,                 // Default whether to show background capsule box
    width: 1.45,                // Default capsule width in grid coordinates
    height: 0.45,              // Default capsule height in grid coordinates
    textPadding: 0.15,         // Padding from left edge of box in grid coordinates

    // Manual overrides and offsets (U/V coordinate offsets) for each line label
    lines: {
      BLOCK: { text: 'BLOCK', uOffset: 0.25, vOffset: -0.53, textColor: '#ffffff', bgColor: '#000000', borderColor: '#ffffff' },
      CRANK: { text: 'CRANK', uOffset: -0.25, vOffset: -0.53, textColor: '#ffffff', bgColor: '#000000', borderColor: '#ffffff' },
      HEAD: { text: 'HEAD', uOffset: -1.25, vOffset: -0.53, textColor: '#ffffff', bgColor: '#000000', borderColor: '#ffffff' }
    }
  }
};

// Enable instant browser page refresh on config change / Ctrl+S
if (import.meta.hot) {
  import.meta.hot.accept(() => {
    window.location.reload();
  });
}
