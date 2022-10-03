import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { ServeStaticModule } from '@nestjs/serve-static';
import { ScheduleModule } from '@nestjs/schedule';
import { MulterModule } from '@nestjs/platform-express';
import { MailerModule } from '@nestjs-modules/mailer';
import { EjsAdapter } from '@nestjs-modules/mailer/dist/adapters/ejs.adapter';
import { TypeOrmModule, TypeOrmModuleOptions } from '@nestjs/typeorm';
import { join } from 'path';
import { Logging } from 'src/schemas/logging.entity';
import { MemberSignUp } from 'src/schemas/member_signup.entity';
import { MemberReset } from 'src/schemas/member_reset.entity';
import { MemberCredential } from 'src/schemas/member_credential.entity';
import { MemberSettings } from 'src/schemas/member_settings.entity';
import { Member } from 'src/schemas/member.entity';
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

		// database typeorm module
		TypeOrmModule.forRootAsync({
			useFactory: () => {
				const type = <'sqlite' | 'mysql'>env.DB_USE;
				let db: string
				if (type === 'sqlite')
					db = join(__dirname, '..', env.STORAGE_DIR, env.DB_FILE);
				else
					db = env.DB_NAME;

				const options: TypeOrmModuleOptions = {
					type,
					host: env.DB_HOST,
					port: +env.DB_PORT,
					username: env.DB_USER,
					password: env.DB_PASS,
					database: db,
					entities: [
						Logging,
						MemberSignUp,
						MemberReset,
						MemberCredential,
						MemberSettings,
						Member,
					],
					synchronize: true,
					//logging: true,
					retryAttempts: 0,
				};
				return options;
			},
		}),

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
