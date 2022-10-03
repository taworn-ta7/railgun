<script setup lang="ts">
import { ref } from 'vue'
import { useI18n } from 'vue-i18n'
import { useRouter } from 'vue-router'
import { useAppStore } from '@/stores/AppStore'
import Constants from '@/Constants'

// using
const { t } = useI18n({
	messages: {
		en: {
			title: "@:app",
			email: "Email",
			password: "Password",
			remember: "Remember Sign-in",
			forgotPassword: "Forgot password?",
			ok: "Sign In",
			signUp: "Sign Up",
			signInGoogle: "Sign-in to Google",
			signInLine: "Sign-in to LINE",
			signInFacebook: "Sign-in to Facebook",
		},
		th: {
			title: "@:app",
			email: "อีเมล",
			password: "รหัสผ่าน",
			remember: "จำรหัสผ่าน",
			forgotPassword: "ลืมรหัสผ่าน?",
			ok: "เข้าสู่ระบบ",
			signUp: "สมัครสมาชิก",
			signInGoogle: "เข้าสู่ระบบโดย Google",
			signInLine: "เข้าสู่ระบบโดย LINE",
			signInFacebook: "เข้าสู่ระบบโดย Facebook",
		},
	},
})
const router = useRouter()
const appStore = useAppStore()

// states
const email = ref(localStorage.getItem('email') || "")
const password = ref(localStorage.getItem('password') || "",)
const remember = ref(localStorage.getItem('remember') ? true : false)

async function onSubmit() {
	if (await appStore.signIn(email.value, password.value)) {
		if (remember.value) {
			localStorage.setItem('email', email.value.trim())
			localStorage.setItem('password', password.value)
			localStorage.setItem('remember', '1')
		}
		else {
			localStorage.removeItem('email')
			localStorage.removeItem('password')
			localStorage.removeItem('remember')
		}
		localStorage.setItem('signin', '1')
	}
}

function onExternalSignIn(url: string) {
	window.location.href = url
}
</script>


<template>
	<AppBox>
		<form id="form" @submit.prevent="onSubmit">
			<!-- email -->
			<label for="email">{{ t('email') }}</label><br />
			<input id="email" type="email" :placeholder="t('email')" required v-model="email" /><br />
			<br />

			<!-- password -->
			<label for="password">{{ t('password') }}</label><br />
			<input id="password" type="password" :placeholder="t('password')" required minlength="4" maxlength="20"
				v-model="password" /><br />
			<br />

			<!-- remember -->
			<input id="remember" type="checkbox" style="margin-right: 0.5rem" v-model="remember" />
			<label for="remember">{{ t('remember') }}</label><br />
			<br />

			<button type="submit">{{ t('ok') }}</button>
			<button type="button" @click.prevent="router.push({ name: 'forgotPass' })">{{ t('forgotPassword')
			}}</button>
			<button type="button" @click.prevent="router.push({ name: 'signup' })">{{ t('signUp') }}</button><br />
			<br />

			<button type="button" @click.prevent="(e: Event) => onExternalSignIn(Constants.googleSignIn())">{{
					t('signInGoogle')
			}}</button>
			<button type="button" @click.prevent="(e: Event) => onExternalSignIn(Constants.lineSignIn())">{{
					t('signInLine')
			}}</button>
		</form>
	</AppBox>
</template>


<style scoped>
</style>
