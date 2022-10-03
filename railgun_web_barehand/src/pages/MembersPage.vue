<script setup lang="ts">
import { ref } from 'vue'
import { useI18n } from 'vue-i18n'
import { useRouter } from 'vue-router'
import AppShare from '@/helpers/AppShare'
import { useDialogStore } from '@/stores/DialogStore'
import Constants from '@/Constants'

// using
const { t } = useI18n({
	messages: {
		en: {
			title: "Members",
			sortBy: {
				id: "Id",
				emailAsc: "Email ASC",
				emailDesc: "Email DESC",
				signUpAsc: "Sign Up ASC",
				signUpDesc: "Sign Up DESC"
			},
			trash: "Disabled or Resigned",
			trash_: "Normal",
		},
		th: {
			title: "สมาชิก",
			sortBy: {
				id: "Id",
				emailAsc: "อีเมล น้อยไปมาก",
				emailDesc: "อีเมล มากไปน้อย",
				signUpAsc: "วันที่สมัคร น้อยไปมาก",
				signUpDesc: "วันที่สมัคร มากไปน้อย"
			},
			trash: "ถูกระงับการใช้งาน หรือ ลาออกจากระบบ",
			trash_: "ปกติ",
		},
	},
})
const router = useRouter()
const dialogStore = useDialogStore()

// states
const params = new URLSearchParams(window.location.search)
const page = ref(Number(params.get('page')) ?? 0)
const order = ref(params.get('order') ?? 'id')
const search = ref(params.get('search') ?? "")
const trash = ref(Number(params.get('trash')) ? 1 : 0)
const trashBin = ref(trash.value ? t('trash_') : t('trash'))
const options = ref([
	{ value: 'id', text: t('sortBy.id') },
	{ value: 'email', text: t('sortBy.emailAsc') },
	{ value: 'email-', text: t('sortBy.emailDesc') },
	{ value: 'created', text: t('sortBy.signUpAsc') },
	{ value: 'created-', text: t('sortBy.signUpDesc') },
])
const items = ref()
const pagination = ref()

function conditionsToUrl() {
	const cond = `page=${page.value}`
		+ `&order=${order.value}`
		+ `&search=${search.value}`
		+ `&trash=${trash.value}`
	return cond
}

function goToPage(diff: number) {
	if (diff < 0) {
		if (page.value > 0) {
			page.value--
			params.set('page', page.value.toString())
			router.push(`/members?${params.toString()}`)
			refresh()
		}
	}
	else if (diff > 0) {
		if (page.value < pagination.value.pageCount - 1) {
			page.value++
			params.set('page', page.value.toString())
			router.push(`/members?${params.toString()}`)
			refresh()
		}
	}
}

function changeOrder(o: string) {
	params.set('order', order.value)
	router.push(`/members?${params.toString()}`)
	refresh()
}

function setSearch() {
	params.set('search', search.value)
	router.push(`/members?${params.toString()}`)
	refresh()
}

function switchTrash() {
	trash.value = !trash.value ? 1 : 0
	trashBin.value = trash.value ? t('trash_') : t('trash')
	params.set('trash', trash.value.toString())
	router.push(`/members?${params.toString()}`)
	refresh()
}

async function refresh() {
	const cond = conditionsToUrl()
	//const url = `members?size=1&${cond}`
	const url = `members?${cond}`
	const result = await dialogStore.waitBox(async () =>
		await AppShare.client.call(url, {
			method: 'GET',
			headers: AppShare.client.defaultHeaders(),
		})
	)
	if (!dialogStore.handleRestError(result)) {
		items.value = result?.json.members
		pagination.value = result?.json.pagination
	}
}
refresh()
</script>


<template>
	<AuthenRequired>
		<AppBox :title="t('title')">
			<!-- ordering, searching and trashing -->
			<select v-model="order" @click.prevent="(e: Event) => changeOrder(order)">
				<option v-for="option in options" :value="option.value">
					{{ option.text }}
				</option>
			</select>
			<input v-model="search" @keyup.enter="(e: Event) => setSearch()" />
			<button @click.prevent="(e: Event) => switchTrash()">{{ trashBin }}</button><br />
			<br />

			<!-- data -->
			<div v-for="(item, index) in items" :key="index" class="item">
				<a :href="`/members/${item.email.replace(/\./g, () => '%2E')}`">
					<img :src="`${Constants.baseUrl}/members/${item.email}/icon`">
					<div>
						<span>{{ item.email }}</span>
						<span>{{ item.name }}</span>
					</div>
				</a>
			</div>
			<br />

			<!-- pagination -->
			<div v-if="pagination && pagination.pageCount > 0">
				<button @click.prevent="(e: Event) => goToPage(-1)">&nbsp;&lt;&nbsp;</button>
				<span style="padding: 0 1rem">{{ `${pagination.page + 1} / ${pagination.pageCount}` }}</span>
				<button @click.prevent="(e: Event) => goToPage(1)">&nbsp;&gt;&nbsp;</button>
			</div>
		</AppBox>
	</AuthenRequired>
</template>


<style scoped>
.item a {
	display: block;
}

.item img {
	display: inline-block;
	width: 80px;
	height: 80px;
}

.item div {
	display: inline-block;
	margin: 0 0 0 1rem;
	padding: 0.5rem 0 0 0;
	vertical-align: top;
}

.item div span:nth-child(1) {
	display: block;
	font-size: 120%;
	color: #444;
}

.item div span:nth-child(2) {
	display: block;
	color: #888;
}

@media (prefers-color-scheme: dark) {
	.item div span:nth-child(1) {
		display: block;
		font-size: 120%;
		color: #ccc;
	}
}
</style>
