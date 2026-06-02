import { defineStore } from 'pinia';
import { backendApi } from '@/services/apiServices';

// Function to convert epoch timestamp to yyyy/mm/dd
function convertEpochToDateString(epoch) {
  const date = new Date(epoch);
  const year = date.getFullYear();
  const month = (date.getMonth() + 1).toString().padStart(2, '0');
  const day = date.getDate().toString().padStart(2, '0');
  return `${year}/${month}/${day}`;
}

export const useActivityStore = defineStore('ActivityStore', {
  state: () => ({
    selectedDates: {
      from: 98099,
      to: 78909,
    },
    pendingData: [],
    completedData: [],
    editedRowIds: [], // New array to store edited row IDs
    editedData: [],
  }),
  actions: {
    fetchActivityData() {
      console.log("inside the store");
      const url = `/maintenance-activities?startTime=${encodeURIComponent(
        this.selectedDates.from
      )}&endTime=${encodeURIComponent(this.selectedDates.to)}`;

      return backendApi.get(url).then((response) => {
        const responseData = response.data;

        // Convert epoch timestamps to yyyy/mm/dd
        this.pendingData = responseData.pending.map((item) => ({
          ...item,
          date_of_identification: convertEpochToDateString(item.date_of_identification),
          latest_occurrence_time: convertEpochToDateString(item.latest_occurrence_time),
        }));

        this.completedData = responseData.completed.map((item) => ({
          ...item,
          date_of_identification: convertEpochToDateString(item.date_of_identification),
          latest_occurrence_time: convertEpochToDateString(item.latest_occurrence_time),
        }));

        return responseData; // Optional: Return data if needed in the component
      });
    },
    // ... other actions as needed

    //save action
    saveEditedRowIds(rowId) {
      this.editedRowIds.push(rowId);
      console.log("Saved table")
    },
    


    sendEdit(editedDatas) {
      console.log("this is the data changed from paretn")
      console.log(editedDatas)
      console.log("meow");
      console.log(this.pendingData)
      this.editedData = editedDatas;
      console.log("after pushing ")
      console.log(this.editedData)
      const url = '/maintenance-activities';

       
      // Flatten the array if needed
      console.log("sending dagta")
      
      const payload = {
        data: this.editedData,
      };

      console.log("payload")
      console.log(payload)
      // Assuming backendApi.post is available and you've defined a method for sending data
      // You may need to adjust this based on your API service implementation
      return backendApi.put(url, payload).then((response) => {
        console.log('Edited data sent successfully:', response.data);
        // Optionally, reset the edited data array after successful submission
        this.editedData = [];
        return response.data; // Optional: Return data if needed in the component
      }).catch((error) => {
        console.error('Error sending edited data:', error);
        throw error; // Rethrow the error for handling in the component
      });
    },

  },
});
