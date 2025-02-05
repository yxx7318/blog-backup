# WordPress

官网：[博客工具、发布平台和内容管理系统 – WordPress.org China 简体中文](https://cn.wordpress.org/)

## 下载使用

> [发行版本归档 – WordPress.org China 简体中文](https://cn.wordpress.org/download/releases/#branch-62)

### 版本要求

实际使用时PHP规定在8.0、MySQL8.0：

![image-20250205151416814](img/WordPress/image-20250205151416814.png)

### 历史版本

指定版本：

![image-20250122100050545](img/WordPress/image-20250122100050545.png)

### 运行Wordpress

新建网站：

![image-20250122100353037](img/WordPress/image-20250122100353037.png)

文件替换：

![image-20250122100736244](img/WordPress/image-20250122100736244.png)

运行效果：

![image-20250122100811678](img/WordPress/image-20250122100811678.png)

对于6.2版本，php的最低版本应该为7.4：

![image-20250205102512271](img/WordPress/image-20250205102512271.png)

> php对于数据库密码验证方式只支持`mysql_native_password`，而且wordpress对`mysql8.0`兼容性不好，最好使用`mysql5.7`

## 权限修改

给予目录权限：

```
chmod 777 -R wp-content/
```

修改`wp-config.php`，允许文件直接上传，要求文件和目录拥有最高权限777：

```php
define("FS_METHOD", "direct");  
define("FS_CHMOD_DIR", 0777);  
define("FS_CHMOD_FILE", 0777); 
```

> ![image-20250205150506197](img/WordPress/image-20250205150506197.png)

## Astra主题

![image-20250205145111833](img/WordPress/image-20250205145111833.png)

## Astar插件

![image-20250205153301600](img/WordPress/image-20250205153301600.png)

## Elementor插件

![image-20250205204222939](img/WordPress/image-20250205204222939.png)

## 网站构建

![image-20250205204750057](img/WordPress/image-20250205204750057.png)

![image-20250205205931970](img/WordPress/image-20250205205931970.png)

选择一个模板：

![image-20250205211050951](img/WordPress/image-20250205211050951.png)

编辑模板：

![image-20250205211631189](img/WordPress/image-20250205211631189.png)

选择功能：

![image-20250205211927612](img/WordPress/image-20250205211927612.png)

填写信息：

![image-20250205211942016](img/WordPress/image-20250205211942016.png)

等待构建：

![image-20250205212006926](img/WordPress/image-20250205212006926.png)

构建完毕：

![image-20250205212509094](img/WordPress/image-20250205212509094.png)

访问首页：

![image-20250205214333454](img/WordPress/image-20250205214333454.png)

> 管理后台：`/wp-login.php`