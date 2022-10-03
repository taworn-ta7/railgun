import {
	Logger,
	Injectable,
} from '@nestjs/common';

@Injectable()
export class AppService {

	private readonly logger = new Logger(AppService.name);

	constructor(
	) { }

	// ----------------------------------------------------------------------

	/**
	 * Returns server name and version.
	 */
	about(): {
		app: string,
		version: string,
	} {
		this.logger.log(`let' go...`);
		this.logger.error(`on and on...`);
		this.logger.warn(`keep going...`);
		this.logger.debug(`still fighting...`);
		this.logger.verbose(`alive and kicking...`);
		return {
			app: process.env.npm_package_name,
			version: process.env.npm_package_version,
		};
	}

	// ----------------------------------------------------------------------

	/**
	 * Returns current configuration.
	 */
	config(): any {
		const env = process.env;
		return {
			config: {
				LOG_DIR: env.LOG_DIR,
				LOG_TO_CONSOLE: env.LOG_TO_CONSOLE,
				LOG_TO_FILE: env.LOG_TO_FILE,

				DAYS_TO_KEEP_LOG: env.DAYS_TO_KEEP_LOG,
				DAYS_TO_KEEP_DBLOG: env.DAYS_TO_KEEP_DBLOG,
				DAYS_TO_KEEP_SIGNUP: env.DAYS_TO_KEEP_SIGNUP,
				DAYS_TO_KEEP_RESET: env.DAYS_TO_KEEP_RESET,

				STORAGE_DIR: env.STORAGE_DIR,
				UPLOAD_DIR: env.UPLOAD_DIR,

				DB_URL: env.DB_URL,

				MAIL_HOST: env.MAIL_HOST,
				MAIL_PORT: env.MAIL_PORT,
				MAIL_USER: env.MAIL_USER,
				MAIL_ADMIN: env.MAIL_ADMIN,

				HTTP_PORT: env.HTTP_PORT,

				AUTHEN_TIMEOUT: env.AUTHEN_TIMEOUT,

				PROFILE_ICON_FILE_LIMIT: env.PROFILE_ICON_FILE_LIMIT,
			},
		};
	}

}
