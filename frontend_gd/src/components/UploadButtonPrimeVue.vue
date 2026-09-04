<template>
  <div class="m-4 flex flex-row">
    <div class="bg-white p-2 shadow-md rounded-md flex flex-row">
      <input
        type="file"
        class="border rounded w-full p-2"
        @change="handleFileUpload"
      />
      <button
        class="m-4 bg-blue-500 hover:bg-blue-600 text-white py-2 px-4 rounded"
        @click="uploadFile"
      >
        Upload
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';

const fileInputRef = ref(null);

const handleFileUpload = () => {
  const file = fileInputRef.value.files[0];
  // Handle file selection or validation if needed
};

const uploadFile = () => {
  // Perform file upload logic here
};
</script>
