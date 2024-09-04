#!/bin/sh

# 拉取代码，这里使用国内的gitcode，可能同步没那么及时
git clone https://gitcode.com/hiyouga/LLaMA-Factory.git

cd LLaMA-Factory
pip3 install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# 如果要在 Windows 平台上开启量化 LoRA（QLoRA），需要安装预编译的 bitsandbytes 库, 支持 CUDA 11.1 到 12.1.
# pip install https://github.com/jllllll/bitsandbytes-windows-webui/releases/download/wheels/bitsandbytes-0.39.1-py3-none-win_amd64.whl
# 这里gitcode没有，可以手动下载后使用 pip install bitsandbytes-0.39.1-py3-none-win_amd64.whl 安装

# Linux启动 LLaMA Board，确保该任务只使用第一个 GPU（7860端口），windows无需此前缀
CUDA_VISIBLE_DEVICES=0 python3 src/train_web.py