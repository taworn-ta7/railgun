import {
	Entity,
	Column,
	PrimaryGeneratedColumn,
	CreateDateColumn,
	UpdateDateColumn,
} from 'typeorm';

/**
 * Generic logging.
 */
@Entity({
	name: 'logging',
})
export class Logging {
	@PrimaryGeneratedColumn({
		// not for SQLite
		//type: 'bigint',
		type: 'int',
	})
	id: number;

	// ----------------------------------------------------------------------

	/** 
	 * Who do this action?
	 */
	@Column({
		length: 50,
	})
	memberId: string;

	/**
	 * CRUD: create, read, update or delete.
	 */
	@Column({
		length: 50,
	})
	action: string;

	/**
	 * Which table(s)?
	 */
	@Column({
		length: 100,
	})
	table: string;

	/**
	 * Description text.
	 */
	@Column({
	})
	description: string;

	// ----------------------------------------------------------------------

	/// Created date/time.
	@CreateDateColumn({})
	created: Date;

	/// Updated date/time.
	@UpdateDateColumn({})
	updated: Date;

	constructor(o?: Partial<Logging>) {
		Object.assign(this, o)
	}
}
