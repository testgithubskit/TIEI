<script setup>
import { ref, computed, watch, onMounted, onUnmounted } from 'vue';

const isOpen = ref(false);
const searchTerm = ref('');
const selectedItems = ref([]);

const items = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];

const isDropdownOpen = computed(() => isOpen.value || searchTerm.value !== '');
const filteredItems = ref(['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5']);

const toggleDropdown = () => {
  isOpen.value = !isOpen.value;
};

const iconClass = computed(() => ({
  'fa-chevron-up': isDropdownOpen.value,
  'fa-chevron-down': !isDropdownOpen.value,
}));

const searchItems = () => {
  const query = searchTerm.value;

  // Create a case-insensitive regular expression pattern
  const pattern = new RegExp(`.*${query}.*`, 'i');

  // Use the pattern to filter items and get similar words
  const _filteredItems = items.filter(item => pattern.test(item));

  filteredItems.value = _filteredItems;
};

watch(selectedItems, () => {
  // Do something with the selected items
  console.log(selectedItems.value);
});

// Close dropdown when clicked outside
// const closeDropdownOnClickOutside = (event) => {
//   console.log(isDropdownOpen.value);
//   if (isDropdownOpen.value) {
//     toggleDropdown();
//     console.log("testing from dropdown");
//   }
// };

// Attach click event listener to document
// onMounted(() => {
//   window.addEventListener('click', closeDropdownOnClickOutside);
// });

// // Remove click event listener on component unmount
// onUnmounted(() => {
//   window.removeEventListener('click', closeDropdownOnClickOutside);
// });
</script>

<template>
  <div class="relative w-full md:w-64 lg:w-80">
    <div
      class="w-full p-2 bg-slate-50  text-black border rounded-lg shadow cursor-pointer"
      @click="toggleDropdown"
    >
      <div class="flex justify-between items-center">
        <span class="mr-2">{{ selectedItems.length }} selected</span>
        <span :class="iconClass"></span>
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
          <label
            class="flex items-center cursor-pointer p-2 hover:bg-gray-100"
          >
            <input
              type="checkbox"
              v-model="selectedItems"
              :value="item"
              class="mr-2"
            />
            {{ item }}  
          </label>
        </div>
      </div>
    </div>
  </div>
</template>

<style>
/* Include the FontAwesome CSS for the icons */
</style>
