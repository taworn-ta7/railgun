/**
 * Converts bytes to KB, MB, GB or TB.
 * Thanks to https://www.codegrepper.com/code-examples/javascript/how+to+convert+kilobytes+to+mb+in+typescript.
 */
export function convertBytes(bytes: number): string {
	const units = ['bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
	let l = 0, n = bytes;
	while (n >= 1024 && ++l) {
		n = n / 1024;
	}
	return (n.toFixed(n < 10 && l > 0 ? 1 : 0) + ' ' + units[l]);
}
