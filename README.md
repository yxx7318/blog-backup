# 备份个人博客的仓库，用于随时查阅翻看

远程仓库地址：https://gitee.com/yxx7318/blog-backup.git

## Git全局设置

```
git config --global user.name "yxx7318"
git config --global user.email "1303490776@qq.com"
```

## 提交信息

```
feat: 新功能开发
	用于引入新的功能或功能改进。
	示例：feat: add new user authentication system
fix: 修复漏洞
	用于修复代码中的错误或漏洞。
	示例：fix: resolve null pointer exception in user profile
docs: 文档更新
	仅用于更新文档，不影响代码逻辑。
	示例：docs: update API documentation for user endpoints
style: 格式调整
	用于代码格式化、分号添加等，不影响代码逻辑。
	示例：style: fix indentation in user service
refactor: 重构
	用于代码重构，但不改变功能。
	示例：refactor: simplify user authentication flow
perf: 性能优化
	用于提升代码性能。
	示例：perf: optimize database query for user list
test: 测试相关
	添加或更新测试用例。
	示例：test: add unit tests for user service
build: 构建相关
	修改构建流程或配置文件。
	示例：build: update npm dependencies
ci: 持续集成相关
	修改 CI 配置文件或脚本。
	示例：ci: update GitHub Actions workflow
chore: 其他维护任务
	用于维护任务，如删除无用文件等。
	示例：chore: remove deprecated user model
revert: 回滚提交
	用于撤销之前的提交。
	示例：revert: undo changes to user authentication
```

## 开启大小写敏感

```
git config core.ignorecase false
```

> - `git config`配置不影响远程仓库，**其他成员拉取后也需要重新配置**
>
> - 开启此配置，在仅大小写重命名文件或者目录(windows仅大小写命名不会真正重命名，需要带额外字符命名，后再删除字符命名到目标名称)之后直接提交会出现远程仓库出现两份文件，分别为重命名前和重命名后，在windows拉取文件会报错：
>
> - ```
>   error: The following untracked working tree files would be overwritten by merge:
>           xxx/xxx.md
>   Please move or remove them before you merge.
>   Aborting
>   Updating 75a64b9..2104b57
>   ```
>   
>   - 先使用`git rm -r --cached <file>`从暂存区中移除指定的文件或目录，修改之前的文件
>   - 再使用`git add .`去添加所有未被追踪的文件和目录，修改之后的文件

## 统一换行符

只允许`lf`换行符文件，无法再追踪`crlf`文件：

```
git config --global core.safecrlf true
git config --global core.autocrlf input
git config --global core.eol lf
```

> ```
> fatal: CRLF would be replaced by LF in aaaa.txt
> ```
>
> IDEA设置，`Settings`->`Code Style`->`Line spearator`
>
> 注意：有时候项目目录下的`.editorconfig`文件会覆盖IDEA的一些配置，需要配合修改

## 不允许换行符处理

```
git config core.autocrlf false
```

> 仅影响本地仓库，需要同步其它成员需要新建文件`.gitattributes`：
>
> ```
> # 将所有文件标记为不进行文本处理（即禁用换行符转换）
> * -text
> ```

## 创建git仓库

```
mkdir blog-backup
cd blog-backup
git init 
touch README.md
git add README.md
git commit -m "first commit"
# 将本地仓库与远程仓库进行关联。origin 是远程仓库的默认名称，后面跟着的是远程仓库的URL
git remote add origin https://gitee.com/yxx7318/blog-backup.git
# 将本地的 master 分支推送到远程仓库名称为 origin 的 master 分支
# -u 参数不仅推送当前分支，还会将本地分支与远程分支进行关联，改变默认的git pull和git push
git push -u origin "master"
# 指定拉取的仓库，拉取远程仓库名称为 local 的 master 分支
# git pull local master
```

## 已有仓库

```
cd existing_git_repo
git remote add origin https://gitee.com/yxx7318/blog-backup.git
git push -u origin "master"
```

## 远程仓库不为空

```
git add .
git commit -m "existing_commit"
git remote add origin https://gitee.com/yxx7318/blog-backup.git
# 执行 git fetch 命令来更新本地仓库的远程跟踪分支信息
git fetch
# 本地 master 分支跟踪远程 origin 的 master 分支
git branch --set-upstream-to=origin/master master
# 强制 Git 合并这两个不相关的历史，如果有冲突，需要解决冲突后，执行 git add、git commit将解决后的文件标记为已解决
git pull --allow-unrelated-histories
git push -u origin "master"
```

> 强制推送：
>
> ```
> git push -f origin master
> ```
>
> 强制将本地的 `master` 分支推送到名为 `origin` 的远程仓库中，并且覆盖远程仓库的 `master` 分支的历史
