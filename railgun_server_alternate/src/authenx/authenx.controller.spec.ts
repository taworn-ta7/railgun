import { Test, TestingModule } from '@nestjs/testing';
import { AuthenxController } from './authenx.controller';

describe('AuthenxController', () => {
	let controller: AuthenxController;

	beforeEach(async () => {
		const module: TestingModule = await Test.createTestingModule({
			controllers: [AuthenxController],
		}).compile();

		controller = module.get<AuthenxController>(AuthenxController);
	});

	it('should be defined', () => {
		expect(controller).toBeDefined();
	});
});
