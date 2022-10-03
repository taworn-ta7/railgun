<script setup lang="ts">
import { ref } from 'vue'
import { useI18n } from 'vue-i18n'
import { useRouter } from 'vue-router'
import AppShare from '@/helpers/AppShare'
import { useDialogStore } from '@/stores/DialogStore'
import { useAppStore } from '@/stores/AppStore'

// using
const { t } = useI18n({
	messages: {
		en: {
		},
		th: {
		},
	},
})
const router = useRouter()
const dialogStore = useDialogStore()
const appStore = useAppStore()

// state
const loaded = ref(false)

async function setup(): Promise<void> {
	const result = await dialogStore.waitBox(async () =>
		await AppShare.client.call(`authenx/google${window.location.search}`, {
			method: 'GET',
			headers: AppShare.client.defaultHeaders(),
		})
	)
	if (!dialogStore.handleRestError(result)) {
		const member = result?.json.member;
		const token = result?.json.token;
		await appStore.signInWithExternalToken(member, token);
	}
	router.push({ path: '/' })
}
setup()
</script>


<template>
	<AppBoxTiny :title="t('wait')">
		<a v-if="loaded" href="/">{{ t('authenExternal.click') }}</a>
	</AppBoxTiny>
</template>


<style scoped>
</style>
