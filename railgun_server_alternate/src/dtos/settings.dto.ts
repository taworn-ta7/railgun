import {
	IsOptional,
	IsIn,
} from 'class-validator';

/**
 * This DTO class provide for service PUT /api/settings.
 */
export class SettingsDto {
	@IsOptional()
	@IsIn(['en', 'th'])
	locale: string | null | undefined;
}
