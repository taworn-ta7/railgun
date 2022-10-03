export const Errors = {

	timeout: {
		locales: {
			en: `Timeout, you need to sign-in again!`,
			th: `หมดเวลา, คุณต้อง sign-in เข้าระบบอีกครั้ง!`,
		},
	},

	needSignIn: {
		locales: {
			en: `You require sign-in!`,
			th: `คุณต้อง sign-in เข้าระบบ!`,
		},
	},

	emailOrPasswordInvalid: {
		locales: {
			en: `Your email or password is incorrect!`,
			th: `คุณใส่อีเมลหรือรหัสผ่านไม่ถูกต้อง!`,
		},
	},

	memberIsResigned: {
		locales: {
			en: `Your membership is resigned!`,
			th: `คุณลาออกจากระบบไปแล้ว!`,
		},
	},

	memberIsDisabledByAdmin: {
		locales: {
			en: `Your membership is disabled!`,
			th: `คุณถูกระงับการใช้การ!`,
		},
	},

	passwordIsIncorrect: {
		locales: {
			en: `Password is incorrect!`,
			th: `รหัสผ่านไม่ถูกต้อง!`,
		},
	},

	// ----------------------------------------------------------------------

	memberRequired: {
		locales: {
			en: `Member rights is required!`,
			th: `ต้องการสิทธิ Member!`,
		},
	},

	adminRequired: {
		locales: {
			en: `Admin rights is required!`,
			th: `ต้องการสิทธิ Admin!`,
		},
	},

	// ----------------------------------------------------------------------

	uploadIsNotType: {
		locales: {
			en: `Uploaded file is not a specify type!`,
			th: `ไฟล์ที่ Upload ขึ้นมา ไม่ใช่ไฟล์ชนิดที่ต้องการ!`,
		},
	},

	uploadIsNotTypeImage: {
		locales: {
			en: `Uploaded file is not an image file!`,
			th: `ไฟล์ที่ Upload ขึ้นมา ไม่ใช่ไฟล์รูปภาพ!`,
		},
	},

	uploadIsTooBig(limit: any): any {
		return {
			locales: {
				en: `Uploaded file size is too big! (Limit ${limit})`,
				th: `ไฟล์ที่ Upload ขึ้นมา มีขนาดใหญ่เกินไป! (ขนาดใหญ่สุด ${limit})`,
			},
		};
	},

};

export default Errors;
