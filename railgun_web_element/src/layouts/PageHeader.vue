<script setup lang="ts">
import { useI18n } from 'vue-i18n'
import { useRouter } from 'vue-router'
import {
	IceTea as AppIcon,
	Back as BackIcon,
	PictureRounded as ChangeIconIcon,
	EditPen as ChangeNameIcon,
	Lock as ChangePassIcon,
	SwitchButton as QuitIcon,
} from '@element-plus/icons-vue'
import { useLocaleStore } from '@/stores/LocaleStore'
import { useAppStore, SignInStateType } from '@/stores/AppStore'

const props = defineProps({
	'title': String,      // text to display title
	'topLevel': Boolean,  // display app icon instead back icon
})

// using
const { t } = useI18n({
	messages: {
		en: {
			changeIcon: "Change Icon",
			changeName: "Change Name",
			changePass: "Change Password",
			quit: "Sign-out",
		},
		th: {
			changeIcon: "เปลี่อน Icon",
			changeName: "เปลี่ยนชื่อ",
			changePass: "เปลี่ยนรหัสผ่าน",
			quit: "ออกจากระบบ",
		},
	},
})
const router = useRouter()
const localeStore = useLocaleStore()
const appStore = useAppStore()

function onLocaleClick(e: Event, locale: string) {
	localeStore.change(locale)
	if (appStore.state === SignInStateType.AlreadySignIn) {
		appStore.saveLocale(locale)
	}
}

function onCommand(command: string | number | object) {
	switch (command) {
		case 'changeIcon':
			router.push({ name: 'changeIcon' })
			break
		case 'changeName':
			router.push({ name: 'changeName' })
			break
		case 'changePass':
			router.push({ name: 'changePass' })
			break
		case 'quit':
			router.push({ name: 'signout' })
			break
	}
}
</script>


<template>
	<header>
		<div id="app-bar">
			<div style="margin: auto 0.5rem">
				<el-button v-if="props.topLevel" circle size="large" :icon="AppIcon"
					@click.prevent="router.push('/')" />
				<el-button v-else circle size="large" :icon="BackIcon" @click.prevent="router.go(-1)" />
			</div>

			<div id="title">{{ props.title ?? t('app') }}</div>

			<button class="icon" :title="t('switchLocale.en')"
				@click.prevent="(e: Event) => onLocaleClick(e, 'en')">EN</button>
			<button class="icon" :title="t('switchLocale.th')"
				@click.prevent="(e: Event) => onLocaleClick(e, 'th')">TH</button>

			<el-dropdown v-if="props.topLevel" @command="onCommand">
				<el-avatar v-if="appStore.member" shape="square" :src="appStore?.icon" style="margin: 0 0 0 0.5rem" />
				<template #dropdown>
					<el-dropdown-menu>
						<el-dropdown-item :icon="ChangeIconIcon" command="changeIcon">
							<span class="profile-menu">{{ t('changeIcon') }}</span>
						</el-dropdown-item>

						<el-dropdown-item :icon="ChangeNameIcon" command="changeName">
							<span class="profile-menu">{{ t('changeName') }}</span>
						</el-dropdown-item>

						<el-dropdown-item :icon="ChangePassIcon" command="changePass">
							<span class="profile-menu">{{ t('changePass') }}</span>
						</el-dropdown-item>

						<el-dropdown-item :icon="QuitIcon" command="quit">
							<span class="profile-menu">{{ t('quit') }}</span>
						</el-dropdown-item>
					</el-dropdown-menu>
				</template>
			</el-dropdown>
		</div>
	</header>
</template>


<style scoped>
header {
	position: relative;
	display: block;
	margin: 0;
	padding: 0;
	background: var(--c-page-header);
}

#app-bar {
	display: flex;
	padding: 0.75rem 1rem 0.85rem;
}

#title {
	flex: 1 0;
	margin: 0 0 0 0.5rem;
	font-size: 170%;
	color: var(--c-page-color);
}

.icon {
	flex: 0 0;
	margin: 0;
	padding: 0.5rem;
}

.profile-menu {
	margin: 0.5rem;
}
</style>
