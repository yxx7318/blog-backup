#!/bin/sh


touch /usr/local/mysql/support-files/my_default.cnf

cat <<EOF > /usr/local/mysql/support-files/my_default.cnf
[mysqld]
#设置mysql的安装目录
basedir=${MYSQL_PATH}
#设置mysql数据库的数据存放目录
datadir=${MYSQL_PATH}/data
#设置端口
port=3306 
socket=/tmp/mysql.sock
#设置字符集
character-set-server=utf8
#日志存放目录
log-error=${MYSQL_PATH}/data/mysqld.log
pid-file=${MYSQL_PATH}/data/mysqld.pid
log-bin-trust-function-creators=1 
group_concat_max_len=20000
sql_mode=STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION
EOF