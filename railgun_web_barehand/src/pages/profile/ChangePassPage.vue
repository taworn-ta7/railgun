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
			title: "Change Password",
			currentPassword: "Current Password",
			newPassword: "New Password",
			confirmPassword: "Confirm Password",
			ok: "Change Password",
			confirm: "You have to sign-out, then sign-in again with new password!",
		},
		th: {
			title: "เปลี่ยนรหัสผ่าน",
			currentPassword: "รหัสผ่านปัจจุบัน",
			newPassword: "รหัสผ่านใหม่",
			confirmPassword: "ยืนยันรหัสผ่านใหม่",
			ok: "เปลี่ยนรหัสผ่าน",
			confirm: "คุณต้องออกจากระบบ แล้วเข้าระบบใหม่ ด้วยรหัสผ่านใหม่!",
		},
	},
})
const router = useRouter()
const dialogStore = useDialogStore()

// states
const currentPassword = ref("")
const newPassword = ref("")
const confirmPassword = ref("")

async function onSubmit() {
	if (newPassword.value !== confirmPassword.value) {
		dialogStore.warningBox(t('validator.isSamePasswords'))
		return
	}

	const result = await dialogStore.waitBox(async () =>
		await AppShare.client.call(`profile/password`, {
			method: 'PUT',
			headers: AppShare.client.defaultHeaders(),
			data: {
				member: {
					currentPassword: currentPassword.value,
					newPassword: newPassword.value,
					confirmPassword: confirmPassword.value,
				},
			},
		})
	)
	if (!dialogStore.handleRestError(result)) {
		dialogStore.infoBox(t('confirm'))
		router.push({ name: 'signout' })
	}
}
</script>


<template>
	<AuthenRequired>
		<AppBox :title="t('title')">
			<form id="form" @submit.prevent="onSubmit">
				<!-- current password -->
				<label for="currentPassword">{{ t('currentPassword') }}</label><br />
				<input id="currentPassword" type="password" :placeholder="t('currentPassword')" required minlength="4"
					maxlength="20" v-model="currentPassword" /><br />
				<br />

				<!-- new password -->
				<label for="newPassword">{{ t('newPassword') }}</label><br />
				<input id="newPassword" type="password" :placeholder="t('newPassword')" required minlength="4"
					maxlength="20" v-model="newPassword" /><br />
				<br />

				<!-- confirm password -->
				<label for="confirmPassword">{{ t('confirmPassword') }}</label><br />
				<input id="confirmPassword" type="password" :placeholder="t('confirmPassword')" required minlength="4"
					maxlength="20" v-model="confirmPassword" /><br />
				<br />

				<button type="submit">{{ t('ok') }}</button>
			</form>
		</AppBox>
	</AuthenRequired>
</template>


<style scoped>
</style>
