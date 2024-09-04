# tsconfig.json文件配置

开启监听模式，自动编译目录下的ts文件

```
tsc --watch
```

或者

```
tsc -w
```

## 配置文件

```json
{
    "compilerOptions": {
        // 移除注释，减少js体积
        "removeComments": true,
        // 指定编译的js版本
        "target": "ES5",
        // 做更严格的代码审核，所以动态类型any被禁止
        "noImplicitAny": true,
        // 不允许给任意类型的变量赋予空值null或者undefined
        "strictNullChecks": true,
    }
}
```

## 使用ts的代码库

在使用第三方库时，有可能库本身不是ts写的，但是想要用ts更加完善的类型支持，可以安装社区维护的类型定义包

原始安装命令

```
npm install three --save
```

> 告诉 npm 将安装的包作为生产依赖添加到的`package.json`文件中。生产依赖是项目运行时需要的包。

再安装社区维护的ts类型定义包

```
npm install three --save-dev @types/three
```

> - `--save`: 这个参数将包添加到`dependencies`部分，表示这个包是生产依赖。生产依赖是项目运行时需要的包，也就是说，它们在应用程序的生产环境中是必需的
> - `--save-dev`: 这个参数将包添加到`devDependencies`部分，表示这个包是开发依赖。开发依赖只在开发过程中需要，比如测试工具、构建工具、文档生成工具等，它们不会在应用程序的生产环境中使用
>
> 在现代的前端项目中，通常将框架、库和应用程序在生产环境中实际需要的其他包作为生产依赖。而将像测试运行器、代码分析工具、编译器（如 TypeScript）和类型定义包作为开发依赖，因为它们不是在生产环境中直接需要的。