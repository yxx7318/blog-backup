# Spring Boot热部署

> 在IDEA中开启自动编译File->Settings->Compiler->Build project automatically
>
> 开启运行时编译`Ctrl + Shift + Alt + /`，打开Maintenance，打开`complier.automake.allow.when.app.running`

## 官方的热部署工具

pom.xml

```xml
        <!-- 热部署 -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
            <scope>runtime</scope>
            <optional>true</optional>
        </dependency>
```

application.yml

```yaml
spring:
  devtools:
    restart:
      enabled: true
```

在修改java文件后可以使用快捷键`Ctrl + F9`构建所有文件或者`Ctrl + Shift + F9`构建当前文件，Spring服务会自动重新启动，旁边会提示

<img src="img/Spring Boot热部署/image-20231208171513567.png" alt="image-20231208171513567" style="zoom:67%;" />

## jrebel

使用第三方插件实现热部署，导入最后一个可以破解的jrebel版本

使用网站获取凭证，进行激活：

- [Jrebel JetBrains License Server 2022 (shenhai.cool)](https://jrebel.shenhai.cool/)
- [Welcome to JetBrains License Server!:) (qekang.com)](https://jrebel.qekang.com/)

<img src="img/Spring Boot热部署/image-20231208171647049.png" alt="image-20231208171647049" style="zoom: 50%;" />

给予所有权限

<img src="img/Spring Boot热部署/image-20231208171815000.png" alt="image-20231208171815000" style="zoom:50%;" />

在启动项目时使用jrebel启动项目

<img src="img/Spring Boot热部署/image-20231208190508120.png" alt="image-20231208190508120" style="zoom:67%;" />

成功启动会有提示信息

<img src="img/Spring Boot热部署/image-20231208190336159.png" alt="image-20231208190336159" style="zoom:67%;" />

使用快捷键`Ctrl + F9`实现代码的热部署，控制台会提示重新编译的类

```
2023-12-08 17:40:13 JRebel: Reconfiguring reprocessed bean 'mpController' [com.atguigu.boot.controller.MpController]
```

> 在C盘的用户目录下，会生成`.jrebel`，为插件配置信息

## 关于报错问题

如果使用jrebel启动报错

```
JRebel-JVMTI [FATAL] Couldn't write to C:\Users\
```

> 这是由于用户名为中文出现的问题，需要修改生成的`.jrebel`目录

IDEA中选择help->自定义vm选项

<img src="img/Spring Boot热部署/image-20231208185929272.png" alt="image-20231208185929272" style="zoom:67%;" />

添加如下代码，目录为`.jrebel`生成的目录

```
-Duser.home=D:\LenovoSoftstore\ideaIU-2019.3.win(v2)\bin\IdeaConfig\config\plugins\jr-ide-idea
```

IDEA选择设置->设置插件运行的jar包目录

<img src="img/Spring Boot热部署/image-20231208190232152.png" alt="image-20231208190232152" style="zoom:50%;" />

重启IDEA，删除C盘用户目录下的`jrebel`目录即可