import {
	Logger,
	ExceptionFilter,
	Catch,
	ArgumentsHost,
	HttpException,
} from '@nestjs/common';
import { Request, Response } from 'express';

@Catch(HttpException)
export class HttpExceptionFilter implements ExceptionFilter {

	private readonly logger = new Logger(HttpExceptionFilter.name);

	catch(exception: HttpException, host: ArgumentsHost) {
		const ctx = host.switchToHttp();
		const req = ctx.getRequest<Request>();
		const res = ctx.getResponse<Response>();
		const status = exception.getStatus();
		const response = exception.getResponse();

		// message
		const message: string = response && response['message'] ? response['message'] : null;

		// locales, if provided
		const locales: any = response && response['locales'] ? response['locales'] : null;

		// logging
		const prefix = req.id ? `${req.id} ` : '';
		const suffix = locales && locales.en ? ` ${locales.en}` : (message ? ` ${message}` : '');
		this.logger.warn(`${prefix}HTTP error: ${status}${suffix}`);

		res.status(status).json({
			statusCode: status,
			message,
			locales,
			path: req.url,
			requestId: req.id,
			timestamp: new Date().toISOString(),
			owner: req.member?.email,
		});
	}
}
