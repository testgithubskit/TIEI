<script setup>
import Gantt from 'frappe-gantt';
import { onMounted } from "vue";

const tasks = [
  {
    id: 'task1',
    name: 'State 1',
    start: '2023-01-01',
    end: '2023-01-10',
    color: 'red',
  },
  {
    id: 'task1', // Same ID as the previous task
    name: 'State 2',
    start: '2023-01-11',
    end: '2023-01-20',
    color: 'green',
  },
];

onMounted(() => {
  const gantt = new Gantt("#gantt", tasks);
});
</script>

<template>
  <svg id="gantt"></svg>
</template>
