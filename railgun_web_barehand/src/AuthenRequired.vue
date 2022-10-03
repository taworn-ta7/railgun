<script setup lang="ts">
import { useI18n } from 'vue-i18n'
import { useAppStore, SignInStateType } from '@/stores/AppStore'
import AppBoxTiny from '@/layouts/AppBoxTiny.vue'

// using
const { t } = useI18n({
	messages: {
		en: {
			title: "Sign-in Expired",
			link: "Click here to go to begin page"
		},
		th: {
			title: "หมดอายุการเชื่อมต่อ",
			link: "คลิ๊กที่นี่ เพื่อไปหน้าเริ่มต้น",
		},
	},
})
const appStore = useAppStore()
</script>


<template>
	<AppBoxTiny v-if="appStore.state !== SignInStateType.AlreadySignIn" :title="t('title')">
		<a href="/">{{ t('link') }}</a>
	</AppBoxTiny>
	<slot v-else></slot>
</template>


<style scoped>
</style>
