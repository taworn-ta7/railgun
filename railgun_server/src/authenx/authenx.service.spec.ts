import { Test, TestingModule } from '@nestjs/testing';
import { AuthenxService } from './authenx.service';

describe('AuthenxService', () => {
	let service: AuthenxService;

	beforeEach(async () => {
		const module: TestingModule = await Test.createTestingModule({
			providers: [AuthenxService],
		}).compile();

		service = module.get<AuthenxService>(AuthenxService);
	});

	it('should be defined', () => {
		expect(service).toBeDefined();
	});
});
