import {
	Logger,
	Controller,
	Req,
	Get,
	Put,
	Body,
	UseGuards,
	UseInterceptors,
} from '@nestjs/common';
import { Request } from 'express';
import { Member } from 'src/schemas/member.entity';
import { MemberSignInDto } from 'src/dtos/member.dto';
import { reduceMemberData } from 'src/helpers/authen.helper';
import { DumpHeaderInterceptor, DumpBodyInterceptor } from 'src/dump.interceptor';
import * as Constants from 'src/constants';
import { AuthenGuard } from './authen.guard';
import { AuthenService } from './authen.service';

@Controller(`${Constants.ControllerPrefix}authen`)
export class AuthenController {

	private readonly logger = new Logger(AuthenController.name);

	constructor(
		private readonly service: AuthenService,
	) { }

	// ----------------------------------------------------------------------

	@Put('signin')
	@UseInterceptors(DumpBodyInterceptor)
	@UseInterceptors(DumpHeaderInterceptor)
	async signIn(
		@Req() req: Request,
		@Body('signin') dto: MemberSignInDto,
	): Promise<{
		member: Member,
		token: string,
	}> {
		const member = await this.service.signIn(req, dto);
		return {
			member: reduceMemberData(member),
			token: member.credential.token,
		};
	}

	@Put('signout')
	@UseGuards(AuthenGuard)
	async signOut(
		@Req() req: Request,
	): Promise<{
		member: Member,
	}> {
		await this.service.signOut(req);
		return {
			member: reduceMemberData(req.member),
		};
	}

	@Get('check')
	@UseGuards(AuthenGuard)
	async check(
		@Req() req: Request,
	): Promise<{
		member: Member,
	}> {
		return {
			member: reduceMemberData(req.member),
		};
	}

}
