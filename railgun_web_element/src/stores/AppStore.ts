import { defineStore } from 'pinia'
import Authen from '@/helpers/Authen'
import AppShare from '@/helpers/AppShare'
import { useLocaleStore } from '@/stores/LocaleStore'
import { useThemeStore } from '@/stores/ThemeStore'
import { useDialogStore } from '@/stores/DialogStore'

/**
 * Sign-in state type.
 */
export enum SignInStateType {
	NowLoading = 0,
	WaitSignIn = -1,
	AlreadySignIn = 1,
}

/**
 * Application shared service singleton class.
 */
export const useAppStore = defineStore({

	id: 'AppStore',

	state: () => ({
		token: '',
		member: <any>null,
		icon: <any>null,
		settings: <any>{},
		state: SignInStateType.AlreadySignIn,
	}),

	actions: {
		/**
		 * Loads previous session.
		 */
		async setup(): Promise<boolean> {
			const localeStore = useLocaleStore()
			const themeStore = useThemeStore()

			// retrieves token from local storage
			const token = localStorage.getItem('token') || ''
			console.log(`retrieve token: ${token}`)
			if (token && token.length > 0) {
				// try reloading member from token
				console.log(`try reload member`)
				const result = await Authen.signInToken(AppShare.client, token)
				if (result && result.ok) {
					// success
					AppShare.client.token = token
					this.token = result.json.token
					this.member = result.json.member
					this.icon = await Authen.loadProfileIcon(AppShare.client, token)
					this.settings = await Authen.loadSettings(AppShare.client, token)
					localeStore.change(this.member.locale)
					themeStore.change(parseInt(this.settings['web-theme-element']) || 0)
					this.state = SignInStateType.AlreadySignIn
					return true
				}
				else {
					// failed, checks remember sign-in
					if (localStorage.getItem('remember') && localStorage.getItem('signin')) {
						console.log(`check remember sign-in flag`)
						const result = await Authen.signIn(
							AppShare.client,
							localStorage.getItem('email') || '',
							localStorage.getItem('password') || '',
						)
						if (result && result.ok) {
							const token = result.json.token
							localStorage.setItem('token', token)
							AppShare.client.token = token
							this.token = token
							this.member = result.json.member
							this.icon = await Authen.loadProfileIcon(AppShare.client, token)
							this.settings = await Authen.loadSettings(AppShare.client, token)
							localeStore.change(this.member.locale)
							themeStore.change(parseInt(this.settings['web-theme-element']) || 0)
							this.state = SignInStateType.AlreadySignIn
							return true
						}
					}
				}
			}
			console.log(`normally wait sign-in`)
			// NOTE:
			// Because App.vue and DialogBox.vue is NOT loaded.
			// So, comment out below line.
			//localeStore.change('en')
			themeStore.change(0)
			this.state = SignInStateType.WaitSignIn
			return false
		},

		// ----------------------------------------------------------------------

		/**
		 * Sign-in with already have member and token.
		 */
		async signInWithExternalToken(member: any, token: string): Promise<boolean> {
			const localeStore = useLocaleStore()
			const themeStore = useThemeStore()
			localStorage.setItem('token', token)
			AppShare.client.token = token
			this.token = token
			this.member = member
			this.icon = await Authen.loadProfileIcon(AppShare.client, token)
			this.settings = await Authen.loadSettings(AppShare.client, token)
			localeStore.change(this.member.locale)
			themeStore.change(parseInt(this.settings['web-theme-element']) || 0)
			this.state = SignInStateType.AlreadySignIn
			return true
		},

		/**
		 * Sign-in over-all function.
		 */
		async signIn(email: string, password: string): Promise<boolean> {
			const dialogStore = useDialogStore()
			const result = await dialogStore.waitBox(async () =>
				await Authen.signIn(AppShare.client, email, password))
			if (!dialogStore.handleRestError(result)) {
				const localeStore = useLocaleStore()
				const themeStore = useThemeStore()
				const token = result?.json.token
				localStorage.setItem('token', token)
				AppShare.client.token = token
				this.token = token
				this.member = result?.json.member
				this.icon = await Authen.loadProfileIcon(AppShare.client, token)
				this.settings = await Authen.loadSettings(AppShare.client, token)
				localeStore.change(this.member.locale)
				themeStore.change(parseInt(this.settings['web-theme-element']) || 0)
				this.state = SignInStateType.AlreadySignIn
				return true
			}
			this.state = SignInStateType.WaitSignIn
			return false
		},

		/**
		 * Sign-out over-all function.
		 */
		async signOut(): Promise<void> {
			const localeStore = useLocaleStore()
			const themeStore = useThemeStore()
			localeStore.change(this.member.locale)
			themeStore.change(parseInt(this.settings['web-theme-element']) || 0)

			const dialogStore = useDialogStore()
			await dialogStore.waitBox(async () => await Authen.signOut(AppShare.client, this.token))
			localStorage.removeItem('token')
			localStorage.removeItem('signin')
			AppShare.client.token = ''
			this.token = ''
			this.member = null
			this.icon = null
			this.settings = {}
			this.state = SignInStateType.WaitSignIn
		},

		// ----------------------------------------------------------------------

		/**
		 * Saves locale settings.
		 */
		async saveLocale(locale: string): Promise<void> {
			const result = await AppShare.client.call(`settings/change`, {
				method: 'PUT',
				headers: AppShare.client.defaultHeaders(this.token),
				data: {
					member: {
						locale,
					},
				},
			})
			if (!result || !result.ok) return
			this.member = result.json.member
		},

		/**
		 * Saves theme settings.
		 */
		async saveTheme(index: number): Promise<void> {
			const value = index.toString()
			const result = await AppShare.client.call(`settings/web-theme-element/${value}`, {
				method: 'PUT',
				headers: AppShare.client.defaultHeaders(this.token),
			})
			if (!result || !result.ok) return
			this.settings['web-theme-element'] = value
		},
	},

})
