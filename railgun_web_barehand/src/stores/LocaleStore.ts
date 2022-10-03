import { defineStore } from 'pinia'
import { useDialogStore } from './DialogStore'

export const useLocaleStore = defineStore({

	id: 'LocaleStore',

	state: () => ({
		/**
		 * Current locale.
		 */
		current: 'en',
	}),

	actions: {
		/**
		 * Changes current locale.
		 */
		change(locale: string): void {
			const dialogStore = useDialogStore()
			dialogStore.changeLocale(locale)
			this.current = locale
			console.log(`current locale: ${this.current}`)
		},
	},

})
