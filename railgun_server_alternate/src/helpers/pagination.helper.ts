import { Request } from 'express';

/**
 * Pagination data.
 */
export type Pagination = {
	page: number,
	offset: number,
	rowsPerPage: number,
	count: number,
	pageIndex: number,
	pageCount: number,
	pageStart: number,
	pageStop: number,
	pageSize: number,
}

/**
 * Gets pagination from page, rows per page and count.
 */
export function getPagination(page: number, rowsPerPage: number, count: number): Pagination {
	const offset = page * rowsPerPage;
	const pageCount = Math.ceil(count / rowsPerPage);
	const pageSize = page < pageCount - 1
		? rowsPerPage
		: (page >= pageCount ? 0 : count - offset);
	return {
		page,
		offset,
		rowsPerPage,
		count,
		pageIndex: page,
		pageCount,
		pageStart: offset,
		pageStop: offset + pageSize,
		pageSize,
	};
}

/**
 * Gets ordering data.
 */
export function getOrderingData(sortDict: any, order: string): Object {
	const result = [];
	if (typeof order === 'string') {
		const parts = order.split(/[ \t.,:;]+/);
		const regex = /([a-zA-Z0-9_]+)([\+\-]?)/;
		for (let i = 0; i < parts.length; i++) {
			const item = parts[i].trim();
			if (item.length > 0) {
				const matches = regex.exec(item);
				const field = matches[1];
				const reverse = matches[2];
				if (field in sortDict) {
					result.push([
						sortDict[field],
						reverse === '-' ? -1 : 1,
					]);
				}
			}
		}
	}
	return result;
}

/**
 * Gets current request and extract page, order, search and trash.
 * 
 * @example
 * const { page, order, search, trash } = queryGenericData(req, {
 *   // sort dictionary
 *   email: 'email',
 *   name: 'name',
 *   created: 'created',
 *   updated: 'updated',
 * });
 */
export function queryPagingData(req: Request, sortDict: any): {
	page: number,
	order: any,
	search: string,
	trash: boolean,
} {
	let page = Number(req.query.page);
	if (!page || page < 0)
		page = 0;
	const order = sortDict ? getOrderingData(sortDict, req.query.order?.toString()) : [];
	const search = req.query.search?.toString().trim();
	const trash = Number(req.query.trash ?? 0) !== 0;
	return {
		page,
		order,
		search,
		trash,
	};
}
