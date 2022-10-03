import {
	Logger,
	Injectable,
	UnauthorizedException,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Request } from 'express';
import { Logging } from 'src/schemas/logging.schema';
import { MemberCredential } from 'src/schemas/member_credential.schema';
import { Member } from 'src/schemas/member.schema';
import { MemberSignInDto } from 'src/dtos/member.dto';
import { validatePassword, newOrUpdateToken } from 'src/helpers/authen.helper';
import Errors from 'src/helpers/errors.helper';

@Injectable()
export class AuthenService {

	private readonly logger = new Logger(AuthenService.name);

	constructor(
		@InjectModel(Logging.name)
		private readonly loggingModel: Model<Logging>,

		@InjectModel(MemberCredential.name)
		private readonly credentialModel: Model<MemberCredential>,

		@InjectModel(Member.name)
		private readonly memberModel: Model<Member>,
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
		const member = await this.memberModel.findOne({ email: dto.email })
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
		await member.save();

		// adds log
		await this.loggingModel.create({
			_id: new Types.ObjectId(),
			memberId: member._id,
			action: 'update',
			table: 'member',
			description: `Member ${member._id}/${member.email} is sign-in.`,
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
		await req.member.save();

		// adds log
		await this.loggingModel.create({
			_id: new Types.ObjectId(),
			memberId: req.member._id,
			action: 'update',
			table: 'member',
			description: `Member ${req.member._id}/${req.member.email} is sign-out.`,
		});
	}

}
