# CUDA

使用`nvcc --version`或者`nvidia-smi`查看cuda版本

## 查看CUDA版本

### torch

```python
import platform
import torch

print("python.version:", platform.python_version())
print("torch.version:", torch.__version__)
print("CUDA.version:", torch.version.cuda)
print("cuDNN.version:", torch.backends.cudnn.version())

```

> ```
> python.version: 3.9.19
> torch.version: 2.4.1
> CUDA.version: 12.1
> cuDNN.version: 90100
> ```

### paddle

```python
import platform
import paddle
import paddleocr

print("python.version:", platform.python_version())
print("PaddleOCR version:", paddleocr.__version__)
print("Paddle version:", paddle.__version__)
print("CUDA version:", paddle.version.cuda())
print("cuDNN version:", paddle.version.cudnn())

```

> ```
> python.version: 3.10.14
> PaddleOCR version: 2.7.0.3
> Paddle version: 2.6.1
> CUDA version: 11.7
> cuDNN version: 8.4.1
> ```

## 升级cuda

官方驱动地址：[NVIDIA GeForce 驱动程序 - N 卡驱动 | NVIDIA](https://www.nvidia.cn/geforce/drivers/)

下载exe按照步骤升级，重启即可：

<img src="img/CUDA/image-20240403225001807.png" alt="image-20240403225001807" style="zoom:50%;" />

## cuda安装

### 安装对应cuda

下载cuda：[CUDA Toolkit Archive | NVIDIA Developer](https://developer.nvidia.com/cuda-toolkit-archive)

选择版本：

<img src="img/CUDA/image-20240403224404343.png" alt="image-20240403224404343" style="zoom:67%;" />

下载离线版：

<img src="img/CUDA/image-20240403224513522.png" alt="image-20240403224513522" style="zoom: 50%;" />

设置CUDA安装时临时缓存位置，可以不用改，但得与原先安装的CUDA的安装缓存位置不同：

<img src="img/CUDA/image-20240403231132301.png" alt="image-20240403231132301"  />

自定义安装：

<img src="img/CUDA/image-20240403231534254.png" alt="image-20240403231534254"  />

只需要选择CUDA即可：

<img src="img/CUDA/image-20240403231625295.png" alt="image-20240403231625295"  />

选择安装目录，需要记住安装位置：

<img src="img/CUDA/image-20240403232154000.png" alt="image-20240403232154000"  />

修改为：

<img src="img/CUDA/image-20240403232310230.png" alt="image-20240403232310230"  />

勾选后继续：

<img src="img/CUDA/image-20240403232358137.png" alt="image-20240403232358137"  />

完成安装：

<img src="img/CUDA/image-20240403232700122.png" alt="image-20240403232700122"  />

### 环境变量

安装完成后会自动配置环境变量`nvcc --version`：

<img src="img/CUDA/image-20240403232900580.png" alt="image-20240403232900580"  />

多了两个环境变量，系统变量中的`CUDA_PATH`发生了改变，增加`NVCUDASAMPLES_ROOT`：

<img src="img/CUDA/image-20240403233227807.png" alt="image-20240403233227807"  />

<img src="img/CUDA/image-20240403233723752.png" alt="image-20240403233723752" style="zoom: 80%;" />

在Path中新建两个变量，并上移：

```
D:\CUDA\v11.7\bin
D:\CUDA\v11.7\libnvvp
```

> <img src="img/CUDA/image-20240403233957741.png" alt="image-20240403233957741"  />

### 安装对应cuDNN

下载历史cudNN：[cuDNN Archive | NVIDIA Developer](https://developer.nvidia.com/rdp/cudnn-archive)

<img src="img/CUDA/image-20240905163801241.png" alt="image-20240905163801241"  />

> 登录后才能下载，cuDNN对应的版本号也需要依据实际情况进行下载，这里是`v8.9.6`

解压放到对应目录：

<img src="img/CUDA/image-20240403234306520.png" alt="image-20240403234306520" style="zoom: 80%;" />

<img src="img/CUDA/image-20240403234400559.png" alt="image-20240403234400559"  />

在`extras`目录下的`demo_suite`目录运行cmd，执行`bandwidthTest.exe`和`deviceQuery.exe`

<img src="img/CUDA/image-20240403234638138.png" alt="image-20240403234638138"  />

<img src="img/CUDA/image-20240403234717407.png" alt="image-20240403234717407"  />

至此， 新版本的CUDA与cudnn安装成功，可以使用该版本的CUDA进行GPU加速了

### 新版本的cuDNN

> 所有cuDNN：[cuDNN Archive | NVIDIA Developer](https://developer.nvidia.com/cudnn-archive)

![image-20240912145727397](img/CUDA/image-20240912145727397.png)

> 支持下载压缩包的方式使用

![image-20240912152146627](img/CUDA/image-20240912152146627.png)

> 更推荐直接使用exe文件方式使用（windows下直接兼容CUDA11和CUDA12）

![image-20240912152410293](img/CUDA/image-20240912152410293.png)

自定义安装：

![image-20240912152855588](img/CUDA/image-20240912152855588.png)

执行清理安装：

![image-20240912152920679](img/CUDA/image-20240912152920679.png)

修改安装后的位置：

![image-20240912153334713](img/CUDA/image-20240912153334713.png)

安装完成：

![image-20240912154731869](img/CUDA/image-20240912154731869.png)

## 切换cuda

> 当需要切换为其它版本，只需要对环境变量进行修改即可

在系统变量`Path`中，上移需要切换的版本：

```
D:\CUDA\v12.1\bin
D:\CUDA\v12.1\libnvvp
```

> ![image-20240912120234616](img/CUDA/image-20240912120234616.png)
>
> 系统变量的`Path`比用户变量`Path`优先级更高，为了防止隐藏的问题，两个都改
>
> ![image-20240912120408825](img/CUDA/image-20240912120408825.png)

修改`CUDA_PATH`的值：

```
D:\CUDA\v12.1
```

> ![image-20240912115946774](img/CUDA/image-20240912115946774.png)

修改`NVCUDASAMPLES_ROOT`的值：

```
D:\CUDA\v12.1
```

> ![image-20240905173943448](img/CUDA/image-20240905173943448.png)

检验版本：

```
nvcc --version
```

> ![image-20240905174231966](img/CUDA/image-20240905174231966.png)

### 切换cuDNN

> 有些库对cuDNN版本有要求
>
> ![image-20240912155532217](img/CUDA/image-20240912155532217.png)

直接替换：

![image-20240912120949705](img/CUDA/image-20240912120949705.png)
