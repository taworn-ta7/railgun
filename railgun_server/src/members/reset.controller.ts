import {
	Logger,
	Controller,
	Req,
	Get,
	Post,
	Query,
	Body,
} from '@nestjs/common';
import { Request } from 'express';
import { MemberReset } from 'src/schemas/member_reset.entity';
import { Member } from 'src/schemas/member.entity';
import { MemberResetDto } from 'src/dtos/member.dto';
import { reduceMemberData } from 'src/helpers/authen.helper';
import * as Constants from 'src/constants';
import { ResetService } from './reset.service';

@Controller(`${Constants.ControllerPrefix}members`)
export class ResetController {

	private readonly logger = new Logger(ResetController.name);

	constructor(
		private readonly service: ResetService,
	) { }

	// ----------------------------------------------------------------------

	@Post('request-reset')
	async request(
		@Req() req: Request,
		@Body('member') dto: MemberResetDto,
	): Promise<{
		member: MemberReset,
		url: string,
	}> {
		const reset = await this.service.request(req, dto.email);
		return reset;
	}

	@Get('reset-password')
	async resetPassword(
		@Req() req: Request,
		@Query('code') code: string,
	): Promise<{
		member: Member,
	}> {
		const member = await this.service.resetPassword(req, code);
		return {
			member: reduceMemberData(member),
		};
	}

}
