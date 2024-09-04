#!/bin/sh

# 设置环境变量，确保mysqldump命令可以被找到
# `which mysqldump`命令查找
# /usr/local/mysql/bin/mysqldump
# export PATH=$PATH:/usr/local/mysql/bin

# 使用which命令找到mysqldump的路径
# mysqldump_path=$(which mysqldump)

# 如果mysqldump命令在路径中，则执行它
# if [ -n "$mysqldump_path" ]; then
#     $mysqldump_path -u username -p database_name > /path/to/backup.sql
# else
#     echo "mysqldump command not found"
#     exit 1
# fi

origin_path="/usr/local/mysqlshell"


# 备份目录
backup_path="$origin_path/backup"
# 恢复目录
recover_path="$origin_path/recover"


# 使用date命令获取当前时间，格式化为格式化为YYYY-MM-DD HH:MM:SS，$(date +'%Y-%m-%d %H:%M:%S')
date_format=$(date +'%Y-%m-%d %H:%M')


# 备份sql文件
output_file="database_backup.sql"
# 恢复sql文件
recover_file="database_recover.sql"

# 指定数据库
database="jdbc"

backup_host="localhost"
backup_username="root"
backup_password="Yuxingxuan1"

# username="cebc-dev"
# password="Cbec123*&!"
# database="cebc"

recover_host="localhost"
recover_username="root"
recover_password="Yuxingxuan1"
