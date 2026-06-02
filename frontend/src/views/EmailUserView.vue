<script setup>
import { ref, reactive, onMounted, computed } from 'vue';
import {
  mdiEmail,
  mdiAccount,
  mdiPlus,
  mdiPencil,
  mdiDelete,
  mdiContentSave,
  mdiClose,
} from '@mdi/js';
import SectionMain from '@/components/SectionMain.vue';
import CardBox from '@/components/CardBox.vue';
import CardBoxComponentTitle from '@/components/CardBoxComponentTitle.vue';
import BaseDivider from '@/components/BaseDivider.vue';
import FormField from '@/components/FormField.vue';
import FormControl from '@/components/FormControl.vue';
import BaseButton from '@/components/BaseButton.vue';
import BaseButtons from '@/components/BaseButtons.vue';
import LayoutAuthenticated from '@/layouts/LayoutAuthenticated.vue';
import SectionTitleLineWithButton from '@/components/SectionTitleLineWithButton.vue';

import Toastify from 'toastify-js';
import 'toastify-js/src/toastify.css';

import emailUserService from '@/services/emailUserService';

const emailUsers = ref([]);
const isLoading = ref(false);
const showAddForm = ref(false);
const showEditForm = ref(false);
const selectedUser = ref(null);

const newUser = reactive({
  user_name: '',
  email_id: ''
});

const editUser = reactive({
  user_name: '',
  email_id: ''
});

// Computed properties to handle v-model binding
const currentUserName = computed({
  get: () => showAddForm.value ? newUser.user_name : editUser.user_name,
  set: (value) => {
    if (showAddForm.value) {
      newUser.user_name = value;
    } else {
      editUser.user_name = value;
    }
  }
});

const currentUserEmail = computed({
  get: () => showAddForm.value ? newUser.email_id : editUser.email_id,
  set: (value) => {
    if (showAddForm.value) {
      newUser.email_id = value;
    } else {
      editUser.email_id = value;
    }
  }
});

const loadEmailUsers = async () => {
  isLoading.value = true;
  try {
    const data = await emailUserService.getAllEmailUsers();
    emailUsers.value = data;
  } catch (error) {
    showToast('Error loading email users', 'error');
  } finally {
    isLoading.value = false;
  }
};

const showAddUserForm = () => {
  showAddForm.value = true;
  showEditForm.value = false;
  resetNewUser();
};

const showEditUserForm = (user) => {
  selectedUser.value = user;
  editUser.user_name = user.user_name;
  editUser.email_id = user.email_id;
  showEditForm.value = true;
  showAddForm.value = false;
};

const hideForms = () => {
  showAddForm.value = false;
  showEditForm.value = false;
  resetNewUser();
  selectedUser.value = null;
};

const resetNewUser = () => {
  newUser.user_name = '';
  newUser.email_id = '';
};

const addUser = async () => {
  if (!newUser.user_name || !newUser.email_id) {
    showToast('Please fill all required fields', 'error');
    return;
  }

  try {
    await emailUserService.createEmailUser(newUser);
    showToast('Email user created successfully', 'success');
    hideForms();
    await loadEmailUsers();
  } catch (error) {
    showToast(error.response?.data?.detail || 'Error creating email user', 'error');
  }
};

const updateUser = async () => {
  if (!editUser.user_name || !editUser.email_id) {
    showToast('Please fill all required fields', 'error');
    return;
  }

  try {
    await emailUserService.updateEmailUser(selectedUser.value.id, editUser);
    showToast('Email user updated successfully', 'success');
    hideForms();
    await loadEmailUsers();
  } catch (error) {
    showToast(error.response?.data?.detail || 'Error updating email user', 'error');
  }
};

const deleteUser = async (user) => {
  if (!confirm(`Are you sure you want to delete ${user.user_name}?`)) {
    return;
  }

  try {
    await emailUserService.deleteEmailUser(user.id);
    showToast('Email user deleted successfully', 'success');
    await loadEmailUsers();
  } catch (error) {
    showToast(error.response?.data?.detail || 'Error deleting email user', 'error');
  }
};

const showToast = (message, type = 'info') => {
  Toastify({
    text: message,
    duration: 3000,
    gravity: 'top',
    position: 'right',
    style: {
      background: type === 'success' ? '#4CAF50' : type === 'error' ? '#F44336' : '#2196F3',
    },
  }).showToast();
};

onMounted(() => {
  loadEmailUsers();
});
</script>

