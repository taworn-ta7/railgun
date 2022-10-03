import { createApp } from 'vue'
import { createPinia } from 'pinia'
import i18n from '@/i18n'
import router from '@/router'
import AppBox from '@/layouts/AppBox.vue'
import AppBoxTiny from '@/layouts/AppBoxTiny.vue'
import AuthenRequired from '@/AuthenRequired.vue'
import App from '@/App.vue'

const app = createApp(App)
app.use(i18n)
app.use(router)
app.use(createPinia())
app.component('AppBox', AppBox)
app.component('AppBoxTiny', AppBoxTiny)
app.component('AuthenRequired', AuthenRequired)
app.mount('#app')
