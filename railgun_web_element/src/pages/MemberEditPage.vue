<script setup lang="ts">
import { ref } from 'vue'
import { useI18n } from 'vue-i18n'
import { useRouter, useRoute } from 'vue-router'
import {
	SuccessFilled as OkIcon,
} from '@element-plus/icons-vue'
import AppShare from '@/helpers/AppShare'
import { useDialogStore } from '@/stores/DialogStore'
import { useAppStore } from '@/stores/AppStore'
import Constants from '@/Constants'

// using
const { t } = useI18n({
	messages: {
		en: {
			title: (ctx: any) => `Edit ${ctx.named('name')}`,
			role: "Role",
			locale: "Locale",
			name: "Name",
			disabled: "Disabled",
			resigned: "Resigned",
			signup: "Sign Up",
			disable: "Disable",
			ok: "Save",
		},
		th: {
			title: (ctx: any) => `แก้ไข ${ctx.named('name')}`,
			role: "ประเภท",
			locale: "ภาษา",
			name: "ชื่อ",
			disabled: "ถูกปิดการทำงาน",
			resigned: "ลาออกจากระบบ",
			signup: "สมัครสมาชิก",
			disable: "ปิดการทำงาน",
			ok: "บันทึก",
		},
	},
})
const router = useRouter()
const route = useRoute()
const dialogStore = useDialogStore()
const appStore = useAppStore()

// states
const email = ref(route.params.email)
const item = ref()
const disable = ref()

async function onSubmit(e: Event) {
	const result = await dialogStore.waitBox(async () =>
		await AppShare.client.call(`admin/members/disable/${email.value}`, {
			method: 'PUT',
			headers: AppShare.client.defaultHeaders(),
			data: {
				member: {
					disabled: disable.value ? true : false,
				},
			},
		})
	)
	if (!dialogStore.handleRestError(result)) {
		router.push({ name: 'members' })
	}
}

async function refresh() {
	const result = await dialogStore.waitBox(async () =>
		await AppShare.client.call(`members/${email.value}`, {
			method: 'GET',
			headers: AppShare.client.defaultHeaders(),
		})
	)
	if (!dialogStore.handleRestError(result)) {
		item.value = result?.json.member
		disable.value = item.value.disabled ? true : false
	}
}
refresh()
</script>


<template>
	<AuthenRequired>
		<AppBox :title="t('title', { name: email })">
			<el-form v-if="item" id="form">
				<el-form-item>
					<!-- icon -->
					<img :width="128" :height="128" :src="`${Constants.baseUrl}/members/${item.email}/icon`"
						:alt="item.email" :title="item.name" />
				</el-form-item>

				<el-form-item>
					<!-- email -->
					<h2><strong>{{ item.email }}</strong></h2>
				</el-form-item>

				<el-form-item>
					<!-- summary -->
					<table>
						<thead>
							<tr>
								<th>{{ t('common.name') }}</th>
								<th>{{ t('common.value') }}</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td><span>{{ t('role') }}</span></td>
								<td><span>{{ item.role }}</span></td>
							</tr>
							<tr>
								<td><span>{{ t('locale') }}</span></td>
								<td><span>{{ item.locale }}</span></td>
							</tr>
							<tr>
								<td><span>{{ t('name') }}</span></td>
								<td><span>{{ item.name }}</span></td>
							</tr>
							<tr>
								<td><span>{{ t('disabled') }}</span></td>
								<td><span>{{ item.disabled }}</span></td>
							</tr>
							<tr>
								<td><span>{{ t('resigned') }}</span></td>
								<td><span>{{ item.resigned }}</span></td>
							</tr>
							<tr>
								<td><span>{{ t('signup') }}</span></td>
								<td><span>{{ item.created }}</span></td>
							</tr>
						</tbody>
					</table>
				</el-form-item>

				<el-form-item>
					<!-- disable -->
					<el-switch id="disable" :active-text="t('disable')" size="large" v-model="disable" />
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
@import "@/assets/base.css";

table {
	border-collapse: collapse;
	border: 2px solid var(--c-grey);
}

table th {
	border: 2px solid var(--c-grey);
	padding: 0.75em 1.0em;
	font-weight: bold;
}

table td {
	border: 2px solid var(--c-grey);
	padding: 0.75em 1.0em;
}
</style>
