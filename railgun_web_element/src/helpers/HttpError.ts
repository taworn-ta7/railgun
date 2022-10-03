//
// This module is required UI file to call this!
//

export const HttpError = {
	/**
	 * Retrives message from REST error JSON.
	 */
	get(e: any, t: any, locale: string): string {
		// first, finds in locales
		if (e.locales !== null) {
			const text = locale in e.locales
				? e.locales[locale]!
				: e.locales['en']!;
			return text;
		}

		// if not, checks in HTTP status codes
		const error = e.statusCode.toString()
		const text = t(`error.e${error}`)
		if (text != null) return text

		// finally, if not, uses error with HTTP status code
		return t('error.unknown', { statusCode: e.statusCode })
	}
}

export default HttpError
