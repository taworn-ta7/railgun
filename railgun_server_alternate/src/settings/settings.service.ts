import {
	Logger,
	Injectable,
	NotFoundException,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Request } from 'express';
import { Logging } from 'src/schemas/logging.schema';
import { Member } from 'src/schemas/member.schema';
import { SettingsDto } from 'src/dtos/settings.dto';
import * as Constants from 'src/constants';

@Injectable()
export class SettingsService {

	private readonly logger = new Logger(SettingsService.name);

	constructor(
		@InjectModel(Logging.name)
		private readonly loggingModel: Model<Logging>,

		@InjectModel(Member.name)
		private readonly memberModel: Model<Member>,
	) { }

	// ----------------------------------------------------------------------

	/**
	 * Changes current settings.  Currently, it has just one setting: locale.
	 */
	async change(
		req: Request,
		dto: SettingsDto,
	): Promise<Member> {
		const member = req.member;
		if (typeof dto.locale === 'string')
			member.locale = dto.locale;
		await member.save();

		// adds log
		await this.loggingModel.create({
			_id: new Types.ObjectId(),
			memberId: member._id,
			action: 'update',
			table: 'member',
			description: `Member ${member._id}/${member.email} settings changed.`,
		});

		return member;
	}

	// ----------------------------------------------------------------------

	/**
	 * Sets key-value generic settings.
	 */
	async set(
		req: Request,
		key: string,
		value: string,
	): Promise<void> {
		const member = req.member;

		// checks with available settings list
		const index = Constants.AvailableSettings.findIndex((v) => v === key);
		if (index < 0)
			throw new NotFoundException();

		// upserts
		member.settings.set(key, value);
		await member.save();

		// adds log
		await this.loggingModel.create({
			_id: new Types.ObjectId(),
			memberId: member._id,
			action: 'upsert',
			table: 'member_settings',
			description: `Member ${member._id}/${member.email} is set ${key}=${value}.`,
		});
	}

	/**
	 * Gets key-value generic settings.  Returns value string, or null if key not exists.
	 */
	async get(
		req: Request,
		key: string,
	): Promise<string> {
		const member = req.member;
		return member.settings.get(key) ?? null;
	}

	/**
	 * Gets all generic settings.  Returns all key-value pairs.
	 */
	async getAll(
		req: Request,
	): Promise<Object> {
		const member = req.member;
		return member.settings;
	}

	/**
	 * Deletes all generic settings.  This function is use for reset.
	 */
	async reset(
		req: Request,
	): Promise<void> {
		const member = req.member;

		// removes all settings
		member.settings = new Map();
		await member.save();

		// adds log
		await this.loggingModel.create({
			_id: new Types.ObjectId(),
			memberId: member._id,
			action: 'delete',
			table: 'member_settings',
			description: `Member ${member._id}/${member.email} is reset settings.`,
		});
	}

}
