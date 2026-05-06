<template>
  <div class="min-h-screen flex items-center justify-center bg-[#F1F8FF] p-4">
    <div class="bg-[#FDFDFD] p-8 rounded-2xl shadow-xl w-full max-w-md">
      <h2 class="text-3xl font-extrabold mb-2 text-center text-[#5F7585]">歡迎回來</h2>
      <p class="text-[#7D9AAE] text-center mb-8">登入以繼續分享你的生活</p>
      
      <form @submit.prevent="handleLogin" class="space-y-5">
        <div>
          <label class="block text-sm font-semibold text-[#5F7585] mb-1">電話號碼</label>
          <input v-model="form.phoneNumber" type="tel" required
            :class="[errorMessage ? 'border-red-500 focus:ring-red-500' : 'border-[#7D9AAE]/40 focus:ring-[#5F7585]']"
            class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:border-transparent outline-none transition bg-white text-[#5F7585] placeholder-[#7D9AAE]/60" 
            placeholder="0912345678">
        </div>

        <div>
          <label class="block text-sm font-semibold text-[#5F7585] mb-1">密碼</label>
          <input v-model="form.password" type="password" required
            :class="[errorMessage ? 'border-red-500 focus:ring-red-500' : 'border-[#7D9AAE]/40 focus:ring-[#5F7585]']"
            class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:border-transparent outline-none transition bg-white text-[#5F7585] placeholder-[#7D9AAE]/60" 
            placeholder="請輸入密碼">
        </div>

        <div v-if="errorMessage" class="text-red-500 text-sm font-bold text-center bg-red-50 py-2 rounded-lg animate-pulse">
          {{ errorMessage }}
        </div>

        <button type="submit" 
          class="w-full bg-[#5F7585] text-[#FDFDFD] font-bold py-3 rounded-lg hover:brightness-110 transform active:scale-95 transition-all shadow-lg">
          登入
        </button>
      </form>
      
      <div class="mt-6 text-center text-sm text-[#7D9AAE]">
        還沒有帳號嗎？ 
        <router-link to="/register" class="text-[#5F7585] font-bold hover:underline">立即註冊</router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import api from '../api/axios'

const router = useRouter()

const form = ref({
  phoneNumber: '',
  password: ''
})

const errorMessage = ref('')

watch(form, () => {
  errorMessage.value = ''
}, { deep: true })

const handleLogin = async () => {
  try {
    const response = await api.post('/users/login', form.value)
    
    if (response.data.success) {
      const actualUserData = response.data.data ? response.data.data : response.data
      localStorage.setItem('user', JSON.stringify(actualUserData))
      router.push('/')
    } else {
      errorMessage.value = '帳號或密碼錯誤'
    }
  } catch (error) {
    console.error('登入失敗：', error)
    errorMessage.value = '帳號或密碼錯誤'
  }
}
</script>