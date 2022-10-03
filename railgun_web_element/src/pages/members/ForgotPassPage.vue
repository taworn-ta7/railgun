<script setup lang="ts">
import { ref } from 'vue'
import { useI18n } from 'vue-i18n'
import { useRouter } from 'vue-router'
import {
	Edit as EmailIcon,
} from '@element-plus/icons-vue'
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
		<el-form id="form">
			<el-form-item :label="t('email')">
				<!-- email -->
				<el-input id="email" type="email" :placeholder="t('email')" required :prefix-icon="EmailIcon"
					v-model="email" />
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
