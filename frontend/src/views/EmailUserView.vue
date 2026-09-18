<script setup>
import { ref, reactive, onMounted, computed } from 'vue';
import {
  mdiEmail,
  mdiAccount,
  mdiPlus,
  mdiContentSave,
  mdiClose,
} from '@mdi/js';
import SectionMain from '@/components/SectionMain.vue';
import CardBox from '@/components/CardBox.vue';
import CardBoxComponentTitle from '@/components/CardBoxComponentTitle.vue';
import FormField from '@/components/FormField.vue';
import FormControl from '@/components/FormControl.vue';
import BaseButton from '@/components/BaseButton.vue';
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
    showToast(error.response?.data?.detail || 'Error loading email users', 'error');
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
          :icon="mdiPlus"
          label="Add Email User"
          color="info"
          @click="showAddUserForm"
        />
      </SectionTitleLineWithButton>

      <CardBox>
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
                  <th class="px-6 py-3 text-left text-xs font-bold text-white uppercase tracking-wider">Sl No</th>
                  <th class="px-6 py-3 text-left text-xs font-bold text-white uppercase tracking-wider">User Name</th>
                  <th class="px-6 py-3 text-left text-xs font-bold text-white uppercase tracking-wider">Email ID</th>
                  <th class="px-6 py-3 text-left text-xs font-bold text-white uppercase tracking-wider">Actions</th>
                </tr>
              </thead>
              <tbody class="bg-white divide-y divide-gray-200">
                <tr
                  v-for="(user, index) in emailUsers"
                  :key="user.id"
                  class="hover:bg-blue-50 transition-colors duration-200"
                >
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
                        type="button"
                        class="inline-flex items-center px-3 py-1.5 bg-yellow-500 hover:bg-yellow-600 text-white rounded-md transition-colors duration-200 text-xs font-medium"
                        title="Edit"
                        @click="showEditUserForm(user)"
                      >
                        Edit
                      </button>
                      <button
                        type="button"
                        class="inline-flex items-center px-3 py-1.5 bg-red-500 hover:bg-red-600 text-white rounded-md transition-colors duration-200 text-xs font-medium"
                        title="Delete"
                        @click="deleteUser(user)"
                      >
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

      <Teleport to="body">
        <Transition name="user-modal">
          <div
            v-if="showAddForm || showEditForm"
            class="user-modal-overlay"
            @click.self="hideForms"
          >
            <div class="user-modal-panel" role="dialog" aria-modal="true">
              <div class="user-modal-header">
                <div>
                  <p class="user-modal-kicker">{{ showAddForm ? 'Create' : 'Update' }}</p>
                  <h3 class="user-modal-title">
                    {{ showAddForm ? 'Add New Email User' : 'Edit Email User' }}
                  </h3>
                </div>
                <button type="button" class="user-modal-close" aria-label="Close" @click="hideForms">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                  </svg>
                </button>
              </div>

              <form class="user-modal-body" @submit.prevent="showAddForm ? addUser() : updateUser()">
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

                <div class="user-modal-actions">
                  <BaseButton
                    color="danger"
                    label="Cancel"
                    :icon="mdiClose"
                    outline
                    @click="hideForms"
                  />
                  <BaseButton
                    type="submit"
                    color="info"
                    :label="showAddForm ? 'Add User' : 'Update User'"
                    :icon="mdiContentSave"
                  />
                </div>
              </form>
            </div>
          </div>
        </Transition>
      </Teleport>
    </SectionMain>
  </LayoutAuthenticated>
</template>

<style scoped>
.user-modal-overlay {
  position: fixed;
  inset: 0;
  z-index: 10050;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 1.25rem;
  background: rgba(15, 23, 42, 0.55);
  backdrop-filter: blur(4px);
}

.user-modal-panel {
  width: min(100%, 28rem);
  max-height: calc(100vh - 2.5rem);
  overflow: auto;
  background: #fff;
  border-radius: 1rem;
  box-shadow: 0 25px 50px -12px rgba(15, 23, 42, 0.35);
  border: 1px solid #e2e8f0;
}

.user-modal-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 1rem;
  padding: 1.25rem 1.5rem 0.75rem;
  border-bottom: 1px solid #e2e8f0;
}

.user-modal-kicker {
  margin: 0;
  font-size: 0.7rem;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: #0284c7;
}

.user-modal-title {
  margin: 0.15rem 0 0;
  font-size: 1.25rem;
  font-weight: 700;
  color: #0f172a;
}

.user-modal-close {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 2rem;
  height: 2rem;
  border-radius: 9999px;
  color: #64748b;
  background: #f1f5f9;
  transition: background 0.15s ease, color 0.15s ease;
}

.user-modal-close:hover {
  background: #e2e8f0;
  color: #0f172a;
}

.user-modal-body {
  padding: 1.25rem 1.5rem 1.5rem;
}

.user-modal-actions {
  display: flex;
  justify-content: flex-end;
  gap: 0.75rem;
  margin-top: 1.25rem;
  padding-top: 1rem;
  border-top: 1px solid #e2e8f0;
}

.user-modal-enter-active,
.user-modal-leave-active {
  transition: opacity 0.2s ease;
}

.user-modal-enter-active .user-modal-panel,
.user-modal-leave-active .user-modal-panel {
  transition: transform 0.2s ease, opacity 0.2s ease;
}

.user-modal-enter-from,
.user-modal-leave-to {
  opacity: 0;
}

.user-modal-enter-from .user-modal-panel,
.user-modal-leave-to .user-modal-panel {
  opacity: 0;
  transform: translateY(12px) scale(0.98);
}
</style>
