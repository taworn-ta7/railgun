<script setup lang="ts">
import { ref } from 'vue'
import { useI18n } from 'vue-i18n'
import { useThemeStore } from '@/stores/ThemeStore'
import { useAppStore } from '@/stores/AppStore'

// using
const { t } = useI18n({
	messages: {
		en: {
			title: "Settings",
			color: "Change Color Theme",
			dark: "Dark",
			lite: "Lite",
		},
		th: {
			title: "การตั้งค่า",
			color: "เปลี่ยนธีมสี",
			dark: "มืด",
			lite: "สว่าง",
		},
	},
})
const themeStore = useThemeStore()
const appStore = useAppStore()

// state
const mode = ref(localStorage.getItem('lite') ? true : false)

function onSwitch(e: Event) {
	console.log(`mode: ${mode.value}`)
	document.documentElement.setAttribute('class', mode.value ? '' : 'dark')
	let index: number
	if (mode.value) {
		localStorage.setItem('lite', '1')
		index = 1
	}
	else {
		localStorage.removeItem('lite')
		index = 0
	}

	themeStore.change(index)
	appStore.saveTheme(index)
}
</script>


<template>
	<AuthenRequired>
		<AppBox :title="t('title')" :top-level="true">
			<el-form id="form">
				<el-form-item>
					<h2><strong>{{ t('color') }}</strong></h2>
				</el-form-item>

				<el-form-item>
					<!-- switch dark/lite -->
					<el-switch id="switch" :inactive-text="t('dark')" :active-text="t('lite')" size="large"
						v-model="mode" @click.prevent="(e: Event) => onSwitch(e)" />
				</el-form-item>
			</el-form>
		</AppBox>
	</AuthenRequired>
</template>


<style scoped>
</style>
