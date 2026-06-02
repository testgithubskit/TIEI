<template>
  <NavBarItem
    v-for="(item, index) in menu"
    :key="index"
    :item="item"
    @menu-click="menuClickDropdown"
    :selected-item="selectedItem"
  />
</template>

<script setup>
import NavBarItem from "@/components/NavBarItem.vue";

defineProps({
  menu: {
    type: Array,
    default: () => [],
  },
  selectedItem: {
    type: String,
    default: "",
  },
});

const emit = defineEmits(["menu-click"]);

const menuClickDropdown = (event, item) => {
  emit("menu-click", event, item);
};
</script>
