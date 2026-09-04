  <script setup>
  import { ref, onMounted, onBeforeUnmount, computed, defineEmits, onBeforeMount, watch } from 'vue';
  import { mdiChevronUp, mdiChevronDown, mdiMenu, mdiClockOutline, mdiCloud, mdiCrop } from '@mdi/js';
  import { useStyleStore } from '@/stores/style';
  import BaseIcon from '@/components/BaseIcon.vue';
  import { useHomeStore } from '@/stores/homeStore'; 
  import { useMachineSamplingStore } from '@/stores/MachineSamplingStore'; 

  const machineSamplingStore = useMachineSamplingStore();

  const props = defineProps({
    item: {
      type: Object,
      required: true,
      default: () => ({
        icon: mdiMenu,
        label: 'Select A Machine',
        menu: [
          {
            icon: mdiClockOutline,
            label: 'Machine 1',
          },
          {
            icon: mdiCloud,
            label: 'Machine 2',
          },
          {
            icon: mdiCrop,
            label: 'Machine 3',
          },
        ],
      }),
    }
  });

  console.log("From Dropdown");

  const isDropdownActive = ref(false);

  let selectedItemLabel = ref(props.item.menu[0].label);


  const toggleDropdown = () => {
    isDropdownActive.value = !isDropdownActive.value;
  };

  const emit = defineEmits(['item-selected']);


  const handleItemClick = (subItem) => {
    console.log(`Clicked ${subItem.label}`);

    selectedItemLabel.value = subItem.label; // Use .value to update the ref
    emit('item-selected', subItem);
  };


  const root = ref(null);

  const forceClose = (event) => {
    if (root.value && !root.value.contains(event.target)) {
      isDropdownActive.value = false;
    }
  };

  onBeforeMount(async () => {
    console.log("Creating the dropdown");
    // await homeStore.fetchAndUpdateAvailableMachines();
    // console.log("after update", homeStore.availableMachines);
  });

  onMounted(() => {
    
    console.log("Mounting the dropdown");
    if (props.item.menu) {
      window.addEventListener('click', forceClose);
    }
  });

  onBeforeUnmount(() => {
    if (props.item.menu) {
      window.removeEventListener('click', forceClose);
    }
  });

  const styleStore = useStyleStore();

  const componentClass = computed(() => {
    const base = [
      isDropdownActive.value
        ? `${styleStore.navBarItemLabelActiveColorStyle} dark:text-slate-400`
        : `${styleStore.navBarItemLabelStyle} dark:text-white dark:hover:text-slate-400 ${styleStore.navBarItemLabelHoverStyle}`,
      props.item.menu ? 'lg:py-2 lg:px-3' : 'py-2 px-3',
    ];

    if (props.item.isDesktopNoLabel) {
      base.push('lg:w-16', 'lg:justify-center');
    }

    return base;
  });


  function formatString(input) {
    const words = input.split('_');
    const capitalizedWords = words.map(word => word.charAt(0).toUpperCase() + word.slice(1));
    const formattedString = capitalizedWords.join(' ');
    return formattedString;
  }


  const tailwindWidthClass = (width) => {
    const widths = [
      0, 1, 1.5, 2, 2.5, 3, 3.5, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 16, 20, 24, 28, 32,
      36, 40, 44, 48, 52, 56, 60, 64, 72, 80, 96
    ];
    const maxClass = 'w-96'; // Maximum width class in Tailwind CSS

    const nearestWidth = widths.reduce((prev, curr) => (curr >= width ? curr : prev));
    return `w-${nearestWidth}` || maxClass;
  };

  // const maxItemLength = computed(() => {
  //   const maxLabelLength = Math.max(...props.item.menu.map(item => item.label.length));
  //   const minWidth = 4; // Minimum width in rem units
  //   const maxWidth = 16; // Maximum width in rem units
  //   const maxLength = 20; // Maximum label length to determine proportional width

  //   const proportionalWidth = minWidth + ((maxLabelLength / maxLength) * (maxWidth - minWidth));
  //   console.log("widh", Math.round(proportionalWidth * 4));
  //   const result = tailwindWidthClass(Math.round(proportionalWidth * 4));
  //   console.log("computed result", result);
  //   return result;
  // });

  const maxItemLength = "w-96";

  watch(() => props.item.menu, (newItems) => {
    selectedItemLabel.value = newItems[0].label;
    console.log("emitting machine select");
    emit('item-selected', newItems[0]);
  });

  watch(() => maxItemLength, (newItems) => {
    console.log("Max item Changed", maxItemLength.value);
  });

  </script>

  <template>
    <div class="flex flex-col items-start relative">
      <div class="flex items-center" @click="toggleDropdown" ref="root">
        <div class="flex items-center" :class="componentClass">
          <!-- <BaseIcon v-if="item.icon" :path="item.icon" class="transition-colors" /> -->
          <span class="text-lg px-2 transition-colors" :class="maxItemLength">{{ formatString(selectedItemLabel) }}</span>
          <BaseIcon
            v-if="item.menu"
            :path="isDropdownActive ? mdiChevronUp : mdiChevronDown"
            class="hidden lg:inline-flex transition-colors"
          />
        </div>  
      </div>
      <div v-if="item.menu && isDropdownActive" class="ml-4 mt-8 absolute z-50 max-h-48 overflow-y-auto">
        <ul class="cursor-pointer mt-2 bg-white rounded-lg shadow-lg" :class="maxItemLength" >
          <li v-for="subItem in item.menu" :key="subItem.label" class="py-2 px-4 hover:bg-gray-100">
            <a class="cursor-pointer block w-full" @click="handleItemClick(subItem)">{{ formatString(subItem.label) }}</a>
          </li>
        </ul>
      </div>
    </div>
  </template>


