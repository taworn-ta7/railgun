import {
	Logger,
	Controller,
	Req,
	Res,
	Get,
	Param,
	Query,
} from '@nestjs/common';
import { Request, Response } from 'express';
import { Member } from 'src/schemas/member.entity';
import { reduceMemberData } from 'src/helpers/authen.helper';
import { Pagination } from 'src/helpers/pagination.helper';
import * as Constants from 'src/constants';
import { MembersService } from './members.service';

@Controller(`${Constants.ControllerPrefix}members`)
export class MembersController {

	private readonly logger = new Logger(MembersController.name);

	constructor(
		private readonly service: MembersService,
	) { }

	// ----------------------------------------------------------------------

	@Get()
	async list(
		@Req() req: Request,
		@Query('size') size: number,
	): Promise<{
		members: Member[],
		pagination: Pagination,
	}> {
		const pageSize = Number(size);
		return await this.service.list(req, pageSize);
	}

	@Get(':email')
	async get(
		@Req() req: Request,
		@Param('email') email: string,
	): Promise<{
		member: Member,
	}> {
		const member = await this.service.get(req, email);
		return {
			member: reduceMemberData(member),
		}
	}

	@Get(':email/icon')
	async getIcon(
		@Req() req: Request,
		@Res() res: Response,
		@Param('email') email: string,
	): Promise<void> {
		await this.service.getIcon(req, res, email);
	}

}
