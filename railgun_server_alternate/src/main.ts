import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { CustomLogger } from 'src/logger';
import { LoggingsInterceptor } from 'src/loggings.interceptor';
import { HttpExceptionFilter } from 'src/http_exception.filter';
import { AppModule } from 'src/app.module';

async function bootstrap() {
	const port = +process.env.HTTP_PORT;
	console.log(`server listening on port: ${port}`);

	const app = await NestFactory.create(AppModule, {
		logger: new CustomLogger(),
	});
	app.enableCors();
	app.useGlobalInterceptors(new LoggingsInterceptor());
	app.useGlobalFilters(new HttpExceptionFilter());
	app.useGlobalPipes(new ValidationPipe());

	await app.listen(port);
}
bootstrap();
