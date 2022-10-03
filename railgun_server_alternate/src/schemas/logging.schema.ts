import { SchemaFactory, Schema, Prop } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

/**
 * Generic logging.
 */
@Schema()
export class Logging {
	@Prop()
	_id: Types.ObjectId;

	// ----------------------------------------------------------------------

	/** 
	 * Who do this action?
	 */
	@Prop({ required: true })
	memberId: string;

	/**
	 * CRUD: create, read, update or delete.
	 */
	@Prop({ required: true })
	action: string;

	/**
	 * Which table(s)?
	 */
	@Prop({ required: true })
	table: string;

	/**
	 * Description text.
	 */
	@Prop({ required: true })
	description: string;

	// ----------------------------------------------------------------------

	/// Created date/time.
	@Prop()
	created: Date;

	/// Updated date/time.
	@Prop()
	updated: Date;
}

export type LoggingDocument = Logging & Document;
export const LoggingSchema = SchemaFactory.createForClass(Logging);
