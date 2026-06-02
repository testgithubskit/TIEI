<script setup>
import { ref } from "vue";
import AutoComplete from 'primevue/autocomplete';

const items = ref([
  "actual_production_time_cumulative",
  "actual_production_time_current_day",
  "actual_production_time_current_shift",
  "availability_cumulative",
  "availability_current_day",
  "availability_current_shift",
  "bad_part_count_cumulative",
  "bad_part_count_current_day",
  "bad_part_count_current_shift",
  "execution_mode",
  "good_part_count_cumulative",
  "good_part_count_current_day",
  "good_part_count_current_shift",
  "ideal_production_time_cumulative",
  "ideal_production_time_current_day",
  "ideal_production_time_current_shift",
  "machine_status",
  "oee_cumulative",
  "oee_current_day",
  "oee_current_shift",
  "performance_cumulative",
  "performance_current_day",
  "performance_current_shift",
  "planned_production_time_cumulative",
  "planned_production_time_current_day",
  "planned_production_time_current_shift",
  "program_status",
  "quality_cumulative",
  "quality_current_day",
  "quality_current_shift",
  "total_part_count_cumulative",
  "total_part_count_current_day",
  "total_part_count_current_shift"
].map(item => ({
  label: item.split('_').map(part => part.charAt(0).toUpperCase() + part.slice(1)).join(' '),
  value: item
})));

const selectedItem = ref();
const filteredItems = ref();

const searchItems = (event) => {
  let query = event.query;

  // Create a case-insensitive regular expression pattern
  let pattern = new RegExp(`.*${query}.*`, 'i');

  // Use the pattern to filter items and get similar words
  let _filteredItems = items.value.filter(item => pattern.test(item.label));

  filteredItems.value = _filteredItems;
  console.log("from meow 1", query);
  console.log("from meow", _filteredItems);
};

let passThroughAutoComplete = {root: {class:'bg-blue-600 rounded-lg w-80'}, input: {class:'border border-black w-64 bg-slate-50 rounded-lg'},
         container: {class:'bg-slate-50 rounded-lg'}, panel: {class:'bg-slate-50 rounded-lg'},
         dropdownButton: {class:'bg-amber-500 mx-2'}};
</script>

<template>
  <div class="flex justify-content-center">
      <AutoComplete v-model="selectedItem" :suggestions="filteredItems"
       @complete="searchItems" :virtualScrollerOptions="{ itemSize: 38 }"
        optionLabel="label" dropdown :pt="passThroughAutoComplete" />
  </div>
</template>