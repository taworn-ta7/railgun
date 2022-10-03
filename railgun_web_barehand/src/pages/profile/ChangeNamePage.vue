<script setup lang="ts">
import { ref, watch } from 'vue'
import { useI18n } from 'vue-i18n'
import { useRouter } from 'vue-router'
import AppShare from '@/helpers/AppShare'
import { useDialogStore } from '@/stores/DialogStore'
import { useAppStore } from '@/stores/AppStore'

// using
const { t } = useI18n({
	messages: {
		en: {
			title: "Change Name",
			name: "Current Name",
			ok: "Change Name",
		},
		th: {
			title: "เปลี่ยนชื่อ",
			name: "ชื่อปัจจุบัน",
			ok: "เปลี่ยนชื่อ",
		},
	},
})
const router = useRouter()
const dialogStore = useDialogStore()
const appStore = useAppStore()

// states
const name = ref(appStore.member?.name)

// changes
watch(appStore, (current, old) => {
	name.value = appStore.member.name
})

async function onSubmit() {
	const result = await dialogStore.waitBox(async () =>
		await AppShare.client.call(`profile/name`, {
			method: 'PUT',
			headers: AppShare.client.defaultHeaders(),
			data: {
				member: {
					name: name.value,
				},
			},
		})
	)
	if (!dialogStore.handleRestError(result)) {
		appStore.member.name = name
		router.push({ name: 'home' })
	}
}
</script>


<template>
	<AuthenRequired>
		<AppBox :title="t('title')">
			<form id="form" @submit.prevent="onSubmit">
				<label for="name">{{ t('name') }}</label><br />
				<input id="name" :placeholder="t('name')" required v-model="name" /><br />
				<br />

				<button type="submit">{{ t('ok') }}</button>
			</form>
		</AppBox>
	</AuthenRequired>
</template>


<style scoped>
</style>
