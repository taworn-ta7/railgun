<script setup lang="ts">
import { useAppStore, SignInStateType } from '@/stores/AppStore'
import BeginPage from '@/pages/BeginPage.vue'
import DashboardPage from '@/pages/DashboardPage.vue'

// using
const appStore = useAppStore()
</script>


<template>
	<DashboardPage v-if="appStore.state === SignInStateType.AlreadySignIn" />
	<BeginPage v-else />
</template>


<style scoped>
</style>
