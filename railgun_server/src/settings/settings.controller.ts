import {
	Logger,
	Controller,
	Req,
	Get,
	Put,
	Param,
	Body,
	UseGuards,
} from '@nestjs/common';
import { Request } from 'express';
import { Member } from 'src/schemas/member.entity';
import { AuthenGuard } from 'src/authen/authen.guard';
import { SettingsDto } from 'src/dtos/settings.dto';
import { reduceMemberData } from 'src/helpers/authen.helper';
import * as Constants from 'src/constants';
import { SettingsService } from './settings.service';

@Controller(`${Constants.ControllerPrefix}settings`)
@UseGuards(AuthenGuard)
export class SettingsController {

	private readonly logger = new Logger(SettingsController.name);

	constructor(
		private readonly service: SettingsService,
	) { }

	// ----------------------------------------------------------------------

	@Put('change')
	async change(
		@Req() req: Request,
		@Body('member') dto: SettingsDto,
	): Promise<{
		member: Member,
	}> {
		const member = await this.service.change(req, dto);
		return {
			member: reduceMemberData(member),
		};
	}

	// ----------------------------------------------------------------------

	@Put(':key/:value')
	async set(
		@Req() req: Request,
		@Param('key') key: string,
		@Param('value') value: string,
	): Promise<void> {
		return await this.service.set(req, key, value);
	}

	@Get(':key')
	async get(
		@Req() req: Request,
		@Param('key') key: string,
	): Promise<{
		value: string,
	}> {
		return {
			value: await this.service.get(req, key),
		}
	}

	@Get('')
	async getAll(
		@Req() req: Request,
	): Promise<Object> {
		const settings = await this.service.getAll(req);
		return {
			settings,
		}
	}

	@Put('')
	async reset(
		@Req() req: Request,
	): Promise<void> {
		return await this.service.reset(req);
	}

}
