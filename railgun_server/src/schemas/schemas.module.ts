import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Logging } from './logging.entity';
import { MemberSignUp } from './member_signup.entity';
import { MemberReset } from './member_reset.entity';
import { MemberCredential } from './member_credential.entity';
import { MemberSettings } from './member_settings.entity';
import { Member } from './member.entity';

@Module({
	imports: [
		TypeOrmModule.forFeature([
			Logging,
			MemberSignUp,
			MemberReset,
			MemberCredential,
			MemberSettings,
			Member,
		]),
	],
	exports: [
		TypeOrmModule,
	],
})
export class SchemasModule { }
