#!/bin/sh


touch /etc/systemd/system/nginx.service

cat <<EOF > /etc/systemd/system/nginx.service
[Unit]
Description=nginx service
Documentation=http://nginx.org/en/docs/
After=network.target

[Service]
Type=forking
PIDFile=${NGINX_PATH}/logs/nginx.pid
ExecStartPre=${NGINX_PATH}/sbin/nginx -t -c /usr/local/nginx/conf/nginx.conf
ExecStart=${NGINX_PATH}/sbin/nginx
ExecReload=${NGINX_PATH}/sbin/nginx -s reload
ExecStop=${NGINX_PATH}/sbin/nginx -s stop
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF