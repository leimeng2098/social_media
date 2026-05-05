<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-100 p-4">
    <div class="bg-white p-8 rounded-2xl shadow-xl w-full max-w-md">
      <h2 class="text-3xl font-extrabold mb-2 text-center text-blue-600">歡迎回來</h2>
      <p class="text-gray-500 text-center mb-8">登入以繼續分享你的生活</p>
      
      <form @submit.prevent="handleLogin" class="space-y-5">
        <!-- 這裡改成電話號碼 -->
        <div>
          <label class="block text-sm font-semibold text-gray-700 mb-1">電話號碼</label>
          <input v-model="form.phoneNumber" type="tel" required
            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none transition" 
            placeholder="0912345678">
        </div>

        <div>
          <label class="block text-sm font-semibold text-gray-700 mb-1">密碼</label>
          <input v-model="form.password" type="password" required
            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none transition" 
            placeholder="請輸入密碼">
        </div>

        <button type="submit" 
          class="w-full bg-blue-600 text-white font-bold py-3 rounded-lg hover:bg-blue-700 transform active:scale-95 transition-all shadow-lg">
          登入
        </button>
      </form>
      
      <div class="mt-6 text-center text-sm text-gray-600">
        還沒有帳號嗎？ 
        <router-link to="/register" class="text-blue-500 font-bold hover:underline">立即註冊</router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import api from '../api/axios'

const router = useRouter()

// 資料模型改成 phoneNumber
const form = ref({
  phoneNumber: '',
  password: ''
})

const handleLogin = async () => {
  try {
    const response = await api.post('/users/login', form.value)
    
    if (response.status === 200) {
      const actualUserData = response.data.data ? response.data.data : response.data
      
      localStorage.setItem('user', JSON.stringify(actualUserData))
      
      router.push('/')
    }
  } catch (error) {
    console.error('登入失敗：', error)
    const errorMsg = error.response?.data || '登入失敗，請檢查網路連線。'
    alert(errorMsg)
  }
}
</script>