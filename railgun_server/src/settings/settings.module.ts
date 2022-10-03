import { Module } from '@nestjs/common';
import { SchemasModule } from 'src/schemas/schemas.module';
import { SettingsController } from './settings.controller';
import { SettingsService } from './settings.service';

@Module({
	imports: [
		SchemasModule,
	],
	controllers: [
		SettingsController,
	],
	providers: [
		SettingsService,
	],
})
export class SettingsModule { }
