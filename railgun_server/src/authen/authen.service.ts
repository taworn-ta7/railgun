import {
	Logger,
	Injectable,
	UnauthorizedException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { Request } from 'express';
import { Logging } from 'src/schemas/logging.entity';
import { Member } from 'src/schemas/member.entity';
import { MemberSignInDto } from 'src/dtos/member.dto';
import { validatePassword, newOrUpdateToken } from 'src/helpers/authen.helper';
import Errors from 'src/helpers/errors.helper';

@Injectable()
export class AuthenService {

	private readonly logger = new Logger(AuthenService.name);

	constructor(
		private readonly dataSource: DataSource,

		@InjectRepository(Logging)
		private readonly loggingRepo: Repository<Logging>,

		@InjectRepository(Member)
		private readonly memberRepo: Repository<Member>,
	) { }

	// ----------------------------------------------------------------------

	/**
	 * Authorizes the email and password.
	 * Returns member data and sign-in token and will be use all the session.
	 */
	async signIn(
		req: Request,
		dto: MemberSignInDto,
	): Promise<Member> {
		// selects member
		const member = await this.memberRepo.findOne({
			where: { email: dto.email },
			relations: ['credential'],
		});
		if (!member || !validatePassword(dto.password, member.credential.salt, member.credential.hash))
			throw new UnauthorizedException(Errors.emailOrPasswordInvalid);

		// checks if this member resigned or disabled
		if (member.resigned)
			throw new UnauthorizedException(Errors.memberIsResigned);
		if (member.disabled)
			throw new UnauthorizedException(Errors.memberIsDisabledByAdmin);

		// checks if expiry sign-in
		const t = await newOrUpdateToken(member);

		// updates member
		await this.dataSource.manager.save(member);

		// adds log
		await this.loggingRepo.insert({
			memberId: member.id,
			action: 'update',
			table: 'member',
			description: `Member ${member.id}/${member.email} is sign-in.`,
		});

		// success
		return member;
	}

	// ----------------------------------------------------------------------

	/**
	 * Signs off from current session.  The sign-in token will be invalid.
	 */
	async signOut(
		req: Request,
	): Promise<void> {
		// updates member
		req.member.end = new Date();
		req.member.credential.token = null;
		await this.dataSource.manager.save(req.member);

		// adds log
		await this.loggingRepo.insert({
			memberId: req.member.id,
			action: 'update',
			table: 'member',
			description: `Member ${req.member.id}/${req.member.email} is sign-out.`,
		});
	}

}
