import {
	Logger,
	Controller,
	Req,
	Get,
	Query,
	UseInterceptors,
} from '@nestjs/common';
import { Request } from 'express';
import { Member } from 'src/schemas/member.schema';
import { reduceMemberData } from 'src/helpers/authen.helper';
import { DumpHeaderInterceptor } from 'src/dump.interceptor';
import * as Constants from 'src/constants';
import { AuthenXGoogleService } from './authenx-google.service';
import { AuthenXLineService } from './authenx-line.service';

@Controller(`${Constants.ControllerPrefix}authenx`)
export class AuthenXController {

	private readonly logger = new Logger(AuthenXController.name);

	constructor(
		private readonly google: AuthenXGoogleService,
		private readonly line: AuthenXLineService,
	) { }

	// ----------------------------------------------------------------------

	@Get('google')
	@UseInterceptors(DumpHeaderInterceptor)
	async signInGoogle(
		@Req() req: Request,
		@Query('code') code: string,
		@Query('scope') scope: string,
		@Query('authuser') authuser: string,
		@Query('prompt') prompt: string,
	): Promise<{
		member: Member,
		token: string,
	}> {
		const member = await this.google.signInExternal(req, code, scope, authuser, prompt);
		return {
			member: reduceMemberData(member),
			token: member.credential.token,
		};
	}

	// ----------------------------------------------------------------------

	@Get('line')
	@UseInterceptors(DumpHeaderInterceptor)
	async signInLine(
		@Req() req: Request,
		@Query('code') code: string,
		@Query('state') state: string,
	): Promise<{
		member: Member,
		token: string,
	}> {
		const member = await this.line.signInExternal(req, code, state);
		return {
			member: reduceMemberData(member),
			token: member.credential.token,
		};
	}

}
