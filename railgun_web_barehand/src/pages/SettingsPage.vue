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
			locale: "Change Locale",
			color: "Change Color Theme",
			sidebar: "Change Side Bar",
			minimize: "Minimize Side Bar",
		},
		th: {
			title: "การตั้งค่า",
			locale: "เปลี่ยนภาษา",
			color: "เปลี่ยนธีมสี",
			sidebar: "เปลี่ยน Side Bar",
			minimize: "แสดง Side Bar ขนาดย่อ",
		},
	},
})
const themeStore = useThemeStore()
const appStore = useAppStore()

// states
const groups = ref([
	[0, 1, 2, 3, 4],
])
const colors = ref(themeStore.themes)

function onClick(e: Event, index: number) {
	themeStore.change(index)
	appStore.saveTheme(index)
}
</script>


<template>
	<AuthenRequired>
		<AppBox :title="t('title')">
			<h2><strong>{{ t('color') }}</strong></h2>
			<br />

			<div v-for="group in groups">
				<button v-for="index in group" :style="{ margin: '0.5rem 0.5rem', background: colors[index] }"
					@click.prevent="(e: Event) => onClick(e, index)">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br />
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br />
				</button>
			</div>

			<br />
		</AppBox>
	</AuthenRequired>
</template>


<style scoped>
</style>
