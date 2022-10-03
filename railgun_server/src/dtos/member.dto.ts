import {
	IsEmail,
	IsIn,
	IsNotEmpty,
	IsBoolean,
	MinLength,
	MaxLength,
} from 'class-validator';
import { IsEqualTo } from 'src/decorators/IsEqualTo';

/**
 * This DTO class provide for service POST /api/members/signup.
 */
export class MemberSignUpDto {
	@IsEmail()
	email: string;

	@IsIn(['en', 'th'])
	locale: string;

	@IsNotEmpty()
	@MinLength(4)
	@MaxLength(20)
	password: string;

	@IsNotEmpty()
	@IsEqualTo('password')
	confirmPassword: string;
}

/**
 * This DTO class provide for service POST /api/members/request-reset.
 */
export class MemberResetDto {
	@IsEmail()
	email: string;
}

/**
 * This DTO class provide for service PUT /api/authen/signin.
 */
export class MemberSignInDto {
	@IsEmail()
	email: string;

	@IsNotEmpty()
	@MinLength(4)
	@MaxLength(20)
	password: string;
}

/**
 * This DTO class provide for service PUT /api/admin/members/disable?id=<email>.
 */
export class MemberDisabledDto {
	@IsBoolean()
	disabled: boolean;
}
