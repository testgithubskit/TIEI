import { defineStore } from 'pinia';

import axios from 'axios';


export const useManufacturingInformationSystemStore = defineStore('manufacturingInformationSystem', {
  state: () => ({
    departments: [[
      {
        "heading": "Sample Heading 1",
        "items": [
          {
            "name": "Document 1",
            "link": "https://cmti.res.in/"
          },
          {
            "name": "Document 2",
            "link": "https://cmti.res.in/"
          },
          {
            "name": "Document 3",
            "link": "https://cmti.res.in/"
          }
        ],
        "color": {
          "background": "bg-green-50",
          "border": "border-blue-200",
          "headerText": "text-green-500",
          "listText": "text-blue-800"
        }
      },
      {
        "heading": "Sample Heading 2",
        "items": [
          {
            "name": "Document 1",
            "link": "https://cmti.res.in/"
          },
          {
            "name": "Document 2",
            "link": "https://cmti.res.in/"
          },
          {
            "name": "Document 3",
            "link": "https://cmti.res.in/"
          },
          {
            "name": "Document 4",
            "link": "https://cmti.res.in/"
          }
        ],
        "color": {
          "background": "bg-green-50",
          "border": "border-blue-200",
          "headerText": "text-green-500",
          "listText": "text-red-800"
        }
      },
      {
        "heading": "Sample Heading 3",
        "items": [
          {
            "name": "Document 1",
            "link": "https://cmti.res.in/"
          },
          {
            "name": "Document 2",
            "link": "https://cmti.res.in/"
          },
          {
            "name": "Document 3",
            "link": "https://cmti.res.in/"
          },
          {
            "name": "Document 4",
            "link": "https://cmti.res.in/"
          }
        ],
        "color": {
          "background": "bg-yellow-50",
          "border": "border-red-200",
          "headerText": "text-yellow-500",
          "listText": "text-green-800"
        }
      }
    ]],
    inputUId: ''
  }),
  actions: {

    async fetchAndUpdateAvailableDocuments() {
      const url = 'http://172.18.100.87:8000/api/v1/get_sample_documents';
      console.log("from actions");
      try {
        console.log(1);
        const response = await axios.get(url);
        console.log(2);
        const departments = response.data;
        console.log('Available Departments:', departments);
        this.departments= departments;
        console.log(this.departments);
        console.log(3);
        return departments;
      } catch (error) {
        console.error('Error fetching/ updating available departments:', error);
        throw error;
      }
    }
  },
});
