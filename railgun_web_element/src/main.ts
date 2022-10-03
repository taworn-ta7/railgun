import { createApp } from 'vue'
import { createPinia } from 'pinia'
import ElementPlus from 'element-plus'
import 'element-plus/theme-chalk/dark/css-vars.css'
import 'element-plus/dist/index.css'
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
app.use(ElementPlus, {})
app.component('AppBox', AppBox)
app.component('AppBoxTiny', AppBoxTiny)
app.component('AuthenRequired', AuthenRequired)
app.mount('#app')
