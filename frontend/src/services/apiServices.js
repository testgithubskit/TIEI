import axios from 'axios';

const getBaseUrl = () => {
  if (import.meta.env.VITE_DEV_API_URL) {
    return import.meta.env.VITE_DEV_API_URL;
  }

  const isDevelopment = import.meta.env.DEV;

  if (isDevelopment) {
    return 'http://172.18.100.87:8000/api/v1';
  }

  return import.meta.env.VITE_API_URL || 'https://maintenance.cmti.online/api/v1';
};

export const backendApi = axios.create({
  baseURL: getBaseUrl(),
  headers: {
    'Content-Type': 'application/json',
  },
  timeout: 30000,
  withCredentials: false,
});

// Request interceptor
backendApi.interceptors.request.use(
  (config) => {
    console.log('Making request to:', config.url);
    return config;
  },
  (error) => {
    console.error('Request error:', error);
    return Promise.reject(error);
  }
);

// Response interceptor
backendApi.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.message === 'Network Error') {
      console.error('Network error occurred. Please check your connection.');
    } else if (error.response) {
      console.error('Response error:', {
        status: error.response.status,
        data: error.response.data,
        headers: error.response.headers,
      });
    }
    return Promise.reject(error);
  }
);