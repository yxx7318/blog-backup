#!/bin/bash


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

codePath="/usr/local/yxx/code/yxx-yi"
runPath="/usr/local/yxx/yxx-yi"
port="7318"


codeName=$1
branch=${2:-master}  # 设置第二个参数作为分支名，默认为 "master"
server=$3


cd ${codePath}
if [[ $? -ne 0 ]]; then
    exit 1
fi
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
# 清理旧包，跳过测试重新打包
mvn clean package -Dmaven.test.skip=true
if [[ $? -ne 0 ]]; then
    exit 1
fi

# 根据端口关闭进程
stop_by_port() {
    local APP_PORT=$1
    if [ -z "$APP_PORT" ]; then
        echo "Error: Port number is required."
        return 1
    fi

    echo "停止原来运行中的工程: 端口 ${APP_PORT}"
    tpid=$(netstat -nlp | grep ":${APP_PORT}" | awk '{print $7}' | awk -F"/" '{print $1}')
    # 如果没有找到对应的进程，直接退出函数
    if [ -z "$tpid" ]; then
        echo "No running process found for port: ${APP_PORT}"
        return 0
    fi

    # 如果找到进程，尝试优雅地终止
    echo 'Stop Process...'
    kill -15 "$tpid"

    sleep 2
    tpid=$(netstat -nlp | grep ":${APP_PORT}" | awk '{print $7}' | awk -F"/" '{print $1}')
    if [ -n "$tpid" ]; then
        echo 'Kill Process!'
        kill -9 "$tpid"
    else
        echo 'Stop Success!'
    fi
}

stop_by_port $port

cp $codePath/yxx-yxx/target/yxx-yxx.jar $runPath/yxx-yxx.jar

cd $runPath && nohup java -jar -Dspring.profiles.active=test yxx-yxx.jar &> yxx-yxx.log &

cd $runPath && timeout 30s tail -f -n200 yxx-yxx.log
