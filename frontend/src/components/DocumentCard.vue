<script setup>
import { defineProps, computed } from 'vue';

const props = defineProps({
  heading: {
      type: String,
      required: true,
      default: () => ("Customer Input"),
    },
  items: {
      type: Array,
      required: true,
      default: () => ([{name: 'STPO/Planned Order',
                        link: 'https://cmti.res.in/'}]),
    },
  color: {
      type: Object,
      required: true,
      default: () => ({background: 'bg-blue-50',
    border: 'border-blue-200',headerText: 'text-blue-500', listText: 'text-blue-800'}),
    }
});

const borderProperties = computed(() => `${props.color.background} border ${props.color.border} rounded-lg p-6 shadow-lg hover:shadow-md`);

const headerProperties = computed(() => `text-xl font-bold leading-none mb-4 ${props.color.headerText}`);

const listProperties = computed(() => `hover:underline ${props.color.listText}`);
</script>

<template>
  <div class="w-full md:w-1/2 lg:w-1/3 xl:w-1/4 p-4">
    <div :class="borderProperties">
      <h5 :class="headerProperties">{{ heading }}</h5>
      <ul class="space-y-2">
        <li v-for="item in items" :key="item" >
          <a target="_blank" :href="item.link" :class="listProperties">{{ item.name }}</a>
        </li>
      </ul>
    </div>
  </div>
</template>
