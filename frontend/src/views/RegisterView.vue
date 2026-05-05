<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-100 p-4">
    <div class="bg-white p-8 rounded-2xl shadow-xl w-full max-w-md">
      <h2 class="text-3xl font-extrabold mb-2 text-center text-blue-600">建立新帳號</h2>
      <p class="text-gray-500 text-center mb-8">加入我們的社群，開始分享生活</p>
      
      <form @submit.prevent="handleRegister" class="space-y-5">
        <div>
          <label class="block text-sm font-semibold text-gray-700 mb-1">使用者名稱</label>
          <input v-model="form.username" type="text" required
            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none transition" 
            placeholder="請輸入暱稱">
        </div>

        <div>
          <label class="block text-sm font-semibold text-gray-700 mb-1">電話號碼 (登入用)</label>
          <input v-model="form.phoneNumber" type="tel" required
            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none transition" 
            placeholder="0912345678">
        </div>

        <div>
          <label class="block text-sm font-semibold text-gray-700 mb-1">Email</label>
          <input v-model="form.email" type="email"
            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none transition" 
            placeholder="example@mail.com">
        </div>

        <div>
          <label class="block text-sm font-semibold text-gray-700 mb-1">密碼</label>
          <input v-model="form.password" type="password" required
            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none transition" 
            placeholder="請設定登入密碼">
        </div>

        <button type="submit" 
          class="w-full bg-blue-600 text-white font-bold py-3 rounded-lg hover:bg-blue-700 transform active:scale-95 transition-all shadow-lg">
          立即註冊
        </button>
      </form>
      
      <div class="mt-6 text-center text-sm text-gray-600">
        已經有帳號了？ 
        <router-link to="/login" class="text-blue-500 font-bold hover:underline">立即登入</router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import api from '../api/axios' // 引入剛寫好的連線工具

const form = ref({
  username: '',
  phoneNumber: '',
  email: '',
  password: ''
})

const handleRegister = async () => {
  try {
    const response = await api.post('/users/register', form.value)
    if (response.data.success) {
      alert('註冊成功！')
    }
  } catch (error) {
    console.error('註冊失敗：', error)
    alert('註冊失敗，請檢查後端伺服器是否啟動。')
  }
}
</script>
