# Air Pressure Monitoring Feature — Change Log

This document lists **every file touched** for the **AIR_PRESSURE** monitoring feature (machines **2nd Rough** and **4th Finish** on **BLOCK** line).  
Data source: PostgreSQL tables `pressure_monitoring_machine` and `pressure_sensor_data` via **raw SQL** (not Pony ORM models).

---

## Feature summary

| Item | Detail |
|------|--------|
| Parameter group | `AIR_PRESSURE` |
| Machines | `2nd Rough` (id 1), `4th Finish` (id 2) |
| Line | `BLOCK` |
| States | OK / WARNING / CRITICAL only |
| Chart time range | 1–3 seconds (`created_at` filter) |
| Latest reading | `ORDER BY created_at DESC, "timestamp" DESC` per machine |
| `latest_update_time` in API | IST string from `created_at` |
| `latest_update_time_ms` in API | Epoch ms from `created_at` |

---

## New files added

| File | Purpose |
|------|---------|
| `backend/scripts/test_pressure_queries.py` | Local script to test pressure SQL queries |
| `backend/scripts/test_pressure_raw_sql.py` | Local script to test DISTINCT ON / LATERAL SQL via Pony connection |
| `backend/scripts/test_user_timestamps.py` | Local script to verify timestamp parsing |
| `AIR_PRESSURE_MONITORING_FEATURE_README.md` | This documentation file |

---

## Backend changes

### 1. `backend/machine_monitoring_app/database/crud_operations.py`

**New constants (lines ~82–90)**

- `PRESSURE_PARAMETER_GROUP`, `PRESSURE_PARAMETER_NAME`, `PRESSURE_DISPLAY_NAME`
- `PRESSURE_AXIS_LABEL`, `PRESSURE_LINE_NAME = "BLOCK"`
- `PRESSURE_MIN_RANGE_SECONDS = 1`, `PRESSURE_MAX_RANGE_SECONDS = 3`
- `PRESSURE_MAX_CHART_POINTS = 120`, `PRESSURE_DB_TIMEZONE`

**New helper functions**

| Function | What it does |
|----------|----------------|
| `_pressure_dt_to_epoch_ms()` | Naive DB datetime → epoch ms (IST) |
| `_epoch_ms_to_pressure_dt()` | Epoch ms → naive IST datetime |
| `_format_pressure_sql_timestamp()` | SQL timestamp string |
| `_format_pressure_ist_datetime()` | API IST display string |
| `_pressure_sql_time_bounds()` | Inclusive `created_at` window for chart filter |
| `_downsample_pressure_chart_data()` | Cap chart points at 120 |
| `_build_pressure_chart_data()` | Map readings to selected time window for x-axis |
| `parse_pressure_time_param()` | Accept epoch ms or IST datetime string |
| `_escape_sql_literal()` | SQL string escape |
| `_execute_raw_sql()` | Run raw SQL via Pony connection cursor |
| `_get_pressure_parameter_state()` | OK / WARNING / CRITICAL from limits |
| `_fetch_pressure_machine_rows()` | Latest row per machine: `DISTINCT ON` / `created_at DESC, "timestamp" DESC` |
| `_build_pressure_machine_json()` | Machine + parameter JSON for factory state |
| `_merge_pressure_machines_into_lines()` | Append pressure machines to BLOCK line |
| `_merge_pressure_into_group_json()` | Merge into BLOCK for every parameter group **without changing `group_state`** |
| `get_pressure_monitoring_group_details()` | Full `AIR_PRESSURE` group for factory state API |
| `_get_pressure_group_status_item()` | `{ item_name, item_state }` for dropdown |
| `get_pressure_machine_timeline()` | Chart data for one machine + time window |

**Existing functions modified**

| Function | Change |
|----------|--------|
| `get_real_time_parameters_data()` | After each group built: `_merge_pressure_into_group_json()`; append `AIR_PRESSURE` group to layout |
| `get_machine_states_2()` | Before return: `_merge_pressure_into_group_json()` for non–AIR_PRESSURE groups |
| `get_latest_snapshot_for_parameter_group_test()` | If group is `AIR_PRESSURE`, return `get_pressure_monitoring_group_details()` |
| `get_parameter_group_statuses()` | Append `AIR_PRESSURE` status if missing |
| Factory layout line merge (~6632) | `_merge_pressure_machines_into_lines()` return tuple fix |

**SQL for latest machine value (matches your query)**

```sql
SELECT DISTINCT ON (machine_id)
    machine_id, pressure_value, created_at
FROM tiei_sample_5.pressure_sensor_data
ORDER BY machine_id, created_at DESC NULLS LAST, "timestamp" DESC NULLS LAST;
```

---

### 2. `backend/machine_monitoring_app/routers/core_data_route.py`

