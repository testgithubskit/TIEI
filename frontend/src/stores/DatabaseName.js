import { defineStore } from 'pinia';
import { backendApi } from '@/services/apiServices';


export const useDatabaseName = defineStore('DatabaseName', {
  state: () => ({
    schemaName: '',
  }),
  actions: {
    async fetchSchemaName() {
      const url = '/get_schema_name'; // Use the direct URL
      return backendApi.get(url).then((response) => {
        this.schemaName = response.data.schema_name[0]; // Assuming schema_name is always an array with one element
        console.log("shcemaaaaaaaa")
        console.log(this.schemaName)
        return this.schemaName; // Return schema name if needed in the component
      });
    },

    
  },
});
