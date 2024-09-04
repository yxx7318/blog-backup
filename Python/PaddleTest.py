# python -m pip install paddlepaddle-gpu==2.6.1.post117 -f https://www.paddlepaddle.org.cn/whl/windows/mkl/avx/stable.html

import paddle

# 指定使用GPU
# paddle.set_device('gpu:0')

# 创建一个张量
tensor = paddle.to_tensor([1, 2, 3, 4], dtype='float32')

# 检查张量的位置
if tensor.place.is_gpu_place():
    print("Using GPU")
else:
    print("Using CPU")
