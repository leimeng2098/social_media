<template>
  <!-- 將高度鎖定為螢幕高度 (h-screen)，並隱藏外部滾動條 -->
  <div class="h-screen bg-gray-100 flex justify-center overflow-hidden">
    
    <!-- 主體內容區塊：改為垂直排列的 Flex 容器 -->
    <div class="w-full max-w-2xl bg-white border-x border-gray-200 flex flex-col h-full relative shadow-2xl">

      <!-- 1. 頂部導覽列 (固定在最上方) -->
      <div class="z-10 bg-white/90 backdrop-blur-sm border-b border-gray-200 p-4 flex justify-between items-center shrink-0">
        <h1 class="text-xl font-extrabold cursor-pointer">首頁</h1>
        <!-- 頭像區塊 -->
        <div v-if="!isLoggedIn" @click="goToLogin" class="w-10 h-10 rounded-full bg-black text-white flex items-center justify-center text-xs cursor-pointer hover:bg-gray-800 transition">
          未登入
        </div>
        <div v-else class="w-10 h-10 rounded-full bg-blue-500 text-white flex items-center justify-center text-lg font-bold shadow-md">
          {{ currentUser?.username?.charAt(0).toUpperCase() }}
        </div>
      </div>

      <!-- 2. 貼文列表清單 -->
      <div class="flex-1 overflow-y-auto p-4 bg-gray-50">
        
        <!-- 單篇貼文卡片：加入 @click 讓點擊整張卡片都能進入留言頁面 -->
        <div v-for="post in posts" :key="post.id" 
             @click="router.push(`/post/${post.id}`)"
             class="bg-white p-5 rounded-2xl shadow-sm border border-gray-100 mb-4 hover:shadow-md transition-shadow flex gap-4 cursor-pointer">
          
          <!-- 貼文者的頭像 -->
          <div class="flex-shrink-0">
            <div class="w-10 h-10 rounded-full bg-blue-500 text-white flex items-center justify-center font-bold shadow-sm">
              {{ post.username?.charAt(0).toUpperCase() }}
            </div>
          </div>
          
          <!-- 貼文內容 -->
          <div class="flex-1 pb-1">
            <div class="flex items-center justify-between mb-2">
                <div class="flex items-center gap-2">
                    <span class="font-bold text-gray-900 hover:underline">{{ post.username }}</span>
                    <span class="text-gray-400 text-sm font-medium">· {{ formatTime(post.createdAt) }}</span>
                </div>
                
                <!-- 專屬作者的操作按鈕區塊 -->
                <div v-if="currentUser && post.userId === currentUser.id" class="flex gap-2 text-sm">
                    <button @click.stop="startEdit(post)" v-if="editingPostId !== post.id" class="text-blue-500 hover:text-blue-700">編輯</button>
                    <button @click.stop="handleDelete(post.id)" v-if="editingPostId !== post.id" class="text-red-500 hover:text-red-700">刪除</button>
                </div>
            </div>
            
            <!-- 狀態 A：正常顯示貼文 -->
            <p v-if="editingPostId !== post.id" class="text-gray-800 whitespace-pre-wrap leading-relaxed text-[15px]">{{ post.content }}</p>
            
            <!-- 狀態 B：正在編輯中的輸入框 (@click.stop 防止點擊輸入框時跳轉頁面) -->
            <div v-else @click.stop>
                <textarea
                  v-model="editContent"
                  rows="3"
                  class="w-full resize-none bg-white border border-blue-300 rounded-lg px-3 py-2 outline-none focus:ring-2 focus:ring-blue-200 transition"
                ></textarea>
                <div class="flex justify-end gap-2 mt-2">
                    <button @click="editingPostId = null" class="px-4 py-1.5 rounded-full text-sm font-bold text-gray-500 hover:bg-gray-100">取消</button>
                    <button @click="handleUpdate(post.id)" class="bg-blue-500 text-white px-4 py-1.5 rounded-full text-sm font-bold hover:bg-blue-600">儲存</button>
                </div>
            </div>

            <div v-if="editingPostId !== post.id" class="mt-3 flex items-center gap-6 text-gray-400">
              <button @click.stop="router.push(`/post/${post.id}`)" class="flex items-center gap-1.5 hover:text-blue-500 transition group">
                <div class="p-1.5 rounded-full group-hover:bg-blue-50 transition">
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"></path></svg>
                </div>
                <span class="text-sm">{{ post.commentCount || 0 }}</span>
              </button>
            </div>

          </div>
        </div> 

        <!-- 畫面防呆：沒有半篇貼文時的狀態 -->
        <div v-if="posts.length === 0" class="p-10 flex flex-col items-center justify-center text-gray-400 h-full">
          <svg class="w-16 h-16 mb-4 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"></path></svg>
          <p>目前還沒有任何貼文，來當第一個發文的人吧！</p>
        </div>
      </div>

      <!-- 3. 發文區塊 (固定在最下方) -->
      <div class="p-4 bg-white border-t border-gray-200 shrink-0 flex gap-4 shadow-[0_-4px_6px_-1px_rgba(0,0,0,0.05)]">
        <!-- 發文者頭像預覽 -->
        <div class="flex-shrink-0 mt-1">
          <div class="w-10 h-10 rounded-full bg-blue-500 text-white flex items-center justify-center font-bold shadow-sm">
            <span v-if="isLoggedIn">{{ currentUser?.username?.charAt(0).toUpperCase() }}</span>
            <span v-else>?</span>
          </div>
        </div>

        <!-- 輸入框與按鈕 -->
        <div class="flex-1">
          <div v-if="!isLoggedIn" class="bg-gray-50 p-4 rounded-xl border border-gray-100 flex justify-between items-center">
            <span class="text-sm text-gray-500">登入後即可發佈貼文！</span>
            <button @click="goToLogin" class="bg-black text-white px-4 py-1.5 rounded-full font-bold text-sm hover:bg-gray-800 transition">
              前往登入
            </button>
          </div>

          <div v-else>
            <textarea
              v-model="newPostContent"
              rows="2"
              class="w-full resize-none bg-gray-50 border border-gray-200 rounded-xl px-4 py-3 outline-none text-[15px] focus:ring-2 focus:ring-blue-100 focus:bg-white transition placeholder-gray-400"
              placeholder="有什麼新鮮事？"
            ></textarea>
            <div class="flex justify-end mt-2">
              <button
                @click="handlePost"
                :disabled="!newPostContent.trim()"
                class="bg-blue-500 text-white px-6 py-2 rounded-full font-bold text-sm shadow-md shadow-blue-500/30 disabled:opacity-50 disabled:cursor-not-allowed hover:bg-blue-600 hover:-translate-y-0.5 transition-all"
              >
                發佈
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
import { useRouter } from 'vue-router'
import api from '../api/axios'

