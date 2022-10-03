export const Constants = {

	/**
	 * Local base URL.
	 */
	localUrl: 'http://localhost:8080',
	localIpUrl: 'http://127.0.0.1:8080',

	/**
	 * Server base URL.
	 */
	baseUrl: 'http://localhost:7777/api',

	/**
	 * Static server base URL.
	 */
	baseStaticUrl: 'http://localhost:7777',

	/**
	 * Google Client
	 */
	googleClientId: '910650963966-lo741r414qq6kechso59bb3anp48mc8t.apps.googleusercontent.com',
	googleAuthUrl: 'https://accounts.google.com/o/oauth2/v2/auth',
	googleSignIn: () => {
		const scope = [
			'openid',
			'profile',
			'email',
			'https://www.googleapis.com/auth/userinfo.profile',
			'https://www.googleapis.com/auth/userinfo.email',
		]
		return Constants.googleAuthUrl
			+ `?redirect_uri=${Constants.localUrl}/authenx/google`
			+ `&client_id=${Constants.googleClientId}`
			+ `&access_type=offline&response_type=code&prompt=consent`
			+ `&scope=${scope.join(' ')}`
	},

	/**
	 * LINE Client
	 */
	lineClientId: '1657365738',
	lineAuthUrl: 'https://access.line.me/oauth2/v2.1/authorize',
	lineSignIn: () => {
		return Constants.lineAuthUrl
			+ `?redirect_uri=${Constants.localIpUrl}/authenx/line`
			+ `&client_id=${Constants.lineClientId}`
			+ `&response_type=code&state=${`R@iL-gUn`}`
			+ `&scope=profile%20openid%20email`
	},

}

export default Constants
