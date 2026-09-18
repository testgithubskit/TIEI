<script setup>
import { ref, reactive, onMounted, computed } from 'vue';
import {
  mdiAccount,
  mdiMail,
  mdiPlus,
  mdiContentSave,
  mdiClose,
  mdiFormTextboxPassword,
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

import userService from '@/services/userService';

const users = ref([]);
const isLoading = ref(false);
const showAddForm = ref(false);
const showEditForm = ref(false);
const selectedUser = ref(null);

const emptyForm = () => ({
  username: '',
  email: '',
  password: '',
  role: 'guest',
  company_id: null,
});

const newUser = reactive(emptyForm());
const editUser = reactive(emptyForm());

const currentUsername = computed({
  get: () => (showAddForm.value ? newUser.username : editUser.username),
  set: (value) => {
    if (showAddForm.value) newUser.username = value;
    else editUser.username = value;
  },
});

const currentEmail = computed({
  get: () => (showAddForm.value ? newUser.email : editUser.email),
  set: (value) => {
    if (showAddForm.value) newUser.email = value;
    else editUser.email = value;
  },
});

const currentPassword = computed({
  get: () => (showAddForm.value ? newUser.password : editUser.password),
  set: (value) => {
    if (showAddForm.value) newUser.password = value;
    else editUser.password = value;
  },
});

const currentCompanyId = computed({
  get: () => (showAddForm.value ? newUser.company_id : editUser.company_id),
  set: (value) => {
    if (showAddForm.value) newUser.company_id = value;
    else editUser.company_id = value;
  },
});

const currentRole = computed({
  get: () => (showAddForm.value ? newUser.role : editUser.role),
  set: (value) => {
    if (showAddForm.value) newUser.role = value;
    else editUser.role = value;
  },
});

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

const loadUsers = async () => {
  isLoading.value = true;
  try {
    users.value = await userService.getAllUsers();
  } catch (error) {
    showToast(error.response?.data?.detail || 'Error loading users', 'error');
  } finally {
    isLoading.value = false;
  }
};

const resetNewUser = () => {
  Object.assign(newUser, emptyForm());
};

const showAddUserForm = () => {
  showAddForm.value = true;
  showEditForm.value = false;
  resetNewUser();
};

const showEditUserForm = (user) => {
  selectedUser.value = user;
  editUser.username = user.username || '';
  editUser.email = user.email || '';
  editUser.password = '';
  editUser.role = user.role || 'guest';
  editUser.company_id = user.company_id ?? null;
  showEditForm.value = true;
  showAddForm.value = false;
};

const hideForms = () => {
  showAddForm.value = false;
  showEditForm.value = false;
  resetNewUser();
  selectedUser.value = null;
};

const normalizeCompanyId = (value) => {
  if (value === null || value === undefined || value === '') return null;
  const parsed = Number(value);
  return Number.isNaN(parsed) ? null : parsed;
};

const addUser = async () => {
  if (!newUser.username || !newUser.password) {
    showToast('Username and password are required', 'error');
    return;
  }

  try {
    await userService.createUser({
      username: newUser.username,
      email: newUser.email || null,
      password: newUser.password,
      role: newUser.role || 'guest',
      company_id: normalizeCompanyId(newUser.company_id),
    });
    showToast('User created successfully', 'success');
    hideForms();
    await loadUsers();
  } catch (error) {
    showToast(error.response?.data?.detail || 'Error creating user', 'error');
  }
};

const updateUser = async () => {
  if (!editUser.username) {
    showToast('Username is required', 'error');
    return;
  }

  const payload = {
    username: editUser.username,
    email: editUser.email || null,
    role: editUser.role || 'guest',
    company_id: normalizeCompanyId(editUser.company_id),
  };
  if (editUser.password) {
    payload.password = editUser.password;
  }

  try {
    await userService.updateUser(selectedUser.value.id, payload);
    showToast('User updated successfully', 'success');
    hideForms();
    await loadUsers();
  } catch (error) {
    showToast(error.response?.data?.detail || 'Error updating user', 'error');
  }
};

const deleteUser = async (user) => {
  if (user.username === 'cmti') {
    showToast('Super user cmti cannot be deleted', 'error');
    return;
  }
  if (!confirm(`Are you sure you want to delete ${user.username}?`)) {
    return;
  }

  try {
    await userService.deleteUser(user.id);
    showToast('User deleted successfully', 'success');
    await loadUsers();
  } catch (error) {
    showToast(error.response?.data?.detail || 'Error deleting user', 'error');
  }
};

onMounted(() => {
  loadUsers();
});
</script>

<template>
  <LayoutAuthenticated>
    <SectionMain>
      <SectionTitleLineWithButton :icon="mdiAccount" title="Users" main>
        <BaseButton
          :icon="mdiPlus"
          label="Add User"
          color="info"
          @click="showAddUserForm"
        />
      </SectionTitleLineWithButton>

      <CardBox>
        <CardBoxComponentTitle title="Users List" />

        <div v-if="isLoading" class="text-center py-8">
          <div class="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500"></div>
          <p class="mt-2 text-gray-600">Loading users...</p>
        </div>

        <div v-else-if="users.length === 0" class="text-center py-8">
          <p class="text-gray-500 text-lg">No users found.</p>
          <p class="text-gray-400 text-sm mt-2">Click "Add User" to create your first user.</p>
        </div>

        <div v-else class="overflow-hidden">
          <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
              <thead class="bg-gradient-to-r from-blue-500 to-blue-600">
                <tr>
                  <th class="px-6 py-3 text-left text-xs font-bold text-white uppercase tracking-wider">Sl No</th>
                  <th class="px-6 py-3 text-left text-xs font-bold text-white uppercase tracking-wider">User Name</th>
                  <th class="px-6 py-3 text-left text-xs font-bold text-white uppercase tracking-wider">Email</th>
                  <th class="px-6 py-3 text-left text-xs font-bold text-white uppercase tracking-wider">Role</th>
                  <th class="px-6 py-3 text-left text-xs font-bold text-white uppercase tracking-wider">Company ID</th>
                  <th class="px-6 py-3 text-left text-xs font-bold text-white uppercase tracking-wider">Actions</th>
                </tr>
              </thead>
              <tbody class="bg-white divide-y divide-gray-200">
                <tr
                  v-for="(user, index) in users"
                  :key="user.id"
                  class="hover:bg-blue-50 transition-colors duration-200"
                >
                  <td class="px-6 py-4 whitespace-nowrap text-sm font-semibold text-gray-700">
                    {{ index + 1 }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                    <div class="flex items-center">
                      <div class="flex-shrink-0 h-8 w-8 rounded-full bg-blue-100 flex items-center justify-center">
                        <span class="text-blue-600 font-semibold text-sm">
                          {{ (user.username || '?').charAt(0).toUpperCase() }}
                        </span>
                      </div>
                      <div class="ml-3 text-sm font-medium text-gray-900">{{ user.username }}</div>
                    </div>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                    {{ user.email || '—' }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                    {{ user.role || '—' }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                    {{ user.company_id ?? '—' }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                    <div class="flex space-x-2">
                      <button
                        type="button"
                        class="inline-flex items-center px-3 py-1.5 bg-yellow-500 hover:bg-yellow-600 text-white rounded-md transition-colors duration-200 text-xs font-medium"
                        @click="showEditUserForm(user)"
                      >
                        Edit
                      </button>
                      <button
                        type="button"
                        class="inline-flex items-center px-3 py-1.5 bg-red-500 hover:bg-red-600 text-white rounded-md transition-colors duration-200 text-xs font-medium disabled:opacity-50"
                        :disabled="user.username === 'cmti'"
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
          <div class="mt-4 text-sm text-gray-500 text-center">
            Total: {{ users.length }} user(s)
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
                  <h3 class="user-modal-title">{{ showAddForm ? 'Add New User' : 'Edit User' }}</h3>
                </div>
                <button type="button" class="user-modal-close" aria-label="Close" @click="hideForms">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                  </svg>
                </button>
              </div>

              <form class="user-modal-body" @submit.prevent="showAddForm ? addUser() : updateUser()">
                <FormField label="User Name" help="Required. Login username">
                  <FormControl
                    v-model="currentUsername"
                    :icon="mdiAccount"
                    placeholder="Enter username"
                    required
                    autocomplete="username"
                  />
                </FormField>

                <FormField label="E-mail" help="Optional. User email">
                  <FormControl
                    v-model="currentEmail"
                    :icon="mdiMail"
                    type="email"
                    placeholder="Enter email address"
                    autocomplete="email"
                  />
                </FormField>

                <FormField
                  label="Password"
                  :help="showAddForm ? 'Required. Login password' : 'Leave blank to keep existing password'"
                >
                  <FormControl
                    v-model="currentPassword"
                    :icon="mdiFormTextboxPassword"
                    type="password"
                    :required="showAddForm"
                    :placeholder="showAddForm ? 'Enter password' : 'Leave blank to keep current'"
                    autocomplete="new-password"
                  />
                </FormField>

                <div class="user-modal-grid">
                  <FormField label="Company ID" help="Optional">
                    <FormControl
                      v-model="currentCompanyId"
                      type="number"
                      placeholder="Company ID"
                    />
                  </FormField>

                  <FormField label="Role" help="Select role">
                    <select v-model="currentRole" class="user-modal-select">
                      <option value="admin">Admin</option>
                      <option value="guest">Guest</option>
                      <option value="maintenance_operator">Maintenance Operator</option>
                    </select>
                  </FormField>
                </div>

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
  width: min(100%, 32rem);
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

.user-modal-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 0.25rem 1rem;
}

@media (min-width: 640px) {
  .user-modal-grid {
    grid-template-columns: 1fr 1fr;
  }
}

.user-modal-select {
  width: 100%;
  border: 1px solid #cbd5e1;
  border-radius: 0.5rem;
  background: #f8fafc;
  padding: 0.625rem 0.75rem;
  color: #0f172a;
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
