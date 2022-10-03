import {
	Logger,
	Injectable,
	NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { Request, Response } from 'express';
import * as path from 'path';
import * as fs from 'fs';
import * as mime from 'mime-types';
import { Member, MemberRole } from 'src/schemas/member.entity';
import { Pagination, getPagination, queryPagingData } from 'src/helpers/pagination.helper';
import { reduceMemberData } from 'src/helpers/authen.helper';

@Injectable()
export class MembersService {

	private readonly logger = new Logger(MembersService.name);

	constructor(
		private readonly dataSource: DataSource,

		@InjectRepository(Member)
		private readonly memberRepo: Repository<Member>,
	) { }

	// ----------------------------------------------------------------------

	/**
	 * Lists members with conditions.  All parameters are optional.
	 */
	async list(
		req: Request,
		pageSize?: number,
	): Promise<{
		members: Member[],
		pagination: Pagination,
	}> {
		// gets paging query
		const { page, order, search, trash } = queryPagingData(req, {
			email: 'email',
			name: 'name',
			created: 'created',
			updated: 'updated',
		});
		const rowsPerPage = pageSize && pageSize > 0 ? pageSize : 10;

		// conditions
		let query = "member.role != :role";
		if (search && search.length > 0)
			query += " AND (member.email LIKE :search OR member.name LIKE :search)";
		if (!trash)
			query += " AND (member.disabled IS NULL AND member.resigned IS NULL)";
		else
			query += " AND (member.disabled IS NOT NULL OR member.resigned IS NOT NULL)";
		this.logger.debug(`${req.id} query: ${JSON.stringify(query, null, 2)}`);

		// finds and counts
		const [members, count] = await this.dataSource
			.getRepository(Member)
			.createQueryBuilder()
			.where(query, { role: MemberRole.admin, search: `%${search}%` })
			.orderBy(order)
			.skip(page * rowsPerPage)
			.take(rowsPerPage)
			.getManyAndCount();

		// reduces and returns
		const reduces = members.map((item) => reduceMemberData(item));
		return {
			members: reduces,
			pagination: getPagination(page, rowsPerPage, count),
		};
	}

	// ----------------------------------------------------------------------

	/**
	 * Gets member's information.
	 */
	async get(
		req: Request,
		email: string,
	): Promise<Member> {
		const member = await this.memberRepo.findOne({ where: { email } });
		if (!member)
			throw new NotFoundException();
		return member;
	}

	// ----------------------------------------------------------------------

	/**
	 * Gets member's icons.
	 */
	async getIcon(
		req: Request,
		res: Response,
		email: string,
	) {
		const member = await this.memberRepo.findOne({ where: { email } });
		if (!member)
			throw new NotFoundException();

		const dir = path.join(process.cwd(), process.env.UPLOAD_DIR, member.id, 'profile');
		const iconFile = path.join(dir, `icon`);
		const mimeFile = path.join(dir, `icon-mime`);
		let data: fs.ReadStream;
		let contentType: string;
		try {
			await fs.promises.access(iconFile);
			data = fs.createReadStream(iconFile);
			const buffer = await fs.promises.readFile(mimeFile);
			contentType = buffer.toString();
		}
		catch (ex) {
			const defaultFile = path.resolve(path.join(__dirname, '..', 'assets', 'default-profile-icon.png'));
			data = fs.createReadStream(defaultFile);
			contentType = mime.contentType(defaultFile);
		}

		res.writeHead(200, { 'Content-Type': contentType });
		data.pipe(res);
	}

}
