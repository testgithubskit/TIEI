import { defineStore } from 'pinia';
import { backendApi } from '@/services/apiServices';
import Toastify from 'toastify-js';
import 'toastify-js/src/toastify.css';

export const useProfileStore = defineStore('ProfileStore', {
  state: () => ({
    profileForm: {
      username: '',
      email: '',
      password:'',
      role:'',
      company_id:'',
    },
    passwordForm: {
      password_current: '',
      password: '',
      password_confirmation: '',
    },
  }),
  actions: {
    async setProfileForm(formData) {
      const url = '/register';

      this.profileForm = formData;
      const postProfile = this.profileForm;

      const token = localStorage.getItem('token'); // Example using localStorage

      // Add token as a header to the request
      const config = {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      };
      
      try {
        const response = await backendApi.post(url, postProfile, config);
        console.log('Edited data sent successfully:', response.data);
        
        // Show success toast notification
        this.showSuccessToast('User successfully created');
        
        return response.data; // Optional: Return data if needed in the component
      } catch (error) {
        console.error('Error sending edited data:', error);
        
        // Show error toast notification
        this.showErrorToast(`Error: ${error.message}`);
        
        throw error; // Rethrow the error for handling in the component
      }
    },
    
    showSuccessToast(message) {
      Toastify({
        text: message,
        duration: 3000,
        close: true,
        gravity: 'bottom',
        position: 'right',
        backgroundColor: 'green',
      }).showToast();
    },

    showErrorToast(message) {
      Toastify({
        text: message,
        duration: 3000,
        close: true,
        gravity: 'bottom',
        position: 'right',
        backgroundColor: 'red',
      }).showToast();
    },
    
    clearFormData() {
      // Reset form values to default or empty
      this.profileForm.username = '';
      this.profileForm.email = '';
      this.profileForm.password = '';
      this.profileForm.role = 'admin'; // Set the default role or an appropriate default value
      this.profileForm.company_id = null; // Set the default value for company_id
    },
  },
});
