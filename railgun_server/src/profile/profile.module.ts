import { Module } from '@nestjs/common';
import { SchemasModule } from 'src/schemas/schemas.module';
import { ProfileController } from './profile.controller';
import { ProfileService } from './profile.service';

@Module({
	imports: [
		SchemasModule,
	],
	controllers: [
		ProfileController,
	],
	providers: [
		ProfileService,
	],
})
export class ProfileModule { }
