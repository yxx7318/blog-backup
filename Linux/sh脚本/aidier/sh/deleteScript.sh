#!/bin/sh

ORIGIN_PATH="/usr/local/en"
LOG_FILE="$ORIGIN_PATH/deployOut.log"

JDK_PATH="/usr/local/jdk"
MYSQL_PATH="/usr/local/mysql"
NGINX_PATH="/usr/local/nginx"
REDIS_PATH="/usr/local/redis"


# 功能：检查并删除文件或目录的函数
# 参数：$1 - 绝对路径

delete_if_exists() {
  local path="$1"

  # 检查路径是否为空
  if [ -z "${path}" ]; then
    echo "路径不能为空"
    return 1
  fi

  # 安全检查：确保路径不是根目录 /
  if [ "$path" = '/' ] || [ "$path" = "/*" ]; then
    echo "不能删除根目录 / 或 /*"
    return 1
  fi

  # 安全检查：确保路径不是关键系统目录
  for key_dir in /home /etc /var /usr /bin /sbin /root /usr/local /usr/local/aidier; do
    if [ "$path" = "$key_dir" ] || [ "$path" = "$key_dir/" ]; then
      echo "不能删除关键系统目录：$key_dir"
      return 1
    fi
  done

  # 检查路径是否存在
  if [ -e "${path}" ]; then
    # 如果是目录，则递归删除
    if [ -d "${path}" ]; then
      rm -rf "${path}"
    else
      # 如果是文件，则直接删除
      rm -f "${path}"
    fi
  else
    echo "路径不存在: ${path}"
  fi
}

# 功能：停止与指定服务相关的所有进程
# 参数：$1 - 服务名称

stop_service_processes() {
    local service_name=$1
    local pids=$(ps -ef | grep ${service_name} | grep -v grep | awk '{print $2}')

    if [ -z "${pids}" ]; then
        echo "No processes found for service ${service_name}."
    else
        echo "Stopping processes for service ${service_name}:"
        for pid in ${pids}; do
            echo "Stopping process with PID ${pid}"
            kill -9 ${pid} 2>/dev/null
            if [ $? -eq 0 ]; then
                echo "Process with PID ${pid} has been stopped."
            else
                echo "Failed to stop process with PID ${pid}."
            fi
        done
    fi
}
