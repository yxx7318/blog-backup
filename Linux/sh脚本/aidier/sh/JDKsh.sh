#!/bin/sh

ORIGIN_PATH="/usr/local/en"
chmod 777 "${ORIGIN_PATH}/sh/deleteScript.sh"
source "${ORIGIN_PATH}/sh/deleteScript.sh"


# 将整个脚本的输出追加形式重定向到日志文件，过滤掉终端字符
exec > >(sed -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g' | tee -a "$LOG_FILE") 2>&1


echo ""
echo "================================="
echo  "JDK安装脚本$0启动"
echo "================================="
echo ""


# $? 变量存储了最后一条命令的退出状态
java -version > /dev/null 2>&1
if [ $? -eq 0 ] || [ -d "$JDK_PATH" ]; then
  # java -version 命令成功执行，有Java安装，清除环境，/d 参数用于删除匹配到的行
  sudo sed -i '/^export JAVA_HOME=\/usr\/local\/jdk/d' /etc/profile
  sudo sed -i '/^export CLASSPATH=\.:\$JAVA_HOME\/lib\/dt.jar:\$JAVA_HOME\/lib\/tools.jar/d' /etc/profile
  sudo sed -i '/^export PATH=\$JAVA_HOME\/bin:/d' /etc/profile
  source /etc/profile
  # 清除JDK文件
  delete_if_exists "$JDK_PATH"
fi

# 配置JDK环境
echo "export JAVA_HOME=/usr/local/jdk" >> /etc/profile
echo "export CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar" >> /etc/profile
echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile
source /etc/profile

echo ""

cd "$ORIGIN_PATH"
tar -zxf jdk-8u201-linux-x64.tar.gz
mv jdk1.8.0_201/ "$JDK_PATH"
source /etc/profile

echo "==============================================="
echo  "JDK版本"
echo "==============================================="
java -version
echo ""

cd "$ORIGIN_PATH"

# 恢复标准输出
exec > /dev/tty 2>&1
