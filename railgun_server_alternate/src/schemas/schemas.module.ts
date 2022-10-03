import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { Logging, LoggingDocument, LoggingSchema } from './logging.schema';
import { MemberSignUp, MemberSignUpDocument, MemberSignUpSchema } from './member_signup.schema';
import { MemberReset, MemberResetDocument, MemberResetSchema } from './member_reset.schema';
import { MemberCredential, MemberCredentialSchema } from './member_credential.schema';
import { Member, MemberDocument, MemberSchema } from './member.schema';

function hookPreSave(that: any, next: Function) {
	const d = new Date();
	that.created = d;
	that.updated = d;
	next();
}

@Module({
	imports: [
		MongooseModule.forFeatureAsync([
			// logging
			{
				name: Logging.name,
				useFactory: () => {
					LoggingSchema.pre('save', function preSave(next) {
						hookPreSave(this as LoggingDocument, next);
					});
					return LoggingSchema;
				},
			},

			// member_signup
			{
				name: MemberSignUp.name,
				useFactory: () => {
					MemberSignUpSchema.pre('save', function preSave(next) {
						hookPreSave(this as MemberSignUpDocument, next);
					});
					return MemberSignUpSchema;
				},
			},

			// member_reset
			{
				name: MemberReset.name,
				useFactory: () => {
					MemberResetSchema.pre('save', function preSave(next) {
						hookPreSave(this as MemberResetDocument, next);
					});
					return MemberResetSchema;
				},
			},

			// member_credential
			{
				name: MemberCredential.name,
				useFactory: () => MemberCredentialSchema,
			},

			// member
			{
				name: Member.name,
				useFactory: () => {
					MemberSchema.pre('save', function preSave(next) {
						hookPreSave(this as MemberDocument, next);
					});
					return MemberSchema;
				},
			},
		]),

		Logging,
		MemberSignUp,
		MemberReset,
		MemberCredential,
		Member,
	],
	exports: [
		MongooseModule,
	],
})
export class SchemasModule { }
