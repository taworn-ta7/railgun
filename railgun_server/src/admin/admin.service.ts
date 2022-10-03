import {
	Logger,
	Injectable,
	NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { Request } from 'express';
import { Logging } from 'src/schemas/logging.entity';
import { Member, MemberRole } from 'src/schemas/member.entity';
import { MemberDisabledDto } from 'src/dtos/member.dto';

@Injectable()
export class AdminService {

	private readonly logger = new Logger(AdminService.name);

	constructor(
		private readonly dataSource: DataSource,

		@InjectRepository(Logging)
		private readonly loggingRepo: Repository<Logging>,

		@InjectRepository(Member)
		private readonly memberRepo: Repository<Member>,
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
		const member = await this.memberRepo.findOne({
			where: {
				email,
				role: MemberRole.member,
			},
			relations: [
				'credential',
			],
		});
		if (!member)
			throw new NotFoundException();

		// updates
		const now = new Date();
		member.disabled = dto.disabled ? now : null;
		member.end = null;
		member.credential.token = null;
		await this.dataSource.manager.save(member);

		// adds log
		await this.loggingRepo.insert({
			memberId: req.member.id,
			action: 'update',
			table: 'member',
			description: `Admin ${req.member.id}/${req.member.email} changed ${member.id}/${member.email}, disabled = ${dto.disabled}.`,
		});

		return member;
	}

}
