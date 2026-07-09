import { defineStore } from 'pinia';
import axios from 'axios';

import CardBoxMetric from "@/components/CardBoxMetric.vue";

import { backendApi } from '@/services/apiServices';

export const useFactoryPollOverviewStore = defineStore('useFactoryPollOverview', {
  state: () => ({
    SelectedParmeter: { item_name: "Group-661", item_state: "OK" },
    availableParameters: [
    { item_name: "Group-661", item_state: "OK" },
    { item_name: "Group-492", item_state: "WARNING" },
    { item_name: "Group-224", item_state: "CRITICAL" },
    { item_name: "Group-225", item_state: "DISCONNECTED" }
  ],
    isSuccessMessage: false,
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
              {
                label: 'DISCONNECTED',
                type: CardBoxMetric,
                value: 0,
                icon: 'mdi',
                class: 'mt-4',
                borderSide:'s',
                borderThickness:'4',
                state:'DISCONNECTED',
              },
            
            ],
          }
        ]
      }
    ],
    groupData: [
      {
        "group_name": "Group-661",
        "count": {
          "OK": 0,
          "WARNING": 0,
          "CRITICAL": 0,
          "DISCONNECTED":0,
        },
        "group_state": "OK",
        "group_details": [
          {
            "line_name": "Line-2681",
            "count": {
              "OK": 0,
              "WARNING": 0,
              "CRITICAL": 0,
              "DISCONNECTED":0,
            },
            "line_state": "CRITICAL",
            "machines": [
              {
                "machine_name": "Mac-221",
                "machine_state": "OK",
                "parameters": [
                  {
                    "internal_parameter_name": "Param-834511",
                    "display_name": "Y",
                    "actual_parameter_name": "temperature",
                    "parameter_state": "OK",
                    "parameter_value": 42,
                    "latest_update_time": 1702695914272,
                    "warning_limit": 20,
                    "critical_limit": 30,
                    
                  },
                  {
                    "internal_parameter_name": "Param-375163",
                    "display_name": "Z",
                    "actual_parameter_name": "temperature",
                    "parameter_state": "OK",
                    "parameter_value": 42,
                    "latest_update_time": 1702695914272,
                    "warning_limit": 20,
                    "critical_limit": 30
                  },
                  
                  {
                    "internal_parameter_name": "Param-375163",
                    "display_name": "Z",
                    "actual_parameter_name": "temperature",
                    "parameter_state": "OK",
                    "parameter_value": 42,
                    "latest_update_time": 1702695914272,
                    "warning_limit": 20,
                    "critical_limit": 30
                  },
                  
                  {
                    "internal_parameter_name": "Param-375163",
                    "display_name": "Z",
                    "actual_parameter_name": "temperature",
                    "parameter_state": "OK",
                    "parameter_value": 42,
                    "latest_update_time": 1702695914272,
                    "warning_limit": 20,
                    "critical_limit": 30
                  },
                  
                  {
                    "internal_parameter_name": "Param-375163",
                    "display_name": "Z",
                    "actual_parameter_name": "temperature",
                    "parameter_state": "OK",
                    "parameter_value": 42,
                    "latest_update_time": 1702695914272,
                    "warning_limit": 20,
                    "critical_limit": 30
                  },
                  
                  {
                    "internal_parameter_name": "Param-375163",
                    "display_name": "Z",
                    "actual_parameter_name": "temperature",
                    "parameter_state": "OK",
                    "parameter_value": 42,
                    "latest_update_time": 1702695914272,
                    "warning_limit": 20,
                    "critical_limit": 30
                  },
                  
                  {
                    "internal_parameter_name": "Param-375163",
                    "display_name": "Z",
                    "actual_parameter_name": "temperature",
                    "parameter_state": "OK",
                    "parameter_value": 42,
                    "latest_update_time": 1702695914272,
                    "warning_limit": 20,
                    "critical_limit": 30
                  }
                ]
              },
              {
                "machine_name": "Mac-763",
                "machine_state": "WARNING",
                "parameters": [
                  {
                    "internal_parameter_name": "Param-749271",
                    "display_name": "BMG",
                    "actual_parameter_name": "temperature",
                    "parameter_state": "OK",
                    "parameter_value": 42,
                    "latest_update_time": 1702695914272,
                    "warning_limit": 20,
                    "critical_limit": 30
                  }
                ]
              }
            ]
          },
          {
            "line_name": "Line-5710",
            "line_state": "CRITICAL",
            "count": {
              "OK": 0,
              "WARNING": 0,
              "CRITICAL": 0
            },
            "machines": [
              {
                "machine_name": "Mac-104",
                "machine_state": "WARNING",
                "parameters": [
                  {
                    "internal_parameter_name": "Param-547319",
                    "display_name": "BMG",
                    "actual_parameter_name": "temperature",
                    "parameter_state": "OK",
                    "parameter_value": 42,
                    "latest_update_time": 1702695914272,
                    "warning_limit": 20,
                    "critical_limit": 30
                  },
                  {
                    "internal_parameter_name": "Param-500678",
                    "display_name": "X",
                    "actual_parameter_name": "temperature",
                    "parameter_state": "OK",
                    "parameter_value": 42,
                    "latest_update_time": 1702695914272,
                    "warning_limit": 20,
                    "critical_limit": 30
                  }
                ]
              },
              {
                "machine_name": "Mac-84",
                "machine_state": "WARNING",
                "parameters": [
                  {
                    "internal_parameter_name": "Param-894309",
                    "display_name": "Y",
                    "actual_parameter_name": "temperature",
                    "parameter_state": "OK",
                    "parameter_value": 42,
                    "latest_update_time": 1702695914272,
                    "warning_limit": 20,
                    "critical_limit": 30
                  }
                ]
              }
            ]
          }
        ]
      },
      {
        "group_name": "Group-492",
        "group_state": "CRITICAL",
        "count": {
          "OK": 0,
          "WARNING": 0,
          "CRITICAL": 0
        },
        "group_details": [
          {
            "line_name": "Line-2465",
            "line_state": "CRITICAL",
            "count": {
              "OK": 0,
              "WARNING": 0,
              "CRITICAL": 0
            },
            "machines": [
              {
                "machine_name": "Mac-01",
                "machine_state": "WARNING",
                "parameters": [
                  {
                    "internal_parameter_name": "Param-308075",
                    "display_name": "X",
                    "actual_parameter_name": "temperature",
                    "parameter_state": "OK",
                    "parameter_value": 42,
                    "latest_update_time": 1702695914272,
                    "warning_limit": 20,
                    "critical_limit": 30
                  },
                  {
                    "internal_parameter_name": "Param-404436",
                    "display_name": "Y",
                    "actual_parameter_name": "temperature",
                    "parameter_state": "OK",
                    "parameter_value": 42,
                    "latest_update_time": 1702695914272,
                    "warning_limit": 20,
                    "critical_limit": 30
                  }
                ]
              }
            ]
          }
        ]
      },
      {
        "group_name": "Group-224",
        "group_state": "CRITICAL",
        "count": {
          "OK": 0,
          "WARNING": 0,
          "CRITICAL": 0
        },
        "group_details": [
          {
            "line_name": "Line-9254",
            "line_state": "CRITICAL",
            "count": {
              "OK": 0,
              "WARNING": 0,
              "CRITICAL": 0
            },
            "machines": [
              {
                "machine_name": "Mac-166",
                "machine_state": "WARNING",
                "parameters": [
                  {
                    "internal_parameter_name": "Param-121266",
                    "display_name": "Z",
                    "actual_parameter_name": "temperature",
                    "parameter_state": "OK",
                    "parameter_value": 42,
                    "latest_update_time": 1702695914272,
                    "warning_limit": 20,
                    "critical_limit": 30
                  }
                ]
              },
              {
                "machine_name": "Mac-612",
                "machine_state": "WARNING",
                "parameters": [
                  {
                    "internal_parameter_name": "Param-129598",
                    "display_name": "Z",
                    "actual_parameter_name": "temperature",
                    "parameter_state": "OK",
                    "parameter_value": 42,
                    "latest_update_time": 1702695914272,
                    "warning_limit": 20,
                    "critical_limit": 30
                  },
                  {
                    "internal_parameter_name": "Param-826368",
                    "display_name": "X",
                    "actual_parameter_name": "temperature",
                    "parameter_state": "OK",
                    "parameter_value": 42,
                    "latest_update_time": 1702695914272,
                    "warning_limit": 20,
                    "critical_limit": 30
                  }
                ]
              }
            ]
          },
          {
            "line_name": "Line-1230",
            "line_state": "CRITICAL",
            "count": {
              "OK": 0,
              "WARNING": 0,
              "CRITICAL": 0
            },
            "machines": [
              {
                "machine_name": "Mac-641",
                "machine_state": "WARNING",
                "parameters": [
                  {
                    "internal_parameter_name": "Param-199306",
                    "display_name": "Y",
                    "actual_parameter_name": "temperature",
                    "parameter_state": "OK",
                    "parameter_value": 42,
                    "latest_update_time": 1702695914272,
                    "warning_limit": 20,
                    "critical_limit": 30
                  },
                  {
                    "internal_parameter_name": "Param-609047",
                    "display_name": "Z",
                    "actual_parameter_name": "temperature",
                    "parameter_state": "OK",
                    "parameter_value": 42,
                    "latest_update_time": 1702695914272,
                    "warning_limit": 20,
                    "critical_limit": 30
                  }
                ]
              },
              {
                "machine_name": "Mac-458",
                "machine_state": "WARNING",
                "parameters": [
                  {
                    "internal_parameter_name": "Param-923357",
                    "display_name": "X",
                    "actual_parameter_name": "temperature",
                    "parameter_state": "OK",
                    "parameter_value": 42,
                    "latest_update_time": 1702695914272,
                    "warning_limit": 20,
                    "critical_limit": 30
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
  }),
  actions: {

    async fetchInitialPageData() {

      const url = `/factory/layout`;

      try {
        const response = await backendApi.get(url);
        this.groupData = response.data.all_group_details;
        
        const existingCycleTime = this.availableParameters.find(p => p.item_name === 'CYCLE_TIME');
        
        this.availableParameters = response.data.group_names;
        
        if (existingCycleTime) {
          this.availableParameters.push(existingCycleTime);
        } else {
          this.availableParameters.push({ item_name: 'CYCLE_TIME', item_state: 'OK' });
        }
        
        console.log('Available parameters:', this.availableParameters);
      } catch (error) {
        console.error('Error fetching/updating available machines:', error);
        throw error;
      }
    },
    setSelectedGroup(groupName = null) {

      let groupIndex = groupName? this.groupData.findIndex(group => group.group_name === groupName) : 0;

      let groupData = this.groupData[groupIndex];

      this.SelectedParmeter.item_name = groupData.group_name;
      this.SelectedParmeter.item_state = groupData.group_state;
    },
    getGroupDetail(groupName) {

      let groupIndex = this.groupData.findIndex(group => group.group_name === groupName);

      let groupData = this.groupData[groupIndex];

      return {"groupName": groupData.group_name, "groupState": groupData.group_state};
    },
    async updateGroupData() {
      const url = `/factory-state-mtlinki-test/${this.SelectedParmeter.item_name}`;
      try {
        const response = await backendApi.get(url);

        const existingCycleTime = this.availableParameters.find(p => p.item_name === 'CYCLE_TIME');
        
        this.availableParameters = response.data.group_names;
        
        if (existingCycleTime) {
          this.availableParameters.push(existingCycleTime);
        } else {
          this.availableParameters.push({ item_name: 'CYCLE_TIME', item_state: 'OK' });
        }

        const index = this.groupData.findIndex(group => group.group_name === this.SelectedParmeter.item_name);

        if (index !== -1) {
          this.groupData[index] = response.data.requested_group_details;
        } else if (this.SelectedParmeter.item_name === 'AIR_PRESSURE') {
          this.groupData.push(response.data.requested_group_details);
        }
        this.isSuccessMessage = true;
        this.alertMessage = 'Fetched New Data';
      } catch (error) {
        console.error('Error fetching group data:', error);

        this.alertMessage = 'Fetching New Data failed.';
        this.isSuccessMessage = false;
        throw error;
      } finally {
        setTimeout(() => {
          this.alertMessage = null;
        }, 1000);
      }
    },
  },
});
