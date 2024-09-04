# Nginx性能优化

## 调整核心工作参数

> Nginx在启动时用于定义其工作方式的配置参数，包括工作进程数、连接数等

- `worker_processes auto;`：根据CPU的核心数自动设置工作进程的数量。可以最大化利用CPU资源
- `worker_connections 1024;`：定义了每个工作进程可以打开的最大连接数。根据服务器的内存和流量需求，可以适当增加这个值

## 优化事件模型

> 事件模型是指Nginx处理网络连接和读写操作的方式。Nginx支持多种事件模型，如select、poll、epoll（仅限于Linux）

```nginx
events {
    worker_connections 1024;
    multi_accept on; # 允许一个工作进程同时接受多个新连接
    use epoll; # 在Linux上使用epoll事件模型，提高性能
}
```

## 开启Keep-Alive

> Keep-Alive是一种HTTP持久连接机制，允许客户端和服务器之间的TCP连接在多次请求之间保持打开状态

```nginx
    keepalive_timeout 65;
    keepalive_requests 1000; # 保持连接的请求数量
```

## 开启文件缓存

> 开启文件缓存是Nginx优化的重要手段之一，它可以帮助Nginx提高处理静态文件的速度，减少对文件系统的访问次数，从而降低I/O开销

```nginx
http {
    server {
        listen 80;

        location /images/ {
            root /var/www/html;
            # 缓存最多10000个文件描述符和相关信息，一个文件在20秒内没有被访问，将它从缓存中移除
            open_file_cache max=10000 inactive=20s;
            # 每隔30秒检查一次缓存中的文件描述符是否仍然有效，为了确保缓存中的信息是最新的
            open_file_cache_valid 30s;
            # 个文件至少被访问2次才会被添加到缓存中,防止那些很少被访问的文件占用缓存空间
            open_file_cache_min_uses 2;
            # 缓存那些打开文件时出现的错误信息。如果关闭这个选项，每次请求一个不存在的文件时，Nginx都会尝试打开它，从而产生不必要的I/O操作
            open_file_cache_errors on;
        }
    }
}
```

## 使用HTTP/2

> HTTP/2是HTTP协议的第二个主要版本，它在保持与HTTP/1.x向后兼容的同时，引入了新的二进制分帧层

```nginx
    listen 443 ssl http2;
    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;
```

> HTTP/2协议规范（RFC 7540）并没有规定必须通过HTTPS来使用HTTP/2。理论上，HTTP/2可以在不加密的HTTP连接上运行。因为HTTP/2引入了一些新的特性，比如流复用和多路复用，这些特性如果在不安全的连接上运行，可能会增加中间人攻击的风险。因此，为了安全起见，浏览器厂商决定只在HTTPS连接上支持HTTP/2

## 开启Gzip压缩

> Gzip是一种广泛使用的压缩算法，可以减少HTTP响应的大小，从而减少数据传输时间

```nginx
    gzip on;
    gzip_disable "msie6"; # 禁用对旧版IE的压缩
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_buffers 16 8k;
    gzip_http_version 1.1;
    gzip_min_length 256;
    gzip_types
      text/xml application/xml application/atom+xml application/rss+xml application/xhtml+xml image/svg+xml
      text/javascript application/javascript application/x-javascript
      text/x-json application/json application/x-web-app-manifest+json
      text/css text/plain text/x-component
      font/opentype application/x-font-ttf application/vnd.ms-fontobject
      image/x-icon;
```

## 优化日志记录

> 优化日志记录是提升Nginx性能的一个方面，尤其是在高流量网站中。日志记录可能会占用大量的磁盘I/O资源，因此合理配置日志记录可以减少磁盘I/O，从而提高服务器性能

### access_log指令

`access_log`指令用于指定Nginx记录访问日志的路径和格式。以下是`access_log`指令的相关参数：

- `path`：日志文件的路径
- `format`：日志的格式名称，可以是预定义的格式（如`main`），也可以是自定义的格式
- `buffer=size`：指定缓冲区的大小，用于缓冲日志条目，减少磁盘I/O操作
- `flush=time`：指定缓冲区内容多久被写入磁盘一次

