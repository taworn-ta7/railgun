import {
	Entity,
	Column,
	PrimaryColumn,
	ManyToOne,
	Index,
} from 'typeorm';
import { Member } from './member.entity';

/**
 * Member's personal settings entity.
 */
@Entity({
	name: 'member_settings',
})
@Index([
	"member",
	"key",
], {})
export class MemberSettings {
	@PrimaryColumn({
		length: 50,
	})
	id: string;

	/**
	 * Link to [Member]{@link /entities/Member.html}.
	 */
	@ManyToOne(() => Member, (o) => o.settings)
	@Index()
	member: Member;

	// ----------------------------------------------------------------------

	@Column({
		length: 50,
	})
	key: string;

	@Column({
		length: 512,
		nullable: true,
	})
	value: string | null;

	// ----------------------------------------------------------------------

	constructor(o?: Partial<MemberSettings>) {
		Object.assign(this, o)
	}
}
