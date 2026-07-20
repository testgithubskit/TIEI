import { backendApi } from '@/services/apiServices';
// stores/sparePartsStore.js
import { defineStore } from 'pinia';
import { message } from 'ant-design-vue';
import dayjs from 'dayjs';

const API_BASE_URL = '';

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
        const response = await backendApi.get(
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
        const response = await backendApi.put(
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

    // New function to update activity
    async updateActivity(id, changes) {
      const loadingMessage = message.loading('Saving changes...', 0);
      this.loading = true;
      try {
        // Format the request body according to the API requirements
        const requestBody = {
          priority: changes.priority,
          target_date_of_completion: changes.target_date_of_completion,
          spare_required: changes.spare_required,
          support_needed: changes.support_needed,
          responsible_person: changes.responsible_person_company_id
        };

        const response = await backendApi.put(
          `${API_BASE_URL}/spare-part-activity/${id}/update`,
          requestBody
        );

        if (response.data) {
          message.success('Activity updated successfully');
          // Update the local state immediately for better UX
          this.updateLocalActivity(id, changes);
          return true;
        }
        return false;
      } catch (err) {
        console.error('Error updating activity:', err);
        this.error = err.message;
        const errorMessage = err.response?.data?.detail || 'Failed to update activity';
        message.error(errorMessage);
        return false;
      } finally {
        this.loading = false;
        loadingMessage(); // Close loading message
      }
    },

    // Helper function to update local state
    updateLocalActivity(id, changes) {
      const activityIndex = this.pendingActivities.findIndex(activity => activity.id === id);
      if (activityIndex !== -1) {
        // Create a new object with the updates while preserving other properties
        this.pendingActivities[activityIndex] = {
          ...this.pendingActivities[activityIndex],
          ...changes
        };
      }
    },

    // Clear error state
    clearError() {
      this.error = null;
    }
  },
});