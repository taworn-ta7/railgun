[For English, click here](./README.md)

# Railgun

"ปืนราง" เป็นชื่อเรียก project ใหญ่ ที่ครอบคลุม:

* REST server
* Flutter client
* web client, คุณสมบัติเหมือนกัน Flutter client

projects ทั้งหมด รวมเป็น โปรแกรมทดสอบแบบ client/server

## คุณสมบัติ

ตัวอย่างเหล่านี้ สาธิต:

* ระบบสมาชิก
* ส่งเมล
* ลบ records ที่ไม่ได้ใช้แล้ว, สามารถจะกำหนดค่าได้
* อัพโหลด profile icon
* เปลี่ยนภาษา: อังกฤษ, ไทย
* เปลี่ยนธีมสี
* เข้าสู่ระบบโดย Google และ LINE, บน web เท่านั้น

## การติดตั้ง

ถ้าคุณยังไม่ได้ติดตั้ง โปรแกรมสำหรับพัฒนา ติดตั้งได้แล้ว:

* [Node](https://nodejs.org), สำหรับ REST server
* [Flutter](https://flutter.dev), สำหรับ Flutter client
* [Vue](https://vuejs.org) และ [web browser](https://www.google.com/chrome), สำหรับ web client
* [Postman](https://www.postman.com), สำหรับทดสอบ server

## Run Server

Source code สำหรับ REST server อยู่ใน "railgun/railgun_server" หรือ "railgun/railgun_server_alternate"  โดยที่ railgun_server ใช้ TypeORM ในการเข้าถึง database ในขณะที่ railgun_server_alternate ใช้ MongoDB

เปลี่ยน folder:

	cd %SOURCE%/railgun/railgun_server
	-- or --
	cd %SOURCE%/railgun/railgun_server_alternate

ติดตั้ง, ทำครั้งเดียวเท่านั้น:

	npm i

รอนานมาก!

Run:

	npm start

สำหรับการ run ครั้งแรก, ใช้โปรแกรม REST client เช่น: Postman, โปรด run:

	POST http://localhost:7777/api/setup

โปรแกรมจะสร้างสมาชิก "admin@your.diy" กับรหัสผ่าน "admin"

## Run App

Source code สำหรับ Flutter client อยู่ใน "railgun/railgun_app"

เปลี่ยน folder:

	cd %SOURCE%/railgun/railgun_app

Run:

	flutter run -d <chrome, windows, other platforms>

ถ้าคุณต้องการ run บน Android, คุณต้องการโปรแกรม เช่น [ngrok](https://ngrok.com):

	ngrok http 7777

เปิด browser ด้วย port 4040, ค้นหา URL "https://<random number>.ngrok.io" และ copy ข้อความขึ้นมา:

จากนั้น เปิดไฟล์ "constants.dart" ใน "%SOURCE%/railgun/railgun_app/lib" และแก้ไขข้อความ:

	class Constants {
		/// Server base URL.
		//static const baseUrl = 'http://localhost:7777/api';
		static const baseUrl = 'https://ef6d-49-228-104-227.ngrok.io/api';

		/// Static server base URL.
		//static const baseStaticUrl = 'http://localhost:7777';
		static const baseStaticUrl = 'https://ef6d-49-228-104-227.ngrok.io';
	}

สุดท้าย สร้างโปรแกรมเพื่อ run บน Android

## Run Web

Source code สำหรับ web clients อยู่ใน "railgun/railgun_web_barehand" หรือ "railgun/railgun_web_element"  โดยที่ railgun_web_barehand ไม่ใช้ UI ในขณะที่ railgun_web_element ใช้ [Element Plus](https://element-plus.org/en-US).

เปลี่ยน folder:

	cd %SOURCE%/railgun/railgun_web_barehand
	-- or --
	cd %SOURCE%/railgun/railgun_web_element

ติดตั้ง, ทำครั้งเดียวเท่านั้น:

	npm i

Run:

	npm start

สุดท้าย เปิด browser สำหรับ URL:

	http://localhost:8080

## Run ทดสอบ Server

ถ้าคุณต้องการทดสอบ server เปิดโปรแกรม Postman และ import scripts "railgun.postman_collection" และ "railgun.postman_environment" ใน folder "%SOURCE%/railgun/railgun_server"  อย่าลืม set
Environments เป็น "railgun"

## Run ทดสอบ Client

มี project "railgun_client_dart" มันใช้สำหรับ เขียนโปรแกรมติดต่อ REST server  ก่อนการทดสอบ มันต้องการสมาชิก "admin@your.diy" รหัสผ่าน "admin" และสมาชิก "test0@your.diy" รหัสผ่าน "test0"  โปรดใช้โปรแกรม Postman ในการสร้างพวกมันขึ้นมา

เปลี่ยน folder:

	cd %SOURCE%/railgun/railgun_client_dart

Run:

	dart test

โปรดระวัง บางเวลา โปรแกรม dart test อาจพบเหตุการณ์หมดเวลาและล้มเหลว  ให้ผ่านไปหรือทดสอบใหม่

## สร้างเอกสาร Server

ถ้าคุณต้องการสร้างเอกสารสำหรับ REST server  พิมพ์:

	cd %SOURCE%/railgun/railgun_server
	-- or --
	cd %SOURCE%/railgun/railgun_server_alternate

	npm run doc

และเปิด browser สำหรับ URL:

	http://localhost:8080

## สร้างเอกสาร Client

ถ้าคุณต้องการสร้างเอกสารสำหรับ REST client  พิมพ์:

	cd %SOURCE%/railgun/railgun_client_dart

	dart doc

เปิด browser สำหรับ:

	%SOURCE%/railgun/railgun_client_dart/doc/api/index.html

## การกำหนดค่า

มีไฟล์ชื่อ ".env.override" อยู่ในต้นทาง folder  มันเก็บการกำหนดค่าและสามารถเปลี่ยนได้

รายการกำหนดค่า:

* LOG_TO_CONSOLE: log ออก console, 0 หรือ 1
* LOG_TO_FILE: log ออกไฟล์, 0 หรือ 1
* DAYS_TO_KEEP_LOGS: จำนวนวันที่จะเก็บค่าเก่า ก่อนลบ log
* DAYS_TO_KEEP_DBLOGS: จำนวนวันที่จะเก็บค่าเก่า database log
* DAYS_TO_KEEP_SIGNUPS: จำนวนวันที่จะเก็บค่าเก่า สำหรับ records ในตาราง member_signup
* DAYS_TO_KEEP_RESETS: จำนวนวันที่จะเก็บค่าเก่า สำหรับ records ในตาราง member_reset
* DB_USE: เลือก database, sqlite หรือ mysql, railgun_server เท่านั้น
* DB_HOST: เครื่องที่ต่อ database
* DB_PORT: port ที่ใช้
* DB_USER: user ที่ใช้
* DB_PASS: รหัสผ่านสำหรับเข้า database
* MAIL_HOST: เครื่องที่ต่อ สำหรับส่งเมล
* MAIL_PORT: port ที่ใช้
* MAIL_USER: user ที่ใช้
* MAIL_PASS: รหัสผ่านสำหรับเข้าเมล
* AUTHEN_TIMEOUT: เวลาก่อนที่ session จะหมดอายุ หน่วยเป็น มิลลิวินาที
* PROFILE_ICON_FILE_LIMIT: จำนวน bytes ที่จะจำกัด ตอนอัพโหลด profile icon

ถ้าคุณใช้ MySQL อย่าลืม สร้าง database เปล่า ชื่อ "railgun"

ผมใช้ [ethereal](https://ethereal.email) ซึ่งเป็น mail service ปลอม สำหรับทดสอบ
และบางครั้ง ชื่อผู้ใช้กับรหัสผ่านจะหมดอายุ และคุณต้องสร้างขึ้นมาใหม่ ไม่เสียค่าใช้จ่าย

## เอกสารสำหรับการเขียนโปรแกรม

เอกสารเพิ่มเติม:

* [APIs ทั้งหมด](./docs/APIs.md)
* [การจัดการ Error สำหรับ Client](./docs/Error%20Handling%20for%20Client.md)
* [การจัดเรียงลำดับ](./docs/Sort%20Ordering.md)

## สุดท้าย

ขอโทษครับ แต่ผมไม่เก่งภาษาอังกฤษ T_T
