import {
	Logger,
	Injectable,
	NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { Request } from 'express';
import { Logging } from 'src/schemas/logging.entity';
import { MemberSettings } from 'src/schemas/member_settings.entity';
import { Member } from 'src/schemas/member.entity';
import { SettingsDto } from 'src/dtos/settings.dto';
import { generateUlid } from 'src/helpers/ulid.helper';
import * as Constants from 'src/constants';

@Injectable()
export class SettingsService {

	private readonly logger = new Logger(SettingsService.name);

	constructor(
		private readonly dataSource: DataSource,

		@InjectRepository(Logging)
		private readonly loggingRepo: Repository<Logging>,

		@InjectRepository(MemberSettings)
		private readonly settingsRepo: Repository<MemberSettings>,

		@InjectRepository(Member)
		private readonly memberRepo: Repository<Member>,
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
		await this.memberRepo.save(member);

		// adds log
		await this.loggingRepo.insert({
			memberId: member.id,
			action: 'update',
			table: 'member',
			description: `Member ${member.id}/${member.email} settings changed.`,
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
		let setting = await this.dataSource
			.getRepository(MemberSettings)
			.createQueryBuilder('settings')
			.where('settings.memberId = :id', { id: member.id })
			.andWhere('settings.key = :key', { key })
			.getOne();
		if (setting) {
			setting.value = value.slice(0, 512);
		}
		else {
			setting = new MemberSettings();
			setting.id = generateUlid();
			setting.member = member;
			setting.key = key;
			setting.value = value.slice(0, 512);
		}
		await this.settingsRepo.save(setting);

		// adds log
		await this.loggingRepo.insert({
			memberId: member.id,
			action: 'upsert',
			table: 'member_settings',
			description: `Member ${member.id}/${member.email} is set ${key}=${value}.`,
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

		// finds one
		const setting = await this.dataSource
			.getRepository(MemberSettings)
			.createQueryBuilder('settings')
			.where('settings.memberId = :id', { id: member.id })
			.andWhere('settings.key = :key', { key })
			.getOne();

		return await setting ? setting.value : null;
	}

	/**
	 * Gets all generic settings.  Returns all key-value pairs.
	 */
	async getAll(
		req: Request,
	): Promise<Object> {
		const member = req.member;

		// finds all
		const settings = await this.dataSource
			.getRepository(MemberSettings)
			.createQueryBuilder('settings')
			.where('settings.memberId = :id', { id: member.id })
			.getMany();

		// maps array to dictionary
		const result = {}
		for (let i = 0; i < settings.length; i++) {
			const key = settings[i].key;
			const value = settings[i].value;
			result[key] = value;
		}

		return result;
	}

	/**
	 * Deletes all generic settings.  This function is use for reset.
	 */
	async reset(
		req: Request,
	): Promise<void> {
		const member = req.member;

		// removes all settings
		await this.dataSource
			.createQueryBuilder()
			.delete()
			.from(MemberSettings)
			.where('memberId = :id', { id: member.id })
			.execute();

		// adds log
		await this.loggingRepo.insert({
			memberId: member.id,
			action: 'delete',
			table: 'member_settings',
			description: `Member ${member.id}/${member.email} is reset settings.`,
		});
	}

}
