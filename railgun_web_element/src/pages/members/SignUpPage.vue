<script setup lang="ts">
import { ref } from 'vue'
import { useI18n } from 'vue-i18n'
import { useRouter } from 'vue-router'
import {
	Edit as EmailIcon,
	Lock as PasswordIcon,
} from '@element-plus/icons-vue'
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
		<el-form id="form" label-width="8rem">
			<el-form-item :label="t('email')">
				<!-- email -->
				<el-input id="email" type="email" :placeholder="t('email')" required :prefix-icon="EmailIcon"
					v-model="email" />
			</el-form-item>

			<el-form-item :label="t('password')">
				<!-- password -->
				<el-input id="password" type="password" :placeholder="t('password')" required minlength="4"
					maxlength="20" :prefix-icon="PasswordIcon" show-password v-model="password" />
			</el-form-item>

			<el-form-item :label="t('confirmPassword')">
				<!-- confirm password -->
				<el-input id="confirmPassword" type="password" :placeholder="t('confirmPassword')" required
					minlength="4" maxlength="20" :prefix-icon="PasswordIcon" show-password v-model="confirmPassword" />
			</el-form-item>

			<el-form-item>
				<!-- ok -->
				<el-button type="primary" size="large" @click.prevent="onSubmit">{{ t('ok') }}</el-button>
			</el-form-item>
		</el-form>
	</AppBox>
</template>


<style scoped>
</style>
