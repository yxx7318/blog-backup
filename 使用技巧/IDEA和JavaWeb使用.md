# IDEA和JavaWeb使用

场景：服务器中安装了Tomcat软件后，可以当做tomcat服务器，同样在我们开发的过程中同样需要在集合开发工具中，比如idea，eclipse...等使用tomcat这款软件；但是一般在开发阶段，我们还需要进一步修改资源（resource）和文件（classes），这个时候如何能够不重启服务器便可以将代码生效就显得尤为重要。

配置属性：

**On Update action**：当代码改变的时候，Idea执行什么操作；（修改重启按钮的默认位置）

```java
-Update resource：如果有更新，并且更新资源为（*.jsp,*.xml,不包括java文件），就会立即生效

-Update classes and resources：如果发现有更新，并且更新资源为（资源文件或Java文件），就会立即生效

 注：在正常运行模式下，修改java文件也不会立即生效；而在debug模式下，就会立即生效；这两种模式下，修改resource资源文件都是可以立即生效的。

-Redploy：重新部署，只是把原来的war包删除，不重启服务器

-Restart：重启服务器（一般几乎不使用）
```

**On Frame deactivation**：当失去焦点（不停留在idea里面），idea执行什么操作；（推荐使用失去焦点刷新资源，如果修改Java类则需要重启服务）

```java
-Do nothing：不做任何事情

-Update resource：类似于前文

-Update classes and resource：类似于前文
```