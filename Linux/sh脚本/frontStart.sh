#!/bin/sh


REPOSITORY_PATH=/usr/local/vue/jkqcyl
PROJECT_PATH=jkqcyl
NGINX_PATH=/usr/local/nginx/html/front

BUILD=build
IS_INSTALL=false


# 获取选择输入的参数(只要有-i命令即会执行，后面无需参数)
while getopts "ib:" opt; do
  case $opt in
    i )
      IS_INSTALL=true
      ;;
    b )
      BUILD=$OPTARG
      ;;
  esac
done


echo =================================
echo  前端自动化部署脚本$0启动：$PROJECT_PATH
echo =================================


echo 准备从Git仓库拉取最新代码
cd $REPOSITORY_PATH

echo 开始从Git仓库拉取最新代码
git pull
echo 代码拉取完成

cd $PROJECT_PATH

# 此步骤非常消耗时间，当输入有-i时开启
if [ "$IS_INSTALL" = true ]; then
  echo 开始下载模块
  output=`npm install`
fi

echo 开始打包
output=`npm run $BUILD`

sleep 1

echo 删除Nginx上的目录
rm -rf $NGINX_PATH/*

sleep 1

echo 重新部署到Nginx
cp -r dist $NGINX_PATH/

echo 前端更新完成
