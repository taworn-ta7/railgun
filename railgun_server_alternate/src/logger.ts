import { LoggerService } from '@nestjs/common';
import * as path from 'path';
import * as fs from 'fs';
import { Logger, createLogger, format, transports } from 'winston';
import 'winston-daily-rotate-file';

/**
 * A backend logger to output log.
 */
export class CustomLogger implements LoggerService {

	logDir: string;
	logger: Logger;

	constructor() {
		this.logDir = path.resolve(path.join(__dirname, '..', process.env.LOG_DIR));
		if (!fs.existsSync(this.logDir)) {
			fs.mkdirSync(this.logDir);
		}

		let xports = [];
		if (+process.env.LOG_TO_CONSOLE) {
			xports.push(new transports.Console({
				format: format.combine(
					format.colorize({
						all: true,
						colors: {
							info: 'white',
							error: 'red',
							warn: 'yellow',
							debug: 'green',
							verbose: 'cyan',
						},
					}),
				),
			}));
		}
		if (+process.env.LOG_TO_FILE) {
			xports.push(new transports.DailyRotateFile({
				filename: `${this.logDir}/%DATE%.log`,
				datePattern: 'YYYYMMDD',
			}));
		}

		this.logger = createLogger({
			level: process.env.NODE_ENV === 'production' ? 'info' : 'silly',
			format: format.combine(
				format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss.SSS' }),
				format.printf(info => `${info.timestamp} ${info.level.substring(0, 3).toUpperCase()} ${info.message}`),
			),
			transports: xports,
		});
	}

	// ----------------------------------------------------------------------

	/**
	 * Writes a 'log' level log.
	 */
	log(message: any, ...optionalParams: any[]) {
		this.logger.info(this.format(message, optionalParams.length > 0 ? optionalParams[0] : ''));
	}

	/**
	 * Writes an 'error' level log.
	 */
	error(message: any, ...optionalParams: any[]) {
		this.logger.error(this.format(message, optionalParams.length > 0 ? optionalParams[0] : ''));
	}

	/**
	 * Writes a 'warn' level log.
	 */
	warn(message: any, ...optionalParams: any[]) {
		this.logger.warn(this.format(message, optionalParams.length > 0 ? optionalParams[0] : ''));
	}

	/**
	 * Writes a 'debug' level log.
	 */
	debug(message: any, ...optionalParams: any[]) {
		this.logger.debug(this.format(message, optionalParams.length > 0 ? optionalParams[0] : ''));
	}

	/**
	 * Writes a 'verbose' level log.
	 */
	verbose(message: any, ...optionalParams: any[]) {
		this.logger.verbose(this.format(message, optionalParams.length > 0 ? optionalParams[0] : ''));
	}

	// ----------------------------------------------------------------------

	format(message: any, name: string): string {
		const width = 20;
		const prefix = name.substring(0, width).padEnd(width);
		return `${prefix} | ${message}`;
	}

}
