# 爬虫cmd指令

## scrapy指令

安装scrapy

```
pip install scrapy -i https://pypi.tuna.tsinghua.edu.cn/simple
```

创建scrapy项目

```
scrapy startproject scrapy_baidu
```

切换爬虫目录

```
cd scrapy_baidu\scrapy_baidu\spiders
```

创建普通spider爬虫类

```
scrapy genspider baidu www.baidu.com
```

> 创建CrawlSpider爬虫类
>
> ```
> scrapy genspider -t crawl read www.dushu.com
> ```

## 安装的第三方库

xpath

```
pip install lxml -i https://pypi.tuna.tsinghua.edu.cn/simple
```

jsonpath

```
pip install jsonpath
```

bs4

```
pip install bs4 -i https://pypi.tuna.tsinghua.edu.cn/simple
```

selenium

```
pip install selenium -i https://pypi.tuna.tsinghua.edu.cn/simple
```

requesets

```
pip install requests -i https://pypi.tuna.tsinghua.edu.cn/simple
```

pymysql

```
pip install pymysql -i https://pypi.tuna.tsinghua.edu.cn/simple
```

openpyxl

```
pip install openpyxl -i https://pypi.tuna.tsinghua.edu.cn/simple
```

Pyinstaller

```
pip install Pyinstaller -i https://pypi.tuna.tsinghua.edu.cn/simple
```

## 镜像地址

阿里镜像

```
http://mirrors.cloud.aliyuncs.com/pypi/simple/
```

豆瓣镜像

```
https://pypi.douban.com/simple/
```

