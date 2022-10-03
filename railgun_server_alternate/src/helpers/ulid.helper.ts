import { ulid } from 'ulid';

/**
 * Generates ULID.  This function provided as wrapper, 
 * when you want to change other library.
 */
export function generateUlid() {
	return ulid();
}
