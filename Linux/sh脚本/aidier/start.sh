#!/bin/sh

ORIGIN_PATH="/usr/local/en"
chmod 777 "${ORIGIN_PATH}/sh/deleteScript.sh"
source "${ORIGIN_PATH}/sh/deleteScript.sh"


# 将整个脚本的输出追加形式重定向到日志文件，过滤掉终端字符
exec > >(sed -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g' | tee -a "$LOG_FILE") 2>&1


echo ""
echo "==============================================="
echo  "自动配置脚本$0启动，开始自动安装所有环境"
echo "==============================================="
echo ""


# 恢复正常输出
exec > /dev/tty 2>&1

# 容错处理，防止定向出错
exec > >(sed -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g' | tee -a "$LOG_FILE") 2>&1
exec > /dev/tty 2>&1


cd "$ORIGIN_PATH"

source "$ORIGIN_PATH/sh/JDKsh.sh"
sleep 1
source "$ORIGIN_PATH/sh/MySqlsh.sh"
sleep 1
source "$ORIGIN_PATH/sh/Nginxsh.sh"
sleep 1
source "$ORIGIN_PATH/sh/Redissh.sh"

cd "$ORIGIN_PATH"


# 将整个脚本的输出追加形式重定向到日志文件，过滤掉终端字符
exec > >(sed -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g' | tee -a "$LOG_FILE") 2>&1


echo ""
echo ""
echo ""
echo "==============================================="
echo  "所有环境安装结果"
echo "==============================================="

echo ""
echo "==============================================="
echo  "JDK运行结果"
echo "==============================================="
java -version
echo ""


echo "==============================================="
echo  "Mysql运行结果"
echo "==============================================="
mysql --version
ps -ef | grep --color=always mysql | grep -v grep
echo ""


echo "==============================================="
echo  "Nginx运行结果"
echo "==============================================="
nginx -v
ps -ef | grep --color=always nginx | grep -v grep
echo ""


echo "==============================================="
echo  "Redis运行结果"
echo "==============================================="
redis -v
ps -ef | grep --color=always redis | grep -v grep
echo ""
echo ""
echo ""

cd "${ORIGIN_PATH}"

exec > /dev/tty 2>&1
