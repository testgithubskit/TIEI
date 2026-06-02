<script setup>
import { ref, computed, watch } from 'vue';

const emit = defineEmits(['item-selected']);

const isOpen = ref(false);
const searchTerm = ref('');
const selectedItem = ref(null);


const props = defineProps({
    items: {
      type: Array,
      required: false,
      default: () => ([
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
                    ]),
    }
  });

const itemsMapped = computed(() => props.items.map(item => ({
label: item.split('_').map(part => part.charAt(0).toUpperCase() + part.slice(1)).join(' '),
value: item
})));

const isDropdownOpen = computed(() => isOpen.value || searchTerm.value !== '');
const filteredItems = computed(() => {
  const query = searchTerm.value;
  const pattern = new RegExp(`.*${query}.*`, 'i');
  return itemsMapped.value.filter(item => pattern.test(item.label));
});

const toggleDropdown = () => {
  isOpen.value = !isOpen.value;
};

function convertToTitleCase(input) {
  // Split the input text by underscores and capitalize each word
  const words = input.split('_').map(word => word.charAt(0).toUpperCase() + word.slice(1));
  
  // Join the words with spaces to form the title case string
  const titleCase = words.join(' ');
  
  return titleCase;
}

watch(selectedItem, (newValue) => {
  // Emit the selected item to parent
  if (newValue) {
    emit('item-selected', { value: newValue });
  }
  console.log(selectedItem.value);
});

</script>

<template>
  <div class="relative w-full md:w-64 lg:w-80">
    <div
      class="w-full p-2 bg-slate-50  text-black border rounded-lg shadow cursor-pointer"
      @click="toggleDropdown"
    >
      <div class="flex justify-between items-center">
        <span class="mr-2">{{ selectedItem ? convertToTitleCase(selectedItem) : 'Select an item' }}</span>
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
          placeholder="Search..."
          class="w-full border rounded p-2 mb-2"
        />
        <div v-for="(item, index) in filteredItems" :key="index">
          <label
            class="flex items-center cursor-pointer p-2 hover:bg-gray-100"
          >
            <input
              type="radio"
              v-model="selectedItem"
              :value="item.value"
              class="mr-2"
            />
            {{ item.label }}  
          </label>
        </div>
      </div>
    </div>
  </div>
</template>
