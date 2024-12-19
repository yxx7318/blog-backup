# Ollama基本使用

> 官网链接：[Ollama](https://ollama.com/)

## 安装使用

直接安装：

![image-20241218161055674](img/Ollama基本使用/image-20241218161055674.png)

安装后自动运行：

![image-20241218161647559](img/Ollama基本使用/image-20241218161647559.png)

允许任何IP连接：

![image-20241219144232909](img/Ollama基本使用/image-20241219144232909.png)

> 通过系统变量`OLLAMA_HOST`指定ip，默认只允许本地

## 基本命令

```
C:\Users\Administrator>ollama
Usage:
  ollama [flags]
  ollama [command]

Available Commands:
  serve       Start ollama
  create      Create a model from a Modelfile
  show        Show information for a model
  run         Run a model
  stop        Stop a running model
  pull        Pull a model from a registry
  push        Push a model to a registry
  list        List models
  ps          List running models
  cp          Copy a model
  rm          Remove a model
  help        Help about any command

Flags:
  -h, --help      help for ollama
  -v, --version   Show version information

Use "ollama [command] --help" for more information about a command.
```

**模型列表**：

```
ollama list
```

> ```
> C:\Users\Administrator>ollama list
> NAME    ID    SIZE    MODIFIED
> ```

**运行模型**：

```
ollama run llama3.2
```

> ```
> C:\Users\Administrator>ollama run llama3.2
> pulling manifest
> pulling dde5aa3fc5ff... 100% ▕████████████████████████████████████████████████████████▏ 2.0 GB
> pulling 966de95ca8a6... 100% ▕████████████████████████████████████████████████████████▏ 1.4 KB
> pulling fcc5a6bec9da... 100% ▕████████████████████████████████████████████████████████▏ 7.7 KB
> pulling a70ff7e570d9... 100% ▕████████████████████████████████████████████████████████▏ 6.0 KB
> pulling 56bb8bd477a5... 100% ▕████████████████████████████████████████████████████████▏   96 B
> pulling 34bb5ab01051... 100% ▕████████████████████████████████████████████████████████▏  561 B
> verifying sha256 digest
> writing manifest
> success
> ```

**直接对话**：

````
>>> hello
Hello! How can I assist you today?

>>> please write a little code that can print a HelloWorld by Python
Here is a simple Python program that prints "Hello, World!" to the console:

```python
print("Hello, World!")
```

You can save this in a file (e.g., `hello.py`) and run it with Python (e.g., `python hello.py`).

Alternatively, here's a more traditional Python program:

```python
def main():
    print("Hello, World!")

if __name__ == "__main__":
    main()
```

This code defines a function `main()` that prints "Hello, World!", and uses the `if __name__ == "__main__":` idiom
to ensure it's only run when the script is executed directly (not when it's imported as a module).

>>> 请编写一段可以用Python打印HelloWorld的代码，请用中文回答
当然了！以下是使用 Python 打印“Hello World”的简单例子：

```python
# 直接使用 print 函数
print("Hello, World!")

# 定义一个函数
def main():
    print("Hello, World!")

if __name__ == "__main__":
    main()
```

您可以将这个代码保存为一个文件（例如，hello.py），然后在命令行中使用 Python 执行它：

```bash
python hello.py
```

或者，您也可以在 IDLE 或其他 IDE 中创建一个新文件，然后将该代码粘贴到其中。

如果您想使用 Python 的环境或 IDE，例如 PyCharm、Visual Studio Code 等，可以按照以下步骤进行：

1.  导入 Python 环境或 IDE
2.  新建一个新项目或工作空间
3.  在控制台或终端中创建一个新的 Python 脚本（.py文件）
4.  将上述代码粘贴到脚本中
5.  运行脚本，例如使用命令行中的 `python` 命令，或在 IDE 中使用“运行”/“执行”按钮。

所有这些方法都可以让您轻松地用 Python 执行“Hello World”的程序。

>>> /bye
````

**关闭模型**：

```
ollama stop llama3.2
```

参考博客：

- [【LLM】Ollama：本地大模型 WebAPI 调用_ollama api调用-CSDN博客](https://blog.csdn.net/2303_80346267/article/details/142437852)
