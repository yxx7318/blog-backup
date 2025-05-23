#!/bin/sh


PROJECT_PATH=/usr/local/java/jkqcyl
JAR_PATH=ruoyi-admin/target
APP_NAME=ruoyi-admin
LOG_PATH=$PROJECT_PATH/$JAR_PATH
JAR_NAME=$APP_NAME.jar


echo =================================
echo  后端自动化部署脚本$0启动：$JAR_NAME
echo =================================



# 根据名称关闭进程
stop_by_name() {
    local APP_NAME=$1
    if [ -z "$APP_NAME" ]; then
        echo "Error: Application name is required."
        return 1
    fi

    echo "停止原来运行中的工程: ${APP_NAME}"
    tpid=$(ps -ef | grep "$APP_NAME" | grep -v grep | grep -v kill | awk '{print $2}')
    # 如果没有找到对应的进程，直接退出函数
    if [ -z "$tpid" ]; then
        echo "No running process found for application: ${APP_NAME}"
        return 0
    fi

    # 如果找到进程，尝试优雅地终止
    echo 'Stop Process...'
    kill -15 "$tpid"

    sleep 2
    tpid=$(ps -ef | grep "$APP_NAME" | grep -v grep | grep -v kill | awk '{print $2}')
    if [ -n "$tpid" ]; then
        echo 'Kill Process!'
        kill -9 "$tpid"
    else
        echo 'Stop Success!'
    fi
}

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
        echo "No running process found for application: ${APP_NAME}"
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

stop_by_name $APP_NAME

echo 准备从Git仓库拉取最新代码
cd $PROJECT_PATH

echo 开始从Git仓库拉取最新代码
git pull
echo 代码拉取完成

echo 开始打包
output=`mvn clean package -Dmaven.test.skip=true`

cd $JAR_PATH

echo 启动项目
nohup java -jar $JAR_NAME &> $LOG_PATH/$APP_NAME.log &
echo 项目启动完成

timeout 20s tail -f -n200 $LOG_PATH/$APP_NAME.log
