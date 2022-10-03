<script setup lang="ts">
import { ref } from 'vue'
import { useI18n } from 'vue-i18n'
import { useRouter } from 'vue-router'
import AppShare from '@/helpers/AppShare'
import { useDialogStore } from '@/stores/DialogStore'

// using
const { t, locale } = useI18n({
	messages: {
		en: {
			title: "Sign Up",
			email: "Email",
			password: "Password",
			confirmPassword: "Confirm Password",
			ok: "Register",
			confirm: "Please confirm the sign-up by email!",
		},
		th: {
			title: "สมัครสมาชิก",
			email: "อีเมล",
			password: "รหัสผ่าน",
			confirmPassword: "ยืนยันรหัสผ่าน",
			ok: "ลงทะเบียน",
			confirm: "โปรดยืนยันการสมัครสมาชิกทางอีเมล!",
		},
	},
})
const router = useRouter()
const dialogStore = useDialogStore()

// states
const email = ref("")
const password = ref("")
const confirmPassword = ref("")

async function onSubmit() {
	if (password.value !== confirmPassword.value) {
		dialogStore.warningBox(t('validator.isSamePasswords'))
		return
	}

	const result = await dialogStore.waitBox(async () =>
		await AppShare.client.call(`members/signup`, {
			method: 'POST',
			headers: AppShare.client.defaultHeaders(),
			data: {
				member: {
					email: email.value,
					password: password.value,
					confirmPassword: confirmPassword.value,
					locale: locale.value,
				},
			},
		})
	)
	if (!dialogStore.handleRestError(result)) {
		dialogStore.infoBox(t('confirm'))
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

			<!-- password -->
			<label for="password">{{ t('password') }}</label><br />
			<input id="password" type="password" :placeholder="t('password')" required minlength="4" maxlength="20"
				v-model="password" /><br />
			<br />

			<!-- confirm password -->
			<label for="confirmPassword">{{ t('confirmPassword') }}</label><br />
			<input id="confirmPassword" type="password" :placeholder="t('confirmPassword')" required minlength="4"
				maxlength="20" v-model="confirmPassword" /><br />
			<br />

			<button type="submit">{{ t('ok') }}</button>
		</form>
	</AppBox>
</template>


<style scoped>
</style>
