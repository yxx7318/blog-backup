#!/bin/sh

ORIGIN_PATH="/usr/local/en"
chmod 777 "${ORIGIN_PATH}/sh/deleteScript.sh"
source "${ORIGIN_PATH}/sh/deleteScript.sh"


# 将整个脚本的输出追加形式重定向到日志文件，过滤掉终端字符
exec > >(sed -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g' | tee -a "$LOG_FILE") 2>&1


echo ""
echo "================================="
echo  "MySql安装脚本$0启动"
echo "================================="
echo ""


# $? 变量存储了最后一条命令的退出状态
mysql --version > /dev/null 2>&1
if [ $? -eq 0 ] || [ -d "$MYSQL_PATH" ]; then
  echo ""
  echo "-----以下为MySql删除提示信息-----"
  systemctl stop mysqld
  systemctl disable mysqld
  stop_service_processes "mysql"
  # 使用 find 命令搜索所有包含 "mysql" 的文件和目录
  # 并使用 rm -rf 命令删除它们
  find / -name "mysql" -exec rm -rf {} \;
  rm -rf "#MYSQL_PATH/mysqld.pid"
  rm -rf /etc/my.cnf
  userdel mysql
  groupdel mysql
  delete_if_exists "$MYSQL_PATH"
  delete_if_exists "/etc/init.d/mysqld"
  # 当有连接时删除mysql，可能会造成套接字锁文件的残留
  delete_if_exists "/tmp/mysql.sock"
  delete_if_exists "/tmp/mysqlx.sock"
  delete_if_exists "/tmp/mysql.sock.lock"
  echo "-----以上为MySql删除提示信息-----"
  echo ""
fi

cd "$ORIGIN_PATH"
if [ -f "mysql-8.0.28-linux-glibc2.12-x86_64.tar.xz" ]; then
    # 文件存在，执行解压操作
    xz -d "mysql-8.0.28-linux-glibc2.12-x86_64.tar.xz"
fi

tar -xf mysql-8.0.28-linux-glibc2.12-x86_64.tar
mv mysql-8.0.28-linux-glibc2.12-x86_64 "$MYSQL_PATH"

# 安装库，防止出问题
tar -zxf lib.tar.gz
cd lib
rpm -ivh *.rpm --force --nodeps > /dev/null 2>&1
delete_if_exists "$ORIGIN_PATH/lib"

cd "$MYSQL_PATH"
mkdir data
groupadd mysql
useradd -r -g mysql mysql
chown -R mysql.mysql "$MYSQL_PATH/"
cd support-files/

# 获取默认配置文件
source "$ORIGIN_PATH/sh/getMySqlcnf.sh"


# 强制覆盖
yes | cp -f my_default.cnf /etc/my.cnf

cd "$MYSQL_PATH/bin"
./mysqld --initialize

last_line=$(more $MYSQL_PATH/data/mysqld.log | tail -n 1)
result=$(echo "$last_line" | awk -F '@localhost: ' '{print $2}')
echo ""
echo "================================="
echo  "MySql安装脚本执行完成，请注意查看初始数据库密码"
echo "================================="
echo "初始密码：$result"


# 恢复正常输出
exec > /dev/tty 2>&1


# 防止卡住
echo ""
source "$ORIGIN_PATH/sh/setMySql.sh" $result
echo ""


# 将整个脚本的输出追加形式重定向到日志文件，过滤掉终端字符
exec > >(sed -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g' | tee -a "$LOG_FILE") 2>&1


echo ""
echo "==============================================="
echo  "Mysql版本"
echo "==============================================="
mysql --version
echo ""

# 恢复标准输出
exec > /dev/tty 2>&1

cd "$ORIGIN_PATH"
