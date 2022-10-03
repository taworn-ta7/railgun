import axios, { AxiosError } from 'axios'

/**
 * Axios helper.
 */
export const Axios = {

	/**
	 * Calls HTTP.
	 */
	async call(url: string, options?: any): Promise<any> {
		// log before send
		let method
		if (options && options.method)
			method = options.method
		else
			method = 'GET'
		//console.log(`${method} ${url}`)

		// fetches
		try {
			const res = await axios(url, options)
			//console.log(`call result: ${res.status} ${res.statusText} ${JSON.stringify(res.data, null, 2)}`)
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
					//console.log(`call error: ${JSON.stringify(ret, null, 2)}`)
					return ret
				}
				else {
					//console.log(`call error: ${JSON.stringify(err, null, 2)}`)
					return null
				}
			}
			//console.log(`call error: ${ex}`)
			return null
		}
	}

}

export default Axios
