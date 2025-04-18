# SSH连接

## 手动生成密钥对

> 无需重启服务器

密钥生成命令：

```
ssh-keygen
```

> 生成更长的密钥，防止被暴力破解：
>
> ```
> ssh-keygen -t rsa -b 4096
> ```

不设置二级密码：

![image-20241123140849934](img/SSH连接/image-20241123140849934.png)

生成的密钥文件：

![image-20241123141631090](img/SSH连接/image-20241123141631090.png)

修改服务器的`.ssh/authorized_keys`文件，将公钥`id_ed25519.pub`的值追加到服务器内容后面：

![image-20241123141826304](img/SSH连接/image-20241123141826304.png)

直接连接：

```
ssh root@xxx.xxx.xxx.xxx
```

> 如果设置了二级密码，连接时就需要输入私钥密码确认：
>
> ![image-20241123141415380](img/SSH连接/image-20241123141415380.png)

## 云服务商重置

> 需要重启服务器

创建密钥对：

![image-20241123131829037](img/SSH连接/image-20241123131829037.png)

> ![image-20241123132047109](img/SSH连接/image-20241123132047109.png)

配置密钥对：

![image-20241123131844696](img/SSH连接/image-20241123131844696.png)

重启实例：

![image-20241123131924902](img/SSH连接/image-20241123131924902.png)

## FinalShell连接

新增私钥：

![image-20241123132951147](img/SSH连接/image-20241123132951147.png)

选择私钥：

![image-20241123133030799](img/SSH连接/image-20241123133030799.png)

更换认证方式：

![image-20241123153228117](img/SSH连接/image-20241123153228117.png)

> 手动生成的密钥可能finalshell不支持，转换密钥或者生成符合要求的密钥：
>
> ```
> 1.转换成PEM格式私钥
> ssh-keygen -p -m PEM -f 私钥路径
> 2.生成PEM格式的私钥
> 生成时增加 -m PEM参数
> ssh-keygen -m PEM -t rsa -C "注释"
> ```

## 命令行连接

```
ssh -i 测试服务器密钥对.pem root@8.134.145.242
```

> ![image-20241123151404789](img/SSH连接/image-20241123151404789.png)
>
> 如果没有指定密钥文件，SSH客户端会自动使用当前目录中的`id_ed25519`文件

## 禁用密码连接

![image-20241123144845582](img/SSH连接/image-20241123144845582.png)

> 能够使用用户名和密码连接其实是开启了`/etc/ssh/sshd_config`中`PasswordAuthentication`为`yes`

编辑SSH配置文件`/etc/ssh/sshd_config`，找到以下行并按以下设置：

```
PasswordAuthentication no
ChallengeResponseAuthentication no
UsePAM no
```

> 确保这些参数没有被注释掉，并且设置为`no`

重启ssh服务：

```
sudo systemctl restart sshd
```

