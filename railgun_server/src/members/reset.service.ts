import {
	Logger,
	Injectable,
	NotFoundException,
} from '@nestjs/common';
import { MailerService } from '@nestjs-modules/mailer';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { Request } from 'express';
import { Logging } from 'src/schemas/logging.entity';
import { MemberReset } from 'src/schemas/member_reset.entity';
import { Member } from 'src/schemas/member.entity';
import { setPassword, generateToken } from 'src/helpers/authen.helper';
import * as Constants from 'src/constants';

@Injectable()
export class ResetService {

	private readonly logger = new Logger(ResetService.name);

	constructor(
		private readonly mailerService: MailerService,
		private readonly dataSource: DataSource,

		@InjectRepository(Logging)
		private readonly loggingRepo: Repository<Logging>,

		@InjectRepository(MemberReset)
		private readonly resetRepo: Repository<MemberReset>,

		@InjectRepository(Member)
		private readonly memberRepo: Repository<Member>,
	) { }

	// ----------------------------------------------------------------------

	/**
	 * Receives password reset form and sends email to member.
	 * 
	 * @param req The request.
	 * @param email Email as member to reset password.
	 * @returns The URL to confirm password reset in email.
	 */
	async request(
		req: Request,
		email: string,
	): Promise<{
		member: MemberReset,
		url: string,
	}> {
		// first, checks this input email
		// this email must be valid in member table
		const member = await this.memberRepo.findOne({ where: { email } })
		if (!member)
			throw new NotFoundException();

		// creates reset
		const reset = new MemberReset();
		reset.email = email;
		reset.confirmToken = generateToken();
		await this.resetRepo.save(reset);

		// creates url
		const url = `${req.protocol}://${req.get('host')}${Constants.ControllerPrefix}members/reset-password?code=${reset.confirmToken}`;

		// sends email
		await this.mailerService.sendMail({
			to: reset.email,
			subject: `Reset password email`,
			template: 'member_reset',
			context: {
				email: reset.email,
				token: reset.confirmToken,
				url,
			},
		});

		return {
			member: reset,
			url,
		};
	}

	// ----------------------------------------------------------------------

	/**
	 * Confirms the password reset.  This will generate new password and send new password to email.
	 * 
	 * @param req The request.
	 * @param code Code given from email.
	 * @returns The member which reset password.
	 */
	async resetPassword(
		req: Request,
		code: string,
	): Promise<Member> {
		// checks code
		if (!code || code.trim() === '')
			throw new NotFoundException();
		const reset = await this.resetRepo.findOne({ where: { confirmToken: code } });
		if (!reset)
			throw new NotFoundException();

		// checks if reset data must be valid
		const member = await this.memberRepo.findOne({
			where: {
				email: reset.email,
			},
			relations: [
				'credential',
			],
		})
		if (!member)
			throw new NotFoundException();

		// generates new password
		const generate = generateToken().substring(0, 8);
		const password = setPassword(generate);
		member.credential.salt = password.salt;
		member.credential.hash = password.hash;
		member.credential.token = null;
		this.logger.verbose(`${req.id} member password reset: ${JSON.stringify(member, null, 2)}`);

		// saves
		await this.dataSource.manager.save(member.credential);

		// adds log
		await this.loggingRepo.insert({
			memberId: member.id,
			action: 'update',
			table: 'member',
			description: `Member ${member.id}/${member.email} is reset password.`,
		});

		// sends mail
		await this.mailerService.sendMail({
			to: member.email,
			subject: "You have reset your password!",
			template: 'new_password',
			context: {
				email: member.email,
				password: generate,
			}
		});

		return member;
	}

}
