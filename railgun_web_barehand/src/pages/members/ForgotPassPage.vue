<script setup lang="ts">
import { ref } from 'vue'
import { useI18n } from 'vue-i18n'
import { useRouter } from 'vue-router'
import AppShare from '@/helpers/AppShare'
import { useDialogStore } from '@/stores/DialogStore'

// using
const { t } = useI18n({
	messages: {
		en: {
			title: "Forgot Password",
			email: "Email",
			ok: "Send Email",
			check: "Please check email for your instruction!",
		},
		th: {
			title: "ลืมรหัสผ่าน",
			email: "อีเมล",
			ok: "ส่งอีเมล",
			check: "โปรดเช็คอีเมลสำหรับคำแนะนำต่อไป!",
		},
	},
})
const router = useRouter()
const dialogStore = useDialogStore()

// states
const email = ref(localStorage.getItem('email') || "")

async function onSubmit() {
	const result = await dialogStore.waitBox(async () =>
		await AppShare.client.call(`members/request-reset`, {
			method: 'POST',
			headers: AppShare.client.defaultHeaders(),
			data: {
				member: {
					email: email.value,
				},
			},
		})
	)
	if (!dialogStore.handleRestError(result)) {
		dialogStore.infoBox(t('check'))
		router.go(-1)
	}
}
</script>


<template>
	<AppBox :title="t('title')">
		<form id="form" @submit.prevent="onSubmit">
			<!-- email -->
			<label for="email">{{ t('email') }}</label><br />
			<input id="email" type="email" :placeholder="t('email')" required v-model="email" /><br />
			<br />

			<button type="submit">{{ t('ok') }}</button>
		</form>
	</AppBox>
</template>


<style scoped>
</style>
