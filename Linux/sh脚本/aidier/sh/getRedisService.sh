#!/bin/sh


touch /etc/systemd/system/redis.service


# 使用变量
cat <<EOF > /etc/systemd/system/redis.service
[Unit]
Description=redis-server
After=network.target

[Service]
Type=forking
ExecStart=${REDIS_PATH}/bin/redis-server ${REDIS_PATH}/bin/redis.conf
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF
