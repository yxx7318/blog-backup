# pickle

## 方法返回结果持久化

```python
import pickle
import os


def pickle_method(fun=None, *current_args, **current_kwargs):
    pick_path = current_kwargs.get('pick_path', fun if isinstance(fun, str) else 'data.pick')

    def decorator(func):
        def wrapper(*args, **kwargs):
            if os.path.exists(pick_path):
                with open(pick_path, "rb") as file:
                    return pickle.load(file)
            else:
                result = func(*args, **kwargs)
                with open(pick_path, "wb") as file:
                    pickle.dump(result, file)
                    return result

        return wrapper

    import inspect

    if fun and inspect.isfunction(fun):
        return decorator(fun)
    return decorator


@pickle_method
def mytest():
    return "mytest"


@pickle_method("mytest2.pick")
def mytest2():
    return "mytest2"


if __name__ == '__main__':
    print(mytest())
    print(mytest())
    print(mytest2())
    print(mytest2())

```

## 对象持久化共享

```python
import pickle
import os

global_data = {}

pickle_path = "data.pickle"


# 从文件加载对象
def current_load_data(file_path=pickle_path):
    if os.path.exists(file_path):
        with open(file_path, "rb") as file:
            try:
                data = pickle.load(file)
            except (pickle.UnpicklingError, EOFError):
                # 如果文件无法解析为对象或者文件内容为空，则返回空字典对象
                data = {}
    else:
        # 如果文件不存在，则返回空字典对象
        data = {}
    return data


# 将对象保存到文件(with上下文管理器会导致保存的一定滞后性)
def current_save_data(data, file_path=pickle_path):
    # 打开文件以写入模式
    file = open(file_path, "wb")
    # 尝试保存数据到文件
    try:
        pickle.dump(data, file)
    finally:
        # 无论是否成功，都确保文件被关闭
        file.close()


# 定义全局加载方法
def load_data(file_path=pickle_path):
    # 是否已经加载过了
    global global_data
    if global_data and file_path == pickle_path:
        return global_data
    elif not global_data and file_path == pickle_path:
        global_data = current_load_data(file_path)
        return global_data

    # 如果请求读取非默认文件
    if file_path != pickle_path:
        return current_load_data(file_path)


# 定义全局存储方法
def save_data(data=None, file_path=pickle_path):
    # 如果请求保存非默认文件
    if data and file_path != pickle_path:
        return current_save_data(data, file_path)
    # 如果date不为空，则使用传入的data
    elif data and file_path == pickle_path:
        return current_save_data(data, file_path)

    # 如果data为空，则使用全局的变量
    global global_data
    if global_data and file_path == pickle_path:
        return current_save_data(global_data, file_path)


# 初始加载
load_data()

```

