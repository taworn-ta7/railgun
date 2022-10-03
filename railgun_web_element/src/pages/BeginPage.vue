<script setup lang="ts">
import { ref } from 'vue'
import { useI18n } from 'vue-i18n'
import { useRouter } from 'vue-router'
import {
	Edit as EmailIcon,
	Lock as PasswordIcon,
	SuccessFilled as OkIcon,
} from '@element-plus/icons-vue'
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
	<AppBox :top-level="true">
		<el-form id="form" label-width="5rem">
			<el-form-item :label="t('email')">
				<!-- email -->
				<el-input id="email" type="email" :placeholder="t('email')" required :prefix-icon="EmailIcon"
					v-model="email" />
			</el-form-item>

			<el-form-item :label="t('password')">
				<!-- password -->
				<el-input id="password" type="password" :placeholder="t('password')" required minlength="4"
					maxlength="20" :prefix-icon="PasswordIcon" show-password v-model="password" />
			</el-form-item>

			<el-form-item>
				<!-- remember -->
				<el-switch id="remember" :active-text="t('remember')" size="large" v-model="remember" />
			</el-form-item>

			<el-form-item>
				<!-- ok -->
				<el-button type="primary" size="large" :icon="OkIcon" @click.prevent="onSubmit">{{ t('ok') }}
				</el-button>

				<!-- forgot password -->
				<el-button type="warning" size="large" round @click.prevent="router.push({ name: 'forgotPass' })">{{
						t('forgotPassword')
				}}</el-button>

				<!-- sign up -->
				<el-button type="success" size="large" round @click.prevent="router.push({ name: 'signup' })">{{
						t('signUp')
				}}</el-button>
			</el-form-item>

			<el-form-item>
				<!-- signin with google -->
				<el-button type="primary" size="large"
					@click.prevent="(e: Event) => onExternalSignIn(Constants.googleSignIn())">{{
							t('signInGoogle')
					}}</el-button>

				<!-- signin with line -->
				<el-button type="primary" size="large"
					@click.prevent="(e: Event) => onExternalSignIn(Constants.lineSignIn())">{{
							t('signInLine')
					}}</el-button>
			</el-form-item>
		</el-form>
	</AppBox>
</template>


<style scoped>
</style>
