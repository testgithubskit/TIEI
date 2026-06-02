<template>
  <div class="relative">
    <div class="flex items-center justify-between">
      <button
        @click="isOpen = !isOpen"
        type="button"
        class="inline-flex items-center px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
      >
        {{ selectedItems.length === 0 ? 'Select Items' : `${selectedItems.length} Items Selected` }}
        <svg
          :class="{'rotate-180': isOpen}"
          class="-mr-1 ml-2 h-5 w-5 text-gray-400"
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 20 20"
          fill="currentColor"
          aria-hidden="true"
        >
          <path
            fill-rule="evenodd"
            d="M10 14l-5-5h10l-5 5z"
          />
        </svg>
      </button>
    </div>
    <div
      v-if="isOpen"
      class="absolute mt-1 w-full bg-white rounded-md shadow-lg"
    >
      <ul
        class="overflow-y-auto max-h-60"
      >
        <li
          v-for="item in items"
          :key="item.id"
          class="px-4 py-2 hover:bg-gray-100 cursor-pointer"
        >
          <label class="flex items-center">
            <input
              type="checkbox"
              :value="item.id"
              v-model="selectedItemIds"
              @change="handleItemChange"
              class="form-checkbox h-4 w-4 text-indigo-600 transition duration-150 ease-in-out"
            />
            <span class="ml-2 text-gray-700">{{ item.name }}</span>
          </label>
        </li>
      </ul>
    </div>
  </div>
</template>

<script setup>
import { ref, watch, computed } from 'vue';

const items = [
  { id: 1, name: 'Item 1' },
  { id: 2, name: 'Item 2' },
  { id: 3, name: 'Item 3' },
  { id: 4, name: 'Item 4' },
];

const selectedItemIds = ref([]);
const isOpen = ref(false);

const selectedItems = computed(() => {
  return items.filter(item => selectedItemIds.value.includes(item.id));
});

const handleItemChange = () => {
  console.log(selectedItems.value);
};

watch(selectedItems, (newValue, oldValue) => {
  console.log('Selected Items Changed:', newValue);
});
</script>

<style>
/* Add your Tailwind CSS styles here */
</style>
