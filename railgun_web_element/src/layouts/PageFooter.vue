<script setup lang="ts">
import { useI18n } from 'vue-i18n'

// using
const { t } = useI18n({
	messages: {
		en: {
			title: "designed by Oo+",
		},
		th: {
			title: "ออกแบบโดย โอ๋",
		},
	},
})
</script>


<template>
	<footer>{{ t('title') }}</footer>
</template>


<style scoped>
footer {
	padding: 0.4rem 0;
	font-size: 90%;
	text-align: center;
	background-color: var(--c-page-footer);
	color: var(--c-white);
	opacity: 0.8;
}
</style>
