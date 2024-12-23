# Docker运行参数

## 常用参数

- `-d, --detach`：使容器在后台运行，并打印容器ID。适合需要长时间运行的服务，如Web服务器或数据库
- `-i, --interactive`：保持标准输入（STDIN）打开，即使没有附加也一样。常与`-t`结合使用来启动交互式shell会话
- `-t, --tty`：分配一个伪TTY，通常和`-i`一起使用，为用户提供一个交互式的命令行界面
- `-p, --publish list`：将容器的端口映射到主机。例如：`-p 8080:80`会将主机的8080端口映射到容器的80端口，使得可以通过主机的8080端口访问容器内的Web服务
- `-v, --volume list`：挂载一个卷或文件。例如：`-v /host/path:/container/path`可以将主机的`/host/path`目录挂载到容器内的`/container/path`，方便数据持久化或共享文件
- `--name string`：为容器指定一个自定义名称。例如：`--name mywebserver`可以为你的Web服务器容器命名为`mywebserver`，便于管理
- `--env, -e`：设置环境变量。例如：`-e NODE_ENV=production`可以设置Node.js应用的环境变量为生产模式
- `--rm`：容器退出时自动删除它。适用于临时性的任务，如一次性构建脚本执行，避免残留停止的容器
- `--network`：指定容器连接的网络。例如：`--network mynetwork`可以让容器加入名为`mynetwork`的用户定义网络
- `--link`：链接到另一个容器。虽然现代做法是通过网络服务发现来实现容器间通信，但在某些场景下`--link`依然适用
- `--restart`：设置容器的重启策略。例如：`--restart unless-stopped`会让容器在Docker守护进程启动时自动重启，除非它是被手动停止的
  - `no`：默认的重启策略。Docker不会自动重启容器
  - `on-failure`：当容器以非零退出状态码退出时，Docker才会尝试重启容器。可以指定一个可选的最大重试次数，`--restart=on-failure:5`表示如果容器以非零状态退出，则最多尝试重启5次
  - `always`：无论容器的退出状态码是什么，Docker都会始终尝试重启容器。这意味着即使容器正常退出（退出状态码为0），Docker也会重新启动它
  - `unless-stopped`：总是重启容器，除非容器被明确地停止（通过`docker stop`或者手动停止）。这与`always`策略类似，但在容器被用户手动停止后，它不会在系统重启或Docker守护程序重启时自动启动

- `--security-opt`：添加安全选项。例如：`--security-opt no-new-privileges`可以防止容器内的进程获得额外的权限
- `--cap-add, --cap-drop`：调整容器的能力。例如：`--cap-add=SYS_PTRACE`可以添加系统追踪能力，而`--cap-drop=ALL`则移除所有默认能力
- `--user, -u`：指定容器内运行进程的用户。例如：`--user www-data`可以让Web服务器以`www-data`用户身份运行
- `--memory, -m`：限制容器可以使用的内存大小。例如：`--memory=1024M`可以限定容器占用的系统资源不超过1GB
- `--cpus`：限制容器可以使用的CPU数量。例如：`--cpus="1.5"`可以允许容器最多使用1.5个CPU核心

## 容器管理

### 启动容器

- `docker start <container_id|container_name>`：
  - 重新启动一个已经停止的容器。如果容器是第一次启动，则应该使用`docker run`命令。
- `docker restart <container_id|container_name>`：
  - 重启一个正在运行或已停止的容器。这会先停止容器，然后立即再次启动它。

### 停止容器

- `docker stop <container_id|container_name>`

  - 平滑地停止一个正在运行的容器。Docker会向容器发送一个SIGTERM信号，给应用程序一个机会优雅地关闭。默认情况下，Docker 会给容器10秒的时间来处理这个信号；如果超时，容器将被强制停止（SIGKILL）

- `docker kill <container_id|container_name>`
  - 强制停止一个正在运行的容器。这会直接发送一个 SIGKILL 信号，不给容器任何处理时间，因此应谨慎使用

### 查看容器状态

- `docker ps`:
  - 列出所有正在运行的容器。可以加上`-a`参数列出所有容器，包括那些已经停止的
- `docker inspect <container_id|container_name>`
  - 显示有关一个或多个容器的详细信息，包括配置、网络设置、挂载点等
- `docker logs <container_id|container_name>`
  - 查看容器的日志输出。这对于调试和监控应用的行为非常有用。可以添加`-f`参数来实时跟踪日志输出，类似于`tail -f`
- `docker top <container_id|container_name>`
  - 显示容器内运行的进程信息

### 删除容器

- `docker rm <container_id|container_name>`
  - 移除一个或多个已经停止的容器。要移除正在运行的容器，需要先使用`docker stop`或`docker kill`停止它们，或者可以直接使用`docker rm -f`强制移除
- `docker system prune`
  - 清理未使用的数据，包括停止的容器、未标记的镜像（dangling images）、构建缓存和其他可选资源。可以通过`--volumes`参数同时清理未使用的数据卷

### 其他有用的命令

- `docker pause <container_id|container_name>`和 `docker unpause <container_id|container_name>`:
  - 暂停或恢复容器的所有进程。这不会终止容器，但会冻结其所有活动，直到您恢复它为止
