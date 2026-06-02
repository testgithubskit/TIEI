<template>
    <button
      :class="[
        'inline-flex items-center justify-center px-4 py-2 rounded-lg font-medium transition-all duration-200',
        'focus:outline-none focus:ring-2 focus:ring-offset-2',
        sizeClasses[size],
        typeClasses[type],
        { 'opacity-50 cursor-not-allowed': disabled || loading }
      ]"
      :disabled="disabled || loading"
      @click="$emit('click')"
    >
      <component 
        v-if="loading" 
        :is="LoaderIcon"
        class="animate-spin -ml-1 mr-2 h-4 w-4"
      />
      <component 
        v-else-if="icon" 
        :is="icon"
        class="h-4 w-4"
      />
      <slot />
    </button>
  </template>
  
  <script setup>
  import { LoaderIcon } from 'lucide-react';
  
  const props = defineProps({
    type: {
      type: String,
      default: 'default',
      validator: (value) => ['default', 'primary', 'success', 'danger'].includes(value)
    },
    size: {
      type: String,
      default: 'default',
      validator: (value) => ['small', 'default', 'large'].includes(value)
    },
    loading: Boolean,
    disabled: Boolean,
    icon: {
      type: [String, Object],
      default: null
    }
  });
  
  const typeClasses = {
    default: 'bg-white text-gray-700 border border-gray-300 hover:bg-gray-50',
    primary: 'bg-blue-600 text-white hover:bg-blue-700 focus:ring-blue-500',
    success: 'bg-green-600 text-white hover:bg-green-700 focus:ring-green-500',
    danger: 'bg-red-600 text-white hover:bg-red-700 focus:ring-red-500'
  };
  
  const sizeClasses = {
    small: 'text-sm px-3 py-1',
    default: 'text-base px-4 py-2',
    large: 'text-lg px-6 py-3'
  };
  </script>