| Change | Detail |
|--------|--------|
| Import | `get_pressure_machine_timeline`, `parse_pressure_time_param` |
| **New route** | `GET /api/v1/pressure/machines/{machineName}/air-pressure` |
| Query params | `startTime`, `endTime` (epoch ms or IST datetime) |
| MT-Linki fallback | `read_timeline_machine_parameter_name_mtlinki`: if `parameterName == AIR_PRESSURE`, route to pressure timeline |
| `get_latest_snapshot_for_parameter_group_test` | Already calls pressure group via crud |

---

### 3. `backend/machine_monitoring_app/models/response_models.py`

| Model | Change |
|-------|--------|
| `ParameterSchema` (and related) | `latest_update_time: Union[int, str]`; added optional `latest_update_time_ms: int` |

---

### 4. `backend/machine_monitoring_app/database/pony_models.py`

**Not modified for this feature** (per requirement). If git shows changes, they are unrelated to air pressure.

---

## Frontend changes

### 5. `frontend/src/stores/MachineSamplingWithLimitsStore.js`

| Change | Detail |
|--------|--------|
| New export | `pressureTimeToEpoch()` — parse IST string or epoch |
| Pressure detection | `isPressureContext` getter |
| Time range | `pressureRangeSeconds`, `normalizeInvertedPressureTimeRange()` |
| `fetchPressureMachineData()` | Calls `/pressure/machines/{name}/air-pressure` |
| `fetchMachineParameterData()` | Redirects to pressure fetch when `AIR_PRESSURE` |
| `setMachineDetails()` | Initializes 3s window around `latest_update_time_ms` |
| Removed | `ensureValidPressureTimeRange()` auto-reset (was overwriting user From/To) |

---

### 6. `frontend/src/views/MachineLevelSamplingWithLimits.vue`

| Change | Detail |
|--------|--------|
| Pressure submit | 1–3 second validation only on Submit |
| Time pickers | Bound to store; no auto-reset on change |
| `initializePressureDates()` | On mount for pressure machines |
| Chart | Uses `DyLineChartWithLimits` with `colorByThresholds` |

---

### 7. `frontend/src/views/FactoryPollOverview.vue`

| Change | Detail |
|--------|--------|
| `pageReady` gate | Dropdown, abnormality summary, factory summary wait until layout loaded |
| `onBeforeMount` | Await `fetchInitialPageData` then set default `APC_BATTERY` |
| `onMounted` | Await `updateGroupData()` before showing data |
| `handleMachineParameterClick()` | Routes to pressure graph with `AIR_PRESSURE` group |
| `handleParameterClick()` | Abnormality chip → fetch group data |
| `abnormalParameters` | Dedupe by `item_name` |
| `ProductionLine` | `highlightPressureMachines` when `AIR_PRESSURE` selected |

---

### 8. `frontend/src/stores/FactoryPollGridStore.js`

| Change | Detail |
|--------|--------|
| `dedupeAvailableParameters()` | Prevent duplicate `AIR_PRESSURE` in dropdown |
| `ensureCycleTimeParameter()` | Keep `CYCLE_TIME` entry |
| Removed | Manual re-push of `AIR_PRESSURE` (was causing duplicates) |
| `setSelectedGroup()` / `getGroupDetail()` | Safe when group not found (no crash) |

---

### 9. `frontend/src/components/MachineWithParameters.vue`

| Change | Detail |
|--------|--------|
| Pressure detection | By `is_pressure_machine`, `AIR_PRESSURE`, or names `2nd Rough` / `4th Finish` |
| Pressure card UI | **Machine name only** — no AP axis, no value inside, same size as other cards |
| Click | Whole card opens air pressure graph |

---

### 10. `frontend/src/components/ProductionLine.vue`

| Change | Detail |
|--------|--------|
| `displayMachines` | Pressure machines first on BLOCK; only pressure when `AIR_PRESSURE` selected |
| Props | `highlightPressureMachines` passed to line |

---

### 11. `frontend/src/components/StatefulDropdownSingleSelect.vue`

| Change | Detail |
|--------|--------|
| Dedupe | `itemsMapped` by `item_name` |
| `isSyncingSelection` | Avoid spurious emit when setting default from parent |
| `defaultSelectedItem` watch | Sync without triggering false parameter change |

---

### 12. `frontend/src/components/TimePickerFlatEmitter.vue`

| Change | Detail |
|--------|--------|
| Watch `defaultDatetime` | Keep picker in sync when store updates dates |

---

### 13. `frontend/src/components/AbnormalitySummary.vue`

| Change | Detail |
|--------|--------|
| Dedupe items | By `item_name` before render |
| Key | Use `item.value` instead of index |

---

### 14. `frontend/src/components/MachineParameter.vue`

