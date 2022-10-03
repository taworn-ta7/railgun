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
		<AppBox :title="t('title')" :top-level="true">
			<el-form id="form">
				<el-form-item>
					<!-- icon -->
					<img :width="128" :height="128" :src="appStore.icon" :alt="appStore.member.email"
						:title="appStore.member.name" />
				</el-form-item>

				<el-form-item>
					<!-- email -->
					<h2><strong>{{ appStore.member.email }}</strong></h2>
				</el-form-item>

				<el-form-item>
					<!-- summary -->
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
