<template>
  <LayoutGuest>
    <div :class="['mo-screen', 'mo-bg-' + panelTheme]" class="h-screen w-screen flex flex-col pt-3 px-3 pb-0 box-border overflow-hidden">
      <!-- Container for the two cards -->
      <div class="flex flex-1 gap-3 w-full h-full min-h-0">
        
        <!-- ================= LEFT CARD — NOC ALERT PANEL ================= -->
        <div :class="['noc-panel', 'noc-' + panelTheme]" class="h-full flex flex-col overflow-hidden rounded-md" style="width: 28%;">

          <!-- ── NOC Header Bar ── -->
          <div class="noc-header flex-shrink-0">
            <div class="flex items-center justify-between px-3 py-2 noc-header-top">
              <div class="flex items-center gap-2">
                <span class="noc-live-dot"></span>
                <span class="noc-title">FACTORY OVERVIEW</span>
              </div>
              <span class="noc-timestamp">{{ new Date().toLocaleTimeString('en-US', { hour12: false }) }}</span>
            </div>

            <!-- ── Metric Tiles ── -->
            <div class="grid grid-cols-5 gap-0 noc-metrics-grid">
              <div class="noc-metric-tile noc-metric-total">
                <div class="noc-metric-value">{{ totalMachines }}</div>
                <div class="noc-metric-label">TOTAL</div>
              </div>
              <div class="noc-metric-tile noc-metric-ok">
                <div class="noc-metric-value noc-ok">{{ totalOk }}</div>
                <div class="noc-metric-label noc-ok-label">OK</div>
              </div>
              <div class="noc-metric-tile noc-metric-warn">
                <div class="noc-metric-value noc-warn">{{ totalWarning }}</div>
                <div class="noc-metric-label noc-warn-label">WARNING</div>
              </div>
              <div class="noc-metric-tile noc-metric-crit">
                <div class="noc-metric-value noc-crit">{{ totalCritical }}</div>
                <div class="noc-metric-label noc-crit-label">CRITICAL</div>
              </div>
              <div class="noc-metric-tile noc-metric-disc">
                <div class="noc-metric-value noc-disc">{{ totalDisconnected }}</div>
                <div class="noc-metric-label noc-disc-label">DISCONNECTED</div>
              </div>
            </div>

            <!-- ── Status Summary Bar ── -->
            <div class="noc-status-bar">
              <div class="noc-status-bar-fill noc-bar-ok"    :style="{ flex: totalOk }"></div>
              <div class="noc-status-bar-fill noc-bar-warn"  :style="{ flex: totalWarning }"></div>
              <div class="noc-status-bar-fill noc-bar-crit"  :style="{ flex: totalCritical }"></div>
              <div class="noc-status-bar-fill noc-bar-disc"  :style="{ flex: totalDisconnected }"></div>
            </div>
          </div>

          <!-- ── Alert Feed Label ── -->
          <div class="noc-section-label">
            <svg class="w-3 h-3 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
              <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z"/>
            </svg>
            ACTIVE ALERTS
            <span class="noc-alert-count">{{ totalWarning + totalCritical + totalDisconnected }}</span>
          </div>

          <div class="noc-filters px-3 py-2 flex gap-2 overflow-x-auto" :class="panelTheme === 'dark' ? 'bg-[#0f1923] border-b border-[#334155]' : 'bg-[#f1f5f9] border-b border-[#e2e8f0]'">
             <button class="noc-filter-btn" :class="{ 'active': !activeLine }" @click="activeLine = null">ALL</button>
             <button v-for="line in availableLines" :key="line" 
                     class="noc-filter-btn" 
                     :class="[{ 'active': activeLine === line }, 'noc-filter-' + line.toLowerCase()]" 
                     @click="activeLine = activeLine === line ? null : line">
               {{ line }}
             </button>
          </div>

          <!-- ── Scrollable Alert Feed ── -->
          <div class="flex-1 overflow-y-auto noc-feed p-2 space-y-3">
            <div v-if="filteredAlerts.length === 0" class="noc-no-alerts flex flex-col items-center justify-center h-full py-8">
              <div class="w-10 h-10 mb-3 rounded-full flex items-center justify-center bg-emerald-500/10 text-emerald-500">
                <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12.75l6 6 9-13.5"/>
                </svg>
              </div>
              <span class="font-bold">All machines nominal</span>
              <span class="text-[10px] opacity-70 mt-1">No alerts for current filter.</span>
            </div>

            <!-- Grouped by Line -->
            <div v-else v-for="line in groupedAlerts" :key="line.name" class="noc-line-section">
              <!-- Line Section Header -->
              <div class="noc-line-sect-header flex justify-between items-center px-2.5 py-1.5 font-bold text-[10px] tracking-wider uppercase border">
                <span>{{ line.name }} LINE</span>
                <span class="noc-sect-badge px-1.5 py-0.5 rounded-full text-[9px] font-extrabold">
                  {{ line.alerts.length }}
                </span>
              </div>

              <!-- Alert Rows inside this Line -->
              <div class="noc-line-alerts-list border-x border-b overflow-hidden divide-y">
                <div v-for="(alert, idx) in line.alerts" :key="idx"
                     @click="logParameterDetails(alert.paramDetails, alert.machineName, alert.group)"
                     class="noc-alert-row cursor-pointer flex items-center p-2.5 transition-all duration-150"
                     :class="{
                       'noc-alert-crit-row': alert.state === 'CRITICAL',
                       'noc-alert-warn-row': alert.state === 'WARNING',
                       'noc-alert-disc-row': alert.state === 'DISCONNECTED'
                     }">
                  
                  <!-- Flex container for alert details -->
                  <div class="flex-1 min-w-0 flex items-center px-1">
                    <!-- Machine Name -->
                    <div class="w-[17%] shrink-0 font-bold truncate noc-machine-txt" :title="alert.machineName">
                      {{ formatMachineName(alert.machineName) }}
                    </div>
                    <!-- Group/Parameter Name -->
                    <div class="flex-1 min-w-0 font-bold truncate noc-group-txt" :title="alert.group">
                      {{ alert.group }}
                    </div>
                    <!-- Display Name (Max 3 chars) -->
                    <div class="w-[8%] shrink-0 font-semibold truncate text-center noc-display-txt" :title="alert.displayName">
                      {{ alert.displayName }}
                    </div>
                    <!-- Value & Unit -->
                    <div class="w-[10%] shrink-0 text-right font-black font-mono noc-value-txt" 
                         :class="{
                           'text-red-500': alert.state === 'CRITICAL',
                           'text-amber-500': alert.state === 'WARNING',
                           'text-slate-400': alert.state === 'DISCONNECTED'
                         }">
                      {{ alert.value }}
                    </div>
                  </div>
                  
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- ================= RIGHT CARD (72% Width - Isometric SVG) ================= -->
        <div class="h-full rounded-md shadow-sm flex flex-col overflow-hidden relative"
             :style="{ width: '72%', background: svgColors.panelBg, border: '1px solid ' + svgColors.panelBorder }">
          
          <!-- ── Right View Header Bar ── -->
          <div class="flex-shrink-0 flex items-center justify-between px-5 py-2.5 border-b noc-right-header"
               :class="panelTheme === 'dark' ? 'noc-dark-right-header' : 'noc-light-right-header'">
            <div class="flex items-center gap-4">
              <!-- TIEI Logo -->
              <img :src="tieiLogo" alt="TIEI Logo" class="h-8 w-auto max-w-[150px] object-contain opacity-95 hover:scale-105 transition-transform duration-200" />
              
              <!-- Vertical Divider -->
              <div class="h-6 w-px bg-slate-300 dark:bg-slate-700"></div>
              
              <!-- Title & Plant Name -->
              <div class="flex items-center gap-4">
                <span class="font-black tracking-widest text-[20px] uppercase leading-none noc-plant-name">
                  Toyota Industries Engine India
                </span>
                <span class="text-[11px] font-black tracking-widest uppercase px-2.5 py-1.5 transition-all duration-300"
                      :class="panelTheme === 'dark' ? 'noc-plant-badge-dark' : 'noc-plant-badge-light'">
                  TNGA Plant
                </span>
              </div>
            </div>
            
            <div class="flex items-center gap-5">

              
              <!-- CMTI Logo at the far right -->
              <div class="h-8 flex items-center justify-center">
                <img :src="panelTheme === 'dark' ? cmtiLogoWhite : cmtiLogoColor" 
                     alt="CMTI Logo" 
                     :class="panelTheme === 'dark' ? 'h-7' : 'h-11'"
                     class="w-auto max-w-[120px] object-contain opacity-95 hover:scale-105 transition-transform duration-200" />
              </div>
            </div>
          </div>

          <div class="flex-1 min-h-0 w-full relative p-4 flex items-center justify-center"
               :style="{ background: svgColors.bg }">
            
            <!-- Floating Live Connected Status HUD -->
            <div class="absolute top-4 left-4 flex items-center gap-2 px-3 py-1.5 rounded-lg backdrop-blur-md shadow-md z-10 select-none border"
                 :style="{ background: svgColors.hudBg, borderColor: svgColors.hudBorder }">
              <span class="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse"></span>
              <span class="text-[9.5px] font-extrabold tracking-wider uppercase font-mono" :style="{ color: svgColors.hudText }">
                <span class="text-[12px] font-black mr-1" :class="panelTheme === 'dark' ? 'text-white' : 'text-slate-900'">{{ totalMachines }}</span> Machines Connected
              </span>
            </div>
            
            <!-- Glassmorphic Loading HUD overlaying the active machine layout -->
            <div v-if="isLoading" class="absolute inset-0 bg-slate-900/10 dark:bg-slate-950/20 backdrop-blur-[1px] flex items-center justify-center z-20 pointer-events-none">
              <div class="flex items-center gap-3 px-5 py-3 rounded-xl bg-white/80 dark:bg-slate-900/80 backdrop-blur-md border border-slate-200/50 dark:border-slate-700/50 shadow-lg pointer-events-auto">
                <svg class="animate-spin h-5 w-5 text-indigo-600 dark:text-indigo-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                  <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="3"></circle>
                  <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                <span class="text-sm font-bold text-slate-700 dark:text-slate-200 tracking-wide">
                  Loading Live Factory Layout...
                </span>
              </div>
            </div>

            <!-- Isometric SVG Stage -->
            <svg ref="svgRef" :viewBox="computedViewBox" @wheel.prevent="handleWheel" @mousedown="handleMouseDown" @mousemove="handleMouseMove" @mouseup="handleMouseUp" @mouseleave="handleMouseLeave" preserveAspectRatio="xMidYMid meet" class="w-full h-full select-none outline-none">
              
              <defs>
                <filter id="base-glow-filter" x="-50%" y="-50%" width="200%" height="200%">
                  <feGaussianBlur stdDeviation="3" result="blur" />
                  <feColorMatrix type="matrix" values="1 0 0 0 0  0 1 0 0 0  0 0 1 0 0  0 0 0 1 0" />
                </filter>
              </defs>

              <!-- 1. BACKDROP GRID -->
              <g :stroke="svgColors.gridLine" :stroke-width="CONFIG.gridLineWidth" fill="none">
                <line v-for="u in gridUValues" :key="'grid-u-' + u"
                  :x1="isoToScreen(u, CONFIG.gridMin).x" :y1="isoToScreen(u, CONFIG.gridMin).y"
                  :x2="isoToScreen(u, CONFIG.gridMax).x" :y2="isoToScreen(u, CONFIG.gridMax).y"/>
                <line v-for="v in gridVValues" :key="'grid-v-' + v"
                  :x1="isoToScreen(CONFIG.gridMin, v).x" :y1="isoToScreen(CONFIG.gridMin, v).y"
                  :x2="isoToScreen(CONFIG.gridMax, v).x" :y2="isoToScreen(CONFIG.gridMax, v).y"/>
              </g>

              <!-- 1.5. ISOMETRIC LINE LABELS (flat on floor, parallel to U-axis) -->
              <g v-for="label in lineLabels" :key="label.name">
                <!-- Slanted Black Background Box (runs parallel to U-axis, styled dynamically via config) -->
                <polygon v-if="label.box"
                  :points="`
                    ${isoToScreen(label.u - label.halfWidth, label.v - label.halfHeight).x},${isoToScreen(label.u - label.halfWidth, label.v - label.halfHeight).y}
                    ${isoToScreen(label.u + label.halfWidth, label.v - label.halfHeight).x},${isoToScreen(label.u + label.halfWidth, label.v - label.halfHeight).y}
                    ${isoToScreen(label.u + label.halfWidth, label.v + label.halfHeight).x},${isoToScreen(label.u + label.halfWidth, label.v + label.halfHeight).y}
                    ${isoToScreen(label.u - label.halfWidth, label.v + label.halfHeight).x},${isoToScreen(label.u - label.halfWidth, label.v + label.halfHeight).y}
                  `"
                  :fill="svgColors.labelBg"
                  :stroke="svgColors.labelBorder"
                  :stroke-width="label.borderWidth"
                />
                <!-- Slanted White Text (rotated flat along U-axis, styled dynamically via config) -->
                <text 
                  :transform="`matrix(0.7, 0.35, -0.7, 0.35, ${isoToScreen(label.u - label.halfWidth + label.textPadding, label.v).x}, ${isoToScreen(label.u - label.halfWidth + label.textPadding, label.v).y})`"
                  text-anchor="start"
                  dominant-baseline="central"
                  :fill="svgColors.labelText"
                  :font-size="label.fontSize"
                  :font-weight="label.fontWeight"
                  :letter-spacing="label.letterSpacing"
                  :font-family="CONFIG.fontFamily"
                >{{ label.name }}</text>
              </g>

              <!-- 2. MACHINE IMAGES + TOOLTIPS (depth-sorted) -->
              <g v-for="machine in sortedPlacedMachines" :key="machine.machine_name"
                 :style="{ 
                   cursor: isLoading ? 'default' : 'pointer'
                 }"
                 :opacity="activeLine && activeLine !== machine.lineName ? 0.25 : 1.0"
                 @mouseenter="!isLoading && (hoveredMachine = machine.machine_name)"
                 @mouseleave="hoveredMachine = null"
                 @click.stop="!isLoading && showMachineDetails(machine)">
                
                <!-- ── 3D ISOMETRIC PLATFORM (BASE) ── -->
                <!-- Base Glow Shadow (Rhombus) -->
                <polygon v-if="!isLoading && getPlatformColors(machine.machine_state).hasGlow"
                         :points="`
                           ${getMachineX(machine) + CONFIG.machineWidth/2 - rx - 4},${getMachineY(machine) + anchorY + h + 1}
                           ${getMachineX(machine) + CONFIG.machineWidth/2},${getMachineY(machine) + anchorY + h + ry + 2 + 1}
                           ${getMachineX(machine) + CONFIG.machineWidth/2 + rx + 4},${getMachineY(machine) + anchorY + h + 1}
                           ${getMachineX(machine) + CONFIG.machineWidth/2},${getMachineY(machine) + anchorY + h - ry - 2 + 1}
                         `"
                         :fill="getPlatformColors(machine.machine_state).glow" 
                         opacity="0.65" 
                         filter="url(#base-glow-filter)" />

                <!-- Base 3D Left Side Wall -->
                <path v-if="!isLoading"
                      :d="`M ${getMachineX(machine) + CONFIG.machineWidth/2 - rx} ${getMachineY(machine) + anchorY}
                           L ${getMachineX(machine) + CONFIG.machineWidth/2} ${getMachineY(machine) + anchorY + ry}
                           L ${getMachineX(machine) + CONFIG.machineWidth/2} ${getMachineY(machine) + anchorY + ry + h}
                           L ${getMachineX(machine) + CONFIG.machineWidth/2 - rx} ${getMachineY(machine) + anchorY + h}
                           Z`"
                      :fill="getPlatformColors(machine.machine_state).sideLeft"
                      :stroke="getPlatformColors(machine.machine_state).stroke"
                      stroke-width="0.8" />

                <!-- Base 3D Right Side Wall -->
                <path v-if="!isLoading"
                      :d="`M ${getMachineX(machine) + CONFIG.machineWidth/2} ${getMachineY(machine) + anchorY + ry}
                           L ${getMachineX(machine) + CONFIG.machineWidth/2 + rx} ${getMachineY(machine) + anchorY}
                           L ${getMachineX(machine) + CONFIG.machineWidth/2 + rx} ${getMachineY(machine) + anchorY + h}
                           L ${getMachineX(machine) + CONFIG.machineWidth/2} ${getMachineY(machine) + anchorY + ry + h}
                           Z`"
                      :fill="getPlatformColors(machine.machine_state).sideRight"
                      :stroke="getPlatformColors(machine.machine_state).stroke"
                      stroke-width="0.8" />

                <!-- Base Top Face (Rhombus) -->
                <polygon v-if="!isLoading"
                         :points="`
                           ${getMachineX(machine) + CONFIG.machineWidth/2 - rx},${getMachineY(machine) + anchorY}
                           ${getMachineX(machine) + CONFIG.machineWidth/2},${getMachineY(machine) + anchorY - ry}
                           ${getMachineX(machine) + CONFIG.machineWidth/2 + rx},${getMachineY(machine) + anchorY}
                           ${getMachineX(machine) + CONFIG.machineWidth/2},${getMachineY(machine) + anchorY + ry}
                         `"
                         :fill="getPlatformColors(machine.machine_state).top"
                         :stroke="getPlatformColors(machine.machine_state).stroke"
                         stroke-width="0.8" />

                <!-- Nested Group for Machine + Tooltip scaling together on hover -->
                <g
                  :style="{ 
                    transformOrigin: `${getMachineX(machine) + CONFIG.machineWidth/2}px ${getMachineY(machine) + anchorY}px`,
                    transform: (!isLoading && hoveredMachine === machine.machine_name) ? `scale(${CONFIG.hoverScale || 1.15})` : 'scale(1)',
                    transition: 'transform 0.2s cubic-bezier(0.34, 1.56, 0.64, 1)'
                  }"
                >
                  <!-- Machine Image (sitting on platform) -->
                  <image 
                    :href="machineSvg"
                    :x="getMachineX(machine)"
                    :y="getMachineY(machine)"
                    :width="CONFIG.machineWidth"
                    :height="CONFIG.machineHeight"
                    :class="{ 'loading-machine': isLoading }"
                    :style="{ 
                      filter: isLoading ? 'grayscale(0.5) contrast(0.9)' : (CONFIG.useFilters ? (getMachineFilter(machine.machine_state) || '') : 'none')
                    }"
                  />

                  <!-- ── HIGH-CONTRAST TOOLTIP LABEL ── -->
                  <g v-if="shouldShowTooltip(machine)"
                     :class="{ 'noc-tooltip-bounce': machine.machine_state === 'WARNING' || machine.machine_state === 'CRITICAL' || machine.machine_state === 'DISCONNECTED' }">
                    <!-- Shadowed Tooltip Path (Sharp corners + bottom arrow tip) -->
                    <path 
                      :d="getTooltipPath(machine)"
                      :fill="svgColors.tooltipBg"
                      :stroke="getTooltipStroke(machine)"
                      stroke-width="1.8"
                      opacity="0.97"
                    />
                    <!-- Tooltip Text centered inside the box using original font stack -->
                    <text 
                      :x="getMachineX(machine) + CONFIG.machineWidth/2"
                      :y="getMachineY(machine) - CONFIG.tooltipOffsetY + 2"
                      text-anchor="middle"
                      dominant-baseline="central"
                      :fill="svgColors.tooltipText"
                      font-size="10.5"
                      font-weight="800"
                      :font-family="CONFIG.fontFamily"
                    >{{ formatMachineName(machine.machine_name) }}</text>
                  </g>
                </g>
              </g>
            </svg>
            
            <!-- Glassmorphic Zoom Controls HUD -->
            <div class="absolute bottom-4 left-4 flex items-center gap-1.5 px-3 py-1.5 rounded-lg backdrop-blur-md shadow-md z-10 select-none"
                 :style="{ background: svgColors.hudBg, border: '1px solid ' + svgColors.hudBorder }">
              <button @click="zoomOut" class="p-1.5 rounded transition-colors flex items-center justify-center"
                      :style="{ color: svgColors.hudText }" title="Zoom Out">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" class="w-4 h-4">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M5 12h14" />
                </svg>
              </button>
              <span class="text-xs font-mono font-bold min-w-[45px] text-center" :style="{ color: svgColors.hudText }">
                {{ Math.round(zoomScale * 100) }}%
              </span>
              <button @click="zoomIn" class="p-1.5 rounded transition-colors flex items-center justify-center"
                      :style="{ color: svgColors.hudText }" title="Zoom In">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" class="w-4 h-4">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
                </svg>
              </button>
              <div class="w-px h-4 mx-1" :style="{ background: svgColors.hudDivider }"></div>
              <button @click="resetZoom" class="px-2 py-1 rounded text-xs font-bold"
                      :style="{ background: svgColors.fitBg, color: svgColors.fitText }" title="Fit All Machines">Fit</button>
            </div>

            <!-- ── Theme Toggle Button ── -->
            <div class="absolute bottom-4 right-4 z-10">
              <button @click="toggleTheme" class="w-10 h-10 flex items-center justify-center rounded-full backdrop-blur-md shadow-lg border transition-all hover:scale-105 active:scale-95"
                      :style="{ background: svgColors.hudBg, borderColor: svgColors.hudBorder, color: svgColors.hudText }"
                      :title="panelTheme === 'dark' ? 'Switch to Light Mode' : 'Switch to Dark Mode'">
                <!-- Sun icon (shown in dark mode to hint at switching to light) -->
                <svg v-if="panelTheme === 'dark'" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" class="w-5 h-5">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M12 3v2.25m6.364.386-1.591 1.591M21 12h-2.25m-.386 6.364-1.591-1.591M12 18.75V21m-4.773-4.227-1.591 1.591M5.25 12H3m4.227-4.773L5.636 5.636M15.75 12a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0Z" />
                </svg>
                <!-- Moon icon (shown in light mode to hint at switching to dark) -->
                <svg v-else xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" class="w-5 h-5">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M21.752 15.002A9.72 9.72 0 0 1 18 15.75c-5.385 0-9.75-4.365-9.75-9.75 0-1.33.266-2.597.748-3.752A9.753 9.753 0 0 0 3 11.25C3 16.635 7.365 21 12.75 21a9.753 9.753 0 0 0 9.002-5.998Z" />
                </svg>
              </button>
            </div>
          </div>
        </div>

      </div>

      <!-- ================= MACHINE DETAILS MODAL ================= -->
      <div v-if="selectedMachine" class="fixed inset-0 bg-slate-950/70 backdrop-blur-[3px] flex items-center justify-center z-50" @click.self="selectedMachine = null">
        <div :class="['noc-modal-card', panelTheme === 'dark' ? 'noc-dark-modal' : 'noc-light-modal']" class="max-w-lg w-full max-h-[85vh] overflow-hidden flex flex-col select-none border">
          
          <!-- Modal Header -->
          <div class="noc-modal-header flex items-stretch justify-between border-b py-2.5 px-4">
            <div class="flex flex-col justify-center">
              <h2 class="text-base font-mono uppercase tracking-wider noc-mch-title flex items-center gap-2">
                <span class="noc-line-name-txt">{{ selectedMachine.lineName }}</span>
                <span class="noc-sep-txt">&gt;</span>
                <span class="noc-mch-name-txt">{{ formatMachineName(selectedMachine.machine_name) }}</span>
              </h2>
            </div>
            <button @click="selectedMachine = null" class="noc-modal-close-btn flex items-center justify-center p-2 self-center transition-colors duration-150">
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" class="w-4 h-4">
                <path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12" />
              </svg>
            </button>
          </div>

          <!-- Modal Body Content -->
          <div class="flex-1 overflow-y-auto p-4 pb-12 space-y-4 noc-modal-body">
            
            <!-- OK Status (System Nominal Empty State) -->
            <div v-if="selectedMachineAlerts.length === 0" class="flex flex-col items-center justify-center py-10 px-4 text-center noc-nominal-state">
              <div class="noc-nominal-icon-container p-3.5 mb-4 border flex items-center justify-center">
                <svg class="w-6 h-6 text-emerald-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12.75l6 6 9-13.5"/>
                </svg>
              </div>
              <span class="text-sm font-black uppercase tracking-wider text-emerald-500">SYSTEM NOMINAL</span>
              <span class="text-[9px] font-bold text-slate-400 mt-1.5 uppercase tracking-wide">ALL PARAMETERS WITHIN NOMINAL LIMITS</span>
            </div>
            
            <!-- Abnormal Parameter Cards Feed -->
            <div v-else class="space-y-3">
              <div class="text-[9px] font-black uppercase tracking-wider mb-2 noc-abnormalities-header">
                ACTIVE ABNORMALITIES: {{ selectedMachineAlerts.length }} DETECTED
              </div>
              
              <div v-for="param in selectedMachineAlerts" :key="param.actual_parameter_name" 
                   @click="logParameterDetails(param, selectedMachine.machine_name, getParameterGroup(selectedMachine.machine_name, param.internal_parameter_name))"
                   class="noc-modal-param-card cursor-pointer flex flex-col border border-l-[5px] transition-all duration-150"
                   :class="'noc-param-card-' + param.parameter_state.toLowerCase()">
                
                <!-- Param Card Header (Splits into details and full-height axis tag) -->
                <div class="flex items-stretch border-b border-dashed noc-param-header w-full">
                  <!-- Left Details Block -->
                  <div class="flex-1 min-w-0 py-2 px-3 flex flex-col justify-between">
                    <!-- Row 1: Parameter Group Name -->
                    <span class="text-[12px] font-extrabold uppercase tracking-wide truncate font-mono noc-param-group-title">
                      {{ param.parameter_group || getParameterGroup(selectedMachine.machine_name, param.internal_parameter_name) }}
                    </span>
                    
                    <!-- Row 2: Left-aligned Raw Name, Right-aligned Parameter Limit Type Badge -->
                    <div class="flex items-center justify-between mt-2 gap-3">
                      <span class="text-[8.5px] font-semibold tracking-wider uppercase font-mono truncate select-all flex-1 noc-raw-name" :title="param.actual_parameter_name">
                        RAW: {{ param.actual_parameter_name }}
                      </span>
                      
                      <!-- Parameter Limit Type Trend Badge -->
                      <span v-if="param.parameter_type === 'increasing'" class="noc-type-badge-increasing px-1.5 py-0.5 border text-[8px] font-mono font-black tracking-wider flex items-center gap-1 flex-shrink-0">
                        <svg class="w-2 h-2" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3">
                          <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 10.5L12 3m0 0l7.5 7.5M12 3v18"/>
                        </svg>
                        INCREASING LIMIT
                      </span>
                      <span v-else-if="param.parameter_type === 'decreasing'" class="noc-type-badge-decreasing px-1.5 py-0.5 border text-[8px] font-mono font-black tracking-wider flex items-center gap-1 flex-shrink-0">
                        <svg class="w-2 h-2" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3">
                          <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 13.5L12 21m0 0l-7.5-7.5M12 21V3"/>
                        </svg>
                        DECREASING LIMIT
                      </span>
                      <span v-else-if="param.parameter_type === 'bool'" class="noc-type-badge-bool px-1.5 py-0.5 border text-[8px] font-mono font-black tracking-wider flex items-center gap-1 flex-shrink-0">
                        <span class="w-1.5 h-1.5 bg-purple-400"></span>
                        BINARY SWITCH
                      </span>
                    </div>
                  </div>

                  <!-- Rightmost Axis Tag Column (Full Height) -->
                  <div class="w-[60px] shrink-0 border-l border-dashed flex flex-col items-center justify-center py-1 px-1 bg-slate-500/5 noc-axis-col">
                    <span class="text-[7px] font-bold uppercase tracking-widest leading-none noc-axis-label">AXIS</span>
                    <span class="text-[18px] font-black font-mono mt-1 leading-none noc-axis-value">
                      {{ param.display_name }}
                    </span>
                  </div>
                </div>

                <!-- Telemetry Values Row -->
                <div class="grid grid-cols-3 divide-x px-3 py-2.5 noc-param-grid">
                  <div class="flex flex-col justify-center">
                    <div class="text-[8px] font-black uppercase tracking-wider noc-telemetry-label">VALUE</div>
                    <div class="text-base font-black font-mono tracking-tight leading-none mt-1"
                         :class="'noc-value-' + param.parameter_state.toLowerCase()">
                      {{ param.parameter_value !== null ? param.parameter_value : 'N/A' }}
                    </div>
                  </div>
                  <div class="flex flex-col justify-center pl-3">
                    <div class="text-[8px] font-black uppercase tracking-wider noc-telemetry-label">WARN LIMIT</div>
                    <div class="text-xs font-bold font-mono leading-none mt-1">
                      {{ param.warning_limit || '—' }}
                    </div>
                  </div>
                  <div class="flex flex-col justify-center pl-3">
                    <div class="text-[8px] font-black uppercase tracking-wider noc-telemetry-label">CRIT LIMIT</div>
                    <div class="text-xs font-bold font-mono leading-none mt-1">
                      {{ param.critical_limit || '—' }}
                    </div>
                  </div>
                </div>

                <!-- Telemetry Footer -->
                <div class="flex items-center justify-between px-3 py-1.5 border-t border-dashed text-[8px] font-bold text-slate-400 uppercase tracking-wide noc-param-footer">
                  <span>SYNC TIME: {{ formatDate(param.latest_update_time) }}</span>
                  <span class="noc-modal-action-text font-black text-sky-400">ANALYZE SIGNAL &rarr;</span>
                </div>
              </div>
            </div>
          </div>
      </div>
      </div>
      
      <!-- Status Bar / Footer -->
      <div class="mt-3 mx-[-12px] mb-0 flex-shrink-0 py-1.5 px-5 text-[9.5px] font-extrabold tracking-widest text-white bg-[#028ec3] uppercase font-mono flex items-center justify-start gap-1 shadow-inner">
        <span class="w-1.5 h-1.5 rounded-full bg-white animate-pulse mr-1"></span>
        <span class="font-medium text-white/85 normal-case mr-1.5">Developed by</span>
        <span class="font-black text-white tracking-wider">Central Manufacturing Technology Institute</span>
      </div>

    </div>
  </LayoutGuest>
</template>

<script setup>
import { ref, onMounted, computed, nextTick, onBeforeMount } from 'vue';
import { useRouter } from 'vue-router';

// LAYOUT & APIS
import LayoutGuest from "@/layouts/LayoutGuest.vue";
import machineSvg from '@/assets/shopfloor/mch.svg';
import tieiLogo from '@/assets/shopfloor/TIEI_Logo.png';
import cmtiLogoColor from '@/assets/shopfloor/CMTI Logo.png';
import cmtiLogoWhite from '@/assets/shopfloor/cmti_logo white.png';

// PINIA STORES
import { useFactoryOverviewStore } from '../stores/FactoryOverviewStore';
import { useFactoryPollOverviewStore } from '../stores/FactoryPollGridStore';
import { useMachineSamplingWithLimitsStore } from '@/stores/MachineSamplingWithLimitsStore'; 
import { useNavigationHistoryStore } from '../stores/navigationHistoryStore';

// MAIN ISOMETRIC CONFIGURATION
import { CONFIG } from './ManagerialOverviewConfig';

// ── 3D Isometric Platform Geometry & Color Helpers ──
const rx = 70;
const ry = 35;
const h = 3.5;
const anchorY = CONFIG.machineHeight * (1 - CONFIG.machineAnchorYPercent);

const getPlatformColors = (state) => {
  const dark = panelTheme.value === 'dark';
  const mapping = {
    'OK': {
      top: dark ? '#1e293b' : '#f8fafc',
      sideLeft: dark ? '#0f172a' : '#cbd5e1',
      sideRight: dark ? '#334155' : '#e2e8f0',
      stroke: dark ? '#334155' : '#cbd5e1',
      glow: 'transparent',
      hasGlow: false
    },
    'WARNING': {
      top: '#f59e0b',
      sideLeft: '#b45309',
      sideRight: '#d97706',
      stroke: '#fbbf24',
      glow: 'rgba(245, 158, 11, 0.35)',
      hasGlow: true
    },
    'CRITICAL': {
      top: '#ef4444',
      sideLeft: '#991b1b',
      sideRight: '#b91c1c',
      stroke: '#f87171',
      glow: 'rgba(239, 68, 68, 0.5)',
      hasGlow: true
    },
    'DISCONNECTED': {
      top: '#3B3B3B',
      sideLeft: '#2B2B2B',
      sideRight: '#4B4B4B',
      stroke: '#3B3B3B',
      glow: 'rgba(59, 59, 59, 0.5)',
      hasGlow: true
    }
  };
  return mapping[state] || mapping['DISCONNECTED'];
};


const getBeaconColors = (state) => {
  const mapping = {
    'WARNING': {
      top: '#fbbf24', // bright amber
      left: '#d97706', // darker amber
      right: '#f59e0b', // main amber
      glow: '#f59e0b'
    },
    'CRITICAL': {
      top: '#f87171', // bright red
      left: '#b91c1c', // darker red
      right: '#ef4444', // main red
      glow: '#ef4444'
    },
    'DISCONNECTED': {
      top: '#5B5B5B', // bright grey
      left: '#3B3B3B', // darker grey
      right: '#4B4B4B', // main grey
      glow: '#3B3B3B'
    },
    'OK': {
      top: '#34d399',
      left: '#059669',
      right: '#10b981',
      glow: '#10b981'
    }
  };
  return mapping[state] || mapping['OK'];
};

const getMachineFilter = (state) => {
  if (state === 'WARNING') {
    return 'sepia(0.25) saturate(1.4) hue-rotate(0deg) brightness(1.02)';
  } else if (state === 'CRITICAL') {
    return 'sepia(0.35) saturate(1.8) hue-rotate(320deg) brightness(0.94)';
  } else if (state === 'DISCONNECTED') {
    return 'grayscale(0.85) contrast(0.80) saturate(0.1)';
  }
  return 'none';
};

const getStatusColor = (state) => {
  const mapping = {
    'WARNING': '#f59e0b',
    'CRITICAL': '#ef4444',
    'DISCONNECTED': '#94a3b8',
    'OK': '#10b981'
  };
  return mapping[state] || '#10b981';
};

// ── Load Google Font dynamically from config ──
onBeforeMount(() => {
  if (CONFIG.fontUrl) {
    const existing = document.querySelector(`link[href="${CONFIG.fontUrl}"]`);
    if (!existing) {
      const link = document.createElement('link');
      link.rel = 'stylesheet';
      link.href = CONFIG.fontUrl;
      document.head.appendChild(link);
    }
  }
});

// ── Grid iteration arrays ──
const gridUValues = computed(() => {
  const arr = [];
  for (let u = CONFIG.gridMin; u <= CONFIG.gridMax; u++) arr.push(u);
  return arr;
});
const gridVValues = computed(() => {
  const arr = [];
  for (let v = CONFIG.gridMin; v <= CONFIG.gridMax; v++) arr.push(v);
  return arr;
});

// ── Reactive state ──
const router = useRouter();
const factoryStore = useFactoryOverviewStore();
const factoryPollStore = useFactoryPollOverviewStore();
const machineSamplingWithLimitsStore = useMachineSamplingWithLimitsStore();
const navigationHistoryStore = useNavigationHistoryStore();

const svgRef = ref(null);
const activeLine = ref(null);
const selectedMachine = ref(null);
const hoveredMachine = ref(null);
const isLoading = ref(true);

// ── Theme (dark / light) ──
const panelTheme = ref('dark');
const toggleTheme = () => { panelTheme.value = panelTheme.value === 'dark' ? 'light' : 'dark'; };

// ── Theme-reactive SVG colors ──
const svgColors = computed(() => {
  const dark = panelTheme.value === 'dark';
  return {
    bg:           dark ? '#0b1120' : '#f1f5f9',
    panelBg:      dark ? '#0d1117' : '#ffffff',
    panelBorder:  dark ? '#1e2d3d' : '#e2e8f0',
    gridLine:     dark ? 'rgba(148,163,184,0.10)' : 'rgba(100,116,139,0.18)',
    tooltipBg:    dark ? '#090d16'  : '#1e293b',
    tooltipText:  dark ? '#ffffff'  : '#f1f5f9',
    labelBg:      dark ? '#000000'  : '#ffffff',
    labelBorder:  dark ? '#ffffff'  : '#000000',
    labelText:    dark ? '#ffffff'  : '#000000',
    hudBg:        dark ? 'rgba(15,23,42,0.80)' : 'rgba(255,255,255,0.85)',
    hudBorder:    dark ? 'rgba(51,65,85,0.5)'  : 'rgba(203,213,225,0.7)',
    hudText:      dark ? '#94a3b8' : '#475569',
    hudDivider:   dark ? '#334155' : '#cbd5e1',
    fitBg:        dark ? '#1e3a5f' : '#e0f2fe',
    fitText:      dark ? '#38bdf8' : '#0284c7',
  };
});

// ── Skeleton mock data (generated from defaultLineMachines config) ──
const defaultLineNames = ['BLOCK', 'CRANK', 'HEAD'];
const skeletonLinesData = computed(() => {
  const counts = CONFIG.defaultLineMachines || [7, 14, 38];
  return counts.map((count, i) => ({
    name: defaultLineNames[i] || `LINE_${i + 1}`,
    counts: { OK: count, WARNING: 0, CRITICAL: 0, DISCONNECTED: 0 },
    machines: Array.from({ length: count }, (_, j) => ({
      machine_name: `${defaultLineNames[i] || 'L' + i}_OP${(j + 1) * 10}`,
      machine_state: 'OK',
      lineName: defaultLineNames[i] || `LINE_${i + 1}`,
      parameters: []
    })),
    alerts: []
  }));
});

// ── Coordinate transformation ──
const isoToScreen = (u, v) => {
  const x = CONFIG.originX + (u - v) * (CONFIG.tileWidth / 2);
  const y = CONFIG.originY + (u + v) * (CONFIG.tileHeight / 2);
  return { x, y };
};

// ── Zoom & Pan ──
const zoomScale = ref(1.0);
const viewBoxX = ref(0);
const viewBoxY = ref(0);
const viewBoxW = ref(1200);
const viewBoxH = ref(800);
const isPanning = ref(false);
const startX = ref(0);
const startY = ref(0);

const computedViewBox = computed(() => `${viewBoxX.value} ${viewBoxY.value} ${viewBoxW.value} ${viewBoxH.value}`);

const handleMouseDown = (event) => {
  if (event.button === 1) {
    event.preventDefault();
    isPanning.value = true;
    startX.value = event.clientX;
    startY.value = event.clientY;
  }
};
const handleMouseMove = (event) => {
  if (!isPanning.value) return;
  event.preventDefault();
  const dx = event.clientX - startX.value;
  const dy = event.clientY - startY.value;
  startX.value = event.clientX;
  startY.value = event.clientY;
  const svg = event.currentTarget;
  const rect = svg.getBoundingClientRect();
  viewBoxX.value -= dx * (viewBoxW.value / rect.width);
  viewBoxY.value -= dy * (viewBoxH.value / rect.height);
};
const handleMouseUp = (event) => { if (event.button === 1) isPanning.value = false; };
const handleMouseLeave = () => { isPanning.value = false; };

const handleWheel = (event) => {
  event.preventDefault();
  const svg = event.currentTarget;
  const rect = svg.getBoundingClientRect();
  const mouseX = event.clientX - rect.left;
  const mouseY = event.clientY - rect.top;
  const svgMouseX = viewBoxX.value + (mouseX / rect.width) * viewBoxW.value;
  const svgMouseY = viewBoxY.value + (mouseY / rect.height) * viewBoxH.value;
  const zoomFactor = event.deltaY < 0 ? 1.15 : 1 / 1.15;
  const newScale = Math.max(0.4, Math.min(6.0, zoomScale.value * zoomFactor));
  if (newScale === zoomScale.value) return;
  const newW = 1200 / newScale;
  const newH = 800 / newScale;
  viewBoxX.value = svgMouseX - (mouseX / rect.width) * newW;
  viewBoxY.value = svgMouseY - (mouseY / rect.height) * newH;
  zoomScale.value = newScale;
  viewBoxW.value = newW;
  viewBoxH.value = newH;
};

const zoomToScale = (targetScale) => {
  const newScale = Math.max(0.4, Math.min(6.0, targetScale));
  if (newScale === zoomScale.value) return;
  const cx = viewBoxX.value + viewBoxW.value / 2;
  const cy = viewBoxY.value + viewBoxH.value / 2;
  const newW = 1200 / newScale;
  const newH = 800 / newScale;
  viewBoxX.value = cx - newW / 2;
  viewBoxY.value = cy - newH / 2;
  zoomScale.value = newScale;
  viewBoxW.value = newW;
  viewBoxH.value = newH;
};
const zoomIn = () => zoomToScale(zoomScale.value * 1.25);
const zoomOut = () => zoomToScale(zoomScale.value / 1.25);
const resetZoom = () => fitView();

const fitView = () => {
  const machines = placedMachines.value;
  if (machines.length === 0) {
    zoomScale.value = 1.0; viewBoxX.value = 0; viewBoxY.value = 0; viewBoxW.value = 1200; viewBoxH.value = 800;
    return;
  }
  let minX = Infinity, minY = Infinity, maxX = -Infinity, maxY = -Infinity;
  machines.forEach(m => {
    const x = getMachineX(m), y = getMachineY(m);
    minX = Math.min(minX, x); minY = Math.min(minY, y);
    maxX = Math.max(maxX, x + CONFIG.machineWidth); maxY = Math.max(maxY, y + CONFIG.machineHeight);
  });
  const pad = CONFIG.viewPadding || 80;
  minX -= pad; minY -= pad; maxX += pad; maxY += pad;
  const bw = maxX - minX, bh = maxY - minY;
  const ar = 1200 / 800;
  let fitW, fitH;
  if (bw / bh > ar) { fitW = bw; fitH = bw / ar; } else { fitH = bh; fitW = bh * ar; }
  const cx = (minX + maxX) / 2, cy = (minY + maxY) / 2;
  viewBoxX.value = cx - fitW / 2; viewBoxY.value = cy - fitH / 2;
  viewBoxW.value = fitW; viewBoxH.value = fitH; zoomScale.value = 1200 / fitW;
};

// ── Data mapping ──
const uiLinesData = computed(() => {
  const rawLines = factoryStore.formattedOverviewData?.lines || [];
  if (rawLines.length === 0) return skeletonLinesData.value;

  return rawLines.map(line => {
    const name = line.line_name;
    const machines = (line.machines || []).map(m => ({ ...m, lineName: name }));
    const counts = { OK: 0, WARNING: 0, CRITICAL: 0, DISCONNECTED: 0 };
    machines.forEach(m => {
      const s = m.machine_state || 'OK';
      if (counts[s] !== undefined) counts[s]++;
    });
    const alerts = [];
    machines.forEach(m => {
      (m.parameters || []).forEach(p => {
        if (p.parameter_state !== 'OK') {
          alerts.push({ machineName: m.machine_name, paramName: p.actual_parameter_name, value: `${p.parameter_value}`, state: p.parameter_state });
        }
      });
    });
    return { name, counts, machines, alerts };
  });
});

// ── Computed metrics ──
const totalMachines = computed(() => uiLinesData.value.reduce((s, l) => s + (l.machines || []).length, 0));
const totalOk = computed(() => uiLinesData.value.reduce((s, l) => s + (l.counts.OK || 0), 0));
const totalWarning = computed(() => uiLinesData.value.reduce((s, l) => s + (l.counts.WARNING || 0), 0));
const totalCritical = computed(() => uiLinesData.value.reduce((s, l) => s + (l.counts.CRITICAL || 0), 0));
const totalDisconnected = computed(() => uiLinesData.value.reduce((s, l) => s + (l.counts.DISCONNECTED || 0), 0));

// ── Alert Panel Computed ──
const availableLines = computed(() => {
  return uiLinesData.value.map(l => l.name);
});

const allAlerts = computed(() => {
  const alerts = [];
  uiLinesData.value.forEach(line => {
    (line.machines || []).forEach(m => {
      // If machine is DISCONNECTED at machine level, add it to alerts
      if (m.machine_state === 'DISCONNECTED') {
        alerts.push({
          machineName: m.machine_name,
          lineName: m.lineName || line.name,
          group: 'MACHINE STATUS',
          displayName: 'DISC',
          value: 'N/A',
          state: 'DISCONNECTED',
          paramDetails: { parameter_state: 'DISCONNECTED', machine_state: 'DISCONNECTED' }
        });
      }
      // Check individual parameters for WARNING/CRITICAL
      (m.parameters || []).forEach(p => {
        if (p.parameter_state === 'WARNING' || p.parameter_state === 'CRITICAL') {
          alerts.push({
            machineName: m.machine_name,
            lineName: m.lineName || line.name,
            group: p.parameter_group || 'Unknown Group',
            displayName: p.display_name || p.actual_parameter_name,
            value: p.parameter_value !== null ? p.parameter_value : 'N/A',
            state: p.parameter_state,
            paramDetails: p
          });
        }
      });
    });
  });

  // Sort by state (CRITICAL first, then WARNING, then DISCONNECTED), then by machine name
  alerts.sort((a, b) => {
    const statePriority = { 'CRITICAL': 0, 'WARNING': 1, 'DISCONNECTED': 2 };
    const priorityA = statePriority[a.state] ?? 3;
    const priorityB = statePriority[b.state] ?? 3;
    if (priorityA !== priorityB) return priorityA - priorityB;
    return a.machineName.localeCompare(b.machineName);
  });

  return alerts;
});

const filteredAlerts = computed(() => {
  if (!activeLine.value) return allAlerts.value;
  return allAlerts.value.filter(a => a.lineName === activeLine.value);
});

const groupedAlerts = computed(() => {
  const groups = {};
  filteredAlerts.value.forEach(alert => {
    const line = alert.lineName || 'Unknown';
    if (!groups[line]) {
      groups[line] = [];
    }
    groups[line].push(alert);
  });
  return Object.keys(groups).map(name => ({
    name,
    alerts: groups[name]
  })).sort((a, b) => a.name.localeCompare(b.name));
});

// ── Machine placement ──
const placedMachines = computed(() => {
  const list = [];
  const spacing = CONFIG.machineSpacing || 1.0;
  const lineGap = CONFIG.lineGap !== undefined ? CONFIG.lineGap : 1;
  const perRow = CONFIG.machinesPerRow || 10;
  let currentU = 0;

  uiLinesData.value.forEach(line => {
    const machines = line.machines || [];
    const rows = Math.ceil(machines.length / perRow) || 1;
    machines.forEach((m, idx) => {
      const row = Math.floor(idx / perRow);
      const col = idx % perRow;
      list.push({ ...m, lineName: m.lineName || line.name, gridU: currentU + row * spacing, gridV: col * spacing });
    });
    currentU += (rows - 1) * spacing + 1 + lineGap;
  });
  return list;
});

const sortedPlacedMachines = computed(() => [...placedMachines.value].sort((a, b) => (a.gridU + a.gridV) - (b.gridU + b.gridV)));

const lineLabels = computed(() => {
  const labels = [];
  const spacing = CONFIG.machineSpacing || 1.0;
  const lineGap = CONFIG.lineGap !== undefined ? CONFIG.lineGap : 1;
  const perRow = CONFIG.machinesPerRow || 10;
  const settings = CONFIG.lineLabelSettings || {};
  const lineSettings = settings.lines || {};
  let currentU = 0;

  uiLinesData.value.forEach(line => {
    const machines = line.machines || [];
    if (machines.length === 0) return;
    const rows = Math.ceil(machines.length / perRow) || 1;

    const nameKey = line.name.toUpperCase();
    const configForLine = lineSettings[nameKey] || {};

    // Center of the U span
    let uCenter = currentU + (rows * spacing) / 2;
    // Place right above the boundary line (v = 0)
    let vCenter = -0.22;

    // Apply manual overrides
    const uOffset = configForLine.uOffset !== undefined ? configForLine.uOffset : 0.0;
    const vOffset = configForLine.vOffset !== undefined ? configForLine.vOffset : 0.0;
    uCenter += uOffset;
    vCenter += vOffset;

    const boxVisible = configForLine.box !== undefined ? configForLine.box : (settings.box !== undefined ? settings.box : true);
    const boxWidthVal = configForLine.width !== undefined ? configForLine.width : (settings.width !== undefined ? settings.width : (configForLine.boxWidth !== undefined ? configForLine.boxWidth : (settings.boxWidth !== undefined ? settings.boxWidth : 1.3)));
    const boxHeightVal = configForLine.height !== undefined ? configForLine.height : (settings.height !== undefined ? settings.height : (configForLine.boxHeight !== undefined ? configForLine.boxHeight : (settings.boxHeight !== undefined ? settings.boxHeight : 0.44)));
    const textPaddingVal = configForLine.textPadding !== undefined ? configForLine.textPadding : (settings.textPadding !== undefined ? settings.textPadding : 0.08);

    labels.push({
      name: configForLine.text || line.name.toUpperCase(),
      u: uCenter,
      v: vCenter,
      textColor: configForLine.textColor || settings.textColor || '#ffffff',
      bgColor: configForLine.bgColor || settings.bgColor || '#000000',
      borderColor: configForLine.borderColor || settings.borderColor || '#ffffff',
      fontSize: settings.fontSize || 14.5,
      fontWeight: settings.fontWeight || '900',
      letterSpacing: settings.letterSpacing || '1.5px',
      borderWidth: settings.borderWidth || 2,
      box: boxVisible,
      halfWidth: boxWidthVal / 2,
      halfHeight: boxHeightVal / 2,
      textPadding: textPaddingVal
    });

    currentU += (rows - 1) * spacing + 1 + lineGap;
  });
  return labels;
});


// ── Position helpers ──
const getMachineX = (machine) => {
  const uOff = CONFIG.machineGridUOffset ?? 0.5, vOff = CONFIG.machineGridVOffset ?? 0.5;
  const pxOff = CONFIG.machinePixelOffsetX ?? 0;
  return isoToScreen(machine.gridU + uOff, machine.gridV + vOff).x - CONFIG.machineWidth / 2 + pxOff;
};
const getMachineY = (machine) => {
  const uOff = CONFIG.machineGridUOffset ?? 0.5, vOff = CONFIG.machineGridVOffset ?? 0.5;
  const pxOff = CONFIG.machinePixelOffsetY ?? 0;
  const anchorY = CONFIG.machineHeight * (1 - CONFIG.machineAnchorYPercent);
  return isoToScreen(machine.gridU + uOff, machine.gridV + vOff).y - anchorY + pxOff;
};

// ── Tooltip helpers ──
const getTooltipWidth = (text) => {
  // Balanced dimensions for 'Manrope' to prevent touching the side borders
  const charWidth = 7.0;
  const paddingX = 24; // Premium horizontal padding
  return Math.max(56, (text || '').length * charWidth + paddingX);
};

const shouldShowTooltip = (machine) => {
  if (isLoading.value) return false;
  if (machine.machine_state === 'WARNING' || machine.machine_state === 'CRITICAL' || machine.machine_state === 'DISCONNECTED') return true;
  return hoveredMachine.value === machine.machine_name;
};

const getTooltipPath = (machine) => {
  const name = formatMachineName(machine.machine_name);
  const w = getTooltipWidth(name);
  const h = 26; // Generous vertical padding for the standard font to prevent touching borders
  const arrow = CONFIG.tooltipArrowSize || 5;
  const r = CONFIG.tooltipCornerRadius !== undefined ? CONFIG.tooltipCornerRadius : 0;
  const cx = getMachineX(machine) + CONFIG.machineWidth / 2;
  const top = getMachineY(machine) - CONFIG.tooltipOffsetY - 11; // Perfectly centered relative to text (top + h/2 = +2 offset)
  const bottom = top + h;
  const left = cx - w / 2;
  const right = cx + w / 2;

  if (r <= 0) {
    return `M ${left} ${top} L ${right} ${top} L ${right} ${bottom} L ${cx + arrow} ${bottom} L ${cx} ${bottom + arrow} L ${cx - arrow} ${bottom} L ${left} ${bottom} Z`;
  } else {
    return `M ${left + r} ${top} L ${right - r} ${top} Q ${right} ${top} ${right} ${top + r} L ${right} ${bottom - r} Q ${right} ${bottom} ${right - r} ${bottom} L ${cx + arrow} ${bottom} L ${cx} ${bottom + arrow} L ${cx - arrow} ${bottom} L ${left + r} ${bottom} Q ${left} ${bottom} ${left} ${bottom - r} L ${left} ${top + r} Q ${left} ${top} ${left + r} ${top} Z`;
  }
};

const getTooltipBg = (machine) => {
  return 'rgba(15, 23, 42, 0.96)';
};
const getTooltipStroke = (machine) => {
  const state = machine.machine_state;
  if (state === 'CRITICAL') return '#ef4444';
  if (state === 'WARNING') return '#f59e0b';
  if (state === 'DISCONNECTED') return '#3B3B3B';
  return 'rgba(148, 163, 184, 0.3)';
};
const getTooltipTextColor = (machine) => {
  const state = machine.machine_state;
  if (state === 'CRITICAL') return '#ff6b6b';
  if (state === 'WARNING') return '#fbbf24';
  if (state === 'DISCONNECTED') return '#9CA3AF';
  return '#ffffff';
};

// ── Line helpers ──
const focusLine = (lineName) => {
  activeLine.value = activeLine.value === lineName ? null : lineName;
};

function getLineDotClass(name) {
  const mapping = {
    'BLOCK': 'bg-sky-500 shadow-[0_0_6px_rgba(56,189,248,0.5)]',
    'CRANK': 'bg-indigo-500 shadow-[0_0_6px_rgba(99,102,241,0.5)]',
    'HEAD': 'bg-violet-500 shadow-[0_0_6px_rgba(139,92,246,0.5)]'
  };
  return mapping[name.toUpperCase()] || 'bg-slate-400';
}

function formatMachineName(name) {
  if (!name) return '';
  return name.startsWith('T_') ? name.substring(2) : name;
}

function getLineAccentClass(name) {
  const mapping = {
    'BLOCK': 'border-l-4 border-sky-500 dark:border-sky-400 bg-sky-50/20 dark:bg-sky-950/5',
    'CRANK': 'border-l-4 border-indigo-500 dark:border-indigo-400 bg-indigo-50/20 dark:bg-indigo-950/5',
    'HEAD': 'border-l-4 border-violet-500 dark:border-violet-400 bg-violet-50/20 dark:bg-violet-950/5'
  };
  return mapping[name.toUpperCase()] || 'border-l-4 border-slate-450 bg-slate-50/25';
}

function getLineAlertMachines(line) {
  const machines = line.machines || [];
  const critical = machines.filter(m => m.machine_state === 'CRITICAL');
  const warning = machines.filter(m => m.machine_state === 'WARNING');
  return [...critical, ...warning];
}

function getAbnormalParameters(machine) {
  return (machine.parameters || []).filter(p => p.parameter_state !== 'OK');
}

// ── Modal computed ──
const selectedMachineAlerts = computed(() => {
  if (!selectedMachine.value) return [];
  return (selectedMachine.value.parameters || []).filter(p => p.parameter_state !== 'OK');
});

function showMachineDetails(machine) {
  selectedMachine.value = machine;
}

// ── Utility styling ──
function getStatusTextColor(state) {
  return {
    'text-red-500 font-bold': state === 'CRITICAL',
    'text-amber-500 font-bold': state === 'WARNING',
    'text-emerald-500 font-bold': state === 'OK',
    'text-slate-400': !state || state === 'DISCONNECTED'
  };
}

function formatDate(timestamp) {
  if (!timestamp) return 'Just now';
  return new Date(timestamp).toLocaleTimeString();
}

function logParameterDetails(param, machineName, parameterGroup) {
  const details = { machine: machineName, actualParameterName: param.actual_parameter_name, parameterGroup };
  machineSamplingWithLimitsStore.setMachineDetails(details);
  machineSamplingWithLimitsStore.setLastSelectedParameter(details);
  navigationHistoryStore.addToHistory(router.currentRoute.value);
  router.push('/machine-level-sampling');
}

function getParameterGroup(machineName, parameterName) {
  const group = factoryPollStore.groupData?.find(g =>
    g.group_details?.some(line =>
      line.machines?.some(machine =>
        machine.machine_name === machineName &&
        machine.parameters?.some(p => p.internal_parameter_name === parameterName)
      )
    )
  );
  return group ? group.group_name : 'Unknown Group';
}

// ── Lifecycle ──
onMounted(async () => {
  // Initial fit with skeleton data
  await nextTick();
  fitView();

  try {
    await factoryStore.fetchAndFormatData();
  } catch (error) {
    console.warn('Real-time API unavailable, loading fallback simulation.');
  }

  isLoading.value = false;

  // Re-fit after real data loads
  await nextTick();
  fitView();
});
</script>

<style scoped>
.mo-screen,
.mo-screen * {
  font-family: v-bind('CONFIG.fontFamily') !important;
}

/* Dynamic theme background for the window behind the cards */
.mo-bg-dark {
  background: #080d16 !important;
}
.mo-bg-light {
  background: #e2e8f0 !important;
}

@keyframes pulse-shimmer {
  0%, 100% { opacity: 0.45; }
  50% { opacity: 0.85; }
}
.loading-machine {
  animation: pulse-shimmer 1.8s ease-in-out infinite;
}

/* Scrollbar styling */
::-webkit-scrollbar { width: 4px; }
::-webkit-scrollbar-track { background: #0d1117; }
::-webkit-scrollbar-thumb { background: #2d3748; border-radius: 2px; }
::-webkit-scrollbar-thumb:hover { background: #4a5568; }

/* ═══════════════════════════════════════════════
   NOC PANEL — CORE LAYOUT
═══════════════════════════════════════════════ */
.noc-panel {
  background: #0d1117;
  border: 1px solid #334155;
  box-shadow: none !important;
}

/* ── Header ── */
.noc-header {
  background: #0d1117;
  border-bottom: 1px solid #334155;
}

.noc-header-top {
  border-bottom: 1px solid #334155;
}

.noc-title {
  font-size: 11px;
  font-weight: 800;
  letter-spacing: 0.12em;
  color: #94a3b8;
  text-transform: uppercase;
  font-family: 'Barlow Condensed', monospace;
}

.noc-timestamp {
  font-size: 11px;
  font-weight: 600;
  letter-spacing: 0.08em;
  color: #38bdf8;
  font-family: 'Barlow Condensed', monospace;
  opacity: 0.8;
}

/* Live pulsing dot */
.noc-live-dot {
  width: 7px;
  height: 7px;
  border-radius: 50%;
  background: #22c55e;
  box-shadow: 0 0 6px 2px rgba(34, 197, 94, 0.45);
  flex-shrink: 0;
  animation: noc-live-pulse 2s ease-in-out infinite;
}

@keyframes noc-live-pulse {
  0%, 100% { box-shadow: 0 0 4px 1px rgba(34, 197, 94, 0.4); }
  50%       { box-shadow: 0 0 10px 3px rgba(34, 197, 94, 0.7); }
}

/* ── Metric Tiles ── */
.noc-metrics-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
}

.noc-metric-tile {
  padding: 10px 6px 8px;
  text-align: center;
  border-right: 1px solid #334155;
  position: relative;
}
.noc-metric-tile:last-child { border-right: none; }
.noc-metric-tile::before {
  content: '';
  position: absolute;
  top: 0; left: 0; right: 0;
  height: 2px;
}
.noc-metric-total::before  { background: #475569; }
.noc-metric-ok::before     { background: #22c55e; }
.noc-metric-warn::before   { background: #f59e0b; }
.noc-metric-crit::before   { background: #ef4444; }

.noc-metric-value {
  font-size: 26px;
  font-weight: 900;
  line-height: 1;
  color: #e2e8f0;
  margin-bottom: 3px;
  letter-spacing: -0.02em;
}
.noc-ok   { color: #4ade80 !important; }
.noc-warn { color: #fbbf24 !important; }
.noc-crit { color: #f87171 !important; }

.noc-metric-label {
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.12em;
  color: #475569;
  text-transform: uppercase;
}
.noc-ok-label   { color: #16a34a; }
.noc-warn-label { color: #b45309; }
.noc-crit-label { color: #b91c1c; }

/* ── Status Proportion Bar ── */
.noc-status-bar {
  display: flex;
  height: 3px;
  width: 100%;
  gap: 1px;
  background: #0d1117;
}
.noc-status-bar-fill { height: 100%; min-width: 0; transition: flex 0.6s ease; }
.noc-bar-ok   { background: #22c55e; }
.noc-bar-warn { background: #f59e0b; }
.noc-bar-crit { background: #ef4444; }
.noc-bar-disc { background: #334155; }

/* ── Section Label ── */
.noc-section-label {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 6px 10px 5px;
  font-size: 11px;
  font-weight: 800;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: #64748b;
  background: #0a0f16;
  border-bottom: 1px solid #334155;
  flex-shrink: 0;
}
.noc-alert-count {
  margin-left: auto;
  background: #1e2d3d;
  color: #94a3b8;
  font-size: 11px;
  font-weight: 800;
  padding: 1px 6px;
  border-radius: 20px;
  letter-spacing: 0.05em;
}

/* ── Feed ── */
.noc-feed {
  background: #0a0f16;
}

/* ── Line Group ── */
.noc-line-group {
  border-bottom: 1px solid #334155;
}
.noc-line-group:last-child { border-bottom: none; }

/* ── Badges ── */
.noc-badge {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.08em;
  padding: 2px 6px;
  border-radius: 3px;
  text-transform: uppercase;
}
.noc-badge-crit {
  background: rgba(239,68,68,0.15);
  color: #f87171;
  border: 1px solid rgba(239,68,68,0.3);
}
.noc-badge-warn {
  background: rgba(245,158,11,0.13);
  color: #fbbf24;
  border: 1px solid rgba(245,158,11,0.28);
}
.noc-badge-ok {
  background: rgba(34,197,94,0.1);
  color: #4ade80;
  border: 1px solid rgba(34,197,94,0.2);
}

/* Pulsing dot in badge */
.noc-ping-dot {
  width: 5px; height: 5px;
  border-radius: 50%;
  background: #ef4444;
  animation: noc-ping 1.2s ease-in-out infinite;
  display: inline-block;
}
@keyframes noc-ping {
  0%, 100% { opacity: 1; transform: scale(1); }
  50%       { opacity: 0.5; transform: scale(1.4); }
}

@keyframes tooltip-bounce {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-5px);
  }
}

.noc-tooltip-bounce {
  animation: tooltip-bounce 1.6s ease-in-out infinite;
}

/* ── Compact Grouped Alert Styles ── */
.noc-line-section {
  margin-bottom: 12px;
}
.noc-line-section:last-child {
  margin-bottom: 0;
}

.noc-line-sect-header {
  border-bottom: none;
  font-family: 'Barlow Condensed', monospace !important;
  font-weight: 800 !important;
}

.noc-line-alerts-list {
  box-shadow: none !important;
  border-top: none;
}

.noc-alert-row {
  position: relative;
  transition: all 0.1s ease;
  border-left-width: 4px;
}
.noc-alert-row:active {
  transform: scale(0.995);
}

/* Vertical dividers within row columns */
.noc-machine-txt,
.noc-group-txt,
.noc-display-txt {
  border-right-width: 1px;
  border-right-style: solid;
  padding-right: 10px;
  margin-right: 10px;
}

/* ── DARK THEME STYLING ── */
.noc-dark .noc-line-sect-header {
  background: #1f2937; /* Strong, distinct dark grey */
  border-color: #475569;
  color: #ffffff;
}
.noc-dark .noc-sect-badge {
  background: #111827;
  color: #94a3b8;
}
.noc-dark .noc-line-alerts-list {
  background: #090f16;
  border-color: #475569;
}
.noc-dark .noc-line-alerts-list > * + * {
  border-color: #475569;
}
.noc-dark .noc-machine-txt,
.noc-dark .noc-group-txt,
.noc-dark .noc-display-txt {
  border-color: #475569; /* Dark separator borders */
}
.noc-dark .noc-machine-txt {
  color: #ffffff;
  font-weight: 800;
  font-size: 11.5px;
  letter-spacing: 0.02em;
}
.noc-dark .noc-group-txt {
  color: #ffffff; /* Big and bold, not greyed out */
  font-weight: 800;
  font-size: 11.5px;
  letter-spacing: 0.02em;
}
.noc-dark .noc-display-txt {
  color: #94a3b8;
  font-weight: 750;
  font-size: 10.5px;
}
.noc-dark .noc-value-txt {
  font-size: 12.5px;
}

/* Card highlights in dark theme */
.noc-dark .noc-alert-crit-row {
  border-left-color: #ef4444;
  background: rgba(239, 68, 68, 0.08);
}
.noc-dark .noc-alert-crit-row:hover {
  background: rgba(239, 68, 68, 0.16);
}
.noc-dark .noc-alert-warn-row {
  border-left-color: #f59e0b;
  background: rgba(245, 158, 11, 0.06);
}
.noc-dark .noc-alert-warn-row:hover {
  background: rgba(245, 158, 11, 0.13);
}
.noc-dark .noc-alert-disc-row {
  border-left-color: #94a3b8;
  background: rgba(148, 163, 184, 0.08);
}
.noc-dark .noc-alert-disc-row:hover {
  background: rgba(148, 163, 184, 0.16);
}

/* ── LIGHT THEME STYLING ── */
.noc-light .noc-line-sect-header {
  background: #cbd5e1; /* Strong, distinct light slate grey */
  border-color: #94a3b8;
  color: #0f172a; /* High contrast dark text */
}
.noc-light .noc-sect-badge {
  background: #f1f5f9;
  color: #0f172a;
}
.noc-light .noc-line-alerts-list {
  background: #ffffff;
  border-color: #cbd5e1;
}
.noc-light .noc-line-alerts-list > * + * {
  border-color: #f1f5f9;
}
.noc-light .noc-machine-txt,
.noc-light .noc-group-txt,
.noc-light .noc-display-txt {
  border-color: #e2e8f0; /* Light separator borders */
}
.noc-light .noc-machine-txt {
  color: #0f172a;
  font-weight: 800;
  font-size: 11.5px;
  letter-spacing: 0.02em;
}
.noc-light .noc-group-txt {
  color: #1e293b; /* Big and bold, not greyed out */
  font-weight: 800;
  font-size: 11.5px;
  letter-spacing: 0.02em;
}
.noc-light .noc-display-txt {
  color: #475569;
  font-weight: 750;
  font-size: 10.5px;
}
.noc-light .noc-value-txt {
  font-size: 12.5px;
}

/* Card highlights in light theme */
.noc-light .noc-alert-crit-row {
  border-left-color: #dc2626;
  background: rgba(239, 68, 68, 0.05);
}
.noc-light .noc-alert-crit-row:hover {
  background: rgba(239, 68, 68, 0.1);
}
.noc-light .noc-alert-warn-row {
  border-left-color: #d97706;
  background: rgba(245, 158, 11, 0.04);
}
.noc-light .noc-alert-warn-row:hover {
  background: rgba(245, 158, 11, 0.08);
}
.noc-light .noc-alert-disc-row {
  border-left-color: #64748b;
  background: rgba(100, 116, 139, 0.05);
}
.noc-light .noc-alert-disc-row:hover {
  background: rgba(100, 116, 139, 0.1);
}

/* ── Filters ── */
.noc-filter-btn {
  font-size: 10px;
  font-weight: 800;
  padding: 4px 10px;
  border-radius: 12px;
  background: rgba(100, 116, 139, 0.1);
  color: #64748b;
  border: 1px solid rgba(100, 116, 139, 0.2);
  cursor: pointer;
  transition: all 0.2s;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  flex-shrink: 0;
}
.noc-filter-btn:hover {
  background: rgba(100, 116, 139, 0.2);
}
.noc-filter-btn.active {
  background: #38bdf8;
  color: #0f172a;
  border-color: #38bdf8;
  box-shadow: none !important;
}
.noc-dark .noc-filter-btn { color: #94a3b8; }
.noc-light .noc-filter-btn { color: #475569; }
.noc-dark .noc-filter-btn.active { background: #38bdf8; color: #0f172a; }
.noc-light .noc-filter-btn.active { background: #0284c7; color: #ffffff; border-color: #0284c7; }

/* ── No Alerts Row ── */
.noc-no-alerts {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 8px 10px;
  font-size: 11px;
  font-weight: 600;
  letter-spacing: 0.04em;
}
.noc-dark .noc-no-alerts  { color: #334155; }
.noc-light .noc-no-alerts { color: #94a3b8; }

/* ── Light Mode Overrides for NOC Panel ── */
.noc-light {
  background: #f8fafc;
  border-color: #e2e8f0;
  box-shadow: none !important;
}
.noc-light .noc-header       { background: #ffffff; border-bottom-color: #e2e8f0; }
.noc-light .noc-header-top   { border-bottom-color: #e2e8f0; }
.noc-light .noc-title        { color: #475569; }
.noc-light .noc-timestamp    { color: #0284c7; }
.noc-light .noc-live-dot     { background: #22c55e; }
.noc-light .noc-metric-tile  { border-right-color: #e2e8f0; }
.noc-light .noc-metric-value { color: #1e293b; }
.noc-light .noc-metric-label { color: #94a3b8; }
.noc-light .noc-ok-label     { color: #16a34a; }
.noc-light .noc-warn-label   { color: #b45309; }
.noc-light .noc-crit-label   { color: #b91c1c; }
.noc-light .noc-section-label { background: #f1f5f9; border-bottom-color: #e2e8f0; color: #94a3b8; }
.noc-light .noc-alert-count  { background: #e2e8f0; color: #64748b; }
.noc-light .noc-feed         { background: #f8fafc; }
.noc-light .noc-line-group   { border-bottom-color: #e2e8f0; }
.noc-light .noc-line-header  { background: #f1f5f9; border-bottom-color: #e2e8f0; }
.noc-light .noc-line-header:hover { background: #e8eef6; }
.noc-light .noc-line-name    { color: #1e293b; }
.noc-light .noc-machine-count { background: #e2e8f0; color: #64748b; }
.noc-light .noc-badge-ok     { background: rgba(34,197,94,0.08); color: #16a34a; border-color: rgba(34,197,94,0.25); }
.noc-light .noc-badge-warn   { background: rgba(245,158,11,0.10); color: #b45309; border-color: rgba(245,158,11,0.25); }
.noc-light .noc-badge-crit   { background: rgba(239,68,68,0.08); color: #dc2626; border-color: rgba(239,68,68,0.2); }

/* ── Theme Toggle Button ── */
.theme-toggle-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 34px;
  height: 34px;
  border-radius: 50%;
  background: rgba(15,23,42,0.75);
  border: 1px solid rgba(56,189,248,0.2);
  color: #94a3b8;
  cursor: pointer;
  backdrop-filter: blur(8px);
  transition: all 0.2s;
  box-shadow: 0 2px 8px rgba(0,0,0,0.3);
}
.theme-toggle-btn:hover {
  background: rgba(30,42,60,0.9);
  color: #e2e8f0;
  border-color: rgba(56,189,248,0.4);
  box-shadow: 0 4px 14px rgba(0,0,0,0.4);
  transform: scale(1.05);
}

/* ==========================================================================
   REDESIGNED TELEMETRY HUD MODAL (FLAT, SQUARE, HIGH-CONTRAST)
   ========================================================================== */

/* Core Modal Card */
.noc-modal-card {
  border-radius: 0px !important;
  box-shadow: none !important;
  transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
  font-family: v-bind('CONFIG.fontFamily') !important;
}

/* Modal Headers & footers */
.noc-modal-header,
.noc-modal-footer,
.noc-modal-body {
  border-radius: 0px !important;
}

.noc-hud-divider-v {
  font-weight: 300;
  margin: 0 4px;
}

/* Close Button */
.noc-modal-close-btn {
  border-radius: 0px !important;
  border: 1px solid transparent;
  transition: all 0.15s ease;
}

/* Parameter Grid & Monospace value cards */
.noc-modal-param-card {
  border-radius: 0px !important;
  box-shadow: none !important;
  margin-bottom: 12px;
  transition: all 0.15s ease;
}

.noc-param-header,
.noc-param-grid,
.noc-param-footer {
  border-radius: 0px !important;
}

/* Beacon red pulse next to excursions header */
.noc-pulse-dot-red {
  display: inline-block;
  width: 6px;
  height: 6px;
  background-color: #ef4444;
  border-radius: 50% !important;
  animation: noc-live-pulse 1.8s ease-in-out infinite;
}

/* Status Badges */
.noc-modal-status-badge {
  border-radius: 0px !important;
  font-family: 'Barlow Condensed', monospace !important;
}

/* Flat square button */
.noc-modal-btn {
  border-radius: 0px !important;
  box-shadow: none !important;
  cursor: pointer;
}

/* Empty State / Nominal State Box */
.noc-nominal-icon-container {
  border-radius: 0px !important;
}

/* ================= DARK MODE SPECIFIC STYLES ================= */
.noc-dark-modal {
  background: #090f16 !important;
  border-color: #374151 !important; /* Lighter high-contrast modal border */
}

.noc-dark-modal .noc-modal-header {
  background: #0d121c;
  border-color: #2d3748; /* Crisp header border */
}

.noc-dark-modal .noc-line-name-txt {
  color: #cbd5e1; /* Lighter name text for line prefix */
  font-weight: 500;
}

.noc-dark-modal .noc-sep-txt {
  color: #475569;
  font-weight: 300;
}

.noc-dark-modal .noc-mch-name-txt {
  color: #ffffff !important;
  font-weight: 800;
}

.noc-dark-modal .noc-modal-close-btn {
  color: #94a3b8; /* Lighter close button icon */
}

.noc-dark-modal .noc-modal-close-btn:hover {
  background: rgba(255, 255, 255, 0.05);
  color: #ffffff;
  border-color: rgba(255, 255, 255, 0.1);
}

.noc-dark-modal .noc-modal-body {
  background: #090f16;
}

.noc-dark-modal .noc-abnormalities-header {
  color: #94a3b8 !important;
}

/* Dark mode parameter cards */
.noc-dark-modal .noc-modal-param-card {
  background: #0d121c;
}

.noc-dark-modal .noc-param-header {
  border-color: #475569 !important; /* Crisp industrial borders */
  color: #ffffff;
}

.noc-dark-modal .noc-param-group-title {
  color: #ffffff !important;
}

.noc-dark-modal .noc-raw-name {
  color: #94a3b8 !important; /* Clear readable slate color for raw string */
}

.noc-dark-modal .noc-axis-label {
  color: #94a3b8 !important; /* Clear readable label prefix */
}

.noc-dark-modal .noc-axis-value {
  color: #38bdf8 !important;
}

.noc-dark-modal .noc-axis-col {
  border-color: #475569 !important;
}

.noc-dark-modal .noc-param-grid {
  border-color: #475569 !important;
}

.noc-dark-modal .noc-param-grid > * {
  border-color: #475569 !important;
  color: #e2e8f0;
}

.noc-dark-modal .noc-telemetry-label {
  color: #94a3b8 !important; /* Extremely high contrast telemetry headers */
}

.noc-dark-modal .noc-param-footer {
  border-color: #475569 !important;
  color: #94a3b8; /* Readable footers */
  background: rgba(255, 255, 255, 0.01);
}

/* Dynamic State colors (Amber & Red) for cards in Dark mode */
.noc-dark-modal .noc-param-card-warning {
  border-color: #475569 !important;
  border-left-color: #f59e0b !important;
}
.noc-dark-modal .noc-param-card-warning:hover {
  background: rgba(245, 158, 11, 0.03) !important;
  border-color: #f59e0b !important;
}

.noc-dark-modal .noc-param-card-critical {
  border-color: #475569 !important;
  border-left-color: #ef4444 !important;
}
.noc-dark-modal .noc-param-card-critical:hover {
  background: rgba(239, 68, 68, 0.03) !important;
  border-color: #ef4444 !important;
}

/* Badges */
.noc-dark-modal .noc-badge-warning {
  background: rgba(245, 158, 11, 0.1) !important;
  border-color: rgba(245, 158, 11, 0.3) !important;
  color: #fbbf24 !important;
}

.noc-dark-modal .noc-badge-critical {
  background: rgba(239, 68, 68, 0.1) !important;
  border-color: rgba(239, 68, 68, 0.3) !important;
  color: #f87171 !important;
}

/* Values */
.noc-dark-modal .noc-value-warning {
  color: #fbbf24 !important;
}

.noc-dark-modal .noc-value-critical {
  color: #f87171 !important;
}

/* Footer / Close btn */
.noc-dark-modal .noc-modal-footer {
  background: #0d121c;
  border-color: #1a2535;
}

.noc-dark-modal .noc-modal-btn {
  background: transparent;
  border-color: #334155;
  color: #94a3b8;
}

.noc-dark-modal .noc-modal-btn:hover {
  background: #ffffff;
  color: #090f16;
  border-color: #ffffff;
}

/* Status Pill in header */
.noc-dark-modal .noc-status-ok {
  background: rgba(34, 197, 94, 0.1) !important;
  border-color: rgba(34, 197, 94, 0.4) !important;
  color: #4ade80 !important;
}
.noc-dark-modal .noc-status-warning {
  background: rgba(245, 158, 11, 0.1) !important;
  border-color: rgba(245, 158, 11, 0.4) !important;
  color: #fbbf24 !important;
}
.noc-dark-modal .noc-status-critical {
  background: rgba(239, 68, 68, 0.1) !important;
  border-color: rgba(239, 68, 68, 0.4) !important;
  color: #f87171 !important;
}
.noc-dark-modal .noc-status-disconnected {
  background: rgba(148, 163, 184, 0.1) !important;
  border-color: rgba(148, 163, 184, 0.4) !important;
  color: #94a3b8 !important;
}

/* Nominal State empty state box in dark mode */
.noc-dark-modal .noc-nominal-icon-container {
  border-color: rgba(16, 185, 129, 0.2);
  background: rgba(16, 185, 129, 0.03);
}


/* ================= LIGHT MODE SPECIFIC STYLES ================= */
.noc-light-modal {
  background: #ffffff !important;
  border-color: #cbd5e1 !important;
}

.noc-light-modal .noc-modal-header {
  background: #f8fafc;
  border-color: #cbd5e1;
}

.noc-light-modal .noc-line-name-txt {
  color: #64748b;
  font-weight: 500;
}

.noc-light-modal .noc-sep-txt {
  color: #cbd5e1;
  font-weight: 300;
}

.noc-light-modal .noc-mch-name-txt {
  color: #0f172a !important;
  font-weight: 800;
}

.noc-light-modal .noc-modal-close-btn {
  color: #64748b;
}

.noc-light-modal .noc-modal-close-btn:hover {
  background: rgba(0, 0, 0, 0.05);
  color: #0f172a;
  border-color: rgba(0, 0, 0, 0.1);
}

.noc-light-modal .noc-modal-body {
  background: #ffffff;
}

.noc-light-modal .noc-abnormalities-header {
  color: #64748b !important;
}

/* Light mode parameter cards */
.noc-light-modal .noc-modal-param-card {
  background: #f8fafc;
}

.noc-light-modal .noc-param-header {
  border-color: #e2e8f0 !important; /* Solid crisp slate border */
  color: #0f172a;
}

.noc-light-modal .noc-param-group-title {
  color: #0f172a !important;
}

.noc-light-modal .noc-raw-name {
  color: #64748b !important;
}

.noc-light-modal .noc-axis-label {
  color: #94a3b8 !important;
}

.noc-light-modal .noc-axis-value {
  color: #1e293b !important;
}

.noc-light-modal .noc-axis-col {
  border-color: #e2e8f0 !important;
}

.noc-light-modal .noc-param-grid {
  border-color: #e2e8f0 !important;
}

.noc-light-modal .noc-param-grid > * {
  border-color: #e2e8f0 !important;
  color: #334155;
}

.noc-light-modal .noc-telemetry-label {
  color: #64748b !important;
}

.noc-light-modal .noc-param-footer {
  border-color: #e2e8f0 !important;
  color: #64748b;
  background: rgba(0, 0, 0, 0.01);
}

/* Dynamic State colors (Amber & Red) for cards in Light mode */
.noc-light-modal .noc-param-card-warning {
  border-color: #cbd5e1 !important;
  border-left-color: #d97706 !important;
}
.noc-light-modal .noc-param-card-warning:hover {
  background: rgba(245, 158, 11, 0.03) !important;
  border-color: #d97706 !important;
}

.noc-light-modal .noc-param-card-critical {
  border-color: #cbd5e1 !important;
  border-left-color: #dc2626 !important;
}
.noc-light-modal .noc-param-card-critical:hover {
  background: rgba(239, 68, 68, 0.03) !important;
  border-color: #dc2626 !important;
}

/* Badges */
.noc-light-modal .noc-badge-warning {
  background: rgba(245, 158, 11, 0.08) !important;
  border-color: rgba(245, 158, 11, 0.25) !important;
  color: #b45309 !important;
}

.noc-light-modal .noc-badge-critical {
  background: rgba(239, 68, 68, 0.08) !important;
  border-color: rgba(239, 68, 68, 0.25) !important;
  color: #b91c1c !important;
}

/* Values */
.noc-light-modal .noc-value-warning {
  color: #d97706 !important;
}

.noc-light-modal .noc-value-critical {
  color: #dc2626 !important;
}

/* Footer / Close btn */
.noc-light-modal .noc-modal-footer {
  background: #f8fafc;
  border-color: #cbd5e1;
}

.noc-light-modal .noc-modal-btn {
  background: transparent;
  border-color: #94a3b8;
  color: #475569;
}

.noc-light-modal .noc-modal-btn:hover {
  background: #0f172a;
  color: #ffffff;
  border-color: #0f172a;
}

/* Status Pill in header */
.noc-light-modal .noc-status-ok {
  background: rgba(34, 197, 94, 0.08) !important;
  border-color: rgba(34, 197, 94, 0.3) !important;
  color: #16a34a !important;
}
.noc-light-modal .noc-status-warning {
  background: rgba(245, 158, 11, 0.08) !important;
  border-color: rgba(245, 158, 11, 0.3) !important;
  color: #b45309 !important;
}
.noc-light-modal .noc-status-critical {
  background: rgba(239, 68, 68, 0.08) !important;
  border-color: rgba(239, 68, 68, 0.3) !important;
  color: #b91c1c !important;
}
.noc-light-modal .noc-status-disconnected {
  background: rgba(148, 163, 184, 0.08) !important;
  border-color: rgba(148, 163, 184, 0.3) !important;
  color: #64748b !important;
}

/* Nominal State empty state box in light mode */
.noc-light-modal .noc-nominal-icon-container {
  border-color: rgba(16, 185, 129, 0.25);
  background: rgba(16, 185, 129, 0.04);
}

/* ==========================================================================
   HIGH-CONTRAST DYNAMIC TELEMETRY LIMIT DIRECTION BADGES
   ========================================================================== */

/* Dark Modal Trend Badges */
.noc-dark-modal .noc-type-badge-increasing {
  border-color: rgba(245, 158, 11, 0.4) !important;
  color: #fbbf24 !important;
  background: rgba(245, 158, 11, 0.1) !important;
}
.noc-dark-modal .noc-type-badge-decreasing {
  border-color: rgba(56, 189, 248, 0.4) !important;
  color: #38bdf8 !important;
  background: rgba(56, 189, 248, 0.1) !important;
}
.noc-dark-modal .noc-type-badge-bool {
  border-color: rgba(168, 85, 247, 0.4) !important;
  color: #c084fc !important;
  background: rgba(168, 85, 247, 0.1) !important;
}

/* Light Modal Trend Badges (Optimized for High-Contrast Readability) */
.noc-light-modal .noc-type-badge-increasing {
  border-color: rgba(217, 119, 6, 0.5) !important;
  color: #b45309 !important;
  background: #fffbeb !important;
}
.noc-light-modal .noc-type-badge-decreasing {
  border-color: rgba(2, 132, 199, 0.5) !important;
  color: #0369a1 !important;
  background: #f0f9ff !important;
}
.noc-light-modal .noc-type-badge-bool {
  border-color: rgba(124, 58, 237, 0.5) !important;
  color: #6d28d9 !important;
  background: #f5f3ff !important;
}

/* ── Right Panel Header Upgrade ── */
.noc-right-header {
  border-bottom-width: 1px;
  border-bottom-style: solid;
  backdrop-filter: blur(12px);
  box-shadow: 0 4px 20px -5px rgba(0, 0, 0, 0.12);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}
.noc-dark-right-header {
  background: linear-gradient(180deg, rgba(13, 17, 23, 0.90) 0%, rgba(9, 13, 18, 0.95) 100%);
  border-bottom-color: rgba(71, 85, 105, 0.4); /* Sleek slate-600 outline */
}
.noc-dark-right-header .noc-plant-name {
  color: #ffffff;
  font-family: 'Barlow Condensed', monospace !important;
  letter-spacing: 0.08em;
  text-shadow: 0 0 12px rgba(255, 255, 255, 0.15);
}
.noc-light-right-header {
  background: linear-gradient(180deg, rgba(255, 255, 255, 0.92) 0%, rgba(248, 250, 252, 0.96) 100%);
  border-bottom-color: rgba(203, 213, 225, 0.8); /* Slate-300 */
  box-shadow: 0 4px 12px -4px rgba(100, 116, 139, 0.08);
}
.noc-light-right-header .noc-plant-name {
  color: #0f172a;
  font-family: 'Barlow Condensed', monospace !important;
  letter-spacing: 0.08em;
  text-shadow: 0 1px 1px rgba(0, 0, 0, 0.03);
}

/* Glowing Plant Badge */
.noc-plant-badge-dark {
  background: rgba(5, 175, 241, 0.08) !important;
  border: 1px solid rgba(5, 175, 241, 0.35) !important;
  color: #05AFF1 !important;
  box-shadow: 0 0 12px rgba(5, 175, 241, 0.12);
  border-radius: 4px;
}
.noc-plant-badge-light {
  background: rgba(0, 139, 197, 0.06) !important;
  border: 1px solid rgba(0, 139, 197, 0.25) !important;
  color: #008bc5 !important;
  border-radius: 4px;
}
</style>


