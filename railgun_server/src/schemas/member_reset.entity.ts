import {
	Entity,
	Column,
	PrimaryGeneratedColumn,
	CreateDateColumn,
	UpdateDateColumn,
	Index,
} from 'typeorm';

/**
 * Member password reset entity.
 */
@Entity({
	name: 'member_reset'
})
export class MemberReset {
	@PrimaryGeneratedColumn({
		// not for SQLite
		//type: 'bigint',
		type: 'int',
	})
	id: number;

	// ----------------------------------------------------------------------

	@Column({
		length: 254,
	})
	email: string;

	@Index({
		unique: true,
	})
	@Column({
		length: 128,
	})
	confirmToken: string;

	// ----------------------------------------------------------------------

	/// Created date/time.
	@CreateDateColumn({})
	created: Date;

	/// Updated date/time.
	@UpdateDateColumn({})
	updated: Date;

	constructor(o?: Partial<MemberReset>) {
		Object.assign(this, o)
	}
}
