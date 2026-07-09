<script setup>
import { ref, computed, defineProps, defineEmits, watch, onMounted } from 'vue';
import { useFactoryPollOverviewStore } from '@/stores/FactoryPollGridStore';
import Tooltip from 'primevue/tooltip';

const factoryPollOverviewGridStore = useFactoryPollOverviewStore();

const isOpen = ref(false);
const searchTerm = ref('');

const emit = defineEmits(['item-selected-update-parameter']);

const props = defineProps({
  items: {
    type: Array,
    required: true,
    default: () => [
      { item_name: "item_1", item_state: "OK" },
      { item_name: "item2", item_state: "WARNING" },
    ],
  },
  cycleTimeData: {
    type: Object,
    required: false,
    default: null
  }
});

let itemsMapped = computed(() => {
  return props.items.map(item => ({
    label: item.item_name === 'CYCLE_TIME' ? 'Cycle Time' : item.item_name.split('_').map(part => part.charAt(0).toUpperCase() + part.slice(1)).join(' '),
    value: item.item_name,
    state: item.item_state,
  }));
});

const itemBgColor = (state) => {
  return {
    OK: "bg-emerald-600",
    WARNING: "bg-yellow-600",
    CRITICAL: "bg-red-600",
  }[state];
};

function itemClickHandler(selectedItem) {
  emit('item-selected-update-parameter', selectedItem);
}

const hoveredParameterGroup = ref(null);
const hoveredMachines = ref([]);

watch(hoveredParameterGroup, async (newGroup) => {
  if (newGroup) {
    const hoveredState = newGroup.state;
    
    if (newGroup.value === 'CYCLE_TIME' && props.cycleTimeData) {
      const abnormalMachines = [];
      
      props.cycleTimeData.lines.forEach(line => {
        line.machines.forEach(machine => {
          if (machine.machine_state === hoveredState) {
            abnormalMachines.push(machine);
          }
        });
      });
      
      hoveredMachines.value = abnormalMachines;
    } else {
      const layoutData = factoryPollOverviewGridStore.groupData;
      const group = layoutData.find(item => item.group_name === newGroup.value);
      
      if (group) {
        const machines = group.group_details.flatMap(line => line.machines);
        hoveredMachines.value = machines.filter(machine => machine.machine_state === hoveredState);
      }
    }
  } else {
    hoveredMachines.value = [];
  }
});
</script>

<template>
  <div class="w-full relative">
    <div class="flex flex-wrap justify-start gap-4 p-4">
      <div v-for="(item, index) in itemsMapped" :key="index"
           :class="[itemBgColor(item.state), 'rounded-full border-black px-4 py-2 m-2 text-white inline-flex whitespace-nowrap align-middle relative']"
           @click="itemClickHandler(item)"
           @mouseover="hoveredParameterGroup = item"
           @mouseleave="hoveredParameterGroup = null"
           v-tooltip.bottom="{
                value: hoveredMachines.map(machine => `${machine.machine_name}`).join(', '),
                pt: {
                    arrow: {
                        style: {
                            width: '200px',
                            display: 'flex',
                            flexDirection: 'column',
                            alignItems: 'flex-start',
                        }
                    },
                    text: 'bg-primary font-medium',
                    style: {
                       
                    }
                }
            }">
        {{ item.label }}
      </div>
    </div>
  </div>
</template>

<style scoped>
.tooltip-content {
  width: 200px;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}
</style>
