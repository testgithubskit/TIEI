# Machine-Level Disconnection Implementation

## Overview
This document describes the implementation of machine-level disconnection logic based on the `cycle_time_limits` table status column, which is independent of parameter/axis-specific disconnection logic.

**Important Notes:**
- The `status` column already exists in the `cycle_time_limits` table
- An existing script automatically populates this column
- This implementation only reads from the existing status column
- No changes are made to how data is written to the table
- The existing parameter/axis-level disconnection logic remains unchanged

## Changes Made

### 1. Database Model Update (pony_models.py)
**File:** `backend/machine_monitoring_app/database/pony_models.py`

**Change:** Added `status` field to `CycleTimeLimits` model to match existing database column
```python
class CycleTimeLimits(PONY_DATABASE.Entity):
    """Represents the warning and critical limits for cycle time per machine"""

    _table_ = (schema_name, "cycle_time_limits")

    id = PrimaryKey(int, auto=True)
    machine = Required(Machine, column="machine_id")
    warning_limit = Required(float)
    critical_limit = Required(float)
    status = Optional(str)  # DISCONNECTED, NOT_DISCONNECTED, ACTIVE - already exists in DB
```

**Status Values (already in database):**
- `DISCONNECTED`: Machine is disconnected (irrespective of parameters)
- `NOT_DISCONNECTED`: Machine is connected and operational
- `ACTIVE`: Special purpose machine (excluded from counts)

### 2. Backend Logic Updates (crud_operations.py)

#### Function: `get_machine_states_2()`
**File:** `backend/machine_monitoring_app/database/crud_operations.py` (lines 1603-1634)

**Change:** Added machine-level disconnection check before parameter-level logic
```python
# First check machine-level disconnection status from cycle_time_limits table
machine_obj = Machine.get(name=machine_name)
machine_disconnected = False

if machine_obj:
    cycle_time_limits = CycleTimeLimits.get(machine=machine_obj)
    if cycle_time_limits:
        # Check machine-level status
        if cycle_time_limits.status == 'DISCONNECTED':
            machine_json['machine_state'] = 'DISCONNECTED'
            location_json['count']['DISCONNECTED'] += 1
            machine_disconnected = True
        elif cycle_time_limits.status == 'ACTIVE':
            # Skip special purpose machines - don't count them
            machine_disconnected = True  # Mark as processed to skip parameter-level logic

# If not machine-level disconnected, use parameter-level logic
if not machine_disconnected:
    # Existing parameter-level logic...
```

#### Function: `get_real_time_parameters_data_by_group()`
**File:** `backend/machine_monitoring_app/database/crud_operations.py` (lines 1186-1217)

**Change:** Added same machine-level disconnection check and updated count structure to include DISCONNECTED
```python
group_json = {'group_name': group_name, 'group_details': [], 'group_state': 'OK',
              'count': {'OK': 0, 'WARNING': 0, 'CRITICAL': 0, 'DISCONNECTED': 0}}

# Machine-level check logic same as above...
```

#### Function: `get_real_time_parameters_data()`
**File:** `backend/machine_monitoring_app/database/crud_operations.py` (lines 196-227)

**Change:** Added same machine-level disconnection check and updated count structure to include DISCONNECTED
```python
group_json = {'group_name': group_name, 'group_details': [], 'group_state': 'OK',
              'count': {'OK': 0, 'WARNING': 0, 'CRITICAL': 0, 'DISCONNECTED': 0}}

# Machine-level check logic same as above...
```

#### Function: `get_real_time_parameters_data_mtlinki_new_layout()`
**File:** `backend/machine_monitoring_app/database/crud_operations.py` (lines 6103-6177)

**Change:** Added machine-level disconnection check and updated count structure to include DISCONNECTED for Managerial Overview endpoint
```python
location_json = {'line_name': location, 'machines': [], 'line_state': 'OK',
                 'count': {'OK': 0, 'WARNING': 0, 'CRITICAL': 0, 'DISCONNECTED': 0}}

# Machine-level check logic same as above...
```

## Logic Flow

### Priority Order for Machine State Determination:
1. **Machine-Level Check (Highest Priority):**
   - Check `cycle_time_limits.status` for the machine
   - If `DISCONNECTED`: Mark machine as DISCONNECTED, increment DISCONNECTED count
   - If `ACTIVE`: Skip machine entirely (special purpose machine)
   - If `NOT_DISCONNECTED` or no entry: Proceed to parameter-level check

