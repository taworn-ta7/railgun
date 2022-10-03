import { Module } from '@nestjs/common';
import { SchemasModule } from 'src/schemas/schemas.module';
import { SetupController } from './setup.controller';
import { SetupService } from './setup.service';

@Module({
	imports: [
		SchemasModule,
	],
	controllers: [
		SetupController,
	],
	providers: [
		SetupService,
	],
})
export class SetupModule { }
