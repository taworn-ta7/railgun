<script setup lang="ts">
import { useI18n } from 'vue-i18n'
import { useAppStore } from '@/stores/AppStore'

// using
const { t } = useI18n({
	messages: {
		en: {
			title: "Dashboard",
			role: "Role",
			locale: "Locale",
			name: "Name",
			signup: "Sign Up",
		},
		th: {
			title: "กระดานของคุณ",
			role: "ประเภท",
			locale: "ภาษา",
			name: "ชื่อ",
			signup: "สมัครสมาชิก",
		},
	},
})
const appStore = useAppStore()
</script>


<template>
	<AuthenRequired>
		<AppBox v-if="appStore.member != null" :title="t('title')">
			<img :width="128" :height="128" :src="appStore.icon" :alt="appStore.member.email"
				:title="appStore.member.name" />
			<br />

			<h2><strong>{{ appStore.member.email }}</strong></h2>
			<br />

			<table>
				<thead>
					<tr>
						<th><span>{{ t('common.name') }}</span></th>
						<th><span>{{ t('common.value') }}</span></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td><span>{{ t('role') }}</span></td>
						<td><span>{{ appStore.member.role }}</span></td>
					</tr>
					<tr>
						<td><span>{{ t('locale') }}</span></td>
						<td><span>{{ appStore.member.locale }}</span></td>
					</tr>
					<tr>
						<td><span>{{ t('name') }}</span></td>
						<td><span>{{ appStore.member.name }}</span></td>
					</tr>
					<tr>
						<td><span>{{ t('signup') }}</span></td>
						<td><span>{{ appStore.member.created }}</span></td>
					</tr>
				</tbody>
			</table>
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
