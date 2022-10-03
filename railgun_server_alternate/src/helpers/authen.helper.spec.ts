import {
	setPassword,
	validatePassword,
} from './authen.helper';

describe('authen helper', () => {

	it('setPassword() / validatePassword()', () => {
		const password = setPassword('P@SsW0Rd')
		expect(validatePassword('P@SsW0Rd', password.salt, password.hash)).toBeTruthy();
	});

});
