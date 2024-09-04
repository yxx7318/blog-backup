#!/bin/sh


port=7890
clash_path="/usr/local/clash"

echo ""
echo "================================="
echo  "Clash切换脚本$0启动"
echo "================================="
echo ""


# 方法：根据端口查询 PID
get_pid_by_port() {
    local port=$1
    # 被单引号包围，意味着$7会被awk解释为第七个字段的引用，而不是Bash的变量引用
    echo $(netstat -tulnp | grep ":$port" | awk '{print $7}' | cut -d'/' -f1)
}

# 方法：尝试杀死占用指定端口的进程
kill_process_by_port() {
    local port=$1
    local pid=$(get_pid_by_port $port)

    if [ -z "$pid" ]; then
        echo "端口$port没有被占用。"
        return
    fi

    echo "尝试杀死占用端口$port的进程，PID是：$pid"

    # 尝试发送 SIGTERM 信号
    kill -15 $pid
    sleep 2

    # 检查进程是否还在运行
    if [ "$(get_pid_by_port $port)" ]; then
        # 如果进程还在运行，则发送SIGKILL信号
        echo "进程未响应SIGTERM，尝试SIGKILL强制杀死。"
        kill -9 $pid
    else
        echo "进程已成功结束。"
    fi
}


# $? 变量存储了最后一条命令的退出状态
clash -v > /dev/null 2>&1
if [ $? -ne 0 ] ; then
    echo "未安装clash，已退出"
    return 1
fi

cd $clash_path

pid=$(get_pid_by_port $port)

# 检查netstat命令的输出是否为空
if [ -z "$pid" ]; then

    echo ""
    echo "---启动clash---"
    echo ""

    echo "# clash proxy" >> /etc/profile
    echo "export http_proxy=http://127.0.0.1:7890" >> /etc/profile
    echo "export https_proxy=http://127.0.0.1:7890" >> /etc/profile
    source /etc/profile

    nohup clash -d . &> $clash_path/clash.log &
    # nohup clash -d . > $clash_path/clash.log 2>&1 &
    sleep 2
    tail -n100 $clash_path/clash.log
else

    echo ""
    echo "---关闭clash---"
    echo ""

    # 杀死进程
    kill_process_by_port $port

    # 关闭代理
    sudo sed -i "/^# clash proxy/d" /etc/profile
    sudo sed -i "/^export http_proxy=http:\/\/127.0.0.1:7890/d" /etc/profile
    sudo sed -i "/^export https_proxy=http:\/\/127.0.0.1:7890/d" /etc/profile
    source /etc/profile
fi
