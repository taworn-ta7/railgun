import {
	Logger,
	Injectable,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Request } from 'express';
import { MemberCredential } from 'src/schemas/member_credential.schema';
import { Member, MemberRole } from 'src/schemas/member.schema';
import { setPassword } from 'src/helpers/authen.helper';

@Injectable()
export class SetupService {

	private readonly logger = new Logger(SetupService.name);

	constructor(
		@InjectModel(Member.name)
		private readonly memberModel: Model<Member>,

		@InjectModel(MemberCredential.name)
		private readonly credentialModel: Model<MemberCredential>,
	) { }

	// ----------------------------------------------------------------------

	/**
	 * Setup and creates admin member.  Can run only once.
	 */
	async setup(
		req: Request,
	): Promise<string> {
		// checks if we already have 'admin' member?
		const check = await this.memberModel.findOne({
			email: process.env.MAIL_ADMIN,
			role: MemberRole.admin,
		});
		if (check)
			return `Already setup.`;

		// creates 'admin'
		const password = setPassword('admin');
		const member = new this.memberModel();
		member._id = new Types.ObjectId();
		member.email = process.env.MAIL_ADMIN;
		member.role = MemberRole.admin;
		member.locale = 'en';
		member.name = 'Administrator';
		member.disabled = null;
		member.resigned = null;
		member.begin = null;
		member.end = null;
		member.expire = null;
		member.credential = new this.credentialModel();
		member.credential.salt = password.salt;
		member.credential.hash = password.hash;
		member.credential.token = null;
		member.settings = new Map();

		// saves
		await member.save();

		this.logger.verbose(`${req.id} admin created: ${JSON.stringify(member, null, 2)}`);
		return `Setup completed :)`;
	}

}
