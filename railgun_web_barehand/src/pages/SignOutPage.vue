<script setup lang="ts">
import { useRouter } from 'vue-router'
import { useAppStore } from '@/stores/AppStore'

// using
const router = useRouter()
const appStore = useAppStore()

// signs-out from app
appStore.signOut().then(() => router.push({ path: '/' }))
</script>


<template>
</template>


<style scoped>
</style>
