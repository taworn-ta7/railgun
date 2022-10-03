import type { ClientCallResult, Client } from './Client'

/**
 * Provides authentication and related fields.
 */
export const Authen = {

	/**
	 * Sign-in function.
	 */
	async signIn(client: Client, email: string, password: string): Promise<ClientCallResult> {
		return await client.call(`authen/signin`, {
			method: 'PUT',
			headers: client.defaultHeaders(),
			data: {
				signin: {
					email,
					password,
				},
			},
		})
	},

	/**
	 * Sign-in with token function.
	 */
	async signInToken(client: Client, token: string): Promise<ClientCallResult> {
		return await client.call(`authen/check`, {
			method: 'GET',
			headers: client.defaultHeaders(token),
		})
	},

	/**
	 * Loads profile icon.
	 */
	async loadProfileIcon(client: Client, token: string): Promise<any> {
		const result = await client.call(`profile/icon`, {
			method: 'GET',
			headers: client.defaultHeaders(token),
			responseType: 'blob',
		})
		if (!result || !result.ok)
			return null;
		return URL.createObjectURL(result.res.data);
	},

	/**
	 * Loads personal settings.
	 */
	async loadSettings(client: Client, token: string): Promise<any> {
		const result = await client.call(`settings`, {
			method: 'GET',
			headers: client.defaultHeaders(token),
		})
		if (!result || !result.ok)
			return {};
		return result.json.settings;
	},

	/**
	 * Sign-out function.
	 */
	async signOut(client: Client, token: string): Promise<ClientCallResult> {
		return await client.call(`authen/signout`, {
			method: 'PUT',
			headers: client.defaultHeaders(token),
		})
	},

}

export default Authen
