#!/bin/sh

ORIGIN_PATH="/usr/local/en"
chmod 777 "${ORIGIN_PATH}/sh/deleteScript.sh"
source "${ORIGIN_PATH}/sh/deleteScript.sh"


# 将整个脚本的输出追加形式重定向到日志文件，过滤掉终端字符
exec > >(sed -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g' | tee -a "$LOG_FILE") 2>&1


echo ""
echo "================================="
echo  "Redis安装脚本$0启动"
echo "================================="
echo ""


# $? 变量存储了最后一条命令的退出状态
redis --version > /dev/null 2>&1
if [ $? -eq 0 ] || [ -d "$REDIS_PATH" ]; then
  echo ""
  echo "-----以下为Redis删除提示信息-----"
  systemctl stop redis
  systemctl disable redis
  stop_service_processes "redis"
  find / -name "redis" -exec rm -rf {} \;
  delete_if_exists "$REDIS_PATH"
  delete_if_exists "/etc/systemd/system/multi-user.target.wants/redis.service"
  delete_if_exists "/etc/systemd/system/redis.service"
  sudo sed -i '/^export PATH=\/usr\/local\/redis\/bin:/d' /etc/profile
  echo "-----以上为Redis删除提示信息-----"
  echo ""
fi

cd "$ORIGIN_PATH"

# 安装gcc
tar -zxf gcc.tar.gz
cd gcc
rpm -ivh *.rpm --force --nodeps > /dev/null 2>&1
delete_if_exists "/usr/local/en/gcc"

cd "$ORIGIN_PATH"
tar -zxf redis-5.0.3.tar.gz
cd redis-5.0.3/

make -j &> /dev/null && make install PREFIX="$REDIS_PATH" &> /dev/null

delete_if_exists "$ORIGIN_PATH/redis-5.0.3"

# 强制覆盖配置文件
yes | cp -f "$ORIGIN_PATH/sh/redis.conf" "$REDIS_PATH/bin/redis.conf"

cd "$REDIS_PATH"

mkdir logs
mkdir pid
mkdir rdb

# 配置服务文件
source "$ORIGIN_PATH/sh/getRedisService.sh"

# 重启系统服务
systemctl daemon-reload
systemctl start redis.service
systemctl enable redis.service
# 符号链接，方便在任何地方都可以直接运行 redis-cli 命令
ln -s "$REDIS_PATH/bin/redis-cli" /usr/bin/redis

# 配置环境变量
echo "export PATH=$REDIS_PATH/bin:\$PATH" >> /etc/profile
source /etc/profile

echo "==============================================="
echo  "Redis版本"
echo "==============================================="
redis --version
echo ""

# 恢复标准输出
exec > /dev/tty 2>&1

cd "$ORIGIN_PATH"
