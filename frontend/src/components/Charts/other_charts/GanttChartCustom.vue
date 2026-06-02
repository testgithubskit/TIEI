<template>
  <div :class="rootClass" style="overflow-x: auto;">
    <div class="flex">
      <div class="w-40 border-r border-gray-300 py-2" />
      <div class="flex justify-between w-full border-b border-gray-300 py-2" :style="{width: `${timelineWidth}px`}">
        <template v-for="hour in 24" :key="`hour-${hour}`">
          <div class="w-10 border-r border-gray-300 text-center">{{ hour }}</div>
        </template>
      </div>
    </div>
    <div v-for="(machine, machineIndex) in machinesData" :key="`machine-${machineIndex}`" class="flex">
      <div class="w-40 border-r border-gray-300 py-2">{{ machine.name }}</div>
      <div class="relative flex w-full" :style="{width: `${timelineWidth}px`}">
        <template v-for="(task, taskIndex) in machine.tasks" :key="`task-${machineIndex}-${taskIndex}`">
          <div
            :style="computeTaskStyle(task)"
            :class="[task.color, 'absolute h-6 mt-2 rounded-md']"
            @click="onTaskClick(task)"
          >
            {{ task.label }}
          </div>
        </template>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';


function generateMachineData(n, m) {
  const machines = [];

  for (let i = 1; i <= n; i++) {
    const tasks = [];
    let currentTime = 0;

    for (let j = 1; j <= m; j++) {
      const start = currentTime + 1;
      const end = start + Math.floor(Math.random() * 10) + 1;

      const task = {
        id: j.toString(),
        start: start,
        end: end,
        color: `bg-${randomColor()}-500`,
        label: `Task ${j}`,
      };

      tasks.push(task);
      currentTime = end;
    }

    const machine = {
      name: `Machine ${i}`,
      tasks: tasks,
    };

    machines.push(machine);
  }

  return machines;
}

// Helper function to generate a random color
function randomColor() {
  const colors = ["red", "blue", "green", "yellow", "purple"];
  return colors[Math.floor(Math.random() * colors.length)];
}

// Usage example: Generate 3 machines with 4 tasks each
const machinesData = generateMachineData(1, 20);
console.log(machinesData);


// const machines = ref([
//   {
//     name: "Machine 1",
//     tasks: [
//       { id: "1", start: 1, end: 5, color: "bg-blue-500", label: "Task 1" },
//       { id: "2", start: 6, end: 12, color: "bg-green-500", label: "Task 2" },
//     ],
//   },
//   {
//     name: "Machine 2",
//     tasks: [
//       { id: "3", start: 0, end: 4, color: "bg-red-500", label: "Task 3" },
//       { id: "4", start: 8, end: 9, color: "bg-purple-500", label: "Task 4" },
//       { id: "5", start: 13, end: 18, color: "bg-yellow-500", label: "Task 5" },
//     ],
//   },
// ]);

const rootClass = ref('bg-gray-100 p-4'); // your root class goes here

const maxEndTime = machinesData.reduce((maxTime, machine) => {
  const machineMaxTime = machine.tasks.reduce((max, task) => Math.max(max, task.end), 0);
  return Math.max(maxTime, machineMaxTime);
}, 0);

const timelineWidth = maxEndTime * 10;  // adjust this factor according to your design


const computeTaskStyle = (task) => {
  const start = task.start * 10; // assuming each hour is 10px wide
  const width = (task.end - task.start) * 10; // assuming each hour is 10px wide
  return { left: `${start}px`, width: `${width}px` };
};

const onTaskClick = (task) => {
  // handle click event
  console.log('Task clicked: ', task.label);
};
</script>

<style>
/* you can customize the tailwind classes and styles here if needed */
</style>
