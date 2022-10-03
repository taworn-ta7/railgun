import {
	Logger,
	Injectable,
	UnauthorizedException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Request } from 'express';
import * as queryString from 'query-string';
import * as path from 'path';
import * as fs from 'fs';
import { Logging } from 'src/schemas/logging.entity';
import { Member } from 'src/schemas/member.entity';
import { Axios } from 'src/helpers/axios.helper';
import { AuthenXService } from './authenx.service';

@Injectable()
export class AuthenXGoogleService {

	private readonly logger = new Logger(AuthenXGoogleService.name);

	constructor(
		@InjectRepository(Logging)
		private readonly loggingRepo: Repository<Logging>,

		private readonly common: AuthenXService,
	) { }

	// ----------------------------------------------------------------------

	/**
	 * Sign-in using Google.
	 */
	async signInExternal(
		req: Request,
		code: string,
		scope: string,
		authuser: string,
		prompt: string,
	): Promise<Member> {
		const redirectUrl = process.env.GOOGLE_REDIRECT_URL;

		// retrieves for token
		let token;
		{
			const url = `https://oauth2.googleapis.com/token`;
			const result = await Axios.call(url, {
				method: 'POST',
				headers: {
					'Content-Type': 'application/x-www-form-urlencoded',
				},
				data: queryString.stringify({
					code,
					client_id: process.env.GOOGLE_CLIENT_ID,
					client_secret: process.env.GOOGLE_CLIENT_SECRET,
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
			const url = `https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=${token.access_token}`;
			const result = await Axios.call(url, {
				method: 'GET',
				headers: {
					'Authorization': `Bearer ${token.id_token}`,
				},
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
				const dir = path.join(process.cwd(), process.env.UPLOAD_DIR, member.id, 'profile');
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
		await this.loggingRepo.insert({
			memberId: member.id,
			action: 'update',
			table: 'member',
			description: `Member ${member.id}/${member.email} is sign-in from Google.`,
		});

		return member;
	}

}
