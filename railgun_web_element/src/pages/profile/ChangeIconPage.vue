<script setup lang="ts">
import { ref, watch } from 'vue'
import { useI18n } from 'vue-i18n'
import { useRouter } from 'vue-router'
import {
	SuccessFilled as OkIcon,
} from '@element-plus/icons-vue'
import AppShare from '@/helpers/AppShare'
import { useDialogStore } from '@/stores/DialogStore'
import { useAppStore } from '@/stores/AppStore'

// using
const { t } = useI18n({
	messages: {
		en: {
			title: "Change Icon",
			icon: "Current Icon",
			ok: "Change Icon",
		},
		th: {
			title: "เปลี่ยนรูป Icon",
			icon: "Icon ปัจจุบัน",
			ok: "เปลี่ยนรูป Icon",
		},
	},
})
const router = useRouter()
const dialogStore = useDialogStore()
const appStore = useAppStore()

// states
const icon = ref(appStore.icon)
const type = ref('')

// changes
watch(appStore, (current, old) => {
	icon.value = appStore.icon
})

let file = <any>null

function onUpload(e: any) {
	file = e.target.files[0]
	icon.value = URL.createObjectURL(file)
	type.value = 'upload'
}

function onReset(e: Event) {
	icon.value = '/img/default-profile-icon.png'
	type.value = 'reset'
}

function onRevert(e: Event) {
	icon.value = appStore.icon
	type.value = 'revert'
}

async function onSubmit(e: Event) {
	if (type.value === 'upload') {
		const formData = new FormData()
		formData.append('image', file, file.name)

		const result = await dialogStore.waitBox(async () =>
			await AppShare.client.call(`profile/icon`, {
				method: 'POST',
				headers: AppShare.client.formDataHeaders(),
				data: formData,
			})
		)
		if (!dialogStore.handleRestError(result)) {
			appStore.icon = icon.value
		}
	}
	else if (type.value === 'reset') {
		const result = await dialogStore.waitBox(async () =>
			await AppShare.client.call(`profile/icon`, {
				method: 'DELETE',
				headers: AppShare.client.defaultHeaders(),
			})
		)
		if (!dialogStore.handleRestError(result)) {
			appStore.icon = icon.value
		}
	}

	router.push({ name: 'home' })
}
</script>


<template>
	<AuthenRequired>
		<AppBox :title="t('title')">
			<el-form id="form" enctype="multipart/form-data">
				<el-form-item>
					<!-- icon -->
					<img :width="128" :height="128" :src="icon" :alt="appStore.member?.email"
						:title="appStore.member?.name" />
				</el-form-item>

				<el-form-item>
					<!-- reset -->
					<el-button @click.prevent="onReset">{{ t('imageChooser.reset') }}</el-button>

					<!-- revert -->
					<el-button @click.prevent="onRevert">{{ t('imageChooser.revert') }}</el-button>

					<!-- upload -->
					<input type="file" accept="image/png, image/jpeg" style="margin: 1rem" @change="onUpload" />
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
