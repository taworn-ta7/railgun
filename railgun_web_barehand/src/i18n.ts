import { createI18n } from 'vue-i18n'
import { messages as en } from '@/locales/en'
import { messages as th } from '@/locales/th'

/**
 * Load locale messages
 * 
 * The loaded `JSON` locale messages is pre-compiled by `@intlify/vue-i18n-loader`, which is integrated into `vue-cli-plugin-i18n`.
 * See: https://github.com/intlify/vue-i18n-loader#rocket-i18n-resource-pre-compilation
 */
function loadLocaleMessages() {
	return {}
}

const i18n = createI18n({
	legacy: false,  // you must set `false`, to use Composition API
	locale: 'en',
	fallbackLocale: 'en',
	loadLocaleMessages,
	messages: {
		en,
		th,
	},
})

export default i18n
