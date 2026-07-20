import { defineStore } from 'pinia';
import { backendApi } from '@/services/apiServices';

export const useSparePartStore = defineStore('sparePartStore', {
  state: () => ({
    machine: 'T_H_OP540',
    parameterGroup: 'APC_BATTERY',
    alertMessage: '',
    isSuccessMessage: false,
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
      const url = `/${machineName}/spareParts`;

      try {
        const response = await fetch(url);
        const data = await response.json();

        if (data.total_count >= 0) {
          this.spareParts = data.spare_parts;
          console.log("Inside the store")
          console.log(data.current_count)
          this.currentCount = data.current_count;
          this.cumulativeCount = data.total_count
          console.log(this.currentCount)
          
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

    


    async deleteSparePart(deletedPart) {
      // Implement your logic to delete the spare part
      console.log('Deleting spare part:', deletedPart);

      const url = `/delete/${deletedPart.id}`;
      try {
        // Send a delete request to the backend
        const response = await backendApi.delete(url);

        // Handle success
        console.log('Delete Spare Part Response:', response.data);

        // Set the alert message for success
        this.alertMessage = 'Spare part deleted successfully';
        this.isSuccessMessage = true;
      } catch (error) {
        console.error('Error deleting spare part:', error);

        // Set the alert message for failure
        this.alertMessage = 'Delete failed. Please try again.';
        this.isSuccessMessage = false;
      } finally {
        // Set a timer to clear the alert after a few seconds
        setTimeout(() => {
          this.alertMessage = '';
        }, 5000);
      }
    },
  },
});
