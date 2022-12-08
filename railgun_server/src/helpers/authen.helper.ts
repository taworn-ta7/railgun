import * as crypto from 'crypto';
import * as jwt from 'jsonwebtoken';
import { Member } from 'src/schemas/member.entity';

/**
 * Sets password and returns structure salt and hash.
 */
export function setPassword(password: string): { salt: string, hash: string } {
	const salt = crypto.randomBytes(16).toString('hex');
	const hash = crypto.pbkdf2Sync(password, salt, 10000, 512, 'sha512').toString('hex');
	return { salt, hash };
}

/**
 * Validates password with salt and hash.
 */
export function validatePassword(password: string, salt: string, hash: string): boolean {
	const computeHash = crypto.pbkdf2Sync(password, salt, 10000, 512, 'sha512').toString('hex');
	return hash === computeHash;
}

/**
 * Generates token string.  Parameter n is limit to 256.
 */
export function generateToken(n: number): string {
	const seed = crypto.randomBytes(128).toString('hex');
	const code = Buffer.from(seed).toString('base64');
	return code.substring(0, n);
}

// ----------------------------------------------------------------------

/**
 * Creates or updates token in member.  The member structure must include credential.
 */
export async function newOrUpdateToken(member: Member): Promise<string> {
	let token;
	const now = new Date();
	const expire = now.getTime() + +process.env.AUTHEN_TIMEOUT;
	if (member.credential.token && member.expire && member.expire.getTime() >= now.getTime()) {
		// updates expiry sign-in
		member.expire = new Date(expire);
		token = member.credential.token;
	}
	else {
		// signs token
		const payload = {
			id: member.id,
			iat: Math.floor(Date.now() / 1000) - 30,
		};
		const secret = generateToken(32);
		token = await jwt.sign(payload, secret, {});

		// updates member
		member.begin = now;
		member.end = null;
		member.expire = new Date(expire);
		member.credential.token = token;
	}
	return token;
}

// ----------------------------------------------------------------------

/**
 * Creates new member which removes credential data.
 */
export function reduceMemberData(member: Member): Member {
	const reduce = new Member();
	reduce.id = member.id;
	reduce.email = member.email;
	reduce.role = member.role;
	reduce.locale = member.locale;
	reduce.name = member.name;
	reduce.disabled = member.disabled;
	reduce.resigned = member.resigned;
	reduce.begin = member.begin;
	reduce.end = member.end;
	reduce.expire = member.expire;
	reduce.created = member.created;
	reduce.updated = member.updated;
	return reduce;
}
