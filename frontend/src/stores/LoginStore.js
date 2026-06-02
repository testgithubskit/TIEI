import { defineStore } from 'pinia';
import axios from 'axios';

import { backendApi } from '@/services/apiServices';


export const useLoginStore = defineStore('useLogin', {
  state: () => ({
    userName: "cmti",
    password: "password",
    accessToken: null
  }),
  actions: {

    async fetchAuth() {
      try {
        // Create a new FormData object
        const formData = new FormData();
    
        // Append the form fields to the FormData object
        formData.append("username", localStorage.getItem("userName"));
        formData.append("password", localStorage.getItem("password"));
    
        const url = '/auth'
        
    
        const response = await backendApi.post(url, formData);
    
        // Assuming the token is returned in the response data
        const token = response.data.access_token;
        const role = response.data.role;
        console.log("tokkkkkkk")
        console.log(token)
        // Store the token in localStorage
        localStorage.setItem("token", token);
        localStorage.setItem("role", role);
        console.log("acessessssss")
        console.log(localStorage.getItem("token"))
        console.log("Role")
        console.log(localStorage.getItem("role"))
    
        // Redirect to the dashboard after successful login
        return true
      } catch (error) {
        console.error("Authentication failed", error);
        // Handle authentication failure (e.g., show error message)
        return false
      }
    },
}});
