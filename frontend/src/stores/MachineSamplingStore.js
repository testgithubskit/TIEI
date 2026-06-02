import { defineStore } from 'pinia';
import {
  mdiAccountMultiple,
  mdiCartOutline,
  mdiChartTimelineVariant,
  mdiMonitorCellphone,
  mdiReload,
  mdiGithub,
  mdiChartPie,
} from "@mdi/js";

import axios from 'axios';

import CardBoxWidgetPlain from "@/components/CardBoxWidgetPlain.vue";
import CardBoxMetric from "@/components/CardBoxMetric.vue";

import { backendApi } from '@/services/apiServices';


function subtractHours(date, hours) {
  date.setHours(date.getHours() - hours);

  return date;
}

export const useMachineSamplingStore = defineStore('machineSampling', {
  state: () => ({
    selectedMachine: {
      name: 'Machine 1',
      parameters: {
        SelectedParmeter: "Parameter 1",
        availableParameters: ['Parameter 1', 'Parameter 2', 'Parameter 3']
      },
      selectedDates: ["02 May 2023", "03 May 2023"],
      selectedDatesDict: {
        from: '07-07-2023 16:09:53',
        to: '07-07-2023 15:09:53'
      }
    },
    availableMachines: ['Machine 1', 'Machine 2', 'Machine 3'],
    sections: [
      {
        sectionName: 'Operational Metrics',
        subSections: [
          {
            subSectionName: 'Operational Statuses',
            components: [
              {
                label: 'Machine Status',
                type: CardBoxWidgetPlain,
                value: 'Production',
                icon: mdiAccountMultiple,
                class: 'mt-4',
                borderSide:'t',
                borderThickness:'8',
              },
              {
                label: 'Execution Mode',
                type: CardBoxWidgetPlain,
                value: 'Auto',
                icon: mdiCartOutline,
                class: 'mt-4',
                borderSide:'t',
                borderThickness:'8',
              },
              {
                label: 'Program Status',
                type: CardBoxWidgetPlain,
                value: 'Running',
                icon: mdiChartTimelineVariant,
                class: 'mt-4',
                borderSide:'t',
                borderThickness:'8',
              },
            ],
          },
        ],
      },
      {
        sectionName: 'Production Metrics',
        subSections: [
          {
            subSectionName: 'Part Count',
            components: [
              {
                label: 'Current Shift',
                type: CardBoxMetric,
                value: 0,
                icon: 'mdi',
                class: 'mt-4',
                borderSide:'s',
                borderThickness:'4',
              },
              {
                label: 'Current Day',
                type: CardBoxMetric,
                value: 0,
                icon: 'mdi',
                class: 'mt-4',
                borderSide:'s',
                borderThickness:'4',
              },
              {
                label: 'Cumulative',
                type: CardBoxMetric,
                value: 0,
                icon: 'mdi',
                class: 'mt-4',
                borderSide:'s',
                borderThickness:'4',
              },
            ],
          },
        ],
      },
      {
        sectionName: 'Performance Metrics',
        subSections: [
          {
            subSectionName: 'Availability',
            components: [
              {
                label: 'Current Shift',
                type: CardBoxMetric,
                value: 0,
                icon: 'mdi',
                class: 'mt-4',
                borderSide:'s',
                borderThickness:'4',
              },
              {
                label: 'Current Day',
                type: CardBoxMetric,
                value: 0,
                icon: 'mdi',
                class: 'mt-4',
                borderSide:'s',
                borderThickness:'4',
              },
              {
                label: 'Cumulative',
                type: CardBoxMetric,
                value: 0,
                icon: 'mdi',
                class: 'mt-4',
                borderSide:'s',
                borderThickness:'4',
              },
            ],
          },
          {
            subSectionName: 'Performance',
            components: [
              {
                label: 'Current Shift',
                type: CardBoxMetric,
                value: 0,
                icon: 'mdi',
                class: 'mt-4',
                borderSide:'s',
                borderThickness:'4',
              },
              {
                label: 'Current Day',
                type: CardBoxMetric,
                value: 0,
                icon: 'mdi',
                class: 'mt-4',
                borderSide:'s',
                borderThickness:'4',
              },
              {
                label: 'Cumulative',
                type: CardBoxMetric,
                value: 0,
                icon: 'mdi',
                class: 'mt-4',
                borderSide:'s',
                borderThickness:'4',
              },
            ],
          },
          {
            subSectionName: 'Quality',
            components: [
              {
                label: 'Current Shift',
                type: CardBoxMetric,
                value: 0,
                icon: 'mdi',
                class: 'mt-4',
                borderSide:'s',
                borderThickness:'4',
              },
              {
                label: 'Current Day',
                type: CardBoxMetric,
                value: 0,
                icon: 'mdi',
                class: 'mt-4',
                borderSide:'s',
                borderThickness:'4',
              },
              {
                label: 'Cumulative',
                type: CardBoxMetric,
                value: 0,
                icon: 'mdi',
                class: 'mt-4',
                borderSide:'s',
                borderThickness:'4',
              },
            ],
          },
          {
            subSectionName: 'OEE',
            components: [
              {
                label: 'Current Shift',
                type: CardBoxMetric,
                value: 0,
                icon: 'mdi',
                class: 'mt-4',
                borderSide:'s',
                borderThickness:'4',
              },
              {
                label: 'Current Day',
                type: CardBoxMetric,
                value: 0,
                icon: 'mdi',
                class: 'mt-4',
                borderSide:'s',
                borderThickness:'4',
              },
              {
                label: 'Cumulative',
                type: CardBoxMetric,
                value: 0,
                icon: 'mdi',
                class: 'mt-4',
                borderSide:'s',
                borderThickness:'4',
              },
            ],
          },
        ],
      },
      {
        sectionName: 'Energy Metrics',
        subSections: [
          {
            subSectionName: 'Current & Power',
            components: [
              {
                label: 'Current',
                type: CardBoxWidgetPlain,
                value: 3.3,
                icon: mdiAccountMultiple,
                class: 'mt-4',
                borderSide:'s',
                borderThickness:'4',
              },
              {
                label: 'Power',
                type: CardBoxWidgetPlain,
                value: 161,
                icon: mdiCartOutline,
                class: 'mt-4',
                borderSide:'s',
                borderThickness:'4',
              },
            ],
          },
          {
            subSectionName: 'Energy',
            components: [
              {
                label: 'Current Shift',
                type: CardBoxWidgetPlain,
                value: 45.5,
                icon: mdiCartOutline,
                class: 'mt-4',
                borderSide:'b',
                borderThickness:'8',
              },
              {
                label: 'Current Day',
                type: CardBoxWidgetPlain,
                value: 98.65,
                icon: mdiCartOutline,
                class: 'mt-4',
                borderSide:'b',
                borderThickness:'8',
              },
              {
                label: 'Cumulative',
                type: CardBoxWidgetPlain,
                value: 10520,
                icon: mdiCartOutline,
                class: 'mt-4',
                borderSide:'b',
                borderThickness:'8',
              },
            ],
          },
        ],
      },
    ],
  }),
  actions: {

    async fetchAndUpdateAvailableMachines() {
      const url = 'http://192.168.121.61:7788/api/v1/machines/';
      console.log("from actions");
      try {
        console.log(1);
        const response = await axios.get(url);
        console.log(2);
        const machines = response.data.machines;
        console.log('Available machines:', machines);
        this.availableMachines= machines;
        console.log(this.availableMachines);
        console.log(3);
        return machines;
      } catch (error) {
        console.error('Error fetching/ updating available machines:', error);
        throw error;
      }
    },

    async fetchAndUpdateAvailableParameters() {
      const machineName = this.selectedMachine.name;
  
      const url = `http://172.18.100.87:8000/api/v1/machines/${machineName}/parameters`;
  
      try {
        const response = await axios.get(url);
        const availableParameters = response.data.parameters;
        console.log('Available parameters:', availableParameters);
        this.selectedMachine.parameters.availableParameters = availableParameters;
        console.log('Set parameters:', this.selectedMachine.parameters.availableParameters);
      } catch (error) {
        console.error('Error fetching/updating available machines:', error);
        throw error;
      }
    },

    setSelectedMachine(machine) {
      this.selectedMachine.name = machine;
    },
    randomizeValues() {

      const operationalStatus = this.sections[0].subSections[0].components;

      // Randomize machineStatus
      const machineStatusOptions = ['Production', 'Idle', 'Off'];
      const randomMachineStatus =
        machineStatusOptions[Math.floor(Math.random() * machineStatusOptions.length)];
      operationalStatus[0].value = randomMachineStatus;

      // Randomize executionMode
      const executionModeOptions = ['Auto', 'MDI', 'Jog'];
      const randomExecutionMode =
        executionModeOptions[Math.floor(Math.random() * executionModeOptions.length)];
        operationalStatus[1].value = randomExecutionMode;

      // Randomize programStatus
      const programStatusOptions = ['Executing', 'Interpreted'];
      const randomProgramStatus =
        programStatusOptions[Math.floor(Math.random() * programStatusOptions.length)];
        operationalStatus[2].value = randomProgramStatus;

      // Randomize partCount

      const partCountComponents = this.sections[1].subSections[0].components;

      const randomCount = Math.floor(Math.random() * 10) + 1;

      partCountComponents[0].value = randomCount;
      partCountComponents[1].value = randomCount;
      partCountComponents[2].value = randomCount;

      // Randomize availability
      const availabilityComponents = this.sections[2].subSections[0].components;

      const randomAvailability = Math.floor(Math.random() * 61) + 40;

      availabilityComponents[0].value  = randomAvailability;
      availabilityComponents[1].value  = randomAvailability;
      availabilityComponents[2].value  = randomAvailability;

      // Randomize performance
      const performanceComponents = this.sections[2].subSections[1].components;

      const randomPerformance = Math.floor(Math.random() * 61) + 40;
      performanceComponents[0].value  = randomPerformance;
      performanceComponents[1].value  = randomPerformance;
      performanceComponents[2].value  = randomPerformance;

      // Randomize quality

      const qualityComponents = this.sections[2].subSections[2].components;

      const randomQuality = Math.floor(Math.random() * 61) + 40;
      qualityComponents[0].value  = randomQuality;
      qualityComponents[1].value  = randomQuality;
      qualityComponents[2].value  = randomQuality;


      // Calculate and update oee

      const oeeComponents = this.sections[2].subSections[3].components;

      const oee = (
        (randomAvailability * randomPerformance * randomQuality) /
        1000000
      ).toFixed(2);

      oeeComponents[0].value  = oee;
      oeeComponents[1].value  = oee;
      oeeComponents[2].value  = oee;
      console.log(`OEE: ${oee}`);

      // Randomize energyMetrics current

      const energyComponents = this.sections[3].subSections[0].components;

      const randomCurrent = ((Math.random() * 1.9) + 1.1).toFixed(2);
      energyComponents[0].value  = randomCurrent;

      // Randomize energyMetrics power
      const randomPower = ((Math.random() * 7.5) + 11.1).toFixed(2);
      energyComponents[1].value  = randomPower;
    },
  },
});
