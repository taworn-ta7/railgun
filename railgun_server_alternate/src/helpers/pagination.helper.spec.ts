import {
	getOrderingData,
} from './pagination.helper';

describe('pagination helper', () => {

	const sortDict = {
		email: 'email',
		name: 'name',
		created: 'created',
		updated: 'updated',
	};

	it('getOrderingData() #1', () => {
		const orders = getOrderingData(sortDict, "")
		expect(JSON.parse(JSON.stringify(orders))).toStrictEqual([
		])
	});

	it('getOrderingData() #2', () => {
		const orders = getOrderingData(sortDict, "email")
		expect(JSON.parse(JSON.stringify(orders))).toStrictEqual([
			['email', 1],
		])
	});

	it('getOrderingData() #3', () => {
		const orders = getOrderingData(sortDict, "email+,name;created-")
		expect(JSON.parse(JSON.stringify(orders))).toStrictEqual([
			['email', 1],
			['name', 1],
			['created', -1],
		])
	});

	it('getOrderingData() #4', () => {
		const orders = getOrderingData(sortDict, "email+.name:created-")
		expect(JSON.parse(JSON.stringify(orders))).toStrictEqual([
			['email', 1],
			['name', 1],
			['created', -1],
		])
	});

	it('getOrderingData() #5', () => {
		const orders = getOrderingData(sortDict, "email- name	created+")
		expect(JSON.parse(JSON.stringify(orders))).toStrictEqual([
			['email', -1],
			['name', 1],
			['created', 1],
		])
	});

});
