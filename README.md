[สำหรับภาษาไทย คลิกที่นี่](./README-th.md)

# Railgun

The Railgun is an umbrella project.  It contains of:

* REST server
* Flutter client
* web client, same features as Flutter.

All projects composed to be sample client/server.

## Features

These samples demostration of features:

* Members system
* Send mail
* Delete unused records, configurable
* Upload profile icon
* Change language: English, Thai
* Change theme color
* Sign-in to Google and LINE, on web version only

## Installation

If you not installed development tools, installs them now:

* [Node](https://nodejs.org), for REST server
* [Flutter](https://flutter.dev), for Flutter client
* [Vue](https://vuejs.org) and [modern web browser](https://www.google.com/chrome), for web client
* [Postman](https://www.postman.com), for testing server

## Run Server

Source code for REST servers are in "railgun/railgun_server" or "railgun/railgun_server_alternate".  The railgun_server uses TypeORM as database, while railgun_server_alternate uses MongoDB.

Changes folder to:

	cd %SOURCE%/railgun/railgun_server
	-- or --
	cd %SOURCE%/railgun/railgun_server_alternate

Setup, one-time only:

	npm i

A very long time waiting!

Run:

	npm start

For the first run, uses REST client software, such as: Postman, to run:

	POST http://localhost:7777/api/setup

It will create member "admin@your.diy" with password "admin".

## Run App

Source code for Flutter client is in "railgun/railgun_app".

Changes folder to:

	cd %SOURCE%/railgun/railgun_app

Run:

	flutter run -d <chrome, windows, other platforms>

If you want to run on Android, you have to run software, like [ngrok](https://ngrok.com):

	ngrok http 7777

Opens browser in port 4040, finds the URL "https://<random number>.ngrok.io" and copy it.

Then, opens file "constants.dart" in "%SOURCE%/railgun/railgun_app/lib" and edit:

	class Constants {
		/// Server base URL.
		//static const baseUrl = 'http://localhost:7777/api';
		static const baseUrl = 'https://ef6d-49-228-104-227.ngrok.io/api';

		/// Static server base URL.
		//static const baseStaticUrl = 'http://localhost:7777';
		static const baseStaticUrl = 'https://ef6d-49-228-104-227.ngrok.io';
	}

Finally, build to run in Android platform.

## Run Web

Source code for web clients are in "railgun/railgun_web_barehand" or "railgun/railgun_web_element".  The railgun_web_barehand NOT uses any UI library, while railgun_web_element uses [Element Plus](https://element-plus.org/en-US).

Changes folder to:

	cd %SOURCE%/railgun/railgun_web_barehand
	-- or --
	cd %SOURCE%/railgun/railgun_web_element

Setup, one-time only:

	npm i

Run:

	npm start

Finally, opens browser to URL:

	http://localhost:8080

## Run Server Test

If you want to run test server, open Postman and import scripts "railgun.postman_collection" and "railgun.postman_environment" in folder "%SOURCE%/railgun/railgun_server".  Don't forget to set Environments to "railgun".

## Run Client Test

There is project "railgun_client_dart", it used by Flutter client to connect to REST server.  Before testing, it requires member "admin@your.diy" password "admin" and member "test0@your.diy" password "test0".  Please use Postman to create them.

Changes folder to:

	cd %SOURCE%/railgun/railgun_client_dart

Run:

	dart test

Please note that, sometime, dart test will reach timeout and failed.  Just ignore or re-test the software.

## Generate Server Document

If you want to generate document on REST server.  Type:

	cd %SOURCE%/railgun/railgun_server
	-- or --
	cd %SOURCE%/railgun/railgun_server_alternate

	npm run doc

and opens browser to URL:

	http://localhost:8080

## Generate Client Document

If you want to generate document on REST client.  Type:

	cd %SOURCE%/railgun/railgun_client_dart

	dart doc

Opens browser to:

	%SOURCE%/railgun/railgun_client_dart/doc/api/index.html

## Configuration

There is a file called ".env.override" in the root of server folder.  It keeps configuration and can be changes.

Here are some list:

* LOG_TO_CONSOLE: log out to console, 0 or 1
* LOG_TO_FILE: log out to file, 0 or 1
* DAYS_TO_KEEP_LOG: number of days to keep old log file
* DAYS_TO_KEEP_DBLOG: number of days to keep old database log
* DAYS_TO_KEEP_SIGNUP: number of days to keep old records in member_signup table
* DAYS_TO_KEEP_RESET: number of days to keep old records in member_reset table
* DB_USE: choose database, sqlite or mysql, railgun_server only
* DB_HOST: database host
* DB_PORT: database port
* DB_USER: database user
* DB_PASS: database password
* MAIL_HOST: mail sender host
* MAIL_PORT: mail sender port
* MAIL_USER: mail sender user
* MAIL_PASS: mail sender password
* AUTHEN_TIMEOUT: time before session expire, as milli-seconds
* PROFILE_ICON_FILE_LIMIT: number of bytes to limit upload profile icon

Note #1: If you use MySQL, don't forget to create blank database, named "railgun".

Note #2: I used service [ethereal](https://ethereal.email), which is a fake mail service.
And, some time, your user and password will expire and you have to recreate them.  It's free.

## Programming Documents

There are more documents:

* [All APIs](./docs/APIs.md)
* [Error Handling for Client](./docs/Error%20Handling%20for%20Client.md)
* [Sort Ordering](./docs/Sort%20Ordering.md)

## Last

Sorry, but I'm not good at English. T_T
