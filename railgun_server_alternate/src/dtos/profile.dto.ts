import {
	MinLength,
	MaxLength,
	IsNotEmpty,
} from 'class-validator';
import { IsEqualTo } from 'src/decorators/IsEqualTo';

/**
 * This DTO class provide for service PUT /api/profile/name.
 */
export class ProfileChangeNameDto {
	@MinLength(1)
	@MaxLength(200)
	name: string;
}

/**
 * This DTO class provide for service PUT /api/profile/password.
 */
export class ProfileChangePasswordDto {
	@IsNotEmpty()
	@MinLength(4)
	@MaxLength(20)
	currentPassword: string;

	@IsNotEmpty()
	@MinLength(4)
	@MaxLength(20)
	newPassword: string;

	@IsNotEmpty()
	@IsEqualTo('newPassword')
	confirmPassword: string;
}
