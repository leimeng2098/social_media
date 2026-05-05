<template>
  <div class="h-screen bg-gray-100 flex justify-center overflow-hidden">
    
    <div class="w-full max-w-2xl bg-white border-x border-gray-200 flex flex-col h-full relative shadow-2xl">

      <div class="z-10 bg-white/90 backdrop-blur-sm border-b border-gray-200 p-4 flex justify-between items-center shrink-0">
        <h1 class="text-xl font-extrabold cursor-pointer">首頁</h1>

        <div v-if="!isLoggedIn" @click="goToLogin" class="w-10 h-10 rounded-full bg-black text-white flex items-center justify-center text-xs cursor-pointer hover:bg-gray-800 transition">
          未登入
        </div>
        <div v-else class="w-10 h-10 rounded-full bg-blue-500 text-white flex items-center justify-center text-lg font-bold shadow-md">
          {{ currentUser?.username?.charAt(0).toUpperCase() }}
        </div>
      </div>

      <div class="flex-1 overflow-y-auto p-4 bg-gray-50">
        
        <div v-for="post in posts" :key="post.id" 
             @click="router.push(`/post/${post.id}`)"
             class="bg-white p-5 rounded-2xl shadow-sm border border-gray-100 mb-4 hover:shadow-md transition-shadow flex gap-4 cursor-pointer">
          
          <div class="flex-shrink-0">
            <div class="w-10 h-10 rounded-full bg-blue-500 text-white flex items-center justify-center font-bold shadow-sm">
              {{ post.username?.charAt(0).toUpperCase() }}
            </div>
          </div>
          
          <div class="flex-1 pb-1">
            <div class="flex items-center justify-between mb-2">
                <div class="flex items-center gap-2">
                    <span class="font-bold text-gray-900 hover:underline">{{ post.username }}</span>
                    <span class="text-gray-400 text-sm font-medium">· {{ formatTime(post.createdAt) }}</span>
                </div>
                
                <div v-if="currentUser && post.userId === currentUser.id" class="flex gap-2 text-sm">
                    <button @click.stop="startEdit(post)" v-if="editingPostId !== post.id" class="text-blue-500 hover:text-blue-700">編輯</button>
                    <button @click.stop="handleDelete(post.id)" v-if="editingPostId !== post.id" class="text-red-500 hover:text-red-700">刪除</button>
                </div>
            </div>
            
            <p v-if="editingPostId !== post.id" class="text-gray-800 whitespace-pre-wrap leading-relaxed text-[15px]">{{ post.content }}</p>
            
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

        <div v-if="posts.length === 0" class="p-10 flex flex-col items-center justify-center text-gray-400 h-full">
          <svg class="w-16 h-16 mb-4 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"></path></svg>
          <p>目前還沒有任何貼文，來當第一個發文的人吧！</p>
        </div>
      </div>

      <div class="p-4 bg-white border-t border-gray-200 shrink-0 flex gap-4 shadow-[0_-4px_6px_-1px_rgba(0,0,0,0.05)]">
        <!-- 發文者頭像預覽 -->
        <div class="flex-shrink-0 mt-1">
          <div class="w-10 h-10 rounded-full bg-blue-500 text-white flex items-center justify-center font-bold shadow-sm">
            <span v-if="isLoggedIn">{{ currentUser?.username?.charAt(0).toUpperCase() }}</span>
            <span v-else>?</span>
          </div>
        </div>

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

const posts = ref([])
const newPostContent = ref('')
const isLoggedIn = ref(false)
const currentUser = ref(null)

const editingPostId = ref(null)
const editContent = ref('')

onMounted(() => {
  checkAuth()
  fetchPosts()
})

const checkAuth = () => {
  const userStr = localStorage.getItem('user')
  if (userStr) {
    currentUser.value = JSON.parse(userStr)
    isLoggedIn.value = true
  }
}

const goToLogin = () => {
  router.push('/login')
}

const fetchPosts = async () => {
  try {
    const res = await api.get('/posts')
    posts.value = res.data
  } catch (error) {
    console.error('無法取得貼文', error)
  }
}

const handlePost = async () => {
  if (!newPostContent.value.trim()) return

  try {
    await api.post('/posts', {
      userId: currentUser.value.id,
      content: newPostContent.value,
      imageUrl: null
    })
    
    newPostContent.value = ''
    fetchPosts()
  } catch (error) {
    console.error('發文失敗', error)
    alert('發文失敗，請稍後再試。')
  }
}

const formatTime = (dateString) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  return `${date.getMonth() + 1}/${date.getDate()} ${date.getHours()}:${String(date.getMinutes()).padStart(2, '0')}`
}

const startEdit = (post) => {
  editingPostId.value = post.id
  editContent.value = post.content
}

const handleUpdate = async (postId) => {
  if (!editContent.value.trim()) return

  try {
    await api.put(`/posts/${postId}`, {
      userId: currentUser.value.id,
      content: editContent.value
    })
    
    editingPostId.value = null 
    fetchPosts() 
  } catch (error) {
    console.error('更新失敗', error)
    alert('更新失敗，請稍後再試。')
  }
}

const handleDelete = async (postId) => {
  if (!confirm('確定要刪除這篇貼文嗎？刪除後無法復原。')) return

  try {
    await api.delete(`/posts/${postId}?userId=${currentUser.value.id}`)
    
    fetchPosts() 
  } catch (error) {
    console.error('刪除失敗', error)
    alert('刪除失敗，請稍後再試。')
  }
}
</script>