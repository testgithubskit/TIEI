import { defineStore } from 'pinia';
import {
  mdiAccountMultiple,
  mdiCartOutline,
  mdiChartTimelineVariant
} from "@mdi/js";

import axios from 'axios';

import CardBoxWidgetPlain from "@/components/CardBoxWidgetPlain.vue";
import CardBoxMetric from "@/components/CardBoxMetric.vue";

export const usePlantPollingOverviewTableStore = defineStore('plantPollingOverviewTable', {
  state: () => ({
    selectedMachines: [{
      name: 'Machine 1',
    }],
    availableMachines: ['Machine 1', 'Machine 2', 'Machine 3'],
    
    selectedParameters: [{
      name: 'Machine 1',
    }],
    availableParameters: ['Machine 1', 'Machine 2', 'Machine 3'],
  }),
  actions: {

    async fetchAndUpdateAvailableMachines() {
      const url = 'http://172.18.100.87:8000/api/v1/machines/';
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
