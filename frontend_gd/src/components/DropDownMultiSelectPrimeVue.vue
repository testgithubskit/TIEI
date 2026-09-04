<script setup>
import { ref, watch, onMounted } from "vue";
import MultiSelect from "primevue/multiselect";

// Define props to receive external data and options
defineProps({
  parameters: {
    type: Array, // Expect an array of parameter objects
    required: true,
    default: [{'name': 'temperature', 'item_state': 'OK'},
     {'name': 'pressure', 'item_state': 'WARNING'},
     {'name': 'temperature1', 'item_state': 'OK'},
     {'name': 'pressure1', 'item_state': 'WARNING'},
     {'name': 'temperature2', 'item_state': 'OK'},
     {'name': 'pressure3', 'item_state': 'WARNING'}]
  },
  placeholder: { 
    type: String,
    default: "Select Parameters" // Set a default placeholder
  }
});

const selectedParameters = ref([]);
const emit = defineEmits(['parametersChange']); 

// Function to determine background color based on state
const itemBgColor = (state) => {
  return {
    OK: "bg-emerald-600",
    WARNING: "bg-yellow-600",
    CRITICAL: "bg-red-600",
  }[state];
};

let passThroughDropDown = { 
  root: {class:'border-1 border-black'}, 
  itemCheckbox: {class:'border-2 border-black'}
};

// Watch for changes in selectedParameters
watch(selectedParameters, (newParameters) => {
  emit('parametersChange', newParameters);
});

// Function to handle selection limit
const handleSelectionLimit = () => {
  if (selectedParameters.value.length === 3) {
    // Disable the dropdown after three selections
    const dropdown = document.querySelector('.p-multiselect-panel');
    if (dropdown) {
      dropdown.style.display = 'none';
    }
  }
};

// Watch for changes in selectedParameters to handle selection limit
watch(selectedParameters, () => {
  handleSelectionLimit();
}, { immediate: true });

// Enable dropdown on component mount
onMounted(() => {
  const dropdown = document.querySelector('.p-multiselect-panel');
  if (dropdown) {
    dropdown.style.display = 'block';
  }
});
</script>

<template>
  <div class="card flex justify-content-center">
    <MultiSelect v-model="selectedParameters" :options="parameters" optionLabel="name" :placeholder="placeholder"
      class="w-full md:w-20rem" :pt="passThroughDropDown">

      <template #option="slotProps">
        <div class="flex align-items-center">
          <div>{{ slotProps.option.name }}</div>
          <div class="flex items-center ml-auto"> 
            <div :class="[itemBgColor(slotProps.option.item_state), 'w-4 h-4 rounded-full ml-2']">
            </div>
          </div>
        </div>
      </template>

      <template #footer>
        <div class="py-2 px-3">
          <b>{{ selectedParameters ? selectedParameters.length : 0 }}</b> item{{ (selectedParameters ? selectedParameters.length : 0) > 1 ? 's' : '' }} selected.
        </div>
      </template>

    </MultiSelect>
  </div>
</template>
