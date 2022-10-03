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
import { MemberSignUp } from 'src/schemas/member_signup.schema';
import { Member } from 'src/schemas/member.schema';
import { MemberSignUpDto } from 'src/dtos/member.dto';
import { reduceMemberData } from 'src/helpers/authen.helper';
import * as Constants from 'src/constants';
import { SignUpService } from './signup.service';

@Controller(`${Constants.ControllerPrefix}members`)
export class SignUpController {

	private readonly logger = new Logger(SignUpController.name);

	constructor(
		private readonly service: SignUpService,
	) { }

	// ----------------------------------------------------------------------

	@Post('signup')
	async signUp(
		@Req() req: Request,
		@Body('member') dto: MemberSignUpDto,
	): Promise<{
		member: MemberSignUp,
		url: string,
	}> {
		return await this.service.signUp(req, dto);
	}

	@Get('signup/confirm')
	async confirm(
		@Req() req: Request,
		@Query('code') code: string,
	): Promise<{
		member: Member,
	}> {
		const member = await this.service.create(req, code);
		return {
			member: reduceMemberData(member),
		};
	}

}
