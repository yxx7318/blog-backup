# vite.config.js配置

> node18

## css打包配置

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
