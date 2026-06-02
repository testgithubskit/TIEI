<script setup>
import { ref, onMounted } from 'vue';
import dygraph from 'dygraphs';

const chartContainer = ref(null);

onMounted(() => {
  
  let base = +new Date(1988, 9, 3);
  let oneDay = 24 * 3600 * 1000;
  let data = [[base, Math.random() * 300]];
  for (let i = 1; i < 1000; i++) {
    let now = new Date((base += oneDay));
    data.push([+now, Math.round((Math.random() - 0.5) * 20 + data[i - 1][1])]);
  }

  const options = {
    labels: ['Date', 'Value'],
    strokeWidth: 3,
    fillGraph: true, // Enable area fill
    fillAlpha: 0.3,
    drawPoints: false,
    drawGrid: false,
    animatedZooms: true,
    highlightCircleSize: 4,
    axisLineWidth: 4,
    axisLineColor: 'black',
    stepPlot: true, // Enable step graph,
    colors: ['rgb(5, 150, 105)'], // Set graph color
  };

  const chart = new dygraph(chartContainer.value, data, options);
});

</script>

<template>
  <div ref="chartContainer"></div>
</template>
