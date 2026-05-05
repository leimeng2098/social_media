import { createRouter, createWebHistory } from 'vue-router'
import RegisterView from '../views/RegisterView.vue'
import LoginView from '../views/LoginView.vue' 
import HomeView from '../views/HomeView.vue'
import PostDetailView from '../views/PostDetailView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView 
    },
    {
      path: '/register',
      name: 'register',
      component: RegisterView
    },
    {
      path: '/login', 
      name: 'login',
      component: LoginView
    },
    {
      path: '/',
      redirect: '/login' 
    },
    {
      path: '/post/:id', 
      name: 'postDetail',
      component: PostDetailView
    }
  ]
})

export default router