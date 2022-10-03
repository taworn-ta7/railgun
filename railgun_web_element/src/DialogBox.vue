<script setup lang="ts">
import { ref } from 'vue'
import { useI18n } from 'vue-i18n'
import { ElNotification } from 'element-plus'
import HttpError from '@/helpers/HttpError'

defineExpose({
	/**
	 * Opens information box.
	 */
	infoBox(message: string): void {
		infoMessage.value = message
		infoOpen()
	},

	/**
	 * Opens warning box.
	 */
	warningBox(message: string): void {
		warningMessage.value = message
		warningOpen()
	},

	/**
	 * Opens error box.
	 */
	errorBox(message: string): void {
		errorMessage.value = message
		errorOpen()
	},

	// ----------------------------------------------------------------------

	/**
	 * Handles REST error.
	 */
	errorRest(result: any): boolean {
		if (!result || !result.json) {
			const message = t('serviceRunner.message')
			errorMessage.value = message
			errorOpen()
		}
		else {
			const message = HttpError.get(result.json, t, locale.value as string)
			warningMessage.value = message
			warningOpen()
		}
		return true
	},

	// ----------------------------------------------------------------------

	/**
	 * Open/close wait box.
	 */
	wait(open: boolean): void {
		loading.value = open
	},

	/**
	 * Change current locale.
	 */
	changeLocale(newLocale: string): void {
		locale.value = newLocale
	},
})

// using
const { t, locale } = useI18n({})

// states
const loading = ref(false)
const infoMessage = ref("")
const warningMessage = ref("")
const errorMessage = ref("")

const infoOpen = () => {
	ElNotification({
		title: t('messageBox.info'),
		message: infoMessage.value,
		type: 'info',
		// BUG: because close button is miss layout, so we hidden for now
		showClose: false,
	})
}

const warningOpen = () => {
	ElNotification({
		title: t('messageBox.warning'),
		message: warningMessage.value,
		type: 'warning',
		// BUG: because close button is miss layout, so we hidden for now
		showClose: false,
	})
}

const errorOpen = () => {
	ElNotification({
		title: t('messageBox.error'),
		message: errorMessage.value,
		type: 'error',
		// BUG: because close button is miss layout, so we hidden for now
		showClose: false,
	})
}
</script>


<template>
	<div v-loading="loading" :element-loading-text="t('waitBox.message')"
		element-loading-background="rgba(0x88, 0x88, 0x88, 0.8)" style="height: 100%">
		<slot></slot>
	</div>
</template>


<style scoped>
</style>
