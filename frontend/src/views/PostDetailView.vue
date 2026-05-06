<template>
  <div class="h-screen bg-[#F1F8FF] flex justify-center overflow-hidden">

    <div class="w-full max-w-2xl bg-[#FFFFFF] border-x border-gray-200 flex flex-col h-full relative shadow-2xl">

      <!-- 頂部導覽列與返回按鈕 -->
      <div class="z-10 bg-[#7D9AAE]/95 backdrop-blur-sm border-b border-gray-200 p-4 flex items-center shrink-0 sticky top-0">
        <button @click="goBack" class="mr-5 p-2 rounded-full hover:bg-[#5F7585] hover:text-white transition text-[#FFFFFF]">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path>
          </svg>
        </button>
        <h1 class="text-xl font-extrabold cursor-pointer text-[#FFFFFF]">貼文</h1>
      </div>

      <div class="flex-1 overflow-y-auto bg-[#FDFDFD]">
        
        <!-- 單一貼文主體 -->
        <div v-if="post" class="bg-[#FDFDFD] p-5 border-b border-gray-200 shadow-sm">
          <div class="flex gap-4 mb-3">
            <div :class="[post.avatarColor || 'bg-blue-500', 'w-12 h-12 rounded-full text-white flex items-center justify-center font-bold shadow-sm text-xl']">
                {{ post.username?.charAt(0).toUpperCase() }}
            </div>
            <div class="flex flex-col justify-center">
              <div class="font-bold text-[#1E1E1E] text-lg">{{ post.username }}</div>
              <div class="text-[#7D9AAE] text-sm font-medium">{{ formatTime(post.createdAt) }}</div>
            </div>
          </div>
          <p class="text-[#1E1E1E] whitespace-pre-wrap leading-relaxed text-xl mb-4">{{ post.content }}</p>
          
          <div class="border-t border-[#7D9AAE]/20 pt-3 text-[#7D9AAE] text-sm">
            <span class="font-bold text-[#1E1E1E]">{{ post.commentCount || 0 }}</span> 則留言
          </div>
        </div>

        <!-- 留言列表區塊 -->
        <div class="p-4 space-y-4">
          <div v-for="comment in comments" :key="comment.id" class="bg-[#FDFDFD] p-4 rounded-xl shadow-sm border border-[#7D9AAE]/20 hover:shadow-md hover:bg-[#F1F8FF] transition-all duration-300 flex gap-3">
            <div class="flex-shrink-0">
              <div :class="[comment.avatarColor || 'bg-blue-500', 'w-10 h-10 rounded-full text-white flex items-center justify-center font-bold shadow-sm']">
                {{ comment.username?.charAt(0).toUpperCase() }}
              </div>
            </div>
            <div class="flex-1 pb-1">
              <div class="flex items-center gap-2 mb-1">
                <span class="font-bold text-[#1E1E1E] hover:underline">{{ comment.username }}</span>
                <span class="text-[#7D9AAE] text-sm font-medium">· {{ formatTime(comment.createdAt) }}</span>
              </div>
              <p class="text-[#1E1E1E] whitespace-pre-wrap leading-relaxed text-[15px]">{{ comment.content }}</p>
            </div>
          </div>

          <div v-if="comments.length === 0 && post" class="py-10 flex flex-col items-center justify-center text-[#7D9AAE] h-full">
            <p>還沒有人留言，來搶頭香吧！</p>
          </div>
        </div>
      </div>

      <!-- 底部回覆框區塊 -->
      <div class="p-4 bg-[#7D9AAE] border-t border-[#7D9AAE]/50 shrink-0 flex gap-4 shadow-[0_-4px_6px_-1px_rgba(0,0,0,0.1)]">
        <div class="flex-shrink-0 mt-1">
          <div :class="[currentUser?.avatarColor || 'bg-blue-500', 'w-10 h-10 rounded-full text-white flex items-center justify-center font-bold shadow-sm']">
            <span v-if="isLoggedIn">{{ currentUser?.username?.charAt(0).toUpperCase() }}</span>
            <span v-else>?</span>
          </div>
        </div>

        <div class="flex-1">
          <div v-if="!isLoggedIn" class="bg-[#FDFDFD] p-4 rounded-xl border border-transparent flex justify-between items-center shadow-inner">
            <span class="text-sm text-[#1E1E1E] font-medium">登入後即可回覆貼文！</span>
            <button @click="router.push('/login')" class="bg-[#5F7585] text-white px-4 py-1.5 rounded-full font-bold text-sm hover:brightness-110 transition">
              前往登入
            </button>
          </div>

          <div v-else>
            <textarea
              v-model="newCommentContent"
              rows="1"
              class="w-full resize-none bg-[#FDFDFD] border border-transparent rounded-xl px-4 py-3 outline-none text-[#1E1E1E] focus:ring-2 focus:ring-[#5F7585] transition placeholder-[#7D9AAE] shadow-inner"
              placeholder="發佈你的回覆..."
            ></textarea>
            <div class="flex justify-end mt-2">
              <button
                @click="handleComment"
                :disabled="!newCommentContent.trim()"
                class="bg-[#5F7585] text-[#FDFDFD] px-6 py-2 rounded-full font-bold text-sm shadow-md shadow-black/20 disabled:opacity-50 disabled:cursor-not-allowed hover:brightness-110 hover:-translate-y-0.5 transition-all"
              >
                回覆
              </button>
            </div>
          </div>
        </div>
      </div>

    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import api from '../api/axios'

const route = useRoute() 
const router = useRouter() 

const postId = route.params.id 
const post = ref(null)
const comments = ref([])
const newCommentContent = ref('')

const currentUser = ref(null)
const isLoggedIn = ref(false)

onMounted(() => {
  checkAuth()
  fetchPost()
  fetchComments()
})

const checkAuth = () => {
  const userStr = localStorage.getItem('user')
  if (userStr) {
    currentUser.value = JSON.parse(userStr)
    isLoggedIn.value = true
  }
}

const goBack = () => {
  router.back() 
}

const fetchPost = async () => {
  try {
    const res = await api.get(`/posts/${postId}`)
    post.value = res.data
  } catch (error) {
    console.error('無法取得貼文', error)
    alert('找不到該貼文或已被刪除！')
    router.push('/') 
  }
}

const fetchComments = async () => {
  try {
    const res = await api.get(`/posts/${postId}/comments`)
    comments.value = res.data
  } catch (error) {
    console.error('無法取得留言', error)
  }
}

const handleComment = async () => {
  if (!newCommentContent.value.trim()) return

  try {
    await api.post(`/posts/${postId}/comments`, {
      userId: currentUser.value.id,
      content: newCommentContent.value
    })
    
    newCommentContent.value = ''
    fetchComments() 
    fetchPost() 
  } catch (error) {
    console.error('留言失敗', error)
    alert('留言失敗，請稍後再試。')
  }
}

const formatTime = (dateString) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  return `${date.getMonth() + 1}/${date.getDate()} ${date.getHours()}:${String(date.getMinutes()).padStart(2, '0')}`
}
</script>