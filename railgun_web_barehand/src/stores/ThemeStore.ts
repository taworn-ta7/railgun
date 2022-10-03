import { defineStore } from 'pinia'

export const useThemeStore = defineStore({

	id: 'ThemeStore',

	state: () => ({
		themes: [
			'#fff',
			'#000',
			'#fec',
			'#4CAF50',
			'#1976D2',
		],

		themeNames: [
			'light',
			'dark',
			'sepia',
			'nature',
			'blue',
		],

		/**
		 * Current theme.
		 */
		current: 0,
	}),

	actions: {
		/**
		 * Changes current theme.
		 */
		change(index: number): void {
			const themeName = this.themeNames[index % this.themeNames.length]
			const root = document.querySelector(':root') as any
			const style = root.style;
			style.setProperty(`--c-primary`, `var(--c-${themeName}-primary)`)
			style.setProperty(`--c-secondary`, `var(--c-${themeName}-secondary)`)
			style.setProperty(`--c-background`, `var(--c-${themeName}-background)`)
			style.setProperty(`--c-background-soft`, `var(--c-${themeName}-background-soft)`)
			style.setProperty(`--c-color`, `var(--c-${themeName}-color)`)
			style.setProperty(`--c-color-soft`, `var(--c-${themeName}-color-soft)`)
			style.setProperty(`--c-page-header`, `var(--c-${themeName}-page-header)`)
			style.setProperty(`--c-page-footer`, `var(--c-${themeName}-page-footer)`)
			style.setProperty(`--c-page-color`, `var(--c-${themeName}-page-color)`)
			style.setProperty(`--c-page-color-1`, `var(--c-${themeName}-page-color-1)`)
			document.documentElement.setAttribute('theme', themeName)
			this.current = index
			console.log(`current theme: ${this.current}, theme=${themeName}`)
		},
	},

})
