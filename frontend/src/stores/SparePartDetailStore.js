import { defineStore } from 'pinia';
import { backendApi } from '@/services/apiServices';

export const useSparePartDetailStore = defineStore('sparePartDetailStore', {
  state: () => ({
    selectedMachine: "T_H_OP260", // Default selected machine
    spareParts: [],
    editedRowIds: [], // New array to store edited row IDs
    editedData: [],
    newPartData: {
      part_name: '',
      referencePartNumber: 0,
      warning_limit: 0,
      critical_limit: 0,
      count: 0
    },
    deletedParts : [],
    currentCount: 100,
    cumulativeCount: 1000
  }),
  actions: {
    async fetchSpareData() {
      const url = `/${this.selectedMachine}/spare-parts`;

      await backendApi.get(url).then((response) => {
        const responseData = response.data;
        this.spareParts = responseData.spare_parts;
        this.currentCount = responseData.current_count;
        this.cumulativeCount = responseData.total_count;
      });
    },

    async addNewPart(newPartData) {
      const token = localStorage.getItem('token'); // Retrieve the token from localStorage

      // Add token as a header to the request
      const config = {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      };
      

      const payload = {
        data: newPartData,
      };

      const url = `/${this.selectedMachine}/spare-parts`;

      // Make a POST request with the token included in the headers
      const response = await backendApi.post(url, payload, config);
      console.log(response.data);
    },

    async deletePart(){
      const token = localStorage.getItem('token'); // Retrieve the token from localStorage

      // Add token as a header to the request
      const config = {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      };

      // Create the request body with deleted parts
      const payload = {
        part_names: this.deletedParts
      };
      console.log("To be deleted");
      console.log(this.deletedParts);
      const url = `factory/machines/${this.selectedMachine}/spare-parts`;
      if (this.deletedParts.length != 0){
        
      try {
        const response = await backendApi.delete(url, { data: payload, headers: config.headers });
        this.deletedParts = [];
      } catch (error) {
        throw error;
      }

      }
    },

    //save action
    saveEditedRowIds(rowId) {
      this.editedRowIds.push(rowId);
      console.log("Saved table")
      console.log(this.editedRowIds.length)
    },


    async updateModifiedData() {

      let url = `${this.selectedMachine}/spare-parts`;

      let modifiedData = this.spareParts.filter(row => this.editedRowIds.includes(row.id));
      
      // Assuming you have a variable 'cumulativeCount' defined
      modifiedData.forEach(row => {
        console.log(row.count);
        if (row.count == 0) {
            row.reference_part_number = this.cumulativeCount;
        }
      });

      const payload = {
        data: modifiedData,
      };

      // Assuming backendApi.post is available and you've defined a method for sending data
      // You may need to adjust this based on your API service implementation
      try {
        const response = await backendApi.put(url, payload);
        console.log('Edited data sent successfully:', response.data);
      } catch (error) {
        console.error('Error sending edited data:', error);
        throw error; // Rethrow the error for handling in the component
      }
    },
  },
});
