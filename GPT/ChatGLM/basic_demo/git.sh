#!/bin/sh


echo "================================="
echo  "Shell安装脚本$0启动"
echo "================================="

if command -v git &> /dev/null; then
    echo "git 已安装"
else
    echo "git 未安装"
	yum install git -y
	yum install git-lfs -y
	source /etc/profile
	git lfs install
fi


current_dir=$(pwd)
echo "当前运行目录：$current_dir"

# 创建git下载目录
path="ChatGLM"
mkdir $path
cd $current_dir/$path

git clone https://gitcode.com/THUDM/ChatGLM3.git

# 定义默认pip命令
pip_cmd="pip3"

# 使用grep命令结合正则表达式来提取版本号的前两位数字，9.x是pythn2的
pip_version=$(pip --version | grep -oP '\d+' | head -n 1 2>&1)
pip3_version=$(pip3 --version | grep -oP '\d+' | head -n 1 2>&1)

if command -v pip &> /dev/null; then
	if [[ $pip_version -gt 12 ]]; then
		pip_cmd="pip"
		echo "pip命令满足"
	fi
fi

if command -v pip3 &> /dev/null; then
	if [[ $pip3_version -gt 12 ]]; then
		echo "pip3命令满足"
	fi
fi

# 安装依赖
cd $current_dir/$path/ChatGLM3

$pip_cmd install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# 下载模型
cd $current_dir
mkdir model
cd $current_dir/model

git clone https://www.modelscope.cn/ZhipuAI/chatglm3-6b.git
