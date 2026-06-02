<script setup>
import { ref, defineEmits, watch, computed } from "vue";
import AutoComplete from 'primevue/autocomplete';

const props = defineProps({
    items: {
      type: Array,
      required: true,
      default: () => (["machine_1",
                    "machine_2",
                    ]),
    }
  });


const emit = defineEmits([`item-selected-update-machine`]);

const itemsMapped = computed(() => props.items.map(item => ({
      label: item.split('_').map(part => part.charAt(0).toUpperCase() + part.slice(1)).join(' '),
      value: item
})));


const selectedItems = ref();
const filteredItems = ref(itemsMapped.value);

const searchItems = (event) => {
  let query = event.query;

  // Create a case-insensitive regular expression pattern
  let pattern = new RegExp(`.*${query}.*`, 'i');

  // Use the pattern to filter items and get similar words
  let _filteredItems = itemsMapped.value.filter(item => pattern.test(item.label));
  
  console.log("from meow 1", itemsMapped.value);
  filteredItems.value = _filteredItems;
  console.log("from meow 1", query);
  console.log("from meow", _filteredItems);
};

let passThroughAutoComplete = {root: {class:'bg-blue-600 rounded-lg flex'}, input: {class:'border border-black bg-slate-50 rounded-lg'},
         container: {class:'bg-slate-50 rounded-lg'}, panel: {class:'bg-slate-50 rounded-lg'},
         dropdownButton: {class:'bg-amber-500 mx-2'}};

// Watcher to log changes in the date value
watch(selectedItems, (newValue, oldValue) => {
  console.log('New Item Selected:', newValue);
  
  emit(`item-selected-update-machine`, newValue);
});

// Watcher to log changes in the date value
watch(itemsMapped, (newValue, oldValue) => {
  console.log('New Item Selected:', newValue);
  
  filteredItems.value = newValue;
});

</script>

<template>
  <div class="flex justify-content-center">
      <AutoComplete v-model="selectedItems" :suggestions="filteredItems"
       @complete="searchItems" :virtualScrollerOptions="{ itemSize: 38 }"
        optionLabel="label" dropdown :pt="passThroughAutoComplete" multiple />
  </div>
</template>