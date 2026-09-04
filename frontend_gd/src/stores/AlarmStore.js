import { defineStore } from 'pinia';
import { backendApi } from '@/services/apiServices';

function convertEpochToDateTimeString(epoch) {
  const date = new Date(epoch);
  const year = date.getFullYear();
  const month = (date.getMonth() + 1).toString().padStart(2, '0');
  const day = date.getDate().toString().padStart(2, '0');
  const hours = date.getHours().toString().padStart(2, '0');
  const minutes = date.getMinutes().toString().padStart(2, '0');
  const seconds = date.getSeconds().toString().padStart(2, '0');
  return `${year}/${month}/${day} ${hours}:${minutes}:${seconds}`;
}

export const useAlarmStore = defineStore('Alarm', {
  state: () => ({
    availableMachines: ["T_H_OP100B", "T_H_OP100"],
    selectedMachine: "T_H_OP100B",
    selectedDates: {
      from: 1703058029000,
      to: 1703234429000,
    },
    timelineData : [],
    countData : [],

    timespanData : [],

  }),

  actions: {
    async fetchAlarmData() {
      const url = `/${this.selectedMachine}/alarms?startTime=${this.selectedDates.from}&endTime=${this.selectedDates.to}`;
      try { 
        const response = await backendApi.get(url);
        const data  = response.data.data;
        this.timelineData = data.timeline_data.map((item) => ({
          ...item,
          enddate_epoch_time: convertEpochToDateTimeString(item.enddate_epoch_time * 1000),
          update_epoch_time: convertEpochToDateTimeString(item.update_epoch_time * 1000),
        }));
        console.log("Timeline data");
        console.log(this.timelineData);
        this.countData = data.count_data;
        this.timespanData = data.timespan_data;
      } catch (error) {
        console.error('Error fetching machine data:', error);
        throw error;
      }
    },

    

    async fetchAvailableMachines() {
      const url = '/machines'; // Use the new URL

      try {
        const response = await backendApi.get(url);
        this.availableMachines = response.data.data; // Update availableMachines state
      } catch (error) {
        console.error('Error fetching available machines:', error);
        throw error;
      }
    }
  },
});
