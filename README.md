# Managerial Plant Overview Endpoint Documentation

This document describes the backend endpoint and response structure utilized by the `ManagerialOverview.vue` screen.

## Endpoint Details

- **Path**: `/api/v1/factory/new_layout_mtlinki`
- **HTTP Method**: `GET`
- **Controller/Router**: `backend/machine_monitoring_app/routers/front_end_utility_route.py`
- **Router function**: `read_factory_layout_mtlinki`
- **Database call**: `get_real_time_parameters_data_mtlinki_new_layout()`
- **Response model**: `new_ResponseModel` (defined in `backend/machine_monitoring_app/models/response_models.py`)

## Response Structure (utilized by frontend)

The endpoint returns a list of production lines, where each line contains status counts and a list of machines. Each machine has its own state, counts, and parameters.

### JSON Representation

```json
{
  "lines": [
    {
      "line_name": "BLOCK",
      "line_state": "OK",
      "count": {
        "OK": 12,
        "WARNING": 2,
        "CRITICAL": 0
      },
      "machines": [
        {
          "machine_name": "M-101",
          "machine_state": "WARNING",
          "count": {
            "OK": 5,
            "WARNING": 1,
            "CRITICAL": 0
          },
          "parameters": [
            {
              "actual_parameter_name": "Spindle Temperature",
              "display_name": "Temp",
              "internal_parameter_name": "A0-P1",
              "latest_update_time": 1716182400000,
              "parameter_value": 45.2,
              "parameter_state": "WARNING",
              "warning_limit": 40.0,
              "critical_limit": 50.0
            }
          ]
        }
      ]
    }
  ]
}
```

### Response Schema Fields Definition

#### Root Object (`new_ResponseModel`)
* **`lines`**: List of production line objects.

#### Line Object (`new_Line`)
* **`line_name`**: Name of the line (e.g. `"BLOCK"`, `"CRANK"`, `"HEAD"`).
* **`line_state`**: Overall state of the line (e.g. `"OK"`, `"WARNING"`, `"CRITICAL"`).
* **`count`**: A counter object containing the breakdown of machine states in this line.
  * **`OK`**: Count of machines in OK state.
  * **`WARNING`**: Count of machines in WARNING state.
  * **`CRITICAL`**: Count of machines in CRITICAL state.
* **`machines`**: List of machine objects within this line.

#### Machine Object (`new_Machine`)
* **`machine_name`**: Name of the machine (e.g. `"OP10"`, `"OP20"`).
* **`machine_state`**: State of the machine (e.g. `"OK"`, `"WARNING"`, `"CRITICAL"`).
* **`count`**: Counter object containing parameter state counts:
  * **`OK`**: Count of parameters in OK state.
  * **`WARNING`**: Count of parameters in WARNING state.
  * **`CRITICAL`**: Count of parameters in CRITICAL state.
* **`parameters`**: List of parameter objects monitored on this machine.

#### Parameter Object (`new_Parameter`)
* **`actual_parameter_name`**: Human-readable name of the parameter.
* **`display_name`**: Short label for display.
* **`internal_parameter_name`**: Internal identifier used for mapping.
* **`latest_update_time`**: Timestamp of the last data update (epoch milliseconds).
* **`parameter_value`**: Current numeric value of the parameter.
* **`parameter_state`**: Current state of the parameter (e.g. `"OK"`, `"WARNING"`, `"CRITICAL"`).
* **`warning_limit`**: Threshold above/below which the parameter goes into WARNING state.
* **`critical_limit`**: Threshold above/below which the parameter goes into CRITICAL state.

---

## Screen Usage & Integration

The screen `ManagerialOverview.vue` consumes this data via the Pinia store `useFactoryOverviewStore`. 

1. **State Loading**: `factoryStore.isLoading` manages the display of loading spinner.
2. **Line Overview Grid**: Iterates over `factoryStore.formattedOverviewData.lines` to render individual production lines.
3. **Machine Filter**: Interacts with buttons for filtering machines within a line (All, OK, Warning, Critical) based on the `line_state` counters.
4. **Machine Detail Modal**: Clicking a machine reveals a modal showing abnormal parameters (parameters where `parameter_state !== 'OK'`).
5. **Detailed Sampling Navigation**: Clicking an abnormal parameter redirects the user to `/machine-level-sampling`, saving the selected parameter config in `MachineSamplingWithLimitsStore`.
