# vue.config.js配置

## Vue2

> node16

### css打包配置

> 发现组件里的样式会编译成两个样式：一个全局样式和一个局部样式。可能会导致样式污染问题，即组件的样式影响了其他同名的样式。如果出现样式异常，可以尝试修改打包方式，将样式内联到js中

```js
  css: {
    // loaderOptions: {
    //   sass: {
    //     sassOptions: { outputStyle: "expanded" }
    //   }
    // }
    extract:false, // CSS将不会被提取到单独的文件中，而是以内联样式的方式包含在JavaScript文件中。
    sourceMap:false // 帮助调试器映射编译后的代码到源代码。关闭可以减少构建时间并减少文件大小
  },
```

> 所有的样式都会以内联样式的方式包含在JavaScript文件中，这样可以避免样式提取过程中可能出现的错误。不过，这也会失去将样式分离出来以利用浏览器缓存的优势

## Vue3

> node18

### css打包配置

> `@charset`规则用于声明文件的字符编码。如果`@charset`规则不是文件中的第一个规则，某些CSS处理器可能会发出警告或错误，因为按照CSS规范，`@charset`规则必须出现在任何其他CSS规则之前
>
> 在某些情况下，由于构建过程或CSS文件的合并方式，`@charset`规则可能不会出现在正确的位置，导致构建警告。通过上述配置，PostCSS插件会自动移除所有的`@charset`规则，从而避免这些警告

```js
    //fix:error:stdin>:7356:1: warning: "@charset" must be the first rule in the file
    css: {
      postcss: {
        plugins: [
          {
            postcssPlugin: 'internal:charset-removal',
            AtRule: {
              charset: (atRule) => {
                if (atRule.name === 'charset') {
                  atRule.remove();
                }
              }
            }
          }
        ]
      }
    }
```

