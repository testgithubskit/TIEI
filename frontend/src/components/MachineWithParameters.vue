<script setup>
import { computed, watch } from "vue";
import MachineParameter from "@/components/MachineParameter.vue";

const props = defineProps({
  machineState: {
    type: String,
    default: null,
  },
  machineName: {
    type: String,
    default: null,
  },
  parameters: {
    type: Array,
    default:  [
              {
                "parameter_state": "normal",
                "parameter_value": 42,
                "actual_parameter_name": "temperature",
                "internal_parameter_name": "temp_1",
                "display_name": "X",
                "latest_update_time": 1702356875000
              },
              {
                "parameter_state": "warning",
                "parameter_value": 15,
                "actual_parameter_name": "pressure",
                "internal_parameter_name": "pressure_1",
                "display_name": "Y",
                "latest_update_time": 1702356875000
              },
              {
                "parameter_state": "critical",
                "parameter_value": 78,
                "actual_parameter_name": "velocity",
                "internal_parameter_name": "vel_1",
                "display_name": "Z",
                "latest_update_time": 1702356875000
              }
            ],
  },
  borderSide: {
    type: String,
    default: "s",
  },
  borderThickness: {
    type: String,
    default: "4",
  },
});

const machineBgColor = computed(() => {
  return {
    OK: "bg-emerald-600",
    WARNING: "bg-yellow-600",
    CRITICAL: "bg-red-600",
    DISCONNECTED:"bg-slate-500",
    info: null,
  }[props.machineState];
});

const borderClass = computed(() => {
  return `rounded-lg shadow-lg hover:shadow-md transition-shadow duration-10`;
});

const borderColor = computed(() => {
  return {
    OK: "emerald-600",
    WARNING: "yellow-600",
    CRITICAL: "red-600",
    DISCONNECTED:"bg-slate-500",
  }[props.machineState];
});

const machineWidth = computed(() => {
  const baseWidth = 16;
  const maxParameters = 6;
  const incrementalWidth = 8;

  const maxWidth = baseWidth + incrementalWidth * maxParameters;
  const numeberOfParameters = props.parameters.length;
  const currentWidth = baseWidth + incrementalWidth * numeberOfParameters;
  const appropriateWidth = Math.min(maxWidth, currentWidth);
  const appropriateWidthString = `w-${appropriateWidth}`;

  return appropriateWidthString;
});



const emit = defineEmits(['machine-parameter-clicked']);

// Watch for changes in the parameters array
watch(
  () => props.parameters,
  (newParameters) => {
    // Handle the event emitted by the child component
  },
  { deep: true }
);

// Function to handle the event received from the child component
const handleMachineParameterClick = (clickedParameter) => {
  // Perform any necessary actions with the updated parameters
  let evenData = clickedParameter;
  evenData.machineName = props.machineName;
  emit('machine-parameter-clicked', clickedParameter);
};

</script>

<template>
  <div :class="[machineWidth, borderClass]" class="flex flex-col mx-0">
    <div class="p-4 rounded-t-lg text-white text-center h-5 flex items-center justify-center" :class="machineBgColor">{{ props.machineName }}</div>
    <div class="flex flex-wrap justify-start">
      <MachineParameter
        v-for="parameter in props.parameters"
        :key="parameter.internal_parameter_name"
        :parameterState="parameter.parameter_state"
        :parameterValue="parameter.parameter_value"
        :actualParameterName="parameter.actual_parameter_name"
        :internalParameterName="parameter.internal_parameter_name"
        :displayName="parameter.display_name"
        :lastestUpdateTime="parameter.latest_update_time"
        @machine-parameter-clicked="handleMachineParameterClick"
      />
    </div>
  </div>
</template>