<template>
  <LayoutAuthenticated>
    <SectionMain>
      <SectionTitleLineWithButton :icon="mdiEmail" title="Email Users" main>
        <BaseButton
          v-if="!showAddForm && !showEditForm"
          :icon="mdiPlus"
          label="Add Email User"
          color="info"
          @click="showAddUserForm"
        />
      </SectionTitleLineWithButton>

      <!-- Add/Edit Form -->
      <CardBox v-if="showAddForm || showEditForm" class="mb-6 w-full">
        <CardBoxComponentTitle :title="showAddForm ? 'Add New Email User' : 'Edit Email User'" />
        
        <form @submit.prevent="showAddForm ? addUser() : updateUser()">
          <FormField label="User Name" help="Required. Enter user name">
            <FormControl
              v-model="currentUserName"
              :icon="mdiAccount"
              placeholder="Enter user name"
              required
            />
          </FormField>

          <FormField label="Email ID" help="Required. Enter email address">
            <FormControl
              v-model="currentUserEmail"
              :icon="mdiEmail"
              type="email"
              placeholder="Enter email address"
              required
            />
          </FormField>

          <BaseDivider />

          <BaseButtons>
            <BaseButton
              type="submit"
              color="info"
              :label="showAddForm ? 'Add User' : 'Update User'"
              :icon="mdiContentSave"
              class="px-6 py-2"
            />
            <BaseButton
              color="danger"
              label="Cancel"
              :icon="mdiClose"
              @click="hideForms"
              class="px-6 py-2"
            />
          </BaseButtons>
        </form>
      </CardBox>

      <!-- Email Users List -->
      <CardBox v-if="!showAddForm && !showEditForm">
        <CardBoxComponentTitle title="Email Users List" />
        
        <div v-if="isLoading" class="text-center py-8">
          <div class="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500"></div>
          <p class="mt-2 text-gray-600">Loading email users...</p>
        </div>

        <div v-else-if="emailUsers.length === 0" class="text-center py-8">
          <p class="text-gray-500 text-lg">No email users found.</p>
          <p class="text-gray-400 text-sm mt-2">Click "Add Email User" to create your first email user.</p>
        </div>

        <div v-else class="overflow-hidden">
          <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
              <thead class="bg-gradient-to-r from-blue-500 to-blue-600">
                <tr>
                  <th class="px-6 py-3 text-left text-xs font-bold text-white uppercase tracking-wider">
                    Sl No
                  </th>
                  <th class="px-6 py-3 text-left text-xs font-bold text-white uppercase tracking-wider">
                    User Name
                  </th>
                  <th class="px-6 py-3 text-left text-xs font-bold text-white uppercase tracking-wider">
                    Email ID
                  </th>
                  <th class="px-6 py-3 text-left text-xs font-bold text-white uppercase tracking-wider">
                    Actions
                  </th>
                </tr>
              </thead>
              <tbody class="bg-white divide-y divide-gray-200">
                <tr v-for="(user, index) in emailUsers" :key="user.id" class="hover:bg-blue-50 transition-colors duration-200">
                  <td class="px-6 py-4 whitespace-nowrap text-sm font-semibold text-gray-700">
                    {{ index + 1 }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                    <div class="flex items-center">
                      <div class="flex-shrink-0 h-8 w-8 rounded-full bg-blue-100 flex items-center justify-center">
                        <span class="text-blue-600 font-semibold text-sm">{{ user.user_name.charAt(0).toUpperCase() }}</span>
                      </div>
                      <div class="ml-3">
                        <div class="text-sm font-medium text-gray-900">{{ user.user_name }}</div>
                      </div>
                    </div>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                    <div class="flex items-center">
                      <svg class="h-4 w-4 text-gray-400 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                      </svg>
                      {{ user.email_id }}
                    </div>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                    <div class="flex space-x-2">
                      <button
                        @click="showEditUserForm(user)"
                        class="inline-flex items-center px-3 py-1.5 bg-yellow-500 hover:bg-yellow-600 text-white rounded-md transition-colors duration-200 text-xs font-medium"
                        title="Edit"
                      >
                        <svg class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                        </svg>
                        Edit
                      </button>
                      <button
                        @click="deleteUser(user)"
                        class="inline-flex items-center px-3 py-1.5 bg-red-500 hover:bg-red-600 text-white rounded-md transition-colors duration-200 text-xs font-medium"
                        title="Delete"
                      >
                        <svg class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                        </svg>
                        Delete
                      </button>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          <div v-if="emailUsers.length > 0" class="mt-4 text-sm text-gray-500 text-center">
            Total: {{ emailUsers.length }} email user(s)
          </div>
        </div>
      </CardBox>
    </SectionMain>
  </LayoutAuthenticated>
</template>
