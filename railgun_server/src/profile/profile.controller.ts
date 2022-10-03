import {
	Logger,
	Controller,
	Req,
	Res,
	Get,
	Put,
	Post,
	Delete,
	Body,
	UploadedFile,
	UseInterceptors,
	UseGuards,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { Express, Request, Response } from 'express';
import { Member } from 'src/schemas/member.entity';
import { AuthenGuard } from 'src/authen/authen.guard';
import { ProfileChangeNameDto, ProfileChangePasswordDto } from 'src/dtos/profile.dto';
import { reduceMemberData } from 'src/helpers/authen.helper';
import * as Constants from 'src/constants';
import { ProfileService } from './profile.service';

@Controller(`${Constants.ControllerPrefix}profile`)
@UseGuards(AuthenGuard)
export class ProfileController {

	private readonly logger = new Logger(ProfileController.name);

	constructor(
		private readonly service: ProfileService,
	) { }

	// ----------------------------------------------------------------------

	@Post('icon')
	@UseInterceptors(FileInterceptor('image'))
	async changeIcon(
		@Req() req: Request,
		@UploadedFile() file: Express.Multer.File,
	): Promise<{
		image: {
			protocol: string,
			host: string,
			path: string,
			name: string,
			url: string,
		},
	}> {
		// changes icon
		await this.service.changeIcon(req, file);

		// generates output
		const name = `icon`;
		const part = `/${process.env.UPLOAD_DIR}/${req.member.id}/profile`;
		const host = req.get('host');
		const protocol = req.protocol;

		// success
		return {
			image: {
				protocol,
				host,
				path: part,
				name,
				url: `${protocol}://${host}${part}/${name}`,
			},
		};
	}

	@Get('icon')
	async viewIcon(
		@Req() req: Request,
		@Res() res: Response,
	): Promise<void> {
		await this.service.viewIcon(req, res);
	}

	@Delete('icon')
	async deleteIcon(
		@Req() req: Request,
	): Promise<void> {
		await this.service.deleteIcon(req);
	}

	// ----------------------------------------------------------------------

	@Put('name')
	async changeName(
		@Req() req: Request,
		@Body('member') dto: ProfileChangeNameDto,
	): Promise<{
		member: Member,
	}> {
		const member = await this.service.changeName(req, dto);
		return {
			member: reduceMemberData(member),
		};
	}

	// ----------------------------------------------------------------------

	@Put('password')
	async changePassword(
		@Req() req: Request,
		@Body('member') dto: ProfileChangePasswordDto,
	): Promise<{
		member: Member,
	}> {
		const member = await this.service.changePassword(req, dto);
		return {
			member: reduceMemberData(member),
		};
	}

}
