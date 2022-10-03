import {
	Entity,
	Column,
	PrimaryColumn,
	OneToOne,
	Index,
} from 'typeorm';
import { Member } from './member.entity';

/**
 * Member's credential entity.
 */
@Entity({
	name: 'member_credential',
})
export class MemberCredential {
	@PrimaryColumn({
		length: 50,
	})
	id: string;

	/**
	 * Link to [Member]{@link /entities/Member.html}.
	 */
	@OneToOne(() => Member, (o) => o.credential)
	member: Member;

	// ----------------------------------------------------------------------

	@Column({
		length: 255,
	})
	salt: string;

	@Column({
		length: 1024,
	})
	hash: string;

	/**
	 * Sign-in token.
	 */
	@Index({
		unique: true,
	})
	@Column({
		length: 1024,
		nullable: true,
	})
	token: string | null;

	// ----------------------------------------------------------------------

	constructor(o?: Partial<MemberCredential>) {
		Object.assign(this, o)
	}
}
