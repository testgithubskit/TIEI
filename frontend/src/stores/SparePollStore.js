import { defineStore } from 'pinia';

import CardBoxMetric from "@/components/CardBoxMetric.vue";

import { backendApi } from '@/services/apiServices';

export const useSparePollStore = defineStore('useSparePoll', {
  state: () => ({
    sections: [
      {
        sectionName: 'Factory Summary',
        subSections: [
          {
            subSectionName: 'Total Machines',
            components: [
              {
                label: 'OK',
                type: CardBoxMetric,
                value: 0,
                icon: 'mdi',
                class: 'mt-4',
                borderSide:'s',
                borderThickness:'4',
                state:'OK',
              },
              {
                label: 'WARNING',
                type: CardBoxMetric,
                value: 0,
                icon: 'mdi',
                class: 'mt-4',
                borderSide:'s',
                borderThickness:'4',
                state:'WARNING',
              },
              {
                label: 'CRITICAL',
                type: CardBoxMetric,
                value: 0,
                icon: 'mdi',
                class: 'mt-4',
                borderSide:'s',
                borderThickness:'4',
                state:'CRITICAL',
              },
            ],
          }
        ]
      }
    ],
    spareData: 
    {
      "group_name": "string",
      "count": {
        "OK": 0,
        "WARNING": 0,
        "CRITICAL": 0
      },
      "group_details": [
        {
          "line_name": "string",
          "count": {
            "OK": 0,
            "WARNING": 0,
            "CRITICAL": 0
          },
          "machines": [
            {
              "machine_name": "Machine 1",
              "parameters": [
                {
                  "internal_parameter_name": "A0-P1",
                  "display_name": "X",
                  "actual_parameter_name": "string",
                  "latest_update_time": 0,
                  "parameter_value": 0,
                  "parameter_state": "OK",
                  "warning_limit": 0,
                  "critical_limit": 0
                }
              ],
              "machine_state": "OK"
            }
          ],
          "line_state": "OK"
        }
      ],
      "group_state": "OK"
    }
  }),
  actions: {

    async fetchInitialPageData() {
  
      const url = `/machine-spare-states-new`; 
  
      try {
        const response = await backendApi.get(url);
        this.spareData = response.data;
      } catch (error) {
        console.error('Error fetching/updating available machines:', error);
        throw error;
      }
    },
    async updateStateData() {
  
      const url = `/machine-spare-states-new`; 
  
      try {
        const response = await backendApi.get(url);
        this.spareData = response.data;
        console.log("Updated Spare Details");  
      } catch (error) {
        console.error('Error fetching/updating available machines:', error);
        throw error;
      }
    },
  },
});
