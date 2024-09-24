# Vite

## 基本使用

安装：

```
npm install -g vite
```

创建项目：

```
npm create vite@latest videodubber-vite -- --template vue
```

> ![image-20240819165700159](img/Vite/image-20240819165700159.png)

运行项目：

![image-20240819165843747](img/Vite/image-20240819165843747.png)

## 设置别名

在`vue.config.js`中配置：

```js
export default defineConfig({
  resolve: {
    alias: {
      '@': '/src', // 设置别名 '@' 指向 'src' 目录
    },
  },
})
```

## 增加路由

安装依赖：

```
npm install vue-router@4
```

创建路由文件：

```js
// src/router/index.js
import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home.vue'
import About from '../views/About.vue'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/about',
    name: 'about',
    component: About
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
```

在`main.js`中引入路由：

```js
import { createApp } from 'vue'


createApp(App).use(router)
```

修改`App.vue`：

```vue
<script setup>
import HomeTop from './components/Home/HomeTop.vue'
import HomeBottom from './components/Home/HomeBottom.vue'
</script>

<template>
  <HomeTop />
  <router-view />
  <HomeBottom />
</template>

<style scoped></style>
```

> 消除全局css影响，在`main.js`中注释掉`import './style.css'`引入，或者注释掉`style.css`文件
>
> 使用路由效果，首页：
>
> ![image-20240924115556484](img/Vite/image-20240924115556484.png)
>
> 跳转到指定路由界面：
>
> ![image-20240924115806611](img/Vite/image-20240924115806611.png)