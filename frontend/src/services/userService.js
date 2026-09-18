import { backendApi } from '@/services/apiServices';

const authConfig = () => ({
  headers: {
    Authorization: `Bearer ${localStorage.getItem('token')}`,
  },
});

const userService = {
  async getAllUsers() {
    const response = await backendApi.get('/users', authConfig());
    return response.data?.user_data || [];
  },

  async createUser(userData) {
    // Trailing slash matches backend /register/ and avoids FastAPI 307 double-POST.
    const response = await backendApi.post('/register/', userData, authConfig());
    return response.data;
  },

  async updateUser(userId, userData) {
    const response = await backendApi.put(`/user/${userId}`, userData, authConfig());
    return response.data;
  },

  async deleteUser(userId) {
    const response = await backendApi.delete(`/user/${userId}`, authConfig());
    return response.data;
  },
};

export default userService;
