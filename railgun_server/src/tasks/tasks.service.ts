import {
	Logger,
	Injectable,
} from '@nestjs/common';
import { Timeout, Interval } from '@nestjs/schedule';
import { DataSource } from 'typeorm';
import * as path from 'path';
import * as fs from 'fs';
import * as moment from 'moment';
import { Logging } from 'src/schemas/logging.entity';
import { MemberSignUp } from 'src/schemas/member_signup.entity';
import { MemberReset } from 'src/schemas/member_reset.entity';

const delayTime = 10 * 1000;
const intervalTime = 8 * 60 * 60 * 1000;

const env = process.env;

@Injectable()
export class TasksService {

	private readonly logger = new Logger(TasksService.name);

	private logDir: string;

	constructor(
		private readonly dataSource: DataSource,
	) {
		this.logDir = path.resolve(path.join(__dirname, '..', '..', env.LOG_DIR));
		this.logger.verbose(`logs path: ${this.logDir}`);
		this.logger.verbose(`days to keep logs: ${+env.DAYS_TO_KEEP_LOGS} day(s)`);
		this.logger.verbose(`days to keep database logs: ${+env.DAYS_TO_KEEP_DBLOGS} day(s)`);
		this.logger.verbose(`days to keep unconfirmed signups: ${+env.DAYS_TO_KEEP_SIGNUPS} day(s)`);
		this.logger.verbose(`days to keep unresponded resets: ${+env.DAYS_TO_KEEP_RESETS} day(s)`);
	}

	// ----------------------------------------------------------------------

	@Timeout(delayTime)
	async handleTimeout() {
		await this.deleteLogs(+env.DAYS_TO_KEEP_LOGS, this.logDir);
		await this.deleteDbLogs(+env.DAYS_TO_KEEP_DBLOGS);
		await this.deleteSignups(+env.DAYS_TO_KEEP_SIGNUPS);
		await this.deleteResets(+env.DAYS_TO_KEEP_RESETS);
	}

	@Interval(intervalTime)
	async handleInterval() {
		await this.deleteLogs(+env.DAYS_TO_KEEP_LOGS, this.logDir);
		await this.deleteDbLogs(+env.DAYS_TO_KEEP_DBLOGS);
		await this.deleteSignups(+env.DAYS_TO_KEEP_SIGNUPS);
		await this.deleteResets(+env.DAYS_TO_KEEP_RESETS);
	}

	// ----------------------------------------------------------------------

	async deleteLogs(daysToKeep: number, folder: string) {
		// checks before execute, days to keep must keep at least 0 (today) 
		if (daysToKeep < 0)
			return;

		// computes date range
		const now = new Date();
		const end = new Date(now.getFullYear(), now.getMonth(), now.getDate());
		const begin = new Date(end.valueOf() - (daysToKeep * 24 * 60 * 60 * 1000));

		// loop for delete files
		this.logger.debug(`logs older than ${moment(begin).format('YYYY-MM-DD')} will be delete!`);
		const files = await fs.promises.readdir(folder);
		const re = /^([0-9]{4})([0-9]{2})([0-9]{2})\.log$/;
		for (let i = 0; i < files.length; i++) {
			const file = files[i];
			const found = file.match(re);
			if (found) {
				const date = new Date(Date.UTC(Number(found[1]), Number(found[2]) - 1, Number(found[3])));
				if (date.valueOf() < begin.valueOf()) {
					this.logger.debug(`delete: ${file}`);
					await fs.promises.rm(path.join(folder, file));
				}
			}
		}
	};

	// ----------------------------------------------------------------------

	async deleteDbLogs(daysToKeep: number) {
		// checks before execute, days to keep must keep at least 0 (today) 
		if (daysToKeep < 0)
			return;

		// computes date range
		const now = new Date();
		const end = new Date(now.getFullYear(), now.getMonth(), now.getDate());
		const begin = new Date(end.valueOf() - (daysToKeep * 24 * 60 * 60 * 1000));

		// cleanup old logging table
		this.logger.debug(`database logs older than ${moment(begin).format('YYYY-MM-DD')} will be delete!`);
		await this.dataSource
			.createQueryBuilder()
			.delete()
			.from(Logging)
			.where("created < :timestamp", { timestamp: begin.toISOString() })
			.execute();
	};

	// ----------------------------------------------------------------------

	async deleteSignups(daysToKeep: number) {
		// checks before execute, days to keep must keep at least 0 (today) 
		if (daysToKeep < 0)
			return;

		// computes date range
		const now = new Date();
		const end = new Date(now.getFullYear(), now.getMonth(), now.getDate());
		const begin = new Date(end.valueOf() - (daysToKeep * 24 * 60 * 60 * 1000));

		// cleanup old member_signup table
		this.logger.debug(`signups data older than ${moment(begin).format('YYYY-MM-DD')} will be delete!`);
		await this.dataSource
			.createQueryBuilder()
			.delete()
			.from(MemberSignUp)
			.where("created < :timestamp", { timestamp: begin.toISOString() })
			.execute();
	};

	// ----------------------------------------------------------------------

	async deleteResets(daysToKeep: number) {
		// checks before execute, days to keep must keep at least 0 (today) 
		if (daysToKeep < 0)
			return;

		// computes date range
		const now = new Date();
		const end = new Date(now.getFullYear(), now.getMonth(), now.getDate());
		const begin = new Date(end.valueOf() - (daysToKeep * 24 * 60 * 60 * 1000));

		// cleanup old member_reset table
		this.logger.debug(`resets data older than ${moment(begin).format('YYYY-MM-DD')} will be delete!`);
		await this.dataSource
			.createQueryBuilder()
			.delete()
			.from(MemberReset)
			.where("created < :timestamp", { timestamp: begin.toISOString() })
			.execute();
	};

}
