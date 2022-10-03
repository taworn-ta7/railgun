import { Module } from '@nestjs/common';
import { SchemasModule } from 'src/schemas/schemas.module';
import { SignUpController } from './signup.controller';
import { SignUpService } from './signup.service';
import { ResetController } from './reset.controller';
import { ResetService } from './reset.service';
import { MembersController } from './members.controller';
import { MembersService } from './members.service';

@Module({
	imports: [
		SchemasModule,
	],
	controllers: [
		SignUpController,
		ResetController,
		MembersController,
	],
	providers: [
		SignUpService,
		ResetService,
		MembersService,
	],
})
export class MembersModule { }
