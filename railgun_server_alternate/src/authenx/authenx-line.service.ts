import {
	Logger,
	Injectable,
	UnauthorizedException,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Request } from 'express';
import * as queryString from 'query-string';
import * as path from 'path';
import * as fs from 'fs';
import { Logging } from 'src/schemas/logging.schema';
import { Member } from 'src/schemas/member.schema';
import { Axios } from 'src/helpers/axios.helper';
import { AuthenXService } from './authenx.service';

@Injectable()
export class AuthenXLineService {

	private readonly logger = new Logger(AuthenXLineService.name);

	constructor(
		@InjectModel(Logging.name)
		private readonly loggingModel: Model<Logging>,

		private readonly common: AuthenXService,
	) { }

	// ----------------------------------------------------------------------

	/**
	 * Sign-in using LINE.
	 */
	async signInExternal(
		req: Request,
		code: string,
		state: string,
	): Promise<Member> {
		const redirectUrl = process.env.LINE_REDIRECT_URL;

		// retrieves for token
		let token;
		{
			const url = `https://api.line.me/oauth2/v2.1/token`;
			const result = await Axios.call(url, {
				method: 'POST',
				headers: {
					'Content-Type': 'application/x-www-form-urlencoded',
				},
				data: queryString.stringify({
					code,
					client_id: process.env.LINE_CLIENT_ID,
					client_secret: process.env.LINE_CLIENT_SECRET,
					redirect_uri: redirectUrl,
					grant_type: 'authorization_code',
				}),
			});
			if (result.status !== 200) {
				this.logger.debug(`${req.id} ${result.status} ${url}`);
				throw new UnauthorizedException();
			}

			token = result.json;
			this.logger.debug(`${req.id} token: ${JSON.stringify(token, null, 2)}`);
			if (!token.access_token || !token.id_token) {
				throw new UnauthorizedException();
			}
		}

		// retrieves for member information
		let info;
		{
			const url = `https://api.line.me/oauth2/v2.1/verify?id_token=${token.id_token}&client_id=${process.env.LINE_CLIENT_ID}`;
			const result = await Axios.call(url, {
				method: 'POST',
			});
			if (result.status !== 200) {
				this.logger.debug(`${req.id} ${result.status} ${url}`);
				throw new UnauthorizedException();
			}

			info = await result.json;
			this.logger.debug(`${req.id} member: ${JSON.stringify(info, null, 2)}`);
			if (!info.email || !info.name) {
				throw new UnauthorizedException();
			}
		}

		// creates or loads member
		const { member, created } = await this.common.memberForExternalSignIn(req, info.email, info.locale, info.name);

		// if just created and have profile
		if (created && info.picture) {
			// loads profile icon from host
			const result = await Axios.call(info.picture, {
				responseType: 'arraybuffer',
			});
			if (result.status === 200) {
				// creates folder, if not exists
				const dir = path.join(process.cwd(), process.env.UPLOAD_DIR, member._id.toString(), 'profile');
				await fs.promises.mkdir(dir, { recursive: true });
				this.logger.debug(`dir: ${dir}`);

				// deletes old image file, if it exists
				const iconFile = path.join(dir, `icon`);
				try {
					await fs.promises.access(iconFile);
					await fs.promises.rm(iconFile);
				}
				catch (ex) {
				}

				// writes mime
				const mimeFile = path.join(dir, `icon-mime`);
				await fs.promises.writeFile(mimeFile, 'image/png');

				// writes file
				const buffer = Buffer.from(result.res.data);
				await fs.promises.writeFile(iconFile, buffer);
			}
		}

		// adds log
		await this.loggingModel.create({
			_id: new Types.ObjectId(),
			memberId: member._id,
			action: 'update',
			table: 'member',
			description: `Member ${member._id}/${member.email} is sign-in from LINE.`,
		});

		return member;
	}

}
