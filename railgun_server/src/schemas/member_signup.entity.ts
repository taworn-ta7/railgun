import {
	Entity,
	Column,
	PrimaryGeneratedColumn,
	CreateDateColumn,
	UpdateDateColumn,
	Index,
} from 'typeorm';

/**
 * Member sign-up entity.
 */
@Entity({
	name: 'member_signup'
})
export class MemberSignUp {
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

	@Column({
		length: 10,
	})
	locale: string;

	@Column({
		length: 255,
	})
	salt: string;

	@Column({
		length: 1024,
	})
	hash: string;

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

	constructor(o?: Partial<MemberSignUp>) {
		Object.assign(this, o)
	}
}
