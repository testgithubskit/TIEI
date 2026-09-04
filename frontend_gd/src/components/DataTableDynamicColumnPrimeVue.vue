<script setup>
import { ref, onMounted } from 'vue';
import DataTable from 'primevue/datatable';
import Column from 'primevue/column';
import ColumnGroup from 'primevue/columngroup';   // optional
import Row from 'primevue/row';                   // optional

const columns = [
    { field: 'code', header: 'Code' },
    { field: 'name', header: 'Name' },
    { field: 'category', header: 'Category' },
    { field: 'quantity', header: 'Quantity' }
];

const products = ref([
  {
    code: 'P001',
    name: 'Product A',
    category: 'Electronics',
    quantity: 25,
  },
  {
    code: 'P002',
    name: 'Product B',
    category: 'Clothing',
    quantity: 50,
  },
  {
    code: 'P003',
    name: 'Product C',
    category: 'Furniture',
    quantity: 10,
  },
  // Add more products as needed
]);

</script>

<template>
  <div class="card">
    <DataTable :value="products" tableStyle="min-width: 50rem">
            <Column v-for="col of columns" :key="col.field" :field="col.field" :header="col.header"></Column>
    </DataTable>
  </div>
</template>