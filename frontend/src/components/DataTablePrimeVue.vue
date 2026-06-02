<script setup>
import { ref, onMounted } from 'vue';
import DataTable from 'primevue/datatable';
import Column from 'primevue/column';
import ColumnGroup from 'primevue/columngroup';   // optional
import Row from 'primevue/row';                   // optional


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
          <Column field="code" header="Code"></Column>
          <Column field="name" header="Name"></Column>
          <Column field="category" header="Category"></Column>
          <Column field="quantity" header="Quantity"></Column>
      </DataTable>
  </div>
</template>