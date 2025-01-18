#!/bin/sh

ORIGIN_PATH="/usr/local/en"
chmod 777 "${ORIGIN_PATH}/sh/deleteScript.sh"
source "${ORIGIN_PATH}/sh/deleteScript.sh"


# 将整个脚本的输出追加形式重定向到日志文件，过滤掉终端字符
exec > >(sed -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g' | tee -a "$LOG_FILE") 2>&1


echo ""
echo "================================="
echo  "Nginx安装脚本$0启动"
echo "================================="
echo ""


# $? 变量存储了最后一条命令的退出状态
nginx -version > /dev/null 2>&1
if [ $? -eq 0 ] || [ -d "$NGINX_PATH" ]; then
  echo ""
  echo "-----以下为Nginx删除提示信息-----"
  systemctl stop nginx
  systemctl disable nginx
  stop_service_processes "nginx"
  find / -name "nginx" -exec rm -rf {} \;
  delete_if_exists "$NGINX_PATH"
  delete_if_exists "/lib/systemd/system/nginx.service.d"
  delete_if_exists "/etc/systemd/system/multi-user.target.wants/nginx.service"
  delete_if_exists "/usr/lib/systemd/system/nginx.service"
  delete_if_exists "/usr/local/luajit"
  sed -i '/^export PATH=\/usr\/local\/nginx\/sbin:\$PATH/d' /etc/profile
  source /etc/profile
  echo "-----以上为Nginx删除提示信息-----"
  echo ""
fi

cd "$ORIGIN_PATH"
tar -zxf nginx-1.20.2.tar.gz

# 安装依赖文件
tar -zxf rpm.tar.gz
cd "$ORIGIN_PATH/rpm"
rpm -ivh *.rpm --force --nodeps > /dev/null 2>&1
delete_if_exists "$ORIGIN_PATH/rpm"

cd "$ORIGIN_PATH"
tar -zxf make-4.2.tar.gz
cd "$ORIGIN_PATH/make-4.2"
./configure >/dev/null
make &> /dev/null && make install &> /dev/null
ln -s -f /usr/local/bin/make  /usr/bin/make

cd "$ORIGIN_PATH"
tar -zxf libtool-2.4.6.tar.gz
cd "$ORIGIN_PATH/libtool-2.4.6"
./configure >/dev/null
make -j &> /dev/null && make install &> /dev/null

cd "$ORIGIN_PATH"
tar -zxf pcre-8.35.tar.gz
cd "$ORIGIN_PATH/pcre-8.35"
./configure >/dev/null
make -j &> /dev/null && make install &> /dev/null

cd "$ORIGIN_PATH"



# 所有基本模块其它依赖
tar -zxf 2.3.tar.gz
tar -zxf master.tar.gz
# 0.10.14版本
tar -zxf lua-nginx-module-0.10.14.tar.gz
tar -zxf v0.3.1.tar.gz

# # 编译lua
# tar -zxf luajit.tar.gz
# cd luajit
# make install PREFIX="/usr/local/luajit"
# # 编译安装设置环境变量
# export LUAJIT_INC=/usr/local/luajit/include/luajit-2.1
# export LUAJIT_LIB=/usr/local/luajit/lib

# rpm安装lua模块，和编译方式二选一
tar -zxf lua.tar.gz
rpm -ivh ./lua/*.rpm --force --nodeps > /dev/null 2>&1
delete_if_exists "$ORIGIN_PATH/lua"

# rpm包安装设置环境变量
export LUAJIT_INC=/usr/include/luajit-2.0
export LUAJIT_LIB=/usr/lib64

cd "$ORIGIN_PATH/nginx-1.20.2"

# 所有基本模块安装
./configure \
  --with-http_ssl_module \
  --with-http_v2_module \
  --with-http_stub_status_module \
  --with-http_flv_module \
  --with-http_mp4_module \
  --with-http_gzip_static_module \
  --with-http_sub_module \
  --with-http_dav_module \
  --with-http_realip_module \
  --with-http_image_filter_module \
  --with-http_gunzip_module \
  --with-threads \
  --with-file-aio \
  --add-module=../ngx_cache_purge-2.3 \
  --add-module=../nginx-goodies-nginx-sticky-module-ng-08a395c66e42 \
  --add-module=../ngx_devel_kit-0.3.1 \
  --add-module=../lua-nginx-module-0.10.14 \
  --prefix="$NGINX_PATH" >/dev/null

# 0.10.19版本有问题
#  --add-module=../lua-nginx-module-0.10.19



# cd "$ORIGIN_PATH/nginx-1.20.2"

# 编译选项
# --with-http_image_filter_module 安装图片模块(依赖GD库)
# yumdownloader --resolve --destdir=/usr/local/en gd-devel
# --with-http_mp4_module 安装mp4模块
# ./configure \
  # --with-http_ssl_module \
  # --with-http_image_filter_module \
  # --with-http_mp4_module \
  # --prefix="$NGINX_PATH" >/dev/null


# make -j
# make install PREFIX="$NGINX_PATH"

# 安装Nginx
make -j &> /dev/null && make install PREFIX="$NGINX_PATH" &> /dev/null

cd "$ORIGIN_PATH"
delete_if_exists "$ORIGIN_PATH/pcre-8.35"
delete_if_exists "$ORIGIN_PATH/nginx-1.20.2"
delete_if_exists "$ORIGIN_PATH/libtool-2.4.6"
delete_if_exists "$ORIGIN_PATH/make-4.2"
# delete_if_exists "$ORIGIN_PATH/luajit"
delete_if_exists "$ORIGIN_PATH/lua-nginx-module-0.10.14"
delete_if_exists "$ORIGIN_PATH/nginx-goodies-nginx-sticky-module-ng-08a395c66e42"
delete_if_exists "$ORIGIN_PATH/ngx_cache_purge-2.3"
delete_if_exists "$ORIGIN_PATH/ngx_devel_kit-0.3.1"


# 配置服务文件
source "$ORIGIN_PATH/sh/getNginxService.sh"

# 复制配置文件到nginx目录下
yes | cp -f "$ORIGIN_PATH/sh/nginx.conf" "$NGINX_PATH/conf/nginx.conf"

systemctl enable nginx
systemctl start nginx.service

# 配置环境变量
echo "export PATH=/usr/local/nginx/sbin:\$PATH" >> /etc/profile
source /etc/profile

echo "==============================================="
echo  "Nginx版本"
echo "==============================================="
nginx -version
echo ""

# 恢复标准输出
exec > /dev/tty 2>&1

cd "$ORIGIN_PATH"
