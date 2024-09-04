#!/bin/sh


PROJECT_PATH=/usr/local/java/jkqcyl
JAR_PATH=ruoyi-admin/target
APP_NAME=ruoyi-admin
LOG_PATH=$PROJECT_PATH/$JAR_PATH
JAR_NAME=$APP_NAME.jar


echo =================================
echo  后端自动化部署脚本$0启动：$JAR_NAME
echo =================================


echo 停止原来运行中的工程
tpid=`ps -ef|grep $APP_NAME|grep -v grep|grep -v kill|awk '{print $2}'`
if [ ${tpid} ]; then
    echo 'Stop Process...'
    kill -15 $tpid
fi
sleep 2
tpid=`ps -ef|grep $APP_NAME|grep -v grep|grep -v kill|awk '{print $2}'`
if [ ${tpid} ]; then
    echo 'Kill Process!'
    kill -9 $tpid
else
    echo 'Stop Success!'
fi

echo 准备从Git仓库拉取最新代码
cd $PROJECT_PATH

echo 开始从Git仓库拉取最新代码
git pull
echo 代码拉取完成

echo 开始打包
output=`mvn clean package -Dmaven.test.skip=true`

cd $JAR_PATH

echo 启动项目
nohup java -jar $JAR_NAME &> $LOG_PATH/$APP_NAME.log &
echo 项目启动完成

timeout 20s tail -f -n200 $LOG_PATH/$APP_NAME.log
