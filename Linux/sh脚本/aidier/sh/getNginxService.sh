#!/bin/sh


touch /lib/systemd/system/nginx.service

cat <<EOF > /lib/systemd/system/nginx.service
[Unit]
Description=nginx service
After=network.target

[Service]
Type=forking
ExecStart=${NGINX_PATH}/sbin/nginx
ExecReload=${NGINX_PATH}/sbin/nginx -s reload
ExecStop=${NGINX_PATH}/sbin/nginx -s quit
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF