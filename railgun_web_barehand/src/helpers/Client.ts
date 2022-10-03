import axios, { AxiosError } from 'axios'

/**
 * The returns type from client.call.
 */
export type ClientCallResult = {
	ok: boolean
	status: number
	json: any
	res: any
} | null

/**
 * Client connection manager.
 */
export class Client {

	/**
	 * Constructor.
	 */
	constructor(baseUrl: string, baseStaticUrl: string) {
		this.baseUrl = baseUrl
		if (!this.baseUrl.endsWith('/')) this.baseUrl += '/'
		this.baseStaticUrl = baseStaticUrl
		if (!this.baseStaticUrl.endsWith('/')) this.baseStaticUrl += '/'
	}

	// ----------------------------------------------------------------------

	/**
	 * Server base URL.
	 */
	baseUrl: string = ''

	/**
	 * Static server base URL.
	 */
	baseStaticUrl: string = ''

	// ----------------------------------------------------------------------

	/**
	 * Concats base URL with address.
	 */
	url(address: string): string {
		return `${this.baseUrl}${address}`
	}

	// ----------------------------------------------------------------------

	/**
	 * Authen token.
	 */
	token: string = ''

	// ----------------------------------------------------------------------

	/**
	 * Gets default headers.
	 */
	defaultHeaders(token?: string): any {
		const t = token || this.token
		return {
			'Content-Type': 'application/json;charset=utf-8',
			'Authorization': `Bearer ${t}`,
		}
	}

	/**
	 * Gets multi-part headers.
	 */
	formDataHeaders(token?: string): any {
		const t = token || this.token
		return {
			'Content-Type': 'multipart/form-data',
			'Authorization': `Bearer ${t}`,
		}
	}

	// ----------------------------------------------------------------------

	/**
	 * Calls HTTP.
	 */
	async call(url: string, options?: any): Promise<ClientCallResult | null> {
		// log before send
		let method
		if (options && options.method)
			method = options.method
		else
			method = 'GET'
		console.log(`${method} ${this.baseUrl + url}`)

		// fetches
		try {
			const res = await axios(this.baseUrl + url, options)
			console.log(`call result: ${res.status} ${res.statusText} ${JSON.stringify(res.data, null, 2)}`)
			return {
				ok: res.status === 200 || res.status === 201,
				status: res.status,
				json: res.data,
				res,
			}
		}
		catch (ex) {
			const err = ex as AxiosError
			if (err) {
				if (err.response) {
					const res = err.response
					const ret = {
						ok: res.status === 200 || res.status === 201,
						status: res.status,
						json: res.data,
						res,
					}
					console.log(`call error: ${JSON.stringify(ret, null, 2)}`)
					return ret
				}
				else {
					console.log(`call error: ${JSON.stringify(err, null, 2)}`)
					return null
				}
			}
			console.log(`call error: ${ex}`)
			return null
		}
	}

}
