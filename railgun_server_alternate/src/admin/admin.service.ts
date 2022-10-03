import {
	Logger,
	Injectable,
	NotFoundException,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Request } from 'express';
import { Logging } from 'src/schemas/logging.schema';
import { Member, MemberRole } from 'src/schemas/member.schema';
import { MemberDisabledDto } from 'src/dtos/member.dto';

@Injectable()
export class AdminService {

	private readonly logger = new Logger(AdminService.name);

	constructor(
		@InjectModel(Logging.name)
		private readonly loggingModel: Model<Logging>,

		@InjectModel(Member.name)
		private readonly memberModel: Model<Member>,
	) { }

	// ----------------------------------------------------------------------

	/**
	 * Disables or enables a member.
	 */
	async disable(
		req: Request,
		email: string,
		dto: MemberDisabledDto,
	): Promise<Member> {
		const member = await this.memberModel.findOne({
			email,
			role: MemberRole.member,
		});
		if (!member)
			throw new NotFoundException();

		// updates
		const now = new Date();
		member.disabled = dto.disabled ? now : null;
		member.end = null;
		member.credential.token = null;
		await member.save();

		// adds log
		await this.loggingModel.create({
			_id: new Types.ObjectId(),
			memberId: req.member._id,
			action: 'update',
			table: 'member',
			description: `Admin ${req.member._id}/${req.member.email} changed ${member._id}/${member.email}, disabled = ${dto.disabled}.`,
		});

		return member;
	}

}
