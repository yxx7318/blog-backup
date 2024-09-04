# CUDA

使用`nvcc --version`或者`nvidia-smi`查看cuda版本

## 升级cuda

官方驱动地址：[NVIDIA GeForce 驱动程序 - N 卡驱动 | NVIDIA](https://www.nvidia.cn/geforce/drivers/)

下载exe按照步骤升级，重启即可：

<img src="img/CUDA/image-20240403225001807.png" alt="image-20240403225001807" style="zoom:50%;" />

## 多版本cuda切换

### 安装对应cuda

下载cuda：[CUDA Toolkit Archive | NVIDIA Developer](https://developer.nvidia.com/cuda-toolkit-archive)

选择版本：

<img src="img/CUDA/image-20240403224404343.png" alt="image-20240403224404343" style="zoom:67%;" />

下载离线版：

<img src="img/CUDA/image-20240403224513522.png" alt="image-20240403224513522" style="zoom: 50%;" />

设置CUDA 安装时临时缓存位置，可以不用改，但得与原先安装的 CUDA 的安装缓存位置不同：

<img src="img/CUDA/image-20240403231132301.png" alt="image-20240403231132301" style="zoom:80%;" />

自定义安装：

<img src="img/CUDA/image-20240403231534254.png" alt="image-20240403231534254" style="zoom: 80%;" />

只需要选择CUDA即可：

<img src="img/CUDA/image-20240403231625295.png" alt="image-20240403231625295" style="zoom: 80%;" />

选择安装目录，需要记住安装位置：

<img src="img/CUDA/image-20240403232154000.png" alt="image-20240403232154000" style="zoom: 80%;" />

修改为：

<img src="img/CUDA/image-20240403232310230.png" alt="image-20240403232310230" style="zoom: 80%;" />

勾选后继续：

<img src="img/CUDA/image-20240403232358137.png" alt="image-20240403232358137" style="zoom: 80%;" />

完成安装：

<img src="img/CUDA/image-20240403232700122.png" alt="image-20240403232700122" style="zoom: 80%;" />

### 环境变量

安装完成后会自动配置环境变量`nvcc --version`：

<img src="img/CUDA/image-20240403232900580.png" alt="image-20240403232900580" style="zoom:80%;" />

多了两个环境变量，系统变量中的`CUDA_PATH`发生了改变，增加`NVCUDASAMPLES_ROOT`：

<img src="img/CUDA/image-20240403233227807.png" alt="image-20240403233227807" style="zoom:80%;" />

<img src="img/CUDA/image-20240403233723752.png" alt="image-20240403233723752" style="zoom: 80%;" />

在Path中新建两个变量，并上移：

```
D:\CUDA\v11.7\bin
D:\CUDA\v11.7\libnvvp
```

> <img src="img/CUDA/image-20240403233957741.png" alt="image-20240403233957741" style="zoom:80%;" />

### 安装对应cudnn

下载cudnn：[cuDNN Archive | NVIDIA Developer](https://developer.nvidia.com/rdp/cudnn-archive)

解压放到对应目录：

<img src="img/CUDA/image-20240403234306520.png" alt="image-20240403234306520" style="zoom:67%;" />

<img src="img/CUDA/image-20240403234400559.png" alt="image-20240403234400559" style="zoom:80%;" />

在`extras`目录下的`demo_suite`目录运行cmd，执行`bandwidthTest.exe`和`deviceQuery.exe`

<img src="img/CUDA/image-20240403234638138.png" alt="image-20240403234638138" style="zoom:80%;" />

<img src="img/CUDA/image-20240403234717407.png" alt="image-20240403234717407" style="zoom:67%;" />

至此， 新版本的CUDA与cudnn安装成功，可以使用该版本的CUDA进行GPU加速了

### 切换cuda

> 当需要切换为其它版本，只需要对环境变量进行修改即可

在系统变量Path中，上移需要切换的版本，像是上移：

```
D:\CUDA\v12.1\bin
D:\CUDA\v12.1\libnvvp
```

修改`CUDA_PATH`的值：

```
D:\CUDA\v12.1
```

修改`NVCUDASAMPLES_ROOT`的值：

```
D:\CUDA\v12.1
```

