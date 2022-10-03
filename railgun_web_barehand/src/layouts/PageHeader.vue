<script setup lang="ts">
import { useI18n } from 'vue-i18n'
import { useLocaleStore } from '@/stores/LocaleStore'
import { useAppStore, SignInStateType } from '@/stores/AppStore'

const props = defineProps({
	'title': String,  // text to display title
})

// using
const { t } = useI18n({})
const localeStore = useLocaleStore()
const appStore = useAppStore()

function onClick(e: Event, locale: string) {
	localeStore.change(locale)
	if (appStore.state === SignInStateType.AlreadySignIn) {
		appStore.saveLocale(locale)
	}
}
</script>


<template>
	<header>
		<div id="app-bar">
			<div id="title">{{ props.title ?? t('app') }}</div>

			<button class="icon" :title="t('switchLocale.en')"
				@click.prevent="(e: Event) => onClick(e, 'en')">EN</button>
			<button class="icon" :title="t('switchLocale.th')"
				@click.prevent="(e: Event) => onClick(e, 'th')">TH</button>
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
</style>
