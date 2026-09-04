<script setup>
import { ref, computed, defineProps, defineEmits, watch } from 'vue';

const isOpen = ref(false);
const searchTerm = ref('');

const emit = defineEmits(['item-selected-update-parameter']);

const props = defineProps({
  items: {
    type: Array,
    required: true,
    default: () => [
      "item_1",
      "item_2",
      // ... other items
    ],
  },
  defaultSelectedItem: {
    type: [String, Number, Object],
    default: null,
  },
});

let itemsMapped = computed(() => {
  return props.items.map(item => ({
    label: item,
    value: item,
  }));
});

let selectedItem = ref(itemsMapped.value[0]);

let isDropdownOpen = computed(() => isOpen.value);
let filteredItems = ref(itemsMapped.value);

let toggleDropdown = () => {
  isOpen.value = !isOpen.value;
  // Reset to original items when closing the dropdown
  if (!isOpen.value) {
    filteredItems.value = itemsMapped.value;
    searchTerm.value = "";
  }
};

const searchItems = () => {
  const query = searchTerm.value.trim();
  if (query === '') {
    // Show original items when search query is empty
    filteredItems.value = itemsMapped.value;
  } else {
    const pattern = new RegExp(`.*${query}.*`, 'i');
    let _filteredItems = itemsMapped.value.filter(item => pattern.test(item.label));

    filteredItems.value = _filteredItems;
  }
};

watch(selectedItem, () => {
  emit('item-selected-update-parameter', selectedItem.value);
});

watch(itemsMapped, (newItemsMapped) => {
  // Update filteredItems when itemsMapped changes
  filteredItems.value = newItemsMapped;
  if (props.defaultSelectedItem === null) {
    selectedItem.value = newItemsMapped[0];
  }
});

watch(props, (newProps) => {
  // Update filteredItems when itemsMapped changes
  selectedItem.value = newProps.defaultSelectedItem;
});
</script>

<template>
  <div class="relative w-full md:w-64 lg:w-80">
    <div
      class="w-full p-2 bg-slate-50 text-black border rounded-lg shadow cursor-pointer"
      @click="toggleDropdown"
    >
      <div class="flex justify-between items-center">
        <span class="mr-2">{{ selectedItem ? selectedItem.label : 'Select an item' }}</span>
      </div>
    </div>
    <div
      v-if="isDropdownOpen"
      class="absolute top-full left-0 w-full border rounded shadow bg-white z-10 mt-2"
    >
      <div class="p-2 max-h-48 overflow-y-auto m-2">
        <input
          type="text"
          v-model="searchTerm"
          @input="searchItems"
          placeholder="Search..."
          class="w-full border rounded p-2 mb-2"
        />
        <div v-for="(item, index) in filteredItems" :key="index">
          <label class="flex items-center cursor-pointer p-2 hover:bg-gray-100">
            <input
              type="radio"
              v-model="selectedItem"
              :value="item"
              class="mr-2"
            />
            <div class="flex items-center">
              <div>{{ item.label }}</div>
            </div>
          </label>
        </div>
      </div>
    </div>
  </div>
</template>
