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
import { Member, MemberRole } from 'src/schemas/member.schema';
import { setPassword, generateToken, newOrUpdateToken } from 'src/helpers/authen.helper';
import Errors from 'src/helpers/errors.helper';

@Injectable()
export class AuthenXService {

	private readonly logger = new Logger(AuthenXService.name);

	constructor(
		@InjectModel(Logging.name)
		private readonly loggingModel: Model<Logging>,

		@InjectModel(Member.name)
		private readonly memberModel: Model<Member>,
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
		const member = await this.memberModel.findOne({ email })

		// not found, creates it
		if (!member) {
			// checks locale
			if (locale !== 'en' && locale !== 'th')
				locale = 'en';

			// creates member
			const generate = generateToken().substring(0, 8);
			const password = setPassword(generate);
			const member = new this.memberModel();
			member._id = new Types.ObjectId();
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
			member.credential._id = new Types.ObjectId();
			member.credential.salt = password.salt;
			member.credential.hash = password.hash;
			member.credential.token = null;
			member.settings = new Map();

			// updates token and saves
			await newOrUpdateToken(member);
			await member.save();

			// adds log
			await this.loggingModel.create({
				_id: new Types.ObjectId(),
				memberId: member._id,
				action: 'create',
				table: 'member',
				description: `Member ${member._id}/${member.email} is created via external sign-in.`,
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
			await member.save();

			this.logger.verbose(`${req.id} member loaded: ${JSON.stringify(member, null, 2)}`);
			return {
				member,
				created: false,
			};
		}
	}

}