- `docker exec -it <container_id|container_name> /bin/bash`或 `/bin/sh`:
  - 在运行中的容器中执行命令。`-it`选项允许新创建的交互式终端会话进行交互。这是进入容器内部并执行命令的一种常见方式

## update命令

> `docker update`命令从Docker 1.13版本开始引入

`docker update` 支持以下与资源限制相关的选项：

- `--blkio-weight`
  - 默认值：500（范围：10 到 1000）
  - 说明：设置块 I/O 权重，默认为 500，表示中等优先级。较高的值意味着更高的 I/O 优先级
- `--cpu-period`
  - 默认值：100,000 微秒 (100 毫秒)
  - 说明：限制 CPU CFS 周期，默认为 100 毫秒，定义每个调度周期的时间长度。
-  `--cpu-quota`
  - 默认值：-1（无限制）
  - 说明：限制 CPU CFS 配额，默认为 -1，表示没有配额限制，容器可以使用整个周期的 CPU 时间
- `--cpu-rt-period`
  - 默认值：1,000,000 微秒 (1 秒)
  - 说明：限制实时 CPU 周期，默认为 1 秒，定义每个实时调度周期的时间长度
- `--cpu-rt-runtime`
  - 默认值：950,000 微秒 (950 毫秒)
  - 说明：限制实时 CPU 运行时间，默认为 950 毫秒，定义在每个实时调度周期内容器可以使用的最大 CPU 时间
- `--cpus`
  - 默认值：无限制
  - 说明：限制可用的 CPU 数量，默认情况下，容器可以使用所有可用的 CPU 核心
- `--cpu-shares`
  - 默认值：1024（范围：2 到 1024）
  - 说明：设置容器的 CPU 权重，默认为 1024，表示标准优先级，较高的值意味着更高的 CPU 优先级
- `--cpuset-cpus`
  - 默认值：无限制
  - 说明：分配特定的 CPU 核心给容器，默认情况下，容器可以使用所有可用的 CPU 核心
- `--cpuset-mems`
  - 默认值：无限制
  - 说明：分配特定的内存节点给容器（在 NUMA 系统中），默认情况下，容器可以使用所有可用的内存节点
- `--kernel-memory`
  - 默认值：无限制
  - 说明：限制容器的内核内存使用量，默认情况下，容器可以使用所有可用的内核内存
- `--memory` 或 `-m`
  - 默认值：无限制
  - 说明：限制用户内存（不包括交换区），默认情况下，容器可以使用所有可用的用户内存
- `--memory-reservation`
  - 默认值：无限制（与 `--memory` 相同）
  - 说明：设置内存软限制，默认情况下，与 `--memory` 的值相同，定义容器在内存不足时应尽量保持的最小内存使用量
- `--memory-swap`
  - 默认值：-1（无限制）
  - 说明：设置总内存限制（内存 + 交换区），默认为 -1，表示不限制交换区大小
- `--pids-limit`
  - 默认值：无限制
  - 说明：限制容器可以创建的最大进程数量，默认情况下，容器可以创建任意数量的进程

## 参数更改

**在不重建容器的情况下进行更改的参数**：

- 环境变量(`-e, --env`)：可以通过`docker exec`命令在运行中的容器内设置新的环境变量，但不会更新容器启动时设置的环境变量

- 网络设置(`--network`)：可以使用`docker network connect`和`docker network disconnect`来添加或移除容器的网络连接

- 卷挂载(`-v, --volume`)：虽然不能直接更改现有的卷挂载，但是可以通过创建新的卷并重新挂载来间接实现这一目的

- 资源限制(`--memory, --cpus, --cpu-shares, --memory-swap等`)：如CPU、内存等资源限制可以在容器运行时通过`docker update`命令修改

  - ```
    docker update \
      --memory="512m" \
      --cpus="1.0" \
      --cpu-shares="512" \
      --memory-swap="1g" \
      mysql_8.0.27
    ```

- 健康检查：可以使用`docker inspect`查看当前的健康检查配置，并通过替换容器的入口点或命令来改变健康检查行为

**重建容器的情况下才能进行更改的参数**：

- 基础镜像：如果想要更改容器的基础镜像，必须基于新的镜像创建一个新的容器
- 启动命令/入口点(`ENTRYPOINT、CMD`)：这些是容器启动时执行的命令，通常在`Dockerfile`中定义。更改它们通常意味着需要构建新的镜像并启动新的容器
- 端口映射(`-p, --publish`)：虽然可以停止容器并使用不同的端口映射选项重新启动它，但这是通过`docker run`命令完成的，实际上等于创建了一个新容器
- 卷挂载路径和选项(`-v, --volume`)：更改挂载点或挂载选项通常需要在`docker run`命令中指定，这也会导致创建新的容器
- 容器名称(`--name`)：一旦容器创建，其名称就不能更改。要使用不同的名称，需要创建一个新容器
- 容器重启策略(`--restart`)：一旦容器创建，其重启策略就不能改改。要使用不同的重启策略，需要创建一个新容器
- 用户/组(`--user, -u`)：容器运行的用户或组在创建时指定，之后无法更改，除非你进入容器内部并手动更改权限，但这不是推荐的做法
- 其他构建时配置：任何在`Dockerfile`中定义并在构建镜像时应用的配置，如安装软件包、设置环境变量等，都需要通过重建镜像来更改