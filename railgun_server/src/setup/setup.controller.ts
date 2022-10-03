import {
	Logger,
	Controller,
	Post,
	Req,
} from '@nestjs/common';
import { Request } from 'express';
import * as Constants from 'src/constants';
import { SetupService } from './setup.service';

@Controller(`${Constants.ControllerPrefix}setup`)
export class SetupController {

	private readonly logger = new Logger(SetupController.name);

	constructor(
		private readonly service: SetupService,
	) { }

	// ----------------------------------------------------------------------

	@Post()
	async setup(
		@Req() req: Request,
	): Promise<string> {
		return await this.service.setup(req);
	}

}
