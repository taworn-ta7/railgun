Sort Ordering
=============

When APIs need to return sort ordering, such as:

	GET /api/members?order=email-,name+,created

There are fields (in this case: email, name and created) and optional ascending or descending order.

Here is format:

	field [optional order] [separate by comma]

Such as:

	GET /api/members?order=email-,name+

Order by descending email, then ascending name.

Or:

	GET /api/members?order=created,email,name

Order by created, email, then name.  All are ascending.
