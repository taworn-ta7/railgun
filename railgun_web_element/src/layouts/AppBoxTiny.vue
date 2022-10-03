<script setup lang="ts">
import PageHeaderTiny from '@/layouts/PageHeaderTiny.vue'
import PageFooter from '@/layouts/PageFooter.vue'

const props = defineProps({
	'title': String,  // text to display title
})
</script>


<template>
	<div id="app-inner">
		<PageHeaderTiny :title="props.title" />

		<div id="app-body">
			<main id="app-page">
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

#app-page {
	flex: 1 0;
	margin: 1.5rem;
}
</style>
