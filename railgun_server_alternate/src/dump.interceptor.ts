import {
	Logger,
	CallHandler,
	ExecutionContext,
	Injectable,
	NestInterceptor,
} from '@nestjs/common';
import { Request } from 'express';
import { Observable } from 'rxjs';

@Injectable()
export class DumpHeaderInterceptor implements NestInterceptor {

	private readonly logger = new Logger(DumpHeaderInterceptor.name);

	intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
		const req = context.switchToHttp().getRequest<Request>();
		this.logger.verbose(`${req.id} headers: ${JSON.stringify(req.headers, null, 2)}`);
		return next.handle();
	}

}

// ----------------------------------------------------------------------

@Injectable()
export class DumpBodyInterceptor implements NestInterceptor {

	private readonly logger = new Logger(DumpBodyInterceptor.name);

	intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
		const req = context.switchToHttp().getRequest<Request>();
		this.logger.verbose(`${req.id} body: ${JSON.stringify(req.body, null, 2)}`);
		return next.handle();
	}

}
