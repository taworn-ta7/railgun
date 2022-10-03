import { SchemaFactory, Schema, Prop } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';
import { MemberCredential } from './member_credential.schema';

/**
 * Member role constants.
 */
export enum MemberRole {
	member = 'member',
	admin = 'admin',
};

/**
 * Member schema.
 */
@Schema()
export class Member {
	@Prop()
	_id: Types.ObjectId;

	// ----------------------------------------------------------------------

	/**
	 * Email.
	 */
	@Prop({ required: true, index: true })
	email: string;

	/**
	 * Role level, can be 'member' or 'admin'.
	 */
	@Prop({ required: true })
	role: string;

	/**
	 * Locale, can be 'en' or 'th'.
	 */
	@Prop({ required: true })
	locale: string;

	/**
	* Display name.
	*/
	@Prop({ required: true })
	name: string;

	// ----------------------------------------------------------------------

	/**
	 * Disabled by admin.
	 */
	@Prop()
	disabled: Date | null;

	/**
	 * Resigned by this member.
	 */
	@Prop()
	resigned: Date | null;

	// ----------------------------------------------------------------------

	/**
	 * Last sign-in date/time.
	 */
	@Prop()
	begin: Date | null;

	/**
	 * Last sign-out date/time.
	 */
	@Prop()
	end: Date | null;

	/**
	 * Session expiry date/time.
	 */
	@Prop()
	expire: Date | null;

	// ----------------------------------------------------------------------

	/**
	 * Link to [MemberCredential]{@link MemberCredential}.
	 */
	@Prop({ required: true })
	credential: MemberCredential;

	/**
	 * Personal settings.
	 */
	@Prop({ type: Map })
	settings: Object;

	// ----------------------------------------------------------------------

	/// Created date/time.
	@Prop()
	created: Date;

	/// Updated date/time.
	@Prop()
	updated: Date;
}

export type MemberDocument = Member & Document;
export const MemberSchema = SchemaFactory.createForClass(Member);
