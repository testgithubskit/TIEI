import { defineStore } from 'pinia';
import { backendApi } from '@/services/apiServices';

export const useSparePartTabulatorStore = defineStore('sparePartTabulatorStore', {
  state: () => ({
    machine: 'T_H_OP540',
    cumulativeCount: 3333,
    currentCount : 4040,
    spareParts: [
      {
        id: 0,
        part_name: 'inital Part',
        count: 20,
        warning_limit: 444,
        critical_limit: 44,
      },
    ],
  }),

  actions: {
    async fetchSparePartData(machineName) {
      const url = `http://172.18.100.99:8000/api/v1/${machineName}/spareParts`;

      try {
        const response = await fetch(url);
        const data = await response.json();

        if (data.total_count >= 0) {
          this.spareParts = data.spare_parts;
          this.currentCount = data.current_count;
          this.cumulativeCount = data.total_count;
          
        } else {
          this.spareParts = [
            {
              id: 0,
              part_name: 'fetched Part',
              count: 34,
              warning_limit: 32,
              critical_limit: 23,
            },
          ];
        }
      } catch (error) {
        console.error('Error fetching spare part data:', error);
        this.spareParts = [
          {
            id: 0,
            part_name: 'intiaal Part',
            count: 45,
            warning_limit: 34,
            critical_limit: 23,
          },
        ];
      }
    },

    async updateSparePart(editedPart) {
      // Implement your logic to update the spare part data
      console.log('Updating spare part data:', editedPart);

      const url = `/update-spare-part/${editedPart.id}`;
      try {
        const response = await backendApi.put(url, editedPart);
        const responseData = response.data;

        // Handle success
        console.log('Update Spare Part Response:', responseData);

        // Set the alert message for success
        this.alertMessage = 'Spare part updated successfully';
        this.isSuccessMessage = true;
      } catch (error) {
        console.error('Error updating spare part:', error);

        // Set the alert message for failure
        this.alertMessage = 'Update failed. Please try again.';
        this.isSuccessMessage = false;
      } finally {
        // Set a timer to clear the alert after a few seconds
        setTimeout(() => {
          this.alertMessage = '';
        }, 5000);
      }
    },

    async addNewSparePart(newPart) {
      // Implement your logic to add a new spare part
      console.log('Adding new spare part:', newPart);

      const url = `/add-spare-part`; // Update with your API endpoint
      try {
        // Send a POST request to the backend to add the new part
        const response = await backendApi.post(url, newPart);
        const responseData = response.data;

        // Handle success
        console.log('Add Spare Part Response:', responseData);

        // Set the alert message for success
        this.alertMessage = 'Spare part added successfully';
        this.isSuccessMessage = true;
      } catch (error) {
        console.error('Error adding new spare part:', error);

        // Set the alert message for failure
        this.alertMessage = 'Addition failed. Please try again.';
        this.isSuccessMessage = false;
      } finally {
        // Set a timer to clear the alert after a few seconds
        setTimeout(() => {
          this.alertMessage = '';
        }, 5000);
      }
    },

    async deleteSpareParts(toBeDeletedParts) {
      const url = `/factory/machines/${this.machine}/spare-parts`;
    
      try {
        // Send a delete request to the backend with data in the request body
        const response = await backendApi.delete(url, {
          data: { toBeDeletedParts }, // Include toBeDeletedParts in the request body
        });
    
        // Handle success
        console.log('Delete Spare Part Response:', response.data);
    
        return response.data; // Return the response data if needed
      } catch (error) {
        console.error('Error deleting spare part:', error);
    
        // Raise an error to be captured elsewhere
        throw new Error('Delete failed. Please try again.');
      }
    }    
  },
});
