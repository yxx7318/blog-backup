#!/bin/sh


# 批量启动脚本的目录
SHELL_PATH="/usr/local/projectShell"

# 获取脚本自身名称
SHELL_MYSELF=$0


# 可以通过-p覆盖脚本执行目录
while getopts "p:" opt; do
  case $opt in
    p )
      SHELL_PATH=$OPTARG
      ;;
  esac
done


echo =================================
echo  所有项目自动化部署脚本$0启动，执行目录：$SHELL_PATH
echo =================================


echo 切换到sh脚本位置
cd $SHELL_PATH

for file_sh in $SHELL_PATH/*.sh
do
  if [ "$file_sh" != "$SHELL_PATH/$SHELL_MYSELF" ]; then
	  echo 
	  echo 
	  echo 
	  sh $file_sh
	  echo 
	  echo 
	  echo 
  fi
done

echo 所有脚本执行完成
