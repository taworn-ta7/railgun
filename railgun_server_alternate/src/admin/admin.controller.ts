import {
	Logger,
	Controller,
	Req,
	Put,
	Param,
	Query,
	Body,
	UseGuards,
} from '@nestjs/common';
import { Request } from 'express';
import { Member } from 'src/schemas/member.schema';
import { AuthenAdminGuard } from 'src/authen/authen.guard';
import { MemberDisabledDto } from 'src/dtos/member.dto';
import { reduceMemberData } from 'src/helpers/authen.helper';
import * as Constants from 'src/constants';
import { SignUpService } from 'src/members/signup.service';
import { AdminService } from './admin.service';

@Controller(`${Constants.ControllerPrefix}admin`)
@UseGuards(AuthenAdminGuard)
export class AdminController {

	private readonly logger = new Logger(AdminController.name);

	constructor(
		private readonly service: AdminService,
		private readonly signUpService: SignUpService,
	) { }

	// ----------------------------------------------------------------------

	@Put('members/authorize')
	async authorize(
		@Req() req: Request,
		@Query('code') code: string,
	): Promise<{
		member: Member,
	}> {
		const member = await this.signUpService.create(req, code);
		return {
			member: reduceMemberData(member),
		}
	}

	// ----------------------------------------------------------------------

	@Put('members/disable/:email')
	async disable(
		@Req() req: Request,
		@Param('email') email: string,
		@Body('member') dto: MemberDisabledDto,
	): Promise<{
		member: Member,
	}> {
		const member = await this.service.disable(req, email, dto);
		return {
			member: reduceMemberData(member),
		}
	}

}
