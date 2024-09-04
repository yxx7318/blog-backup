# ffmpeg和ImageMagick

## ffmpeg

### Windows安装

下载地址：[Download FFmpeg](https://ffmpeg.org/download.html)

![image-20240807181704562](img/ffmpeg和ImageMagick/image-20240807181704562.png)

![image-20240807181804860](img/ffmpeg和ImageMagick/image-20240807181804860.png)

解压文件，在path中配置环境变量`C:\ffmpeg\bin`

### Linux安装

```
conda install ffmpeg
```

> 在conda虚拟环境下可以使用，但Linux环境下不污染
>
> ```
> ffmpeg -version
> ```

## ImageMagick

### Windows安装

![image-20240807183816486](img/ffmpeg和ImageMagick/image-20240807183816486.png)

![image-20240807183816486](img/ffmpeg和ImageMagick/image-20240807184132106.png)

### Linux安装

下载地址：[ImageMagick – Download](https://imagemagick.org/script/download.php)

```
sudo yum install ImageMagick
```

> 查看版本号
>
> ```
> magick -version
> ```
>
> 如果没有则创建软连接，因为centos可能不支持最新版本，老版本是`convert`命令
>
> ```
> sudo ln -s /usr/bin/convert /usr/bin/magick
> ```

### 环境判断

```python
from moviepy.config import change_settings

if os.name == 'nt':
    change_settings({"IMAGEMAGICK_BINARY": r"F:\yxx\ImageMagick-7.1.1-Q16-HDRI\magick.exe"})
    print("当前操作系统是Windows")
elif os.name == 'posix':
    change_settings({"IMAGEMAGICK_BINARY": r"/usr/bin/convert"})
    print("当前操作系统是类Unix系统，比如Linux或Mac OS X")
```
