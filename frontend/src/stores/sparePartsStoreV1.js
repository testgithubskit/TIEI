// stores/sparePartsStore.js
import { defineStore } from 'pinia';
import axios from 'axios';
import { message } from 'ant-design-vue';
import dayjs from 'dayjs';

const API_BASE_URL = 'http://172.18.100.87:8000/api/v1';

export const useSparePartsStore = defineStore('spareParts', {
  state: () => ({
    pendingActivities: [],
    completedActivities: [],
    loading: false,
    error: null,
  }),

  actions: {
    async fetchActivities(startTime, endTime) {
      this.loading = true;
      try {
        const response = await axios.get(
          `${API_BASE_URL}/spare-part-maintenance-activities`,
          {
            params: {
              startTime,
              endTime,
            },
          }
        );
        this.pendingActivities = response.data.pending;
        this.completedActivities = response.data.completed;
      } catch (err) {
        console.error('Error fetching activities:', err);
        this.error = err.message;
        message.error(err.response?.data?.detail || 'Failed to fetch activities');
      } finally {
        this.loading = false;
      }
    },

    async completeActivity(id, completionData) {
      const loadingMessage = message.loading('Completing activity...', 0);
      this.loading = true;
      try {
        // Use PUT method instead of POST
        const response = await axios.put(
          `${API_BASE_URL}/spare-part-activity/${id}/complete`,
          completionData
        );

        if (response.data) {
          message.success('Activity completed successfully');
          // Refresh activities with current date range
          const end = dayjs();
          const start = dayjs().subtract(7, 'day');
          await this.fetchActivities(start.valueOf(), end.valueOf());
          return true;
        }
        return false;
      } catch (err) {
        console.error('Error completing activity:', err);
        this.error = err.message;
        const errorMessage = err.response?.data?.detail || 'Failed to complete activity';
        message.error(errorMessage);
        return false;
      } finally {
        this.loading = false;
        loadingMessage(); // Close loading message
      }
    },
  },
});