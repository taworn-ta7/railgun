<script setup lang="ts">
import { ref } from 'vue'
import { useI18n } from 'vue-i18n'
import { useRouter } from 'vue-router'
import { useAppStore, SignInStateType } from '@/stores/AppStore'
import PageHeader from '@/layouts/PageHeader.vue'
import PageFooter from '@/layouts/PageFooter.vue'

const props = defineProps({
	'title': String,      // text to display title
	'fit': Boolean,       // fit or has margin around page
	'topLevel': Boolean,  // display app icon instead back icon
})

// using
const { t } = useI18n({
	messages: {
		en: {
			hello: "Hello",
			home: "Home",
			members: "Members",
			settings: "Settings",
			quit: "Sign-out",
		},
		th: {
			hello: "สวัสดี",
			home: "เริ่มต้น",
			members: "สมาชิก",
			settings: "การตั้งค่า",
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
		case 'quit':
			router.push({ name: 'signout' })
			break
	}
}
</script>


<template>
	<div id="app-inner">
		<PageHeader :title="props.title" :top-level="props.topLevel" />

		<div id="app-body">
			<aside v-if="appStore.state === SignInStateType.AlreadySignIn && props.topLevel" id="app-side">
				<div style="margin: 1rem">
					<div style="margin: 0 0 1rem">
						<img :width="80" :height="80" :src="appStore.icon" :alt="appStore.member?.email"
							:title="appStore.member?.name" style="" />

						<h2 style="color: var(--c-page-color-1)"><strong>{{ t('hello') }}</strong></h2>
						<span style="color: var(--c-page-color-1)">{{ appStore.member?.name }}</span>
						<hr style="margin: 1.5rem 0 0" />
					</div>

					<div v-for=" item in items">
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
