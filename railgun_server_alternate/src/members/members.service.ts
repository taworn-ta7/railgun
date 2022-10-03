import {
	Logger,
	Injectable,
	NotFoundException,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Request, Response } from 'express';
import * as path from 'path';
import * as fs from 'fs';
import * as mime from 'mime-types';
import { Member, MemberRole } from 'src/schemas/member.schema';
import { Pagination, getPagination, queryPagingData } from 'src/helpers/pagination.helper';
import { reduceMemberData } from 'src/helpers/authen.helper';

@Injectable()
export class MembersService {

	private readonly logger = new Logger(MembersService.name);

	constructor(
		@InjectModel(Member.name)
		private readonly memberModel: Model<Member>,
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

		// search conditions
		let searchCond = undefined;
		if (search && search.length > 0) {
			const regex = new RegExp(search, 'i');
			searchCond = {
				$or: [
					{ email: regex },
					{ name: regex },
				],
			};
		}

		// trash conditions
		let trashCond = undefined;
		if (!trash) {
			trashCond = {
				disabled: null,
				resigned: null,
			};
		}
		else {
			trashCond = {
				$or: [
					{ disabled: { $ne: null } },
					{ resigned: { $ne: null } },
				],
			};
		}

		// conditions
		let conditions = [];
		if (searchCond)
			conditions.push(searchCond);
		if (trashCond)
			conditions.push(trashCond);
		const where = {
			$and: conditions,
			role: { $ne: MemberRole.admin },
		};
		const query = where;
		this.logger.debug(`${req.id} query: ${JSON.stringify(query, null, 2)}`);

		// finds and counts
		const count = await this.memberModel.count(query);
		const members = await this.memberModel.find(query, null, {
			skip: page * rowsPerPage,
			limit: rowsPerPage,
		}).sort(order).exec();

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
		const member = await this.memberModel.findOne({ email });
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
		const member = await this.memberModel.findOne({ email });
		if (!member)
			throw new NotFoundException();

		const dir = path.join(process.cwd(), process.env.UPLOAD_DIR, member._id.toString(), 'profile');
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
