#!/bin/bash


# 根据名称关闭进程
stop_by_name() {
    local APP_NAME=$1
    if [ -z "$APP_NAME" ]; then
        echo "错误：必须提供应用名称。"
        return 1
    fi

    echo "停止原来运行中的工程: ${APP_NAME}"
    tpid=$(ps -ef | grep "$APP_NAME" | grep -v grep | grep -v kill | awk '{print $2}')
    # 如果没有找到对应的进程，直接退出函数
    if [ -z "$tpid" ]; then
        echo "未找到运行中的应用进程: ${APP_NAME}"
        return 0
    fi

    # 如果找到进程，尝试优雅地终止
    echo '停止进程中...'
    kill -15 "$tpid"

    sleep 2
    tpid=$(ps -ef | grep "$APP_NAME" | grep -v grep | grep -v kill | awk '{print $2}')
    if [ -n "$tpid" ]; then
        echo '强制终止进程!'
        kill -9 "$tpid"
    else
        echo '停止成功!'
    fi
}

# 根据端口关闭进程
stop_by_port() {
    local APP_PORT=$1
    if [ -z "$APP_PORT" ]; then
        echo "错误：必须提供端口号。"
        return 1
    fi

    echo "停止原来运行中的工程: 端口 ${APP_PORT}"
    tpid=$(netstat -nlp | grep ":${APP_PORT}" | awk '{print $7}' | awk -F"/" '{print $1}')
    # 如果没有找到对应的进程，直接退出函数
    if [ -z "$tpid" ]; then
        echo "未找到运行中的端口进程: ${APP_PORT}"
        return 0
    fi

    # 如果找到进程，尝试优雅地终止
    echo '停止进程中...'
    kill -15 "$tpid"

    sleep 2
    tpid=$(netstat -nlp | grep ":${APP_PORT}" | awk '{print $7}' | awk -F"/" '{print $1}')
    if [ -n "$tpid" ]; then
        echo '强制终止进程!'
        kill -9 "$tpid"
    else
        echo '停止成功!'
    fi
}