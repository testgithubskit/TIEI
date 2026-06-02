<script setup lang="ts">
import { ref } from 'vue';
import 'buffer';
import Plotly from 'plotly.js';

const data = ref([
  {
    task: 'Task 1',
    start: '2023-07-05',
    end: '2023-07-08',
  },
  {
    task: 'Task 2',
    start: '2023-07-06',
    end: '2023-07-10',
  },
  {
    task: 'Task 3',
    start: '2023-07-07',
    end: '2023-07-11',
  },
]);

const layout = {
  title: 'Gantt Chart',
  xaxis: {
    type: 'date',
  },
};

const fig = ref(Plotly.newPlot('myDiv', data.value, layout));
</script>

<template>
  <div id="myDiv"></div>
</template>
