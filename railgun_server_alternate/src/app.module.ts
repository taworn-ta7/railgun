import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { ServeStaticModule } from '@nestjs/serve-static';
import { ScheduleModule } from '@nestjs/schedule';
import { MulterModule } from '@nestjs/platform-express';
import { MailerModule } from '@nestjs-modules/mailer';
import { EjsAdapter } from '@nestjs-modules/mailer/dist/adapters/ejs.adapter';
import { MongooseModule } from '@nestjs/mongoose';
import { join } from 'path';
import { MembersModule } from 'src/members/members.module';
import { AuthenModule } from 'src/authen/authen.module';
import { AuthenXModule } from 'src/authenx/authenx.module';
import { ProfileModule } from 'src/profile/profile.module';
import { SettingsModule } from 'src/settings/settings.module';
import { AdminModule } from 'src/admin/admin.module';
import { TasksModule } from 'src/tasks/tasks.module';
import { SetupModule } from 'src/setup/setup.module';
import { AppController } from './app.controller';
import { AppService } from './app.service';

const env = process.env;

@Module({
	imports: [
		// config module
		ConfigModule.forRoot({
			envFilePath: [
				'.env.override',
				'.env',
			],
		}),

		// serve static module
		ServeStaticModule.forRoot({
			rootPath: join(__dirname, '..', env.UPLOAD_DIR),
			serveRoot: `/${process.env.UPLOAD_DIR}`,
		}),

		// schedule task module
		ScheduleModule.forRoot(),

		// multer module
		MulterModule.registerAsync({
			useFactory: () => ({
				dest: join(__dirname, '..', env.UPLOAD_DIR),
			}),
		}),

		// mailer module
		MailerModule.forRootAsync({
			useFactory: () => ({
				transport: {
					host: env.MAIL_HOST,
					port: +env.MAIL_PORT,
					auth: {
						user: env.MAIL_USER,
						pass: env.MAIL_PASS,
					}
				},
				defaults: {
					from: env.MAIL_ADMIN,
				},
				template: {
					dir: `${__dirname}/mail_templates`,
					adapter: new EjsAdapter(),
					options: {
						strict: false,
					},
				},
			}),
		}),

		// database mongodb module
		MongooseModule.forRoot(env.DB_URL),

		// members module
		MembersModule,

		// authentication module
		AuthenModule,

		// authentication from external sources module
		AuthenXModule,

		// profile module
		ProfileModule,

		// settings module
		SettingsModule,

		// admin module
		AdminModule,

		// task schedule
		TasksModule,

		// setup module
		SetupModule,
	],
	controllers: [
		AppController,
	],
	providers: [
		AppService,
	],
})
export class AppModule { }
