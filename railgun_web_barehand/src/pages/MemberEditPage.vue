<script setup lang="ts">
import { ref } from 'vue'
import { useI18n } from 'vue-i18n'
import { useRouter, useRoute } from 'vue-router'
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
			<div v-if="item">
				<img :width="128" :height="128" :src="`${Constants.baseUrl}/members/${item.email}/icon`"
					:alt="item.email" :title="item.name" />
				<br />

				<h2><strong>{{ item.email }}</strong></h2>
				<br />

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
				<br />

				<form id="form" @submit.prevent="onSubmit">
					<input id="disable" type="checkbox" style="margin-right: 0.5rem" v-model="disable" />
					<label for="disable">{{ t('disable') }}</label><br />
					<br />

					<button type="submit">{{ t('ok') }}</button>
				</form>
			</div>
		</AppBox>
	</AuthenRequired>
</template>


<style scoped>
table {
	border-collapse: collapse;
	border: 1px solid #999999;
}

table th {
	border: 1px solid #999999;
	padding: 0.75em 1.0em;
	font-weight: bold;
}

table td {
	border: 1px solid #999999;
	padding: 0.75em 1.0em;
}
</style>
