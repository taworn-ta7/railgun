<script setup lang="ts">
import { useI18n } from 'vue-i18n'

const props = defineProps({
	'title': String,  // text to display title
})

// using
const { t } = useI18n({})
</script>


<template>
	<header>
		<div id="app-bar">
			<div id="title">{{ props.title ?? t('app') }}</div>
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
	padding: 0.75rem 1rem 0.85rem;
}

#title {
	margin: 0 0 0 0.5rem;
	font-size: 170%;
	color: var(--c-page-color);
}
</style>