### error_log指令

`error_log`指令用于指定Nginx记录错误日志的路径和日志级别

- `path`：日志文件的路径
- `level`：日志级别，如`debug`、`info`、`notice`、`warn`、`error`、`crit`、`alert`或`emerg`

```nginx
http {
    server {
        listen 80;

        access_log /var/log/nginx/access.log main buffer=32k flush=1m;
        error_log /var/log/nginx/error.log warn;

        location / {
            root /var/www/html;
            index index.html index.htm;
        }
    }
}
```

> - `access_log /path/to/log main`：指定访问日志文件的路径为`/path/to/log`，并使用预定义的`main`日志格式
> - `buffer=32k`：设置访问日志的缓冲区大小为32KB。这意味着Nginx会先将日志条目写入32KB的缓冲区，当缓冲区满了或者达到`flush`时间限制时，再将缓冲区内容写入磁盘。这可以减少对磁盘的写操作次数
> - `flush=1m`：设置缓冲区内容每1分钟写入磁盘一次，即使缓冲区没有满。这个设置可以在日志记录的实时性和磁盘I/O之间取得平衡
> - `error_log /path/to/error.log`：指定错误日志文件的路径为`/path/to/error.log`
> - `warn`：设置错误日志的级别为`warn`。这意味着只有警告及以上级别的日志会被记录，而`info`、`notice`和`debug`级别的日志会被忽略。通过设置较高的日志级别，可以减少日志文件的大小，从而减少磁盘I/O

## 使用反向代理和缓存

### proxy_cache_path指令

`proxy_cache_path`指令用于定义缓存的路径和参数

- `path`：设置缓存的存储路径
- `levels`：设置缓存目录的层级结构。`levels=1:2`表示缓存目录有两级，第一级是一位哈希值，第二级是两位哈希值
- `keys_zone`：设置共享内存区域的名字和大小，用于存储缓存键和元数据。例如，`my_cache:10m`表示分配10MB的共享内存给`my_cache`区域
- `max_size`：设置缓存的最大大小。当缓存达到这个大小时，基于最少使用原则，旧的缓存条目将被删除
- `inactive`：设置缓存条目在未被访问后多长时间内应该被删除
- `use_temp_path`：设置为`off`可以避免使用临时文件，直接在缓存路径中写入文件，这可以提高性能

### server和location块中的缓存配置

```nginx
    server {
        location / {
            proxy_pass http://backend;
            proxy_cache my_cache;
            proxy_cache_valid 200 302 60m;
            proxy_cache_valid 404 1m;
        }
    }
```

完整的配置示例

```nginx
http {
    proxy_cache_path /path/to/cache levels=1:2 keys_zone=my_cache:10m max_size=10g inactive=60m use_temp_path=off;

    server {
        listen 80;

        location / {
            proxy_pass http://backend;
            proxy_cache my_cache;
            proxy_cache_valid 200 302 60m;
            proxy_cache_valid 404 1m;
            proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;
            add_header X-Proxy-Cache $upstream_cache_status;
        }
    }
}
```

## 其他优化建议

- **调整sendfile**：启用sendfile可以减少读取和发送文件时的上下文切换

```nginx
http {
    server {
        listen 80;

        location /images/ {
            root /var/www/html;
            sendfile on; # 减少数据在用户空间和内核空间之间的拷贝次数
            tcp_nopush on; # 在Linux系统上启用TCP_CORK选项，告诉TCP栈在有足够的数据包时一次性发送，而不是每个数据包都单独发送
            tcp_nodelay on; # 当与sendfile一起使用时，这个选项可以减少网络包的数量，在发送完整的数据块之前将数据缓存起来。对于发送大文件特别有用，可以减少TCP头部开销，并提高网络利用率
        }
    }
}
```

- **限制请求体大小**：防止大请求体消耗过多资源

```nginx
    client_max_body_size 10m;
```

- **SSL优化**：使用SSL时，可以通过优化SSL会话重用和选择合适的加密套件来提高性能
- **系统层面优化**：包括调整TCP栈参数、文件描述符限制、内存交换策略等