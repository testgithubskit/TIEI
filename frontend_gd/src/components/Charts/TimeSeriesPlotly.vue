<template>
  <CanvasJSChart :options="options" :styles="styleOptions" />
</template>

<script setup>

const options = {
  zoomEnabled: true,
  animationEnabled: true,
  title: {
    text: "Capacity v/s Production of Crude Steel"
  },
  subtitles: [{
    text: "India"
  }],
  toolTip: {
    contentFormatter: toolTipFormatter
  },
  axisX: {
    title: "Date & Time"
  },
  axisY: {
    title: "In tonne"
  },
  data: [{
    type: "stepLine",
    name: "Production of Crude Steel",
    xValueType: "dateTime",
    dataPoints: [
      { x: 1654248000000, y: 71 },
      { x: 1654334400000, y: 55 },
      { x: 1654420800000, y: 50 },
      { x: 1654507200000, y: 65 },
      { x: 1654593600000, y: 95 },
      { x: 1654680000000, y: 68 },
      { x: 1654766400000, y: 28 },
      { x: 1654852800000, y: 34 },
      { x: 1654939200000, y: 14 }
    ]
  },
  {
    type: "stepLine",
    name: "Capacity of Crude Steel Production",
    dataPoints: [
      { x: 1654248110000, y: 76 },
      { x: 1654334510000, y: 60 },
      { x: 1654420910000, y: 55 },
      { x: 1654507310000, y: 70 },
      { x: 1654593710000, y: 100 },
      { x: 1654680110000, y: 73 },
      { x: 1654766510000, y: 33 },
      { x: 1654852910000, y: 39 },
      { x: 1654939310000, y: 19 }
    ]
  }]
};

const styleOptions = {
  width: "100%",
  height: "360px"
};

function toolTipFormatter(e) {
  const datetime = new Date(e.entries[0].dataPoint.x).toLocaleString();
  const yValue = e.entries[0].dataPoint.y;
  
  let content = `<strong> Date & Time: ${datetime}</strong> <br/>`;
  content += `<strong>Value: ${yValue}</strong> <br/>`;
  
  return content;
}
</script>
