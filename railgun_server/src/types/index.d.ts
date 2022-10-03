import { Express, Request } from 'express';
import { Member } from 'src/schemas/member.entity';

declare global {
	namespace Express {

		export interface Request {
			id?: string;
			member?: Member;
		}

	}
}
