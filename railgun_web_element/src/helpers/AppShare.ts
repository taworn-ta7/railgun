import { Client } from './Client'
import Constants from '@/Constants'

/**
 * Application shared across project.
 */
export const AppShare = {

	/**
	 * Client connection.
	 */
	client: new Client(Constants.baseUrl, Constants.baseStaticUrl),

}

export default AppShare