2. **Parameter-Level Check (Fallback - UNCHANGED):**
   - Only executed if machine-level check doesn't determine state
   - Existing logic remains completely unchanged
   - Check if ALL parameters for the selected parameter group are disconnected
   - If all parameters disconnected: Mark as DISCONNECTED
   - Otherwise: Use existing OK/WARNING/CRITICAL logic based on parameter states

**Key Point:** The existing parameter/axis-level disconnection logic is preserved exactly as it was. The machine-level check is an additional layer that takes precedence but doesn't modify the existing behavior.

## Testing Recommendations

1. **Test Machine-Level Disconnection:**
   - Set `status = 'DISCONNECTED'` for a machine in `cycle_time_limits`
   - Verify the machine shows as DISCONNECTED regardless of parameter states
   - Verify DISCONNECTED count increases in factory summary

2. **Test Special Purpose Machines:**
   - Set `status = 'ACTIVE'` for special purpose machines
   - Verify these machines are excluded from all counts
   - Verify they don't appear in the factory summary

3. **Test Normal Operation:**
   - Set `status = 'NOT_DISCONNECTED'` for normal machines
   - Verify parameter-level logic works as before
   - Verify OK/WARNING/CRITICAL counts are accurate

4. **Test Mixed Scenarios:**
   - Some machines with machine-level DISCONNECTED
   - Some with parameter-level disconnection
   - Some with ACTIVE status
   - Verify total counts are accurate

## Frontend Changes

### 1. Managerial Overview Component (ManagerialOverview.vue)
**File:** `frontend/src/views/ManagerialOverview.vue`

**Changes:**

#### A. Alert Feed Enhancement (lines 866-915)
- Updated `allAlerts` computed property to include DISCONNECTED machines
- Machines with `machine_state === 'DISCONNECTED'` are now added to the alert feed
- Displayed with group: 'MACHINE STATUS', displayName: 'DISC', value: 'N/A'
- Sorting updated to prioritize: CRITICAL > WARNING > DISCONNECTED

#### B. Alert Count Update (line 59)
- Changed alert count from `totalWarning + totalCritical` to `totalWarning + totalCritical + totalDisconnected`

#### C. Status Bar Fix (line 49)
- Changed from calculated value to use `totalDisconnected` computed property

#### D. Computed Property Addition (line 859)
- Added `totalDisconnected` computed property to calculate disconnected machine count

#### E. Alert Row Styling (lines 99-103)
- Updated class binding to handle DISCONNECTED state with `noc-alert-disc-row`

#### F. CSS Styling Added
- Dark theme DISCONNECTED alert rows (lines 1502-1508): Slate gray background with hover effect
- Light theme DISCONNECTED alert rows (lines 1568-1574): Slate gray background with hover effect

#### G. Value Text Color (lines 120-127)
- Added slate-400 color for DISCONNECTED state in alert values

#### H. Machine View Enhancements
- Auto-show tooltip for DISCONNECTED machines (line 1033)
- Added bounce animation for DISCONNECTED machines (line 327)
- Added glow effect for DISCONNECTED machines (lines 582-589)
- Platform colors: #3B3B3B (dark gray) for DISCONNECTED state
- Beacon colors: #3B3B3B theme for DISCONNECTED state
- Tooltip stroke: #3B3B3B for DISCONNECTED state
- Tooltip text color: #9CA3AF for DISCONNECTED state

### 2. Factory Poll Overview (FactoryPollOverview.vue)
**File:** `frontend/src/views/FactoryPollOverview.vue`

**Changes:**
- No changes required - automatically picks up DISCONNECTED counts from updated API responses
- The count structure already supports DISCONNECTED

## API Endpoints Affected

1. `/api/v1/factory/layout` - Uses `get_real_time_parameters_data()`
2. `/api/v1/factory-state-mtlinki-test/{parameterGroupName}` - Uses `get_machine_states_2()`
3. `/api/v1/factory/new_layout_mtlinki` - Uses `get_real_time_parameters_data_mtlinki_new_layout()` (Managerial Overview)
4. Internal function `get_real_time_parameters_data_by_group()` - Used by other endpoints

## Notes

- The parameter-level disconnection logic (based on MT-Linki data) remains unchanged and works as a fallback
- Machine-level disconnection takes precedence over parameter-level disconnection
- Special purpose machines (ACTIVE status) are completely excluded from counts
- The 59 regular machines should have their status properly set in the `cycle_time_limits` table
