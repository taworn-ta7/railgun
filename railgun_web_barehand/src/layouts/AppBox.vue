<script setup lang="ts">
import { ref } from 'vue'
import { useI18n } from 'vue-i18n'
import { useRouter } from 'vue-router'
import { useAppStore, SignInStateType } from '@/stores/AppStore'
import PageHeader from '@/layouts/PageHeader.vue'
import PageFooter from '@/layouts/PageFooter.vue'

const props = defineProps({
	'title': String,  // text to display title
	'fit': Boolean,   // fit or has margin around page
})

// using
const { t } = useI18n({
	messages: {
		en: {
			home: "Home",
			members: "Members",
			settings: "Settings",
			changeIcon: "Change Icon",
			changeName: "Change Name",
			changePass: "Change Password",
			quit: "Sign-out",
		},
		th: {
			home: "เริ่มต้น",
			members: "สมาชิก",
			settings: "การตั้งค่า",
			changeIcon: "เปลี่อน Icon",
			changeName: "เปลี่ยนชื่อ",
			changePass: "เปลี่ยนรหัสผ่าน",
			quit: "ออกจากระบบ",
		},
	},
})
const router = useRouter()
const appStore = useAppStore()

// states
const fit = ref(props.fit ? true : false)
const items = ref([
	{ key: 'home' },
	{ key: 'members' },
	{ key: 'settings' },
	{ key: 'changeIcon' },
	{ key: 'changeName' },
	{ key: 'changePass' },
	{ key: 'quit' },
])

function onClick(e: Event, key: string) {
	switch (key) {
		case 'home':
			router.push({ name: 'home' })
			break
		case 'members':
			router.push({ name: 'members' })
			break
		case 'settings':
			router.push({ name: 'settings' })
			break
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
	<div id="app-inner">
		<PageHeader :title="props.title" />

		<div id="app-body">
			<aside v-if="appStore.state === SignInStateType.AlreadySignIn" id="app-side">
				<div style="margin: 1rem">
					<img :width="80" :height="80" :src="appStore.icon" :alt="appStore.member?.email"
						:title="appStore.member?.name" /><br />
					<br />

					<div v-for="item in items">
						<a href="#" @click.prevent="(e: Event) => onClick(e, item.key)">{{ t(item.key) }}</a>
					</div>
				</div>
			</aside>

			<main id="app-page" :style="{ margin: fit ? '0' : '2rem' }">
				<slot></slot>
			</main>
		</div>

		<PageFooter />
	</div>
</template>


<style scoped>
#app-inner {
	display: flex;
	flex-flow: column nowrap;
	align-items: stretch;
	height: 100%;
	min-height: 100%;
}

#app-body {
	display: flex;
	flex: 1 0;
	flex-wrap: wrap;
	align-items: stretch;
}

#app-side {
	flex: 0 0 200px;
	background-color: var(--c-secondary);
}

#app-side a {
	display: block;
	padding: 0.5rem;
	text-decoration: solid;
	color: var(--c-page-color-1);
}

#app-side a:hover {
	background: #eee;
	color: #000;
}

#app-page {
	flex: 1 0;
}
</style>
