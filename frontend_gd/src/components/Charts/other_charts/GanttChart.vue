<template>
  <g-gantt-chart
    chart-start="2021-07-12 12:00"
    chart-end="2021-07-14 12:00"
    precision="hour"
    bar-start="myBeginDate"
    bar-end="myEndDate"
    color-scheme="vue"
    class="flex flex-nowrap overflow-auto overflow-y-hidden"
  >
    <!-- Loop through rows -->
    <template v-for="row in rows" :key="row.label">
      <g-gantt-row :label="row.label" :bars="row.bars" />
    </template>
  </g-gantt-chart>
</template>

<script setup>
import { ref } from "vue"

const rows = ref([
  {
    label: "Machine 1",
    bars: generateBars(15)
  },
  // {
  //   label: "Machine 2",
  //   bars: generateBars(2)
  // },
  // {
  //   label: "Machine 3",
  //   bars: generateBars(1)
  // },
  // {
  //   label: "Machine 4",
  //   bars: generateBars(4)
  // }
])

function generateBars(count) {
  const bars = []
  let currentDate = new Date("2021-07-13 00:00")
  for (let i = 1; i <= count; i++) {
    const startDate = new Date(currentDate)
    const endDate = new Date(currentDate.getTime() + getRandomDuration())
    console.log(endDate);
    const state = getRandomState()
    bars.push({
      myBeginDate: formatDate(startDate),
      myEndDate: formatDate(endDate),
      ganttBarConfig: {
        id: `machine${count}-state${i}`,
        label: `State ${i}`,
        immobile: true,
        style: {
          background: getColorByState(state),
          borderRadius: "20px",
          color: "white"
        }
      }
    })
    currentDate = new Date(endDate)
  }
  return bars
}

function getRandomDuration() {
  const minDuration = 1 * 60 * 60 * 1000 // 1 hour in milliseconds
  const maxDuration = 6 * 60 * 60 * 1000 // 6 hours in milliseconds
  return Math.floor(Math.random() * (maxDuration - minDuration + 1) + minDuration)
}

function formatDate(date) {
  return `${date.getFullYear()}-${padZero(date.getMonth() + 1)}-${padZero(date.getDate())} ${padZero(date.getHours())}:${padZero(date.getMinutes())}`
}

function padZero(number) {
  return String(number).padStart(2, "0")
}

function getRandomState() {
  const states = ["production", "idle", "off"]
  const randomIndex = Math.floor(Math.random() * states.length)
  return states[randomIndex]
}

function getColorByState(state) {
  switch (state) {
    case "production":
      return "#41B883" // Mint
    case "idle":
      return "#FF8F00" // Orange Color
    case "off":
      return "#34495E" // Police Blue
    default:
      return "#000000" // Default color (black)
  }
}
</script>
