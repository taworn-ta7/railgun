import { SchemaFactory, Schema, Prop } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

/**
 * Member sign-up schema.
 */
@Schema()
export class MemberSignUp {
	@Prop()
	_id: Types.ObjectId;

	// ----------------------------------------------------------------------

	@Prop({ required: true })
	email: string;

	@Prop({ required: true })
	locale: string;

	@Prop({ required: true })
	salt: string;

	@Prop({ required: true })
	hash: string;

	@Prop({ required: true, index: true })
	confirmToken: string;

	// ----------------------------------------------------------------------

	/// Created date/time.
	@Prop()
	created: Date;

	/// Updated date/time.
	@Prop()
	updated: Date;
}

export type MemberSignUpDocument = MemberSignUp & Document;
export const MemberSignUpSchema = SchemaFactory.createForClass(MemberSignUp);
