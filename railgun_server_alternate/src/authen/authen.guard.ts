import {
	Logger,
	Injectable,
	CanActivate,
	ExecutionContext,
	UnauthorizedException,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Request } from 'express';
import { Member, MemberRole } from 'src/schemas/member.schema';
import Errors from 'src/helpers/errors.helper';

// ----------------------------------------------------------------------

/**
 * Authentication guard.
 * After this middleware, Request.member is guarantee to be always not null.
 */
@Injectable()
export class AuthenGuard implements CanActivate {

	private readonly logger = new Logger(AuthenGuard.name);

	constructor(
		@InjectModel(Member.name)
		private readonly memberModel: Model<Member>,
	) { }

	async canActivate(context: ExecutionContext): Promise<boolean> {
		const req = context.switchToHttp().getRequest<Request>();
		req.member = await memberFromHeaders(req, this.memberModel);
		return true;
	}

}

// ----------------------------------------------------------------------

/**
 * Optional guard.  Can pass this with req.member attached or not.
 */
@Injectable()
export class AuthenOptionalGuard implements CanActivate {

	private readonly logger = new Logger(AuthenOptionalGuard.name);

	constructor(
		@InjectModel(Member.name)
		private readonly memberModel: Model<Member>,
	) { }

	async canActivate(context: ExecutionContext): Promise<boolean> {
		const req = context.switchToHttp().getRequest<Request>();
		try {
			req.member = await memberFromHeaders(req, this.memberModel);
		}
		catch (ex) {
			req.member = null;
		}
		return true;
	}

}

// ----------------------------------------------------------------------

/**
 * Only member role can pass guard.
 * After this middleware, Request.member is guarantee to be not null and member.role is member.
 */
@Injectable()
export class AuthenMemberGuard implements CanActivate {

	private readonly logger = new Logger(AuthenMemberGuard.name);

	constructor(
		@InjectModel(Member.name)
		private readonly memberModel: Model<Member>,
	) { }

	async canActivate(context: ExecutionContext): Promise<boolean> {
		const req = context.switchToHttp().getRequest<Request>();
		req.member = await memberFromHeaders(req, this.memberModel);
		if (req.member.role != MemberRole.member)
			throw new UnauthorizedException(Errors.memberRequired);
		return true;
	}

}

// ----------------------------------------------------------------------

/**
 * Only admin role can pass guard.
 * After this middleware, Request.member is guarantee to be not null and member.role is admin.
 */
@Injectable()
export class AuthenAdminGuard implements CanActivate {

	private readonly logger = new Logger(AuthenAdminGuard.name);

	constructor(
		@InjectModel(Member.name)
		private readonly memberModel: Model<Member>,
	) { }

	async canActivate(context: ExecutionContext): Promise<boolean> {
		const req = context.switchToHttp().getRequest<Request>();
		req.member = await memberFromHeaders(req, this.memberModel);
		if (req.member.role != MemberRole.admin)
			throw new UnauthorizedException(Errors.adminRequired);
		return true;
	}

}

// ----------------------------------------------------------------------

function tokenFromHeaders(req: Request): string {
	const { headers: { authorization } } = req;
	if (authorization) {
		const a = authorization.split(' ');
		if (a.length >= 2) {
			if (a[0].toLowerCase() === 'bearer') {
				return a[1];
			}
		}
	}
	return null;
}

async function memberFromHeaders(req: Request, memberModel: Model<Member>): Promise<Member> {
	const token = tokenFromHeaders(req);
	if (!token)
		throw new UnauthorizedException(Errors.needSignIn);

	// searches in members by token
	const member = await memberModel.findOne({ 'credential.token': token });
	if (!member)
		throw new UnauthorizedException(Errors.needSignIn);

	// checks if session is expired
	const now = new Date();
	if (member.expire.getTime() < now.getTime())
		throw new UnauthorizedException(Errors.timeout);

	// updates expiry sign-in
	const expire = now.getTime() + +process.env.AUTHEN_TIMEOUT;
	member.expire = new Date(expire);
	await member.save();
	return member;
}
