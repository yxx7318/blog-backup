import os
import concurrent.futures
import queue

IMG_PATH = 'img'


# 获取md路径和图片路径
def get_path(target_path):
    md_path_list = []
    img_path_list = []
    for root, dirs, files in os.walk(target_path):
        for file in files:
            if file.endswith('.md'):
                md_path: str = os.path.join(root, file)
                md_path_list.append(md_path)
                md_name = md_path.split('\\')[-1].split('.md')[0]
                img_path = os.path.join(os.path.join(root, IMG_PATH), md_name)
                img_path_list.append(img_path)
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


def start(target_path):
    # 获取文件目录，文件名称即为img目录下的文件目录
    md_path_list, img_path_list = get_path(target_path)
    # 线程池任务
    result_queue = pool_executor(md_path_list, img_path_list)
    # 打印结果
    print_queue(result_queue)


if __name__ == '__main__':
    target_path = r'D:\博客\blog-backup'
    start(target_path)
