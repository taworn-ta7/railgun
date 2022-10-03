import {
	Logger,
	CallHandler,
	ExecutionContext,
	Injectable,
	NestInterceptor,
} from '@nestjs/common';
import { Request } from 'express';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';

@Injectable()
export class LoggingsInterceptor implements NestInterceptor {

	private readonly logger = new Logger(LoggingsInterceptor.name);

	private static requestId: number = 0;

	generateRequestId(): string {
		const result = LoggingsInterceptor.requestId++;
		if (LoggingsInterceptor.requestId >= 1000000000)
			LoggingsInterceptor.requestId = 0;
		return result.toString().padStart(9, '0')
	}

	intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
		const req = context.switchToHttp().getRequest<Request>();
		req.id = this.generateRequestId();
		this.logger.verbose(`${req.id} ${req.method} ${req.originalUrl}`);
		if (req.member)
			this.logger.verbose(`${req.id} ${req.member.id}/${req.member.email} [${req.member.role}] name=${req.member.name}`);

		const now = Date.now();
		return next.handle().pipe(
			tap(() => this.logger.verbose(`${req.id} success, time ${Date.now() - now} ms`))
		);
	}

}
