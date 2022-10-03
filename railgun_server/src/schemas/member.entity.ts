import {
	Entity,
	Column,
	PrimaryColumn,
	CreateDateColumn,
	UpdateDateColumn,
	OneToOne,
	OneToMany,
	JoinColumn,
	Index,
} from 'typeorm';
import { MemberCredential } from './member_credential.entity';
import { MemberSettings } from './member_settings.entity';

/**
 * Member role constants.
 */
export enum MemberRole {
	member = 'member',
	admin = 'admin',
};

/**
 * Member entity.
 */
@Entity({
	name: 'member',
})
export class Member {
	@PrimaryColumn({
		length: 50,
	})
	id: string;

	/**
	 * Link to [MemberCredential]{@link /entities/MemberCredential.html}.
	 */
	@OneToOne(() => MemberCredential, (o) => o.member, {
		cascade: true,
		onDelete: 'CASCADE',
		orphanedRowAction: 'delete',
	})
	@JoinColumn()
	credential: MemberCredential;

	/**
	 * Link to [MemberSettings]{@link /entities/MemberSettings.html}.
	 */
	@OneToMany(() => MemberSettings, (o) => o.member, {
		cascade: true,
		onDelete: 'CASCADE',
		orphanedRowAction: 'delete',
	})
	@JoinColumn()
	settings: MemberSettings[];

	// ----------------------------------------------------------------------

	/**
	 * Email.
	 */
	@Index({
		unique: true,
	})
	@Column({
		length: 254,
	})
	email: string;

	/**
	 * Role level, can be 'member' or 'admin'.
	 */
	@Column({
		length: 50,
	})
	role: string;
	/*
	// for 'enum' support, not for SQLite
	@Column({
		type: 'enum',
		enum: MemberRole,
		default: MemberRole.member,
	})
	role: MemberRole;
	*/

	/**
	 * Locale, can be 'en' or 'th'.
	 */
	@Column({
		length: 10,
	})
	locale: string;

	/**
	 * Display name.
	 */
	@Column({
		length: 200,
	})
	name: string;

	// ----------------------------------------------------------------------

	/**
	 * Disabled by admin.
	 */
	@Column({
		nullable: true,
	})
	disabled: Date | null;

	/**
	 * Resigned by this member.
	 */
	@Column({
		nullable: true,
	})
	resigned: Date | null;

	// ----------------------------------------------------------------------

	/**
	 * Last sign-in date/time.
	 */
	@Column({
		nullable: true,
	})
	begin: Date | null;

	/**
	 * Last sign-out date/time.
	 */
	@Column({
		nullable: true,
	})
	end: Date | null;

	/**
	 * Session expiry date/time.
	 */
	@Column({
		nullable: true,
	})
	expire: Date | null;

	// ----------------------------------------------------------------------

	/// Created date/time.
	@CreateDateColumn({})
	created: Date;

	/// Updated date/time.
	@UpdateDateColumn({})
	updated: Date;

	constructor(o?: Partial<Member>) {
		Object.assign(this, o)
	}
}
