<script setup>
import { reactive } from "vue";

import {
  mdiAccount,
  mdiMail,
  mdiAsterisk,
  mdiFormTextboxPassword,
  mdiGithub,
  mdiBadgeAccount
} from "@mdi/js";
import SectionMain from "@/components/SectionMain.vue";
import CardBox from "@/components/CardBox.vue";
import BaseDivider from "@/components/BaseDivider.vue";
import FormField from "@/components/FormField.vue";
import FormControl from "@/components/FormControl.vue";
import FormFilePicker from "@/components/FormFilePicker.vue";
import BaseButton from "@/components/BaseButton.vue";
import BaseButtons from "@/components/BaseButtons.vue";
import UserCard from "@/components/UserCard.vue";
import LayoutAuthenticated from "@/layouts/LayoutAuthenticated.vue";
import SectionTitleLineWithButton from "@/components/SectionTitleLineWithButton.vue";

import Toastify from 'toastify-js';
import 'toastify-js/src/toastify.css';


import { useProfileStore } from "@/stores/Profile"; // Import the profile store
import { useMainStore } from "@/stores/main";

const profileStore = useProfileStore(); // Initialize the profile store

const profileForm = reactive({
  username: profileStore.userName,
  email: profileStore.userEmail,
  password: profileStore.userPassword,
  role: profileStore.userRole,
  company_id: profileStore.userCompany_id,

});


const submitProfile =async () => {
  profileStore.setProfileForm(profileForm);
  resetFormValues();
};


const resetFormValues = () => {
  // Reset form values to default or empty
  profileForm.username = '';
  profileForm.email = '';
  profileForm.password = '';
  profileForm.role = 'admin'; // Set the default role or an appropriate default value
  profileForm.company_id = null; // Set the default value for company_id
};

</script>

<template>
  <LayoutAuthenticated>
    <SectionMain>
      <SectionTitleLineWithButton :icon="mdiAccount" title="Profile" main>
        <!-- <BaseButton
          href="https://github.com/justboil/admin-one-vue-tailwind"
          target="_blank"
          :icon="mdiGithub"
          label="Star on GitHub"
          color="contrast"
          rounded-full
          small
        /> -->
      </SectionTitleLineWithButton>

      <!-- <UserCard class="mb-6" /> -->

      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 ">
        <CardBox is-form @submit.prevent="submitProfile">

          <FormField label="Name" help="Required. Your name">
            <FormControl
              v-model="profileForm.username"
              :icon="mdiAccount"
              name="username"
              required
              autocomplete="username"
            />
          </FormField>
          <FormField label="E-mail" help="Required. Your e-mail">
            <FormControl
              v-model="profileForm.email"
              :icon="mdiMail"
              type="email"
              name="email"
              required
              autocomplete="email"
            />
          </FormField>
          <FormField label="Password" help="Required. New Password">
            <FormControl
              v-model="profileForm.password"
              :icon="mdiFormTextboxPassword"
              type="password"
              name="password"
              required
              autocomplete="password"
            />
          </FormField>
          <FormField label="Company ID" help="Required. Company ID">
            <FormControl
              v-model="profileForm.company_id"
              :icon="mdiFormTextboxPassword"
              type="Number"
              name="Number"
              required
              autocomplete="Number"
            />
          </FormField>
          <FormField label="Role" help="Select the Role">
            <select v-model="profileForm.role" class="form-control border-2 rounded-md bg-blue-100">
              <option value="admin">Admin</option>
              <option value="guest">Guest</option>
              <option value="maintenance_operator">Maintenance Operator</option>
            </select>
          </FormField>
          

          <template #footer>
            <BaseButtons>
              <BaseButton color="info" type="submit" label="Submit" />
            </BaseButtons>
          </template>
        </CardBox>

        <!-- <CardBox is-form @submit.prevent="submitPass">
          <FormField
            label="Current password"
            help="Required. Your current password"
          >
            <FormControl
              v-model="passwordForm.password_current"
              :icon="mdiAsterisk"
              name="password_current"
              type="password"
              required
              autocomplete="current-password"
            />
          </FormField>

          <BaseDivider />

          <FormField label="New password" help="Required. New password">
            <FormControl
              v-model="passwordForm.password"
              :icon="mdiFormTextboxPassword"
              name="password"
              type="password"
              required
              autocomplete="new-password"
            />
          </FormField>

          <FormField
            label="Confirm password"
            help="Required. New password one more time"
          >
            <FormControl
              v-model="passwordForm.password_confirmation"
              :icon="mdiFormTextboxPassword"
              name="password_confirmation"
              type="password"
              required
              autocomplete="new-password"
            />
          </FormField>

          <template #footer>
            <BaseButtons>
              <BaseButton type="submit" color="info" label="Submit" />
              <BaseButton color="info" label="Options" outline />
            </BaseButtons>
          </template>
        </CardBox> -->
      </div>  
    </SectionMain>
  </LayoutAuthenticated>
</template>
