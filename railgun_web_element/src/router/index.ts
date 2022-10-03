import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
	history: createWebHistory(import.meta.env.BASE_URL),
	routes: [
		{
			path: "/",
			name: "home",
			component: async () => await import('@/pages/HomePage.vue'),
		},
		{
			path: "/members/forgot-pass",
			name: "forgotPass",
			component: async () => await import('@/pages/members/ForgotPassPage.vue'),
		},
		{
			path: "/members/signup",
			name: "signup",
			component: async () => await import('@/pages/members/SignUpPage.vue'),
		},
		{
			path: "/signout",
			name: "signout",
			component: async () => await import('@/pages/SignOutPage.vue'),
		},

		{
			path: "/profile/change-icon",
			name: "changeIcon",
			component: async () => await import('@/pages/profile/ChangeIconPage.vue'),
		},
		{
			path: "/profile/change-name",
			name: "changeName",
			component: async () => await import('@/pages/profile/ChangeNamePage.vue'),
		},
		{
			path: "/profile/change-pass",
			name: "changePass",
			component: async () => await import('@/pages/profile/ChangePassPage.vue'),
		},

		{
			path: "/members/:email",
			name: "memberEdit",
			component: async () => await import('@/pages/MemberEditPage.vue'),
		},
		{
			path: "/members",
			name: "members",
			component: async () => await import('@/pages/MembersPage.vue'),
		},
		{
			path: "/settings",
			name: "settings",
			component: async () => await import('@/pages/SettingsPage.vue'),
		},

		{
			path: "/authenx/google",
			name: "signinGoogle",
			component: async () => await import('@/pages/authenx/SignInGooglePage.vue'),
		},
		{
			path: "/authenx/line",
			name: "signinLine",
			component: async () => await import('@/pages/authenx/SignInLinePage.vue'),
		},
	],
})

export default router
