#!/bin/sh

conda create -n chatglm3-demo python=3.10
conda activate chatglm3-demo
pip3 install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# 默认依赖只会下载cpu版本，去再下载一个GPU版本的pytorch，英伟达显卡更新驱动后，CUDA版本一般在12.1以上
# 118版本
# linux：pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
# windows：pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
# 121版本
# linux：pip3 install torch torchvision torchaudio
# windows：pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# 安装 Jupyter 内核
ipython kernel install --name chatglm3-demo --user

# 尽可能减少gpu内存碎片
# windows：set PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True
# Linux：export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True

# 安装图形库
# pip3 install matplotlib -i https://pypi.tuna.tsinghua.edu.cn/simple

# 修改client.py中模型的位置
# streamlit run main.py

