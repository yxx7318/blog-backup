# Spring Security入门

## 关键接口和类

- `UserDetailsService`：这个接口用于加载用户特定的数据。在认证过程中，如果传入的凭据（如用户名和密码）有效，Spring Security 会使用 `UserDetailsService` 来加载用户的信息
- `AuthenticationProvider`：这个接口用于定义认证逻辑。您可以实现自己的 `AuthenticationProvider` 来支持不同的认证机制，比如用户名/密码、两步验证等
- `AuthenticationManager`：这个接口用于定义认证的机制。您可以自定义 `AuthenticationManager` 来控制认证流程
- `AbstractAuthenticationProcessingFilter`：这用来创建自定义认证过滤器的基类。可以扩展这个类来处理特定的认证请求
- `AuthenticationSuccessHandler`：这个接口用于定义认证成功后的逻辑，比如重定向到特定的页面或者返回特定的响应
- `AuthenticationFailureHandler`：这个接口用于定义认证失败后的逻辑，比如显示错误信息或者重定向到登录页面
- `PasswordEncoder`：这个接口用于密码编码。应该使用强密码编码器来保护用户的密码