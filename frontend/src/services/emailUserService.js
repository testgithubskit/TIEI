import axios from 'axios';

// VITE_DEV_API_URL / VITE_API_URL already include /api/v1 — do not append it again.
const API_BASE_URL = (
  import.meta.env.VITE_API_BASE_URL
  || import.meta.env.VITE_DEV_API_URL
  || import.meta.env.VITE_API_URL
  || ''
).replace(/\/$/, '');

const authHeaders = () => ({
  Authorization: `Bearer ${localStorage.getItem('token')}`,
});

const emailUserService = {
  // Get all email users
  async getAllEmailUsers() {
    try {
      const response = await axios.get(`${API_BASE_URL}/email_users/`, {
        headers: authHeaders(),
      });
      return response.data;
    } catch (error) {
      console.error('Error fetching email users:', error);
      throw error;
    }
  },

  // Get email user by ID
  async getEmailUserById(userId) {
    try {
      const response = await axios.get(`${API_BASE_URL}/email_users/${userId}`, {
        headers: authHeaders(),
      });
      return response.data;
    } catch (error) {
      console.error('Error fetching email user:', error);
      throw error;
    }
  },

  // Create new email user
  async createEmailUser(userData) {
    try {
      const response = await axios.post(`${API_BASE_URL}/email_users/`, userData, {
        headers: {
          ...authHeaders(),
          'Content-Type': 'application/json',
        },
      });
      return response.data;
    } catch (error) {
      console.error('Error creating email user:', error);
      throw error;
    }
  },

  // Update email user
  async updateEmailUser(userId, userData) {
    try {
      const response = await axios.put(`${API_BASE_URL}/email_users/${userId}`, userData, {
        headers: {
          ...authHeaders(),
          'Content-Type': 'application/json',
        },
      });
      return response.data;
    } catch (error) {
      console.error('Error updating email user:', error);
      throw error;
    }
  },

  // Delete email user
  async deleteEmailUser(userId) {
    try {
      const response = await axios.delete(`${API_BASE_URL}/email_users/${userId}`, {
        headers: authHeaders(),
      });
      return response.data;
    } catch (error) {
      console.error('Error deleting email user:', error);
      throw error;
    }
  },
};

export default emailUserService;
