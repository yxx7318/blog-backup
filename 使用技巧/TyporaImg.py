import os
import concurrent.futures
import queue

IMG_PATH = 'img'


# 获取md路径和图片路径
def get_path(target_path):
    md_count = 0
    img_count = 0
    result_root_set = set()
    current_root = ""
    current_md_count = 0
    current_img_count = 0
    count_dict = {}
    md_path_list = []
    img_path_list = []

    # 保存数据方法
    def save_count():
        nonlocal md_count
        nonlocal img_count
        nonlocal current_root
        nonlocal current_md_count
        nonlocal current_img_count
        nonlocal root
        count_dict[current_root] = f'\t\t当前目录md数量为{current_md_count},img数量为{current_img_count}'
        md_count = md_count + current_md_count
        img_count = img_count + current_img_count
        current_md_count = 0
        current_img_count = 0
        current_root = root

    for root, dirs, files in os.walk(target_path):
        # 排除.git目录，dirs = [d for d in dirs if d != '.git']只会创建一个变量，而对变量进行全切片操作一定需要引用循环中的变量
        dirs[:] = [d for d in dirs if d != '.git']
        if current_root == "":
            # 记录最初始的dirs，也就是根目录
            result_root_set = set([os.path.join(root, d) for d in dirs])
            current_root = root

        # 只有最大的根目录发生变化才更换当前root节点，因为存储前一个的方式，无法顾及到最后一个
        if root in result_root_set:
            save_count()

        # 循环当前目录下的文件
        for file in files:
            if file.endswith(".md"):
                md_path: str = os.path.join(root, file)
                md_path_list.append(md_path)
                md_name = md_path.split('\\')[-1].split('.md')[0]
                img_path = os.path.join(os.path.join(root, IMG_PATH), md_name)
                img_path_list.append(img_path)
                current_md_count = current_md_count + 1
            elif file.endswith(".png") or file.endswith(".jpg"):
                current_img_count = current_img_count + 1

    # 对于最后一个进行存储
    save_count()

    for key, value in count_dict.items():
        print(key, value)
    print("md文件数量为：", md_count)
    print("img文件数量为：", img_count)

    return md_path_list, img_path_list


# 获取md文件的img标签的src的值
def get_md_img_set(md_path: str) -> set:
    md_img_set = set()
    with open(md_path, 'r', encoding='utf-8') as file:
        for line in file.readlines():
            if r'<img src="img/' in line:
                md_img = line.split('<img src="')[1].split('" alt=')[0]
                md_img_set.add(md_img)
            elif r'![' in line and r'](img/' in line:
                md_img = line.split('](')[1].split(')')[0]
                md_img_set.add(md_img)
    return md_img_set


# 获取img目录下的文件set
def get_img_path_set(image_path: str) -> set:
    img_path_set = set()
    if not os.path.exists(image_path):
        return img_path_set
    md_name = image_path.split('\\')[-1].split('.md')[0]
    for image_path in os.listdir(image_path):
        img_path_set.add(rf'{IMG_PATH}/{md_name}/{image_path}')
    return img_path_set


def task(result_queue: queue.Queue, md_path, image_path):
    md_img_set = get_md_img_set(md_path)
    img_path_set = get_img_path_set(image_path)
    md_difference = md_img_set.difference(img_path_set)
    img_difference = img_path_set.difference(md_img_set)
    result_parts = []  # 使用列表来收集结果片段
    if md_difference:
        result_parts.append(f'\nmd错误：{md_path}\t{str(md_difference)}')
    if img_difference:
        result_parts.append(f'\nimg错误：{image_path}\t{str(img_difference)}')

    if result_parts:
        result = "错误：" + "".join(result_parts) + "\n"
        result_queue.put(result)


def pool_executor(md_path_list, img_path_list):
    result_queue = queue.Queue()
    # 创建一个线程池，最大并发数为10
    with concurrent.futures.ThreadPoolExecutor(max_workers=10) as executor:
        for md_path, img_path in zip(md_path_list, img_path_list):
            executor.submit(task, result_queue, md_path, img_path)
        # 等待所有任务完成
        executor.shutdown()
    return result_queue


# 打印队列信息
def print_queue(result_queue: queue.Queue):
    while not result_queue.empty():
        item = result_queue.get()
        print(item)


def start(target_path, is_statistics=False):
    # 获取文件目录，文件名称即为img目录下的文件目录
    md_path_list, img_path_list = get_path(target_path)

    if not is_statistics:
        # 线程池任务
        result_queue = pool_executor(md_path_list, img_path_list)
        # 打印结果
        print_queue(result_queue)


if __name__ == '__main__':
    target_path = r'F:\yxx\blog-backup'
    start(target_path)
    # start(target_path, True)
