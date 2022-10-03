<script setup lang="ts">
import { useI18n } from 'vue-i18n'
import HttpError from '@/helpers/HttpError'

defineExpose({
	/**
	 * Opens information box.
	 */
	infoBox(message: string): void {
		//infoMessage.value = message
		//infoOpen()
		alert(message)
	},

	/**
	 * Opens warning box.
	 */
	warningBox(message: string): void {
		//warningMessage.value = message
		//warningOpen()
		alert(message)
	},

	/**
	 * Opens error box.
	 */
	errorBox(message: string): void {
		//errorMessage.value = message
		//errorOpen()
		alert(message)
	},

	// ----------------------------------------------------------------------

	/**
	 * Handles REST error.
	 */
	errorRest(result: any): boolean {
		if (!result || !result.json) {
			const message = t('serviceRunner.message')
			//errorMessage.value = message
			//errorOpen()
			alert(message)
		}
		else {
			const message = HttpError.get(result.json, t, locale.value as string)
			//warningMessage.value = message
			//warningOpen()
			alert(message)
		}
		return true
	},

	// ----------------------------------------------------------------------

	/**
	 * Open/close wait box.
	 */
	wait(open: boolean): void {
		// nothings to do, for now
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
</script>


<template>
	<div></div>
</template>


<style scoped>
</style>
