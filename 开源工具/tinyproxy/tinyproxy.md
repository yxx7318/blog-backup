# tinyproxy

> Tinyproxy 是一款轻量级、开源的代理服务器软件，它主要用于转发HTTP和HTTPS请求
>
> 官方仓库：[tinyproxy/tinyproxy: tinyproxy - a light-weight HTTP/HTTPS proxy daemon for POSIX operating systems (github.com)](https://github.com/tinyproxy/tinyproxy)

## 包安装

`yum`安装：

```
yum install -y tinyproxy
```

`rpm`安装：

```
rpm -ivh package_name.rpm
```

### 基本使用

### 修改配置：

```
vim /etc/tinyproxy/tinyproxy.conf
```

> 常用的配置项：
>
> - 端口：`Port 8888`，指定为自定义端口，修改为`Port 8080`
>
> - 允许连接代理的ip：`Allow 127.0.0.1`
>
>   - 注释掉允许所有ip连接，修改为`# Allow 127.0.0.1`
>
>   - 添加允许的ip
>
>     - ```
>       Allow 127.0.0.1
>       Allow 192.168.0.1
>       ```
>
> - 隐藏掉Via请求头部，默认是关闭的：`#DisableViaHeader Yes`，开启隐藏，修改为`DisableViaHeader Yes`

### 操作命令

```
service tinyproxy start # 启动
service tinyproxy stop  # 停止
service tinyproxy restart  # 重启
service tinyproxy status  # 状态
```

### 代理设置

电脑设置代理：

![image-20240923211401807](img/tinyproxy/image-20240923211401807.png)

手机设置代理：

![image-20240923211435226](img/tinyproxy/image-20240923211435226.png)

Linux设置代理：

```
vim /etc/profile

export http_proxy=http://47.113.186.151:8080
export https_proxy=http://47.113.186.151:8080

source /etc/profile
```

![image-20241015185241133](img/tinyproxy/image-20241015185241133.png)

### 测试效果

![image-20240923212009395](img/tinyproxy/image-20240923212009395.png)

## 编译安装

> 只有`TinyProxy1.10.0`版本及以上，才支持认证

### 下载编译

```
cd /usr/local
wget https://github.com/tinyproxy/tinyproxy/releases/download/1.11.1/tinyproxy-1.11.1.tar.gz
tar xvpf tinyproxy-1.11.1.tar.gz

cd tinyproxy-1.11.1

./autogen.sh

./configure \
  --enable-upstream

make
make install

```

> 查看版本信息：`tinyproxy -v`
>
> ![image-20240923210110083](img/tinyproxy/image-20240923210110083.png)
>
> 执行后会产生可执行程序：`/usr/local/bin/tinyproxy`
>
> 配置文件：`/usr/local/etc/tinyproxy/tinyproxy.conf`

### 创建配置文件

> 注意配置文件可能随着版本变化而不一样，下面的配置只是参考配置

```
mkdir /etc/tinyproxy/
vi /etc/tinyproxy/tinyproxy.conf
```

tinyproxy.conf

```
# 用户和组(如果无权写入日志，可以禁用用户组，使用root权限直接启动即可)
# User nobody
# Group nobody

# 监听端口
Port 8888

# 在多网卡的情况下，设置出口 IP 是否与入口 IP 相同。默认情况下是关闭的
BindSame yes

# 超时时间
Timeout 30

# 这个地方建议建立一个空文件给到报错时读取的文件模板，默认的模板会打印tinyproxy等信息，其他人可以通过输入错误认证信息得到tinyproxy代理服务名字，版本等
DefaultErrorFile "/usr/local/share/tinyproxy/default_nooutput.html"
# DefaultErrorFile "/usr/local/share/tinyproxy/default.html"

# 该选项配置被当作统计主机的主机名或者IP地址：每当收到对该主机的请求时，Tinyproxy 会返回内部统计信息页面，而不会将请求转发给该主机。此页面的模板可以使用 StatFile 配置项进行配置。StatHost 的默认值为 tinyproxy.stats
StatHost "127.0.0.1"
StatFile "/usr/local/share/tinyproxy/stats.html"

# 指定日志位置
LogFile "/var/log/tinyproxy/tinyproxy.log"

LogLevel Info

# 设置最大客户端链接数
MaxClients 1024

# RFC 2616 要求代理将 Via 标头添加到 HTTP 请求中，但使用真实主机名可能会引起安全问题。 如果设置了 ViaProxyName 选项，其字符串值将用作 Via 标头中的主机名。 否则，将使用服务器的主机名
ViaProxyName "baidu"

# 将此选项设置为Yes将通知Tinyproxy将包含客户端IP地址的标头X-Tinyproxy添加到请求中
# 如果是yes 则在header头中会添加原始ip，非高匿名模式，默认是 no
# 如果是yes 代理提交出去的header中会包含："X-Tinyproxy": "127.0.0.1"
XTinyproxy no

# 该选项设置为 yes 时，Tinyproxy 不会将 Via 标头添加到请求中。 这实际上就使 Tinyproxy 进入了隐身模式。请注意，RFC 2616 要求代理设置 Via 头，因此启用此选项会破坏合规性。 除非您知道自己在做什么，否则不要禁用 Via 标头...
# 默认是 no ，遵循了RFC 2616协议，代理需要带上头说明自己是代理服务过来的请求
# 如果是 no 代理提交出去的header中会包含："Via": "1.1 xxxx (tinyproxy/1.11.1)"
DisableViaHeader yes

# 以上两条修改后就能做到高匿名

# 权限校验，每个请求都需要进行权限校验
BasicAuth admin admin123
```

### 配置启动脚本

```
vim /usr/bin/tp
```

tp

```sh
#!/bin/bash
if [ $# -lt 1 ]
then
    echo "No Args Input..."
    exit ;
fi
case $1 in
"start")
        echo " =================== 启动 ==================="
        nohup tinyproxy -d -c /etc/tinyproxy/tinyproxy.conf > /dev/null 2>&1 &
;;
"stop")
        echo " =================== 关闭 ==================="
        ps -ef|grep tinyproxy|grep -v grep|awk '{print "kill -9 "$2}'|sh
;;
"restart")
        echo " =================== 重启 ==================="
        ps -ef|grep tinyproxy|grep -v grep|awk '{print "kill -9 "$2}'|sh
        nohup tinyproxy -d -c /etc/tinyproxy/tinyproxy.conf > /dev/null 2>&1 &
;;
"status")
        echo " =================== 状态 ==================="
        ps -ef|grep tinyproxy|grep -v grep
;;
*)
    echo "Input Args Error..."
;;
esac
```

> 设置脚本权限：
>
> ```
> chmod 777 /usr/bin/tp
> ```
>
> 控制命令：
>
> ```
> tp start
> tp stop
> tp status
> tp restart
> ```

### 查看日志

```
tail -f -n200 /var/log/tinyproxy/tinyproxy.log
```

> ![image-20240923211908700](img/tinyproxy/image-20240923211908700.png)

### 密码验证

> 在每次请求之前都需要输入密码，浏览器会记录账号密码，不需要每次都输入，开启密码验证可能导致一些应用无法加载使用

电脑：

![image-20240923204120336](img/tinyproxy/image-20240923204120336.png)

手机：

![image-20240923210800621](img/tinyproxy/image-20240923210800621.png)

## 多级代理

> 可以实现多层代理，即安装tinyproxy的服务器再连接安装了tinyproxy的服务器，需要编译时指定:
>
> - `--enable-debug`：如果您想要开启完整的调试支持
> - `--enable-xtinyproxy`：编译时加入对XTinyproxy头的支持，该头信息将发送到您域内的任何web服务器
> - `--enable-filter`：允许Tinyproxy过滤掉某些域名和URL
> - `--enable-upstream`：启用通过另一个代理服务器代理连接的支持
> - --`enable-transparent`：允许Tinyproxy被用作透明代理守护进程。与其他工作模式不同，透明代理不需要显式配置，当流量使用适当的防火墙规则被重定向到代理时，它会自动工作
> - `--enable-reverse`：启用反向代理
> - `--with-stathost=HOST`：设置统计主机的默认名称

```
./configure \
  --enable-upstream
```

修改配置文件

```
#
# Upstream:
#
# Turns on upstream proxy support.
#
# The upstream rules allow you to selectively route upstream connections
# based on the host/domain of the site being accessed.
#
# Syntax: upstream type (user:pass@)ip:port ("domain")
# Or:     upstream none "domain"
# The parts in parens are optional.
# Possible types are http, socks4, socks5, none
#
# For example:
#  # connection to test domain goes through testproxy
#  upstream http testproxy:8008 ".test.domain.invalid"
#  upstream http testproxy:8008 ".our_testbed.example.com"
#  upstream http testproxy:8008 "192.168.128.0/255.255.254.0"
#
#  # upstream proxy using basic authentication
#  upstream http user:pass@testproxy:8008 ".test.domain.invalid"
#
#  # no upstream proxy for internal websites and unqualified hosts
#  upstream none ".internal.example.com"
#  upstream none "www.example.com"
#  upstream none "10.0.0.0/8"
#  upstream none "192.168.0.0/255.255.254.0"
#  upstream none "."
#
#  # connection to these boxes go through their DMZ firewalls
#  upstream http cust1_firewall:8008 "testbed_for_cust1"
#  upstream http cust2_firewall:8008 "testbed_for_cust2"
#
#  # default upstream is internet firewall
#  upstream http firewall.internal.example.com:80
#
# You may also use SOCKS4/SOCKS5 upstream proxies:
#  upstream socks4 127.0.0.1:9050
#  upstream socks5 socksproxy:1080
#
# The LAST matching rule wins the route decision.  As you can see, you
# can use a host, or a domain:
#  name     matches host exactly
#  .name    matches any host in domain "name"
#  .        matches any host with no domain (in 'empty' domain)
#  IP/bits  matches network/mask
#  IP/mask  matches network/mask
#


Upstream http some.remote.proxy:port
```

> ![image-20241015213715693](img/tinyproxy/image-20241015213715693.png)
>
> 对于密码认证：
>
> ```
> Upstream http admin:admin123@some.remote.proxy:port
> ```

## 测试命令

HTTP：

```
curl -x http://admin:admin123@47.113.186.151:8080 http://httpbin.org/get?show_env=1
```

> ```json
> {
>   "args": {
>     "show_env": "1"
>   }, 
>   "headers": {
>     "Accept": "*/*",
>     "Host": "httpbin.org",
>     "User-Agent": "curl/7.29.0",
>     "X-Amzn-Trace-Id": "Root=1-66f169df-3fa8a2d3368b7e512d51c377",
>     "X-Forwarded-For": "47.113.186.151",
>     "X-Forwarded-Port": "80",
>     "X-Forwarded-Proto": "http"
>   }, 
>   "origin": "47.113.186.151", 
>   "url": "http://httpbin.org/get?show_env=1"
> }
> ```
>
> 也可以发送post请求`http://httpbin.org/post?show_env=1`

HTTPS：

```
curl -x http://admin:admin123@47.113.186.151:8080 https://httpbin.org/get?show_env=1
```

> ```json
> {
>      "args": {
>        "show_env": "1"
>      },
>      "headers": {
>        "Accept": "*/*",
>        "Host": "httpbin.org",
>        "User-Agent": "curl/7.29.0",
>        "X-Amzn-Trace-Id": "Root=1-66f169fb-4cfa0a2125fa799e6c83936d",
>        "X-Forwarded-For": "47.113.186.151",
>        "X-Forwarded-Port": "443", 
>        "X-Forwarded-Proto": "https"
>      },
>      "origin": "47.113.186.151",
>      "url": "https://httpbin.org/get?show_env=1"
> }
> ```

参考博客：

- [使用Tinyproxy搭建HTTP(S)代理 - Yuncong的博客 (yuncongz.com)](https://www.yuncongz.com/archives/1.html)
- [TinyProxy从零安装高匿名http协议带账号密码的代理服务 步骤超简单_tinyproxy 密码-CSDN博客](https://blog.csdn.net/qq_38503624/article/details/130265813)
- [TinyProxy正向代理服务器的安装与配置_tinyproxy 密码-CSDN博客](https://blog.csdn.net/qq_44216791/article/details/120886610)