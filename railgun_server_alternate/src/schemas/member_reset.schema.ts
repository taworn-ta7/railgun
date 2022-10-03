import { SchemaFactory, Schema, Prop } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

/**
 * Member password reset schema.
 */
@Schema()
export class MemberReset {
	@Prop()
	_id: Types.ObjectId;

	// ----------------------------------------------------------------------

	@Prop({ required: true })
	email: string;

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

export type MemberResetDocument = MemberReset & Document;
export const MemberResetSchema = SchemaFactory.createForClass(MemberReset);
