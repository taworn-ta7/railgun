import { SchemaFactory, Schema, Prop } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

/**
 * Member's credential schema.
 */
@Schema()
export class MemberCredential {
	@Prop()
	_id: Types.ObjectId;

	// ----------------------------------------------------------------------

	@Prop({ required: true })
	salt: string;

	@Prop({ required: true })
	hash: string;

	/**
	 * Sign-in token.
	 */
	@Prop({ index: true })
	token: string | null;
}

export type MemberCredentialDocument = MemberCredential & Document;
export const MemberCredentialSchema = SchemaFactory.createForClass(MemberCredential);