const router = useRouter()

// 響應式狀態
const posts = ref([])
const newPostContent = ref('')
const isLoggedIn = ref(false)
const currentUser = ref(null)

const editingPostId = ref(null)
const editContent = ref('')

// 頁面載入時觸發
onMounted(() => {
  checkAuth()
  fetchPosts()
})

// 檢查登入狀態 (去 localStorage 找 user 資料)
const checkAuth = () => {
  const userStr = localStorage.getItem('user')
  if (userStr) {
    currentUser.value = JSON.parse(userStr)
    isLoggedIn.value = true
  }
}

// 跳轉到登入頁
const goToLogin = () => {
  router.push('/login')
}

// 取得所有貼文 API
const fetchPosts = async () => {
  try {
    const res = await api.get('/posts')
    posts.value = res.data
  } catch (error) {
    console.error('無法取得貼文', error)
  }
}

// 發佈貼文 API
const handlePost = async () => {
  if (!newPostContent.value.trim()) return

  try {
    await api.post('/posts', {
      userId: currentUser.value.id,
      content: newPostContent.value,
      imageUrl: null
    })
    
    // 發文成功後清空輸入框，並重新拉取最新貼文列表
    newPostContent.value = ''
    fetchPosts()
  } catch (error) {
    console.error('發文失敗', error)
    alert('發文失敗，請稍後再試。')
  }
}

// 時間格式化小工具 (把時間轉成好讀的格式)
const formatTime = (dateString) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  return `${date.getMonth() + 1}/${date.getDate()} ${date.getHours()}:${String(date.getMinutes()).padStart(2, '0')}`
}

// 啟動編輯模式
const startEdit = (post) => {
  editingPostId.value = post.id
  editContent.value = post.content
}

// 儲存修改
const handleUpdate = async (postId) => {
  if (!editContent.value.trim()) return

  try {
    await api.put(`/posts/${postId}`, {
      userId: currentUser.value.id,
      content: editContent.value
    })
    
    editingPostId.value = null // 關閉編輯模式
    fetchPosts() // 重新拉取最新貼文
  } catch (error) {
    console.error('更新失敗', error)
    alert('更新失敗，請稍後再試。')
  }
}

// 刪除貼文
const handleDelete = async (postId) => {
  if (!confirm('確定要刪除這篇貼文嗎？刪除後無法復原。')) return

  try {
    // 刪除請求通常把參數放在 URL 或 Query String
    await api.delete(`/posts/${postId}?userId=${currentUser.value.id}`)
    
    fetchPosts() // 重新拉取列表，畫面上的貼文就會消失了！
  } catch (error) {
    console.error('刪除失敗', error)
    alert('刪除失敗，請稍後再試。')
  }
}
</script>