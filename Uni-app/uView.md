# uView

> 官网：[uView 2.0 - 全面兼容 nvue 的 uni-app 生态框架 - uni-app UI 框架 (uviewui.com)](https://www.uviewui.com/)

## 安装

> 依赖scss插件，如果没有，在HX菜单的 工具->插件安装中找到"scss/sass编译"插件进行安装

选择工具->插件安装

<img src="img/uView/image-20240525221011486.png" alt="image-20240525221011486" style="zoom:80%;" />

前往插件市场：[DCloud 插件市场](https://ext.dcloud.net.cn/?cat1=1&cat2=11)

选择前端组件

<img src="img/uView/image-20240525221131189.png" alt="image-20240525221131189" style="zoom:80%;" />

搜索uView

<img src="img/uView/image-20240525221233415.png" alt="image-20240525221233415" style="zoom:80%;" />

登录后可进行下载

<img src="img/uView/image-20240525221321540.png" alt="image-20240525221321540" style="zoom:67%;" />

安装成功页面

<img src="img/uView/image-20240525221917927.png" alt="image-20240525221917927" style="zoom:80%;" />

## 配置

引入uView主JS库，在项目根目录中的`main.js`中，引入并使用uView的JS库，注意这两行要放在`import Vue`之后

```js
// main.js
import uView from '@/uni_modules/uview-ui'
Vue.use(uView)
```

在引入uView的全局SCSS主题文件，在项目根目录的`uni.scss`中引入此文件

```scss
/* uni.scss */
@import '@/uni_modules/uview-ui/theme.scss';
```

引入uView基础样式，在`App.vue`首行引入

```vue
<style lang="scss">
	/* 注意要写在第一行，同时给style标签加入lang="scss"属性 */
	@import "@/uni_modules/uview-ui/index.scss";
</style>
```

在pages目录下的index下的`index.vue`添加测试代码

```
<u-button type="primary" loading loadingText="加载中"></u-button>
```

> <img src="img/uView/image-20240525222710683.png" alt="image-20240525222710683" style="zoom:67%;" />
