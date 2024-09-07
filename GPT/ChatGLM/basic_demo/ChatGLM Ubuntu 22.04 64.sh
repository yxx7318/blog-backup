#!/bin/sh

# 配置仓库，git-lfs（Large File Storage）没有包含在Ubuntu的默认仓库中
# 先确保已安装了正确的软件来添加新的仓库。如果没有，可以运行以下命令进行安装
apt-get install software-properties-common

# 添加新的仓库：
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash

# 更新包列表
apt-get update

# 安装git大型二进制文件的版本控制工具
apt-get install git-lfs -y
git lfs install

current_dir=$(pwd)
echo "当前运行目录：$current_dir"

# 创建git下载目录
path="ChatGLM"
mkdir $path
cd $current_dir/$path

# 拉取代码，这里使用国内的gitcode，可能同步没那么及时
git clone https://gitcode.com/THUDM/ChatGLM3.git

# 安装依赖
cd $current_dir/$path/ChatGLM3

# 默认依赖只会下载cpu版本，需要下载一个GPU版本的pytorch
# 英伟达显卡更新驱动后，CUDA版本一般在12.1以上
# 118版本
# linux：pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
# windows：pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
# conda：conda install pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia
# 121版本
# linux：pip3 install torch torchvision torchaudio
# windows：pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# 官方下载地址：https://download.pytorch.org/whl/torch/
# pytorch版本 -> cuda版本 -> python版本 -> 平台
# torch-2.0.1+cu117-cp39-cp39-win_amd64.whl
# 安装命令：pip install torch-2.0.1+cu117-cp39-cp39-win_amd64.whl

# 默认优先pytorch的最新版，如果有需要指定到低版本的cuda，需要对pytorch指定版本
# conda：conda install pytorch=2.0.1 torchvision torchaudio pytorch-cuda=11.7 -c pytorch -c nvidia
pip3 install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# 下载模型
cd $current_dir
mkdir model
cd $current_dir/model

git clone https://www.modelscope.cn/ZhipuAI/chatglm3-6b.git

cd $current_dir/$path/ChatGLM3/basic_demo


# qwen/Qwen-VL-Chat
# 打开bf16精度，A100、H100、RTX3060、RTX3070等显卡建议启用以节省显存
# model = AutoModelForCausalLM.from_pretrained(model_dir, device_map="auto", trust_remote_code=True, bf16=True).eval()
# 打开fp16精度，V100、P100、T4等显卡建议启用以节省显存
# model = AutoModelForCausalLM.from_pretrained(model_dir, device_map="auto", trust_remote_code=True, fp16=True).eval()
# 使用CPU进行推理，需要约32GB内存
# model = AutoModelForCausalLM.from_pretrained(model_dir, device_map="cpu", trust_remote_code=True).eval()
# 默认使用自动模式，根据设备自动选择精度
# model = AutoModelForCausalLM.from_pretrained(model_dir, device_map="auto", trust_remote_code=True).eval()


# 模型路径配置，os.environ.get('MODEL_PATH', 'THUDM/chatglm3-6b')
# 模型运行方式，model = AutoModel.from_pretrained(MODEL_PATH, trust_remote_code=True, device_map="auto").eval()，，默认.eval()为gpu运行，.float()为cpu运行
# vim web_demo_streamlit.py

# 更改参数后再启动启动模型（端口8501）
# streamlit run web_demo_streamlit.py