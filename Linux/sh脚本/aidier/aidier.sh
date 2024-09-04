#!/bin/sh



# 对应Nginx服务的目录
NGINX_PATH="/usr/local/aidier/mas/web"

# jar包运行端口号
APP_PORT=8081




echo "================================="
echo  "自动化更新脚本$0启动"
echo "================================="




cd /usr/local/aidier/mas/jar
tar -zxvf dist.tar.gz > /dev/null 2>&1 || exit 1
sleep 1

# 判断变量是否为空，进行删除和移动操作
if [ -z "${NGINX_PATH}" ]; then
    if [ -d "${NGINX_PATH}" ]; then
        if [ -d "dist" ]; then
            rm -rf "${NGINX_PATH}"/* || exit 1
            sleep 1
            mv dist/* "${NGINX_PATH}"/ || exit 1
            rmdir dist || exit 1

            APP_NAME=$(find . -maxdepth 1 -type f -name "*.jar")
			if [ -n "${APP_NAME}" ]; then			
				echo "停止原来运行中的工程: ${APP_NAME}"
				tpid=$(netstat -nlp | grep :${APP_PORT} | awk '{print $7}' | awk -F"/" '{print $1}')
				if [ ${tpid} ]; then
					echo 'Stop Process...'
					kill -15 ${tpid}
				fi

				sleep 2
				tpid=$(netstat -nlp | grep :${APP_PORT} | awk '{print $7}' | awk -F"/" '{print $1}')
				if [ ${tpid} ]; then
					echo 'Kill Process!'
					kill -9 ${tpid}
				else
					echo 'Stop Success!'
				fi

				echo "启动项目"
				# '>'覆盖的方式写入文件nohup.out，'>>'追加写入的方式写入文件
				nohup java -jar ${APP_NAME} > nohup.out 2>&1 &
				sleep 1
				timeout 10s tail -f nohup.out
			fi

		else
            echo "dist目录不存在，跳过删除和移动操作"
        fi
    else
        echo "NGINX_PATH路径不存在，无法执行删除和移动操作"
    fi
else
    echo "NGINX_PATH为空，无法执行删除和移动操作"
fi
