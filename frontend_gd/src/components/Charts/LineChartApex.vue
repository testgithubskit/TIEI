<template>
  <div id="app">
    <VueApexCharts :options="chartOptions" :series="series" type="line" height="350" />
  </div>
</template>

<script setup>
import VueApexCharts from "vue3-apexcharts";

let base = +new Date(1988, 9, 3);
let oneDay = 24 * 3600 * 1000;
let baseData = [[base, Math.random() * 300]];
for (let i = 1; i < 100; i++) {
  let now = new Date((base += oneDay));
  baseData.push([+now, Math.round((Math.random() - 0.5) * 20 + baseData[i - 1][1])]);
}

const series = [
  {
    data: baseData},
];

const chartOptions = {
      chart: {
        id: 'area-datetime',
        type: 'area',
        height: 350,
        zoom: {
          autoScaleYaxis: true
        }
      },
      annotations: {
        yaxis: [{
          y: 30,
          borderColor: '#999',
          label: {
            show: true,
            text: 'Support',
            style: {
              color: "#fff",
              background: '#00E396'
            }
          }
        }],
        xaxis: [{
          x: new Date('14 Nov 2012').getTime(),
          borderColor: '#999',
          yAxisIndex: 0,
          label: {
            show: true,
            text: 'Rally',
            style: {
              color: "#fff",
              background: '#775DD0'
            }
          }
        }]
      },
      dataLabels: {
        enabled: false
      },
      markers: {
        size: 0,
        style: 'hollow',
      },
      xaxis: {
        type: 'datetime',
        min: new Date('01 Mar 2012').getTime(),
        tickAmount: 6,
      },
      tooltip: {
        x: {
          format: 'dd MMM yyyy'
        }
      },
      fill: {
        type: 'gradient',
        gradient: {
          shadeIntensity: 1,
          opacityFrom: 0.7,
          opacityTo: 0.9,
          stops: [0, 100]
        }
      },
    };
</script>

