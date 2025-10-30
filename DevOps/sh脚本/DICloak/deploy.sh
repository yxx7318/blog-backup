#!/bin/bash


echo "********************************************** 变量定义 **********************************************"
codePath="/usr/local/yxx/code/yxx-yi"
javaPath="$codePath/yxx-yxx-8"
vuePath="$codePath/yxx-ui-vue2"
runPath="/usr/local/yxx/yxx-yi"
springSh="$runPath/springBootStart.sh"
vueSh="$runPath/vueStart.sh"
echo "codePath $codePath"
echo "javaPath $javaPath"
echo "vuePath $vuePath"
echo "runPath $runPath"
echo "springSh $springSh"
echo "vueSh $vueSh"


# 定义锁文件路径
LOCK_FILE="/tmp/my_script.lock"
exec 200>"$LOCK_FILE"

# 使用 flock 加锁
if ! flock -n 200; then
  echo "脚本已在运行，请稍后再试！"
  exit 1
fi

# 确保退出时释放锁(正常退出、主动中断、系统终止)
trap 'flock -u 200; exec 200>&-' EXIT INT TERM

# 脚本的主要逻辑
echo "开始执行脚本..."


codeName=$1
branch=${2:-master}  # 设置第二个参数作为分支名，默认为 "master"
server=$3



# 检查目录
cd ${codePath}
if [[ $? -ne 0 ]]; then
  exit 1
fi



echo "********************************************** 发布类型 **********************************************"

# 默认发布前后端
deploy_frontend=false
deploy_backend=false

# 解析命令行参数
while [[ $# -gt 0 ]]; do
  case $1 in
    -f|--frontend)
      deploy_frontend=true
      shift
      ;;
    -b|--backend)
      deploy_backend=true
      shift
      ;;
    -*)
      echo "错误：未知选项 $1"
      echo "用法: $0 [-f|--frontend] [-b|--backend] [codeName] [branch] [server]"
      echo "示例:"
      echo "  $0 -f master          # 只发布前端"
      echo "  $0 -b master          # 只发布后端"
      echo "  $0 master             # 发布前后端"
      exit 1
      ;;
    *)
      # 非选项参数，跳出循环
      break
      ;;
  esac
done

# 如果没有指定任何选项，则默认发布前后端
if [ "$deploy_frontend" = false ] && [ "$deploy_backend" = false ]; then
  deploy_frontend=true
  deploy_backend=true
fi
echo "前端发布： $deploy_frontend"
echo "后端发布： $deploy_backend"



echo "********************************************** 拉取代码 **********************************************"

# 永久删除未提交的更改
git clean -df
# 丢弃所有未提交的更改
git reset --hard HEAD
# 拉取指定分支的代码
git fetch origin ${branch}
# 切换到目标分支
git checkout ${branch}
if [[ $? -ne 0 ]]; then
  exit 1
fi
# 拉取到目标分支最新代码
git pull origin ${branch}
if [[ $? -ne 0 ]]; then
  exit 1
fi




# 部署后端
if [ "$deploy_frontend" = true ]; then
  echo "********************************************** 部署前端 **********************************************"

  # 检查目录
  cd ${vuePath}
  if [[ $? -ne 0 ]]; then
    exit 1
  fi

  if [ ! -d "$vuePath/node_modules" ]; then
    echo "node_modules目录 不存在，正在执行 npm install..."
    npm install
  else
    echo "node_modules目录 已存在，跳过 npm install"
  fi

  if [[ $? -ne 0 ]]; then
    exit 1
  fi

  echo "正在执行构建: npm run build:prod..."
  cd $vuePath && npm run build:prod

  # 启动脚本
  sh $vueSh "$vuePath/dist"

  echo "前端已部署完成"
fi



# 部署后端
if [ "$deploy_backend" = true ]; then
echo "********************************************** 部署后端 **********************************************"

  # 检查目录
  cd ${javaPath}
  if [[ $? -ne 0 ]]; then
    exit 1
  fi

  # 清理旧包，跳过测试重新打包
  mvn clean package -Dmaven.test.skip=true
  if [[ $? -ne 0 ]]; then
    exit 1
  fi

  # 启动脚本
  sh $springSh

  echo "后端已部署完成"
fi

