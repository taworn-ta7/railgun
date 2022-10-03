import { Module } from '@nestjs/common';
import { SchemasModule } from 'src/schemas/schemas.module';
import { SignUpService } from 'src/members/signup.service';
import { AdminController } from './admin.controller';
import { AdminService } from './admin.service';

@Module({
	imports: [
		SchemasModule,
	],
	controllers: [
		AdminController,
	],
	providers: [
		AdminService,
		SignUpService,
	]
})
export class AdminModule { }
