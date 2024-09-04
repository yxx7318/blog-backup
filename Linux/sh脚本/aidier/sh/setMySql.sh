#!/bin/sh


echo ""
echo "================================="
echo  "MySql自动配置脚本$0启动"
echo "================================="
echo ""

password=$1

cd "$MYSQL_PATH/support-files"
chown -R mysql.mysql "$MYSQL_PATH/"
./mysql.server start

ln -s "$MYSQL_PATH/bin/mysql" /usr/bin/mysql;
yes | cp "$MYSQL_PATH/support-files/mysql.server" /etc/init.d/mysqld
chmod 777 /etc/init.d/mysqld
chkconfig --level 345 mysqld on
/usr/lib/systemd/systemd-sysv-install enable mysqld  #开机启动

cd "$MYSQL_PATH/bin"


# 使用--connect-expired-password模式调用mysql
# 如果root用户的密码已经过期，而没有`--connect-expired-password`选项，那么该用户只能修改密码，进行其他任何操作都会被拒绝
./mysql -u root -p$password --connect-expired-password < "$ORIGIN_PATH/sh/script.sql" > >(sed -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g' | tee -a "$LOG_FILE") 2>&1
