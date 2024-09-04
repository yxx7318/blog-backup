# ElementPlus

> 官网：[一个 Vue 3 UI 框架 | Element Plus (element-plus.org)](https://element-plus.org/zh-CN/)

## 原生使用

> 直接通过浏览器的HTML标签导入Element Plus，然后就可以使用全局变量`ElementPlus`了

```html
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0" />
    <script src="https://unpkg.com/vue@3"></script>
    <!-- import CSS -->
    <link rel="stylesheet" href="https://unpkg.com/element-plus/dist/index.css">
    <!-- import JavaScript -->
    <script src="https://unpkg.com/element-plus"></script>
    <title>Element Plus demo</title>
  </head>
  <body>
    <div id="app">
      <el-button>{{ message }}</el-button>
    </div>
    <script>
      const App = {
        data() {
          return {
            message: "Hello Element Plus",
          };
        },
      };
      const app = Vue.createApp(App);
      app.use(ElementPlus);
      app.mount("#app");
    </script>
  </body>
</html>
```

## 安装

```js
# NPM
npm install element-plus --save

# Yarn
yarn add element-plus

# pnpm
pnpm install element-plus
```

### 全局引入

main.js

```js
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'

app.use(ElementPlus)
```

### 按需导入

安装`unplugin-vue-components`和`unplugin-auto-import`这两款插件

```
npm install -D unplugin-vue-components unplugin-auto-import
```

> - `-D`：是一个简写，代表`--save-dev`。这个标志告诉 `npm` 将指定的包添加到 `package.json` 文件的 `devDependencies` 部分。`devDependencies` 是开发依赖项，这些依赖项只在开发环境中使用，例如构建工具、测试库等，不会被包含在生产环境的部署中
> - `unplugin-vue-components`：这是一个Vue.js的插件，它用于自动导入Vue组件。这意味着你不需要在每个文件中手动导入组件，这个插件会自动为你处理。这有助于减少重复代码，并使项目结构更加简洁
> - `unplugin-auto-import`：这是一个用于自动导入 API 的插件。例如，如果使用Vue 3，这个插件可以自动导 `ref`、`reactive`、 `computed`等等，而无需在每个文件中单独导入，减少冗余代码和提高开发效率

配置`vite.config.js`

```js
// vite.config.ts
import { defineConfig } from 'vite'
import AutoImport from 'unplugin-auto-import/vite'
import Components from 'unplugin-vue-components/vite'
import { ElementPlusResolver } from 'unplugin-vue-components/resolvers'

export default defineConfig({
  // ...
  plugins: [
    // ...
    AutoImport({
      resolvers: [ElementPlusResolver()],
    }),
    Components({
      resolvers: [ElementPlusResolver()],
    }),
  ],
})
```

或者`webpack.config.js`

```js
// webpack.config.js
const AutoImport = require('unplugin-auto-import/webpack')
const Components = require('unplugin-vue-components/webpack')
const { ElementPlusResolver } = require('unplugin-vue-components/resolvers')

module.exports = {
  // ...
  plugins: [
    AutoImport({
      resolvers: [ElementPlusResolver()],
    }),
    Components({
      resolvers: [ElementPlusResolver()],
    }),
  ],
}
```

对于`vue.config.js`，对插件版本存在要求

```
npm install -D unplugin-vue-components@0.25.2 unplugin-auto-import@0.16.7
```

可能配置之后也会对打包没有效果，对Vue脚手架有版本要求

```js
// element-plus 按需导入
const AutoImport = require('unplugin-auto-import/webpack')
const Components = require('unplugin-vue-components/webpack')
const {
  ElementPlusResolver
} = require('unplugin-vue-components/resolvers')

module.exports = defineConfig({
  // element-plus 按需导入
  configureWebpack: {
    plugins: [
      AutoImport({
        resolvers: [ElementPlusResolver()],
      }),
      Components({
        resolvers: [ElementPlusResolver()],
      }),
    ],
  },
```

> 配置文件：
>
> - vue脚手架项目：`vue.config.js`，默认使用`webpack`，用于自定义Vue CLI生成的Webpack配置
> - webpack项目：`webpack.config.js`，用于设置入口点、加载器、插件等
> - vite项目：`vite.config.js`，用于自定义Vite的行为和构建过程
