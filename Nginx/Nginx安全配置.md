# Nginx安全配置

## 隐藏版本号信息

```nginx
http {
    # 关闭在响应头中显示Nginx版本号
    # 默认响应头: Server: nginx/1.20.2
    # 关闭后响应头: Server: nginx
    server_tokens off;

}
```

## 配置安全Headers

```nginx
# 防止网站被嵌入恶意网页中，避免点击劫持
add_header X-Frame-Options "SAMEORIGIN";

# 启用浏览器XSS防护功能，并在检测到攻击时，停止渲染页面a
dd_header X-XSS-Protection "1; mode=block";

# 禁止浏览器猜测（嗅探）资源的MIME类型，防止资源类型混淆攻击
add_header X-Content-Type-Options "nosniff";

# 控制引用地址信息的传递，增强隐私保护
add_header Referrer-Policy "strict-origin-origin-when-cross-origin";

# 内容安全策略，控制资源加载来源，防止XSS等攻击
# default-src 'self': 只允许加载同源资源
# http: https:: 允许通过HTTP和HTTPS加载资源
# data:: 允许data:URI的资源（如base64编码的图片）
# blob:: 允许blob:URI的资源（如视频流）
# 'unsafe-inline': 允许内联脚本和样式（根据需要配置）
add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'";
```

## 限制连接数

```nginx
http {
    # 定义一个共享内存区域，用于存储IP连接数信息
    # $binary_remote_addr: 使用二进制格式存储客户端IP，节省空间
    # zone=addr:10m: 指定共享内存区域名称为addr，大小为10MB
    limit_conn_zone $binary_remote_addr zone=addr:10m;
    # 限制每个IP同时最多100个连接
    limit_conn addr 100;
    # 定义请求频率限制，每个IP每秒最多10个请求
    # rate=10r/s: 每秒10个请求
    limit_req_zone $binary_remote_addr zone=req_zone:10m rate=10r/s;
    # 应用请求频率限制，burst=20表示最多允许20个请求排队
    limit_req zone=req_zone burst=20 nodelay;

}
```

