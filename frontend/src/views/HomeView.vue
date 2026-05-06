<template>
  <div class="h-screen bg-[#F1F8FF] flex justify-center overflow-hidden">
    
    <div class="w-full max-w-2xl bg-[#FFFFFF] border-x border-gray-200 flex flex-col h-full relative shadow-2xl">

      <div class="z-10 bg-[#7D9AAE]/95 backdrop-blur-sm border-b border-gray-200 p-4 flex justify-between items-center shrink-0">
        <h1 class="text-xl font-extrabold cursor-pointer text-[#FFFFFF]">首頁</h1>

        <div v-if="!isLoggedIn" @click="goToLogin" class="w-10 h-10 rounded-full bg-[#5F7585] text-white flex items-center justify-center text-xs cursor-pointer hover:bg-gray-800 transition">
          未登入
        </div>

        <div v-else @click="openProfile" 
                :class="[currentUser?.avatarColor || 'bg-[#79B4EC]', 'cursor-pointer hover:ring-2 hover:ring-offset-2 hover:ring-[#E1E1E1] w-10 h-10 rounded-full text-white flex items-center justify-center text-lg font-bold shadow-md transition-all']">
            {{ currentUser?.username?.charAt(0).toUpperCase() }}
        </div>
        
      </div>

      <div class="flex-1 overflow-y-auto p-4 bg-[#FDFDFD]">
        
        <div v-for="post in posts" :key="post.id" 
             @click="router.push(`/post/${post.id}`)"
             class="bg-[#FDFDFD] p-5 rounded-2xl shadow-md border border-gray-200 mb-4 hover:shadow-lg transition-shadow flex gap-4 cursor-pointer">

          <div class="flex-shrink-0">
            <div :class="[post.avatarColor || 'bg-[#79B4EC]', 'w-10 h-10 rounded-full text-white flex items-center justify-center font-bold shadow-sm']">
                <span>{{ post.username?.charAt(0).toUpperCase() }}</span>
            </div>
          </div>
          
          <div class="flex-1 pb-1">
            <div class="flex items-center justify-between mb-2">
                <div class="flex items-center gap-2">
                    <span class="font-bold text-[#1E1E1E] hover:underline">{{ post.username }}</span>
                    <span class="text-[#7D9AAE] text-sm font-medium">· {{ formatTime(post.createdAt) }}</span>
                </div>
                
                <div v-if="currentUser && post.userId === currentUser.id" class="flex gap-2 text-sm">
                    <button @click.stop="startEdit(post)" v-if="editingPostId !== post.id" class="text-[#5F7585] hover:brightness-75 transition">編輯</button>
                    <button @click.stop="handleDelete(post.id)" v-if="editingPostId !== post.id" class="text-red-500 hover:text-red-700">刪除</button>
                </div>
            </div>
            
            <p v-if="editingPostId !== post.id" class="text-[#1E1E1E] whitespace-pre-wrap leading-relaxed text-[15px]">{{ post.content }}</p>
            
            <div v-else @click.stop>
                <textarea
                  v-model="editContent"
                  rows="3"
                  class="w-full resize-none bg-white border border-[#7D9AAE] rounded-lg px-3 py-2 outline-none focus:ring-2 focus:ring-[#7D9AAE] transition"
                ></textarea>
                <div class="flex justify-end gap-2 mt-2">
                    <button @click="editingPostId = null" class="px-4 py-1.5 rounded-full text-sm font-bold text-gray-500 hover:bg-gray-200">取消</button>
                    <button @click="handleUpdate(post.id)" class="bg-[#5F7585] text-white px-4 py-1.5 rounded-full text-sm font-bold hover:brightness-110 transition">儲存</button>
                </div>
            </div>

            <div v-if="editingPostId !== post.id" class="mt-3 flex items-center gap-6 text-[#7D9AAE]">
              <button @click.stop="router.push(`/post/${post.id}`)" class="flex items-center gap-1.5 hover:brightness-75 transition group">
                <div class="p-1.5 rounded-full group-hover:bg-[#7D9AAE]/10 transition">
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"></path></svg>
                </div>
                <span class="text-sm font-medium">{{ post.commentCount || 0 }}</span>
              </button>
            </div>

          </div>
        </div> 

        <div v-if="posts.length === 0" class="p-10 flex flex-col items-center justify-center text-[#7D9AAE] h-full">
          <svg class="w-16 h-16 mb-4 opacity-50" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"></path></svg>
          <p class="font-medium">目前還沒有任何貼文，來當第一個發文的人吧！</p>
        </div>
      </div>

      <div class="p-4 bg-[#7D9AAE] border-t border-[#7D9AAE]/50 shrink-0 flex gap-4 shadow-[0_-4px_6px_-1px_rgba(0,0,0,0.1)]">
        <div class="flex-shrink-0 mt-1">
          <div :class="[currentUser?.avatarColor || 'bg-[#79B4EC]', 'w-10 h-10 rounded-full text-white flex items-center justify-center font-bold shadow-sm']">
            <span v-if="isLoggedIn">{{ currentUser?.username?.charAt(0).toUpperCase() }}</span>
            <span v-else>?</span>
          </div>
        </div>

        <div class="flex-1">
          <div v-if="!isLoggedIn" class="bg-[#FDFDFD] p-4 rounded-xl border border-transparent flex justify-between items-center shadow-inner">
            <span class="text-sm text-[#1E1E1E] font-medium">登入後即可發佈貼文！</span>
            <button @click="goToLogin" class="bg-[#5F7585] text-white px-4 py-1.5 rounded-full font-bold text-sm hover:bg-gray-800 transition">
              前往登入
            </button>
          </div>

          <div v-else>
            <textarea
              v-model="newPostContent"
              rows="2"
              class="w-full resize-none bg-[#FDFDFD] border border-transparent rounded-xl px-4 py-3 outline-none text-[#1E1E1E] focus:ring-2 focus:ring-[#5F7585] transition placeholder-[#7D9AAE] shadow-inner"
              placeholder="有什麼新鮮事？"
            ></textarea>
            <div class="flex justify-end mt-2">
              <button
                @click="handlePost"
                :disabled="!newPostContent.trim()"
                class="bg-[#5F7585] text-[#FDFDFD] px-6 py-2 rounded-full font-bold text-sm shadow-md shadow-black/20 disabled:opacity-50 disabled:cursor-not-allowed hover:brightness-110 hover:-translate-y-0.5 transition-all"
              >
                發佈
              </button>
            </div>
          </div>
        </div>
      </div>

    </div>

    <div v-if="isProfileOpen" @click="isProfileOpen = false" class="fixed inset-0 z-50 bg-black/40 backdrop-blur-sm flex justify-end transition-opacity">
      <div @click.stop class="w-80 bg-white h-full shadow-2xl flex flex-col animate-slide-in-right">
        
        <div class="p-4 flex justify-end border-b border-gray-100">
          <button @click="isProfileOpen = false" class="text-gray-400 hover:text-gray-800 p-2 bg-gray-50 rounded-full transition">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
          </button>
        </div>

        <div class="flex-1 overflow-y-auto p-6 flex flex-col gap-5">
          <div class="flex justify-center mb-2">
            <div :class="[profileForm.avatarColor, 'w-24 h-24 rounded-full text-white flex items-center justify-center text-4xl font-bold shadow-lg border-4 border-gray-50 transition-colors duration-300']">
                {{ profileForm.username?.charAt(0).toUpperCase() }}
            </div>
          </div>

          <div class="flex justify-center gap-3 mb-4">
            <button v-for="color in colorOptions" :key="color" @click="profileForm.avatarColor = color"
                :class="[color, 'w-8 h-8 rounded-full shadow-sm hover:scale-110 transition-transform', profileForm.avatarColor === color ? 'ring-4 ring-gray-300 ring-offset-2' : '']">
            </button>
          </div>

          <div class="space-y-4">
            <div>
              <label class="block text-xs font-bold text-gray-500 mb-1">暱稱 (可修改)</label>
              <input v-model="profileForm.username" type="text" class="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-lg focus:bg-white focus:ring-2 focus:ring-[#7D9AAE] outline-none transition">
            </div>
            <div>
              <label class="block text-xs font-bold text-gray-500 mb-1">電話號碼</label>
              <input :value="currentUser?.phoneNumber" disabled type="text" class="w-full px-3 py-2 bg-gray-100 border border-gray-200 rounded-lg text-gray-500 cursor-not-allowed">
            </div>
            <div>
              <label class="block text-xs font-bold text-gray-500 mb-1">Email</label>
              <input :value="currentUser?.email || '未提供'" disabled type="text" class="w-full px-3 py-2 bg-gray-100 border border-gray-200 rounded-lg text-gray-500 cursor-not-allowed">
            </div>
            <div>
              <label class="block text-xs font-bold text-gray-500 mb-1">個人介紹 (可修改)</label>
              <textarea v-model="profileForm.biography" rows="3" placeholder="介紹一下你自己吧！" class="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-lg focus:bg-white focus:ring-2 focus:ring-[#7D9AAE] outline-none transition resize-none"></textarea>
            </div>
            <button @click="handleUpdateProfile" class="w-full bg-[#5F7585] text-white font-bold py-2.5 rounded-lg hover:brightness-110 active:scale-95 transition-all shadow-md mt-2">
              儲存修改
            </button>
          </div>
        </div>

        <div class="p-4 border-t border-gray-100 bg-gray-50">
          <button @click="handleLogout" class="w-full bg-white border-2 border-red-100 text-red-500 font-bold py-2.5 rounded-lg hover:bg-red-50 hover:border-red-200 transition-colors flex items-center justify-center gap-2">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg>
            登出帳號
          </button>
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

const colorOptions = ['bg-[#79B4EC]', 'bg-[#F09898]', 'bg-[#85C796]', 'bg-[#F2C966]', 'bg-[#B7A0E8]']

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

const isProfileOpen = ref(false)
const profileForm = ref({
  username: '',
  biography: ''
})

const openProfile = () => {
  profileForm.value = {
    username: currentUser.value.username,
    biography: currentUser.value.biography || '',
    avatarColor: currentUser.value.avatarColor || 'bg-[#79B4EC]'
  }
  isProfileOpen.value = true
}

const handleUpdateProfile = async () => {
  if (!profileForm.value.username.trim()) {
    alert('暱稱不能為空！')
    return
  }

  try {
    await api.put(`/users/${currentUser.value.id}`, {
      username: profileForm.value.username,
      biography: profileForm.value.biography,
      avatarColor: profileForm.value.avatarColor
    })
    
    currentUser.value = {
      ...currentUser.value,
      username: profileForm.value.username,
      biography: profileForm.value.biography,
      avatarColor: profileForm.value.avatarColor
    }
    
    localStorage.setItem('user', JSON.stringify(currentUser.value))
    
    alert('個人資料更新成功！')
    isProfileOpen.value = false 
    fetchPosts() 
  } catch (error) {
    console.error('更新失敗', error)
    alert('更新失敗，請稍後再試。')
  }
}

const handleLogout = () => {
  localStorage.removeItem('user')
  currentUser.value = null
  isLoggedIn.value = false
  isProfileOpen.value = false
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