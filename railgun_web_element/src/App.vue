<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useI18n } from 'vue-i18n'
import { useDialogStore } from '@/stores/DialogStore'
import { useAppStore, SignInStateType } from '@/stores/AppStore'
import DialogBox from '@/DialogBox.vue'
import AppBoxTiny from '@/layouts/AppBoxTiny.vue'

// using
const { t } = useI18n({})
const dialogStore = useDialogStore()
const appStore = useAppStore()

// states
const dialogBox = ref()

// on mounting
onMounted(() => {
	dialogStore.box = dialogBox
})

// loads this app
appStore.setup()

const lite = localStorage.getItem('lite') ? true : false
document.documentElement.setAttribute('class', lite ? '' : 'dark')
</script>


<template>
	<!-- support UI for dialogStore -->
	<DialogBox ref="dialogBox">
		<!-- for loading... -->
		<AppBoxTiny v-if="appStore.state === SignInStateType.NowLoading" :title="t('waitBox.message')">
		</AppBoxTiny>

		<!-- loaded -->
		<router-view v-else></router-view>
	</DialogBox>
</template>


<style>
@import "@/assets/common.css";

html,
body,
#app {
	margin: 0;
	padding: 0;
	height: 100%;
}
</style>
