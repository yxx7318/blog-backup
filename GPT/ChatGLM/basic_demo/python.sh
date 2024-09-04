#!/bin/sh

# 不支持Centos 7.9

echo "================================="
echo  "Python安装脚本$0启动"
echo "================================="

python_version=$(python --version 2>&1)
python3_version=$(python3 --version 2>&1)
is_install="false"

if [[ $python_version == *"Python 2."* ]]; then
    if [[ $python3_version == *"Python 3."* ]]; then
        echo "已安装Python 3.x 版本。"
    else
        echo "警告：您正在使用Python 2.x 版本。建议升级到Python 3.x 版本以获得更好的兼容性和功能。"
		$is_install="true"
    fi
elif [[ $python3_version == *"Python 3."* ]]; then
    echo "已安装Python 3.x 版本。"
else
    echo "未安装Python"
	$is_install="true"
fi

# 如果需要安装，则编译源代码安装
if [ "$is_install" = "true" ]; then
    echo "执行python安装"
	current_dir=$(pwd)
	echo "当前运行目录：$current_dir"

	tar -zxf Python-3.10.12.tgz
	cd ${current_dir}/Python-3.10.12

	./configure
	make -j4
	make install

	source /etc/profile
fi
