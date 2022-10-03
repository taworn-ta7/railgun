import { Module } from '@nestjs/common';
import { SchemasModule } from 'src/schemas/schemas.module';
import { AuthenXController } from './authenx.controller';
import { AuthenXService } from './authenx.service';
import { AuthenXGoogleService } from './authenx-google.service';
import { AuthenXLineService } from './authenx-line.service';

@Module({
	imports: [
		SchemasModule,
	],
	controllers: [
		AuthenXController,
	],
	providers: [
		AuthenXService,
		AuthenXGoogleService,
		AuthenXLineService,
	],
})
export class AuthenXModule { }
