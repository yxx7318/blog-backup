# Element Plus X

> 开箱即用的 企业级 AI 交互组件库，让开发者 构建 AIGC 智能界面像搭积木一样简单
>
> 官网：[Element-Plus-X](https://element-plus-x.com/zh/)
>
> 模板仓库：[ruoyi-element-ai: 🎨🎨🎨 Vue3.5 + Element-Plus-X1.2 + ruoyiAI，推出仿豆包/通义，企业级AI-PC端应用模版，助力企业快速搭建-全栈AI项目](https://gitee.com/he-jiayue/ruoyi-element-ai)

## 基本使用

```
pnpm install vue-element-plus-x
```

或者：

```
npm install vue-element-plus-x --save
```

> `vue-element-plus-x`版本`1.3.7`，绑定`vue`版本为`3.5.17`

按需引入：

> 内置`Tree Shaking`优化，无需额外配置

```vue
<script>
import { BubbleList, Sender } from 'vue-element-plus-x';

const list = [
  {
    content: 'Hello, Element Plus X',
    role: 'user'
  }
];
</script>

<template>
  <div
    style="display: flex; flex-direction: column; height: 230px; justify-content: space-between;"
  >
    <BubbleList :list="list" />
    <Sender />
  </div>
</template>
```

全量引入(打包大小会增加3MB的js代码)：

```js
// main.ts
import { createApp } from 'vue'
import ElementPlusX from 'vue-element-plus-x'
import App from './App.vue'

const app = createApp(App)
// 使用 app.use() 全局引入
app.use(ElementPlusX)
app.mount('#app')
```

