import { Module } from '@nestjs/common';
import { SchemasModule } from 'src/schemas/schemas.module';
import { TasksService } from './tasks.service';

@Module({
	imports: [
		SchemasModule,
	],
	providers: [
		TasksService,
	],
})
export class TasksModule { }
