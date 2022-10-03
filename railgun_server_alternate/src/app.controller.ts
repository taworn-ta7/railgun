import {
	Logger,
	Controller,
	Get,
} from '@nestjs/common';
import * as Constants from 'src/constants';
import { AppService } from './app.service';

@Controller(Constants.ControllerPrefix)
export class AppController {

	private readonly logger = new Logger(AppController.name);

	constructor(
		private readonly service: AppService,
	) { }

	// ----------------------------------------------------------------------

	@Get('about')
	about(): {
		app: string,
		version: string,
	} {
		return this.service.about();
	}

	@Get('config')
	config(): any {
		return this.service.config();
	}

}
