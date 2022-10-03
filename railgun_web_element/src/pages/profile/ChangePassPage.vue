<script setup lang="ts">
import { ref } from 'vue'
import { useI18n } from 'vue-i18n'
import { useRouter } from 'vue-router'
import {
	Lock as PasswordIcon,
	SuccessFilled as OkIcon,
} from '@element-plus/icons-vue'
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
			<el-form id="form" label-width="8rem">
				<el-form-item :label="t('currentPassword')">
					<!-- password -->
					<el-input id="currentPassword" type="password" :placeholder="t('currentPassword')" required
						minlength="4" maxlength="20" :prefix-icon="PasswordIcon" show-password
						v-model="currentPassword" />
				</el-form-item>

				<el-form-item :label="t('newPassword')">
					<!-- password -->
					<el-input id="newPassword" type="password" :placeholder="t('newPassword')" required minlength="4"
						maxlength="20" :prefix-icon="PasswordIcon" show-password v-model="newPassword" />
				</el-form-item>

				<el-form-item :label="t('confirmPassword')">
					<!-- confirm password -->
					<el-input id="confirmPassword" type="password" :placeholder="t('confirmPassword')" required
						minlength="4" maxlength="20" :prefix-icon="PasswordIcon" show-password
						v-model="confirmPassword" />
				</el-form-item>

				<el-form-item>
					<!-- ok -->
					<el-button type="primary" size="large" :icon="OkIcon" @click.prevent="onSubmit">{{ t('ok') }}
					</el-button>
				</el-form-item>
			</el-form>
		</AppBox>
	</AuthenRequired>
</template>


<style scoped>
</style>
