APIs
====

# Common Services

## about

	GET /api/about

Returns server name and version.

## config

	GET /api/config

Returns current configuration.

## setup

	POST /api/setup

Setup and creates admin member.  Can run only once.

--------------------------------------------------

# Members Services

## Sign Up

	POST /api/members/signup

Receives sign-up form and saves it to database.  Returns URL to let user confirm it.

Input:

	{
		"member": {
			"email": "email to sign-up",
			"password": "password",
			"confirmPassword": "confirm password",
			"locale": "en or th"
		}
	}

## Confirm Sign Up

	GET /api/members/signup/confirm?code=:code_from_email

Confirms the sign-up form, then, copies sign-up data into member table.

## Password Reset

	POST /api/members/request-reset

Receives password reset form and sends email to member.

Input:

	{
		"member": {
			"email": "email to reset password"
		}
	}

## Confirm Password Reset

	GET /api/members/reset-password?code=:code_from_email

Confirms the password reset.  This will generate new password and send new password to email.

## List

	GET /api/members
		?size=<page size, default=10>
		&page=<page, start at 0>
		&order=<field list>
		&search=<search string>
		&trash=<0 or 1, look in normal or trash>

Field List:

	email
	name
	created
	updated

Lists members with conditions.  All parameters are optional.

## Get

	GET /api/members/:email

Gets member's information.

## Get Icon

	GET /api/members/:email/icon

Gets member's icons.

--------------------------------------------------

# Authentication Services

## Sign In

	PUT /api/authen/signin

Authorizes the email and password.  Returns member data and sign-in token and will be use all the session.

Input:

	{
		"signin": {
			"email": "email to sign-in",
			"password": "password"
		}
	}

## Sign Out

	PUT /api/authen/signout

Signs off from current session.  The sign-in token will be invalid.

## Check

	GET /api/authen/check

Checks current sign-in state.

--------------------------------------------------

# Profile Services

Must be sign-in first.

## Upload Icon

	POST /api/profile/icon

Uploads picture to use as member profile icon.

Input:

	image: <form-data image>

## View Icon

	GET /api/profile/icon

Views the uploaded profile icon.

## Delete Icon

	DELETE /api/profile/icon

Deletes the uploaded profile icon and reverts profile icon to defaults.

## Change Name

	PUT /api/profile/name

Changes the current name.

Input:

	{
		"member": {
			"name": "new name"
		}
	}

## Change Password

	PUT /api/profile/password

Changes the current password.  After the password is changed, you will be sign-out and need to sign-in again.

Input:

	{
		"member": {
			"currentPassword": "current password",
			"newPassword": "new password",
			"confirmPassword": "confirm password"
		}
	}

--------------------------------------------------

# Settings Services

This service will change settings.  Must be sign-in first.

## Change Settings

	PUT /api/settings/change

Changes current settings.  Currently, it has just one setting: locale.

Input:

	{
		"member": {
			"locale": "en or th",
		}
	}

## Set

	PUT /api/settings/:key/:value

Sets key-value generic settings.

## Get

	GET /api/settings/:key

Gets key-value generic settings.  Returns value string, or null if key not exists.

## Get All

	GET /api/settings

Gets all generic settings.  Returns all key-value pairs.

## Reset

	PUT /api/settings

Deletes all generic settings.  This function is use for reset.

--------------------------------------------------

# Admin Services

## Authorized Member

	PUT /api/admin/members/authorize?code=:code_from_member_signup

Authorizes the member signing-up.  This service is primary used in testing only.

## Disabled Member

	PUT /api/admin/members/disable/:email

Disables or enables a member.

Input:

	{
		"member": {
			"disabled": true
		}
	}
