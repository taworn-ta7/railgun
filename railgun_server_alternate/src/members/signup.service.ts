import {
	Logger,
	Injectable,
	NotFoundException,
	ForbiddenException,
} from '@nestjs/common';
import { MailerService } from '@nestjs-modules/mailer';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Request } from 'express';
import { Logging } from 'src/schemas/logging.schema';
import { MemberSignUp } from 'src/schemas/member_signup.schema';
import { MemberCredential } from 'src/schemas/member_credential.schema';
import { Member, MemberRole } from 'src/schemas/member.schema';
import { MemberSignUpDto } from 'src/dtos/member.dto';
import { setPassword, generateToken } from 'src/helpers/authen.helper';

@Injectable()
export class SignUpService {

	private readonly logger = new Logger(SignUpService.name);

	constructor(
		private readonly mailerService: MailerService,

		@InjectModel(Logging.name)
		private readonly loggingModel: Model<Logging>,

		@InjectModel(MemberSignUp.name)
		private readonly signUpModel: Model<MemberSignUp>,

		@InjectModel(MemberCredential.name)
		private readonly credentialModel: Model<MemberCredential>,

		@InjectModel(Member.name)
		private readonly memberModel: Model<Member>,
	) { }

	// ----------------------------------------------------------------------

	/**
	 * Receives sign-up form and saves it to database.  Returns URL to let user confirm it.
	 * 
	 * @param req The request.
	 * @param dto Data pass in.
	 * @returns The sign-up data along with URL to confirm in email.
	 */
	async signUp(
		req: Request,
		dto: MemberSignUpDto,
	): Promise<{
		member: MemberSignUp,
		url: string,
	}> {
		// first, checks this input email
		// this email must not be in member table
		if (await this.memberModel.findOne({ email: dto.email }))
			throw new ForbiddenException();

		// creates sign-up
		const password = setPassword(dto.password);
		const signup = new this.signUpModel(dto);
		signup._id = new Types.ObjectId();
		signup.salt = password.salt;
		signup.hash = password.hash;
		signup.confirmToken = generateToken();
		await signup.save();

		// creates url
		const url = `${req.protocol}://${req.get('host')}${req.path}/confirm?code=${signup.confirmToken}`;

		// sends email
		await this.mailerService.sendMail({
			to: signup.email,
			subject: `Sign-up confirmation email`,
			template: 'member_signup',
			context: {
				email: signup.email,
				token: signup.confirmToken,
				url: url,
			},
		});

		return {
			member: signup,
			url,
		}
	}

	// ----------------------------------------------------------------------

	/**
	 * Confirms the sign-up form, then, copies sign-up data into member table.
	 * 
	 * @param req The request.
	 * @param code Code given from email.
	 * @returns The member created.
	 */
	async create(
		req: Request,
		code: string,
	): Promise<Member> {
		// checks code
		if (!code || code.trim() === '')
			throw new NotFoundException();
		const signup = await this.signUpModel.findOne({ confirmToken: code });
		if (!signup)
			throw new NotFoundException();

		// checks if sign-up data already created member or not
		if (await this.memberModel.findOne({ email: signup.email }))
			throw new ForbiddenException();

		// generates name from email
		const names = signup.email.split("@");
		const name = names[0].charAt(0).toUpperCase() + names[0].slice(1);

		// creates member
		const member = new this.memberModel();
		member._id = new Types.ObjectId();
		member.email = signup.email;
		member.role = MemberRole.member;
		member.locale = signup.locale;
		member.name = name;
		member.disabled = null;
		member.resigned = null;
		member.begin = null;
		member.end = null;
		member.expire = null;
		member.credential = new this.credentialModel();
		member.credential._id = new Types.ObjectId();
		member.credential.salt = signup.salt;
		member.credential.hash = signup.hash;
		member.credential.token = null;
		member.settings = new Map();

		// saves
		await member.save();

		// adds log
		await this.loggingModel.create({
			_id: new Types.ObjectId(),
			memberId: member._id,
			action: 'create',
			table: 'member',
			description: `Member ${member._id}/${member.email} is sign-up and confirm.`,
		});

		this.logger.verbose(`${req.id} member created: ${JSON.stringify(member, null, 2)}`);
		return member;
	}

}
