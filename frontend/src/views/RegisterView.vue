<template>
  <div class="min-h-screen flex items-center justify-center bg-[#F1F8FF] p-4">
    <div class="bg-[#FDFDFD] p-8 rounded-2xl shadow-xl w-full max-w-md">
      <h2 class="text-3xl font-extrabold mb-2 text-center text-[#5F7585]">建立新帳號</h2>
      <p class="text-[#7D9AAE] text-center mb-8">加入我們的社群，開始分享生活</p>
      
      <form @submit.prevent="handleRegister" class="space-y-5">
        <div>
          <label class="block text-sm font-semibold text-[#5F7585] mb-1">使用者名稱</label>
          <input v-model="form.username" type="text" required
            class="w-full px-4 py-2 border border-[#7D9AAE]/40 rounded-lg focus:ring-2 focus:ring-[#5F7585] focus:border-transparent outline-none transition bg-white text-[#5F7585] placeholder-[#7D9AAE]/60" 
            placeholder="請輸入暱稱">
        </div>

        <div>
          <label class="block text-sm font-semibold text-[#5F7585] mb-1">電話號碼 (登入用)</label>
          <input v-model="form.phoneNumber" type="tel" required
            class="w-full px-4 py-2 border border-[#7D9AAE]/40 rounded-lg focus:ring-2 focus:ring-[#5F7585] focus:border-transparent outline-none transition bg-white text-[#5F7585] placeholder-[#7D9AAE]/60" 
            placeholder="0912345678">
        </div>

        <div>
          <label class="block text-sm font-semibold text-[#5F7585] mb-1">Email</label>
          <input v-model="form.email" type="email"
            class="w-full px-4 py-2 border border-[#7D9AAE]/40 rounded-lg focus:ring-2 focus:ring-[#5F7585] focus:border-transparent outline-none transition bg-white text-[#5F7585] placeholder-[#7D9AAE]/60" 
            placeholder="example@mail.com">
        </div>

        <div>
          <label class="block text-sm font-semibold text-[#5F7585] mb-1">密碼</label>
          <input v-model="form.password" type="password" required
            class="w-full px-4 py-2 border border-[#7D9AAE]/40 rounded-lg focus:ring-2 focus:ring-[#5F7585] focus:border-transparent outline-none transition bg-white text-[#5F7585] placeholder-[#7D9AAE]/60" 
            placeholder="請設定登入密碼">
        </div>

        <button type="submit" 
          class="w-full bg-[#5F7585] text-[#FDFDFD] font-bold py-3 rounded-lg hover:brightness-110 transform active:scale-95 transition-all shadow-lg">
          立即註冊
        </button>
      </form>
      
      <div class="mt-6 text-center text-sm text-[#7D9AAE]">
        已經有帳號了？ 
        <router-link to="/login" class="text-[#5F7585] font-bold hover:underline">立即登入</router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import api from '../api/axios' 

const router = useRouter()

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
      router.push('/login')
    }
  } catch (error) {
    console.error('註冊失敗：', error)
    alert('註冊失敗，請檢查後端伺服器是否啟動。')
  }
}
</script>
