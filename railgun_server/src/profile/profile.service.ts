import {
	Logger,
	Injectable,
	BadRequestException,
	UnauthorizedException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { Request, Response } from 'express';
import * as path from 'path';
import * as fs from 'fs';
import * as mime from 'mime-types';
import { inspect } from 'util';
import { Logging } from 'src/schemas/logging.entity';
import { Member } from 'src/schemas/member.entity';
import { ProfileChangeNameDto, ProfileChangePasswordDto } from 'src/dtos/profile.dto';
import { setPassword, validatePassword } from 'src/helpers/authen.helper';
import { convertBytes } from 'src/helpers/convert.helper';
import Errors from 'src/helpers/errors.helper';

@Injectable()
export class ProfileService {

	private readonly logger = new Logger(ProfileService.name);

	constructor(
		private readonly dataSource: DataSource,

		@InjectRepository(Logging)
		private readonly loggingRepo: Repository<Logging>,

		@InjectRepository(Member)
		private readonly memberRepo: Repository<Member>,
	) { }

	// ----------------------------------------------------------------------

	/**
	 * Uploads picture to use as member profile icon.
	 */
	async changeIcon(
		req: Request,
		file: Express.Multer.File,
	) {
		// checks uploaded image
		this.logger.verbose(`${req.id} image: ${inspect(file)}`);
		if (!file)
			throw new BadRequestException();
		if (file.mimetype !== 'image/png' && file.mimetype !== 'image/jpeg' && file.mimetype !== 'image/gif')
			throw new BadRequestException(Errors.uploadIsNotTypeImage);
		const limit = +process.env.PROFILE_ICON_FILE_LIMIT;
		if (file.size >= limit)
			throw new BadRequestException(Errors.uploadIsTooBig(convertBytes(limit)));

		// creates folder, if not exists
		const member = req.member;
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
		await fs.promises.writeFile(mimeFile, file.mimetype);

		// moves file
		await fs.promises.writeFile(iconFile, file.buffer);

		// adds log
		await this.loggingRepo.insert({
			memberId: member.id,
			action: 'update',
			table: 'member',
			description: `Member ${member.id}/${member.email} uploaded profile icon.`,
		});
	}

	/**
	 * Views the uploaded profile icon.
	 */
	async viewIcon(
		req: Request,
		res: Response,
	) {
		const member = req.member;
		const dir = path.join(process.cwd(), process.env.UPLOAD_DIR, member.id, 'profile');
		const iconFile = path.join(dir, `icon`);
		const mimeFile = path.join(dir, `icon-mime`);
		let data: fs.ReadStream;
		let contentType: string;
		try {
			await fs.promises.access(iconFile);
			data = fs.createReadStream(iconFile);
			const buffer = await fs.promises.readFile(mimeFile);
			contentType = buffer.toString();
		}
		catch (ex) {
			const defaultFile = path.resolve(path.join(__dirname, '..', 'assets', 'default-profile-icon.png'));
			data = fs.createReadStream(defaultFile);
			contentType = mime.contentType(defaultFile);
		}

		res.writeHead(200, { 'Content-Type': contentType });
		data.pipe(res);
	}

	/**
	 * Deletes the uploaded profile icon and reverts profile icon to defaults.
	 */
	async deleteIcon(
		req: Request,
	) {
		// deletes icon and mime files
		const member = req.member;
		const dir = path.join(process.cwd(), process.env.UPLOAD_DIR, member.id, 'profile');
		const iconFile = path.join(dir, `icon`);
		const mimeFile = path.join(dir, `icon-mime`);
		try {
			await fs.promises.access(iconFile);
			await fs.promises.rm(iconFile);
		}
		catch (ex) {
		}
		try {
			await fs.promises.access(mimeFile);
			await fs.promises.rm(mimeFile);
		}
		catch (ex) {
		}

		// adds log
		await this.loggingRepo.insert({
			memberId: member.id,
			action: 'update',
			table: 'member',
			description: `Member ${member.id}/${member.email} deleted profile icon.`,
		});
	}

	// ----------------------------------------------------------------------

	/**
	 * Changes the current name.
	 */
	async changeName(
		req: Request,
		dto: ProfileChangeNameDto,
	): Promise<Member> {
		const member = req.member;
		member.name = dto.name;
		await this.memberRepo.save(member);

		// adds log
		await this.loggingRepo.insert({
			memberId: member.id,
			action: 'update',
			table: 'member',
			description: `Member ${member.id}/${member.email} changed name.`,
		});

		return member;
	}

	// ----------------------------------------------------------------------

	/**
	 * Changes the current password.  After the password is changed, 
	 * you will be sign-out and need to sign-in again.
	 */
	async changePassword(
		req: Request,
		dto: ProfileChangePasswordDto,
	): Promise<Member> {
		const member = req.member;
		if (!validatePassword(dto.currentPassword, member.credential.salt, member.credential.hash))
			throw new UnauthorizedException(Errors.passwordIsIncorrect);

		const password = setPassword(dto.newPassword);
		member.end = new Date();
		member.credential.salt = password.salt;
		member.credential.hash = password.hash;
		member.credential.token = null;
		await this.dataSource.manager.save(member);

		// adds log
		await this.loggingRepo.insert({
			memberId: member.id,
			action: 'update',
			table: 'member',
			description: `Member ${member.id}/${member.email} changed password!`,
		});

		return member;
	}

}
