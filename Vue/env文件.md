# env文件

## 多环境env文件加载

对于`package.json`文件中的`script`的值

```json
  "scripts": {
    "dev": "vue-cli-service serve",
    "build:prod": "vue-cli-service build",
    "build:stage": "vue-cli-service build --mode staging",
    "preview": "node build/index.js --preview",
    "lint": "eslint --ext .js,.vue src"
  },
```

- `"dev": "vue-cli-service serve"`：这个命令默认以开发模式（development）启动服务，Vue CLI 会自动加载 `.env.development` 文件中的环境变量
- `"build:prod": "vue-cli-service build"`：这个命令会以 production 模式运行构建，Vue CLI 会自动加载 `.env.production` 文件中的环境变量
- `"build:stage": "vue-cli-service build --mode staging"`：这个命令会以 staging 模式运行构建，Vue CLI 会自动加载 `.env.staging` 文件中的环境变量

Vue CLI 支持以下文件命名规则的环境变量文件：

- `.env`：默认环境变量，在所有环境中加载
- `.env.local`：本地环境变量，会被覆盖其他 `.env` 文件中的变量
- `.env.[mode]`：特定模式的环境变量，例如 `.env.production` 或 `.env.development`
- `.env.[mode].local`：特定模式的本地环境变量，会被覆盖对应模式 `.env.[mode]` 文件中的变量

遵循后加载的变量覆盖先加载的变量的原则

## 引用env文件值

> 因为 `process.env` 对象在客户端代码中是可见的，为了避免将敏感的变量泄露到客户端，只有以 `VUE_APP_` 开头的变量会被 Vue CLI 加载到客户端侧代码中

引用值

```js
const name = process.env.VUE_APP_TITLE || '若依管理系统' // 网页标题

const port = process.env.port || process.env.npm_config_port || 80 // 端口

  // webpack-dev-server 相关配置
  devServer: {
    host: '0.0.0.0',
    port: port,
    open: true,
    proxy: {
      // detail: https://cli.vuejs.org/config/#devserver-proxy
      [process.env.VUE_APP_BASE_API]: {
        target: `http://localhost:8080`,
        changeOrigin: true,
        pathRewrite: {
          ['^' + process.env.VUE_APP_BASE_API]: ''
        }
      }
    },
    disableHostCheck: true
  },
```

## 若依参考env文件

.env.development

```
# 页面标题
VUE_APP_TITLE = 若依管理系统

# 开发环境配置
ENV = 'development'

# 若依管理系统/开发环境
VUE_APP_BASE_API = '/dev-api'

# 路由懒加载
VUE_CLI_BABEL_TRANSPILE_MODULES = true

```

.env.production

```
# 页面标题
VUE_APP_TITLE = 若依管理系统

# 生产环境配置
ENV = 'production'

# 若依管理系统/生产环境
VUE_APP_BASE_API = '/prod-api'

```

.env.staging

```
# 页面标题
VUE_APP_TITLE = 若依管理系统

NODE_ENV = production

# 测试环境配置
ENV = 'staging'

# 若依管理系统/测试环境
VUE_APP_BASE_API = '/stage-api'

```
