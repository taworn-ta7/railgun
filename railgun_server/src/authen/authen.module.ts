import { Module } from '@nestjs/common';
import { SchemasModule } from 'src/schemas/schemas.module';
import { AuthenController } from './authen.controller';
import { AuthenService } from './authen.service';

@Module({
	imports: [
		SchemasModule,
	],
	controllers: [
		AuthenController,
	],
	providers: [
		AuthenService,
	],
})
export class AuthenModule { }
