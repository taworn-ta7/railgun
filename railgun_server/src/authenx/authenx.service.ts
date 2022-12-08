import {
	Logger,
	Injectable,
	UnauthorizedException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { Request } from 'express';
import { Logging } from 'src/schemas/logging.entity';
import { Member, MemberRole } from 'src/schemas/member.entity';
import { MemberCredential } from 'src/schemas/member_credential.entity';
import { setPassword, generateToken, newOrUpdateToken } from 'src/helpers/authen.helper';
import { generateUlid } from 'src/helpers/ulid.helper'
import Errors from 'src/helpers/errors.helper';

@Injectable()
export class AuthenXService {

	private readonly logger = new Logger(AuthenXService.name);

	constructor(
		private readonly dataSource: DataSource,

		@InjectRepository(Logging)
		private readonly loggingRepo: Repository<Logging>,

		@InjectRepository(Member)
		private readonly memberRepo: Repository<Member>,
	) { }

	// ----------------------------------------------------------------------

	/**
	 * Prepares member data for external sign-in.
	 */
	async memberForExternalSignIn(
		req: Request,
		email: string,
		locale: string,
		name: string,
	): Promise<{
		member: Member,
		created: boolean,
	}> {
		// checks if email is exists
		const member = await this.memberRepo.findOne({
			where: { email },
			relations: ['credential'],
		});

		// not found, creates it
		if (!member) {
			// checks locale
			if (locale !== 'en' && locale !== 'th')
				locale = 'en';

			// creates member
			const generate = generateToken(8);
			const password = setPassword(generate);
			const member = new Member();
			member.id = generateUlid();
			member.email = email;
			member.role = MemberRole.member;
			member.locale = locale;
			member.name = name;
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

			// updates token and saves
			await newOrUpdateToken(member);
			await this.dataSource.manager.save(member);

			// adds log
			await this.loggingRepo.insert({
				memberId: member.id,
				action: 'create',
				table: 'member',
				description: `Member ${member.id}/${member.email} is created via external sign-in.`,
			});

			this.logger.verbose(`${req.id} member created: ${JSON.stringify(member, null, 2)}`);
			return {
				member,
				created: true,
			};
		}
		else {
			// checks if this member resigned or disabled
			if (member.resigned)
				throw new UnauthorizedException(Errors.memberIsResigned);
			if (member.disabled)
				throw new UnauthorizedException(Errors.memberIsDisabledByAdmin);

			// updates token and saves
			await newOrUpdateToken(member);
			await this.dataSource.manager.save(member);

			this.logger.verbose(`${req.id} member loaded: ${JSON.stringify(member, null, 2)}`);
			return {
				member,
				created: false,
			};
		}
	}

}