| Change | Detail |
|--------|--------|
| `lastestUpdateTime` | Accept `string` (IST) or `number` (epoch) |
| `displayUpdateTime` | Show IST string as-is when string |

---

### 15. `frontend/src/components/Charts/DyLineChartWithLimits.vue`

| Change | Detail |
|--------|--------|
| `colorByThresholds` | Green / orange / red series by OK / WARNING / CRITICAL |
| IST datetime strings | Supported on x-axis via `toChartDate()` |

---

### 16. `frontend/src/components/CardBoxWidgetPlainWrap.vue`

| Change | Detail |
|--------|--------|
| Limits props | Accept `Number` (fix crash when limits are numeric from pressure API) |

---

### 17. `frontend/src/views/ManagerialOverview.vue`

| Change | Detail |
|--------|--------|
| `formatDate()` | Show IST string for pressure `latest_update_time` |
| `logParameterDetails()` | Pass `latest_update_time_ms`, pressure flags |

---

## API endpoints used

| Method | URL | Purpose |
|--------|-----|---------|
| GET | `/api/v1/factory/layout` | Initial page layout + `AIR_PRESSURE` in group list |
| GET | `/api/v1/factory-state-mtlinki-test/AIR_PRESSURE` | Factory state for pressure group |
| GET | `/api/v1/factory-state-mtlinki-test/{group}` | Other groups (BLOCK includes 2 pressure machines) |
| GET | `/api/v1/pressure/machines/{machineName}/air-pressure?startTime=&endTime=` | Pressure chart (1–3 s window) |

---

## Changelog (Jul 7, 2026)

**Reverted** factory polling page loading logic in `FactoryPollOverview.vue`, `FactoryPollGridStore.js`, and `StatefulDropdownSingleSelect.vue` to match pre-feature behavior. Only minimal AIR_PRESSURE hooks remain (pressure machine click, AIR_PRESSURE groupData push).

**Backend fix retained:** `_merge_pressure_into_group_json()` does not set all parameter groups to CRITICAL.


**Symptom:** On factory polling grid load, all parameters briefly showed **CRITICAL** then corrected.

**Cause:** `_merge_pressure_into_group_json()` was setting `group_json['group_state'] = 'CRITICAL'` for **every** parameter group when the 2 pressure machines were CRITICAL.

**Fix:**
- Backend: merge machines onto BLOCK line and update **counts** only; **do not** change `group_state` of unrelated groups.
- Frontend: hide abnormality summary and factory summary until `pageReady` (after layout API returns).

---

## What was intentionally NOT changed

- `pony_models.py` — no pressure Pony models added
- Existing MT-Linki parameter logic — unchanged except `AIR_PRESSURE` routing fallback
- Pressure machines have **no axis badges** on factory grid (empty card body, name only)

---

## Deploy checklist

1. Restart backend on `172.18.100.87:8000`
2. Hard refresh frontend (`Ctrl + Shift + R`)
3. Verify `/factory/layout` → BLOCK has 9 machines for APC_BATTERY (7 + 2 pressure)
4. Verify `/factory-state-mtlinki-test/AIR_PRESSURE` → 2 machines only
5. Verify chart: `/pressure/machines/4th%20Finish/air-pressure?startTime=...&endTime=...` (1–3 s range)

---

## File change list (quick reference)

**Backend**
- `backend/machine_monitoring_app/database/crud_operations.py` — **modified** (main feature)
- `backend/machine_monitoring_app/routers/core_data_route.py` — **modified**
- `backend/machine_monitoring_app/models/response_models.py` — **modified**

**Frontend**
- `frontend/src/stores/MachineSamplingWithLimitsStore.js` — **modified**
- `frontend/src/stores/FactoryPollGridStore.js` — **modified**
- `frontend/src/views/MachineLevelSamplingWithLimits.vue` — **modified**
- `frontend/src/views/FactoryPollOverview.vue` — **modified**
- `frontend/src/views/ManagerialOverview.vue` — **modified**
- `frontend/src/components/MachineWithParameters.vue` — **modified**
- `frontend/src/components/ProductionLine.vue` — **modified**
- `frontend/src/components/MachineParameter.vue` — **modified**
- `frontend/src/components/StatefulDropdownSingleSelect.vue` — **modified**
- `frontend/src/components/TimePickerFlatEmitter.vue` — **modified**
- `frontend/src/components/AbnormalitySummary.vue` — **modified**
- `frontend/src/components/Charts/DyLineChartWithLimits.vue` — **modified**
- `frontend/src/components/CardBoxWidgetPlainWrap.vue` — **modified**

**New**
- `backend/scripts/test_pressure_*.py` — **added** (dev only)
- `AIR_PRESSURE_MONITORING_FEATURE_README.md` — **added** (this file)

---

*Generated for Toyota machine monitoring — Air Pressure feature integration.*
