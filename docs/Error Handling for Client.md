Error Handling for Client
=========================

When server returns error conditions.  It will send JSON back to client.  Here is an error sample:

	{
		"statusCode": 401,
		"message": null,
		"locales": {
			"en": "Your email or password is incorrect!",
			"th": "คุณใส่อีเมลหรือรหัสผ่านไม่ถูกต้อง!"
		},
		"path": "/api/authen/signin",
		"requestId": "000000001",
		"timestamp": "2022-08-06T20:49:03.527Z"
	}

In this case, you can grab field "locales" and display this text to user.

But sometime, an error will be just:

	{
		"statusCode": 403,
		"message": "Forbidden",
		"locales": null,
		"path": "/api/members/signup",
		"requestId": "000000000",
		"timestamp": "2022-08-06T20:48:31.308Z"
	}

It doesn't have any meaningful error message.  In this case, map statusCode to error message and display.
