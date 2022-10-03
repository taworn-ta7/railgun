import {
	Logger,
	Injectable,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { Request } from 'express';
import { ulid } from 'ulid'
import { MemberCredential } from 'src/schemas/member_credential.entity';
import { Member, MemberRole } from 'src/schemas/member.entity';
import { setPassword } from 'src/helpers/authen.helper';

@Injectable()
export class SetupService {

	private readonly logger = new Logger(SetupService.name);

	constructor(
		private readonly dataSource: DataSource,

		@InjectRepository(Member)
		private readonly memberRepo: Repository<Member>,
	) { }

	// ----------------------------------------------------------------------

	/**
	 * Setup and creates admin member.  Can run only once.
	 */
	async setup(
		req: Request,
	): Promise<string> {
		// checks if we already have 'admin' member?
		const check = await this.memberRepo.findOne({
			where: {
				email: process.env.MAIL_ADMIN,
				role: MemberRole.admin,
			},
		});
		if (check)
			return `Already setup.`;

		// creates 'admin'
		const password = setPassword('admin');
		const member = new Member();
		member.id = ulid();
		member.email = process.env.MAIL_ADMIN;
		member.role = MemberRole.admin;
		member.locale = 'en';
		member.name = 'Administrator';
		member.disabled = null;
		member.resigned = null;
		member.begin = null;
		member.end = null;
		member.expire = null;
		member.credential = new MemberCredential();
		member.credential.id = member.id;
		member.credential.salt = password.salt;
		member.credential.hash = password.hash;
		member.credential.token = null;

		// saves
		await this.dataSource.manager.save(member);

		this.logger.verbose(`${req.id} admin created: ${JSON.stringify(member, null, 2)}`);
		return `Setup completed :)`;
	}

}
