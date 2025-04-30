import os
import mimetypes


def is_text_file(file_path):
    """
    判断文件是否为文本文件。
    :param file_path: 文件路径
    :return: 如果是文本文件，则返回 True；否则返回 False。
    """
    # 使用 mimetypes 判断文件类型
    mime_type, _ = mimetypes.guess_type(file_path)
    if mime_type and mime_type.startswith('text/'):
        return True

    # 对于无法通过 mimetypes 判断的文件，尝试读取前 1KB 内容检测编码
    try:
        with open(file_path, 'rb') as f:
            content = f.read()  # 读取前 1KB 内容
            # 尝试解码为 UTF-8，如果成功则认为是文本文件
            content.decode('utf-8')
            return True
    except UnicodeDecodeError:
        return False
    except Exception as e:
        print(f"无法读取文件 {file_path}: {e}")
        return False


def analyze_line_endings(file_path):
    """
    分析文件的换行符类型，判断是否包含 \\r\\n 或 \\n。
    :param file_path: 文件路径
    :return: 返回一个元组 (contains_crlf, contains_lf)，表示文件是否包含 \\r\\n 和 \\n。
    """
    try:
        with open(file_path, 'rb') as f:  # 以二进制模式打开文件
            content = f.read()  # 读取整个文件内容
            contains_crlf = b'\r\n' in content  # 检查是否存在 \r\n
            contains_lf = b'\n' in content and not contains_crlf  # 检查是否存在单独的 \n
            return contains_crlf, contains_lf
    except Exception as e:
        print(f"无法读取文件 {file_path}: {e}")
        return False, False


def check_line_endings_in_directory(directory):
    """
    检查指定目录下的文本文件的换行符类型，并统计文件总数、包含 \\r\\n 和 \\n 的文件数。
    :param directory: 要检查的目录路径
    """
    excluded_dirs = {'dist', 'node_modules', 'target'}
    total_files = 0  # 总文件数
    crlf_files = []  # 包含 \r\n 的文件列表
    lf_files = []  # 包含 \n 的文件列表

    for root, dirs, files in os.walk(directory):
        # 排除指定的目录和以 '.' 开头的隐藏目录
        dirs[:] = [d for d in dirs if d not in excluded_dirs and not d.startswith('.')]

        for file in files:
            file_path = os.path.join(root, file)
            # 判断文件是否为文本文件
            if is_text_file(file_path):
                total_files += 1  # 计入总文件数
                contains_crlf, contains_lf = analyze_line_endings(file_path)
                if contains_crlf:
                    crlf_files.append(file_path)
                elif contains_lf:
                    lf_files.append(file_path)

    # 打印结果
    if crlf_files:
        print("\n以下文件包含 \\r\\n 组合：")
        for file in crlf_files:
            print(file)
    else:
        print("没有发现包含 \\r\\n 组合的文件。")

    if lf_files:
        print("\n以下文件包含 \\n 换行符：")
        for file in lf_files:
            print(file)
    else:
        print("没有发现包含 \\n 换行符的文件。")

    # 输出统计信息
    print("\n统计信息：")
    print(f"总文件数：{total_files}")
    print(f"包含 \\r\\n 的文件数：{len(crlf_files)}")
    print(f"包含 \\n 的文件数：{len(lf_files)}")
    if total_files > 0:
        crlf_ratio = len(crlf_files) / total_files * 100
        lf_ratio = len(lf_files) / total_files * 100
        print(f"包含 \\r\\n 的文件占比：{crlf_ratio:.2f}%")
        print(f"包含 \\n 的文件占比：{lf_ratio:.2f}%")
    else:
        print("未找到任何符合条件的文件。")
    return crlf_files, lf_files


def convert_line_endings(file_list, target_format, exclude_suffixes):
    """
    将指定文件列表中的文件转换为指定的换行符格式。

    :param file_list: 文件路径列表
    :param target_format: 目标换行符格式，支持 'crlf' (\\r\\n) 或 'lf' (\\n)
    :param exclude_suffixes: 无需转换的文件后缀列表
    """
    if target_format not in ['crlf', 'lf']:
        raise ValueError("目标换行符格式必须是 'crlf' 或 'lf'。")

    converted_files = []  # 转换成功的文件列表
    skipped_files = []  # 跳过的文件列表

    for file_path in file_list:
        # 检查文件是否需要跳过
        _, ext = os.path.splitext(file_path)
        if ext.lower() in exclude_suffixes:
            skipped_files.append(file_path)
            continue

        try:
            # 读取文件内容
            with open(file_path, 'rb') as f:
                content = f.read()

            new_content = None
            # 替换换行符
            if target_format == 'crlf':
                new_content = content.replace(b'\n', b'\r\n')  # 转换为 CRLF
            elif target_format == 'lf':
                new_content = content.replace(b'\r\n', b'\n')  # 转换为 LF

            # 写回文件
            with open(file_path, 'wb') as f:
                f.write(new_content)

            converted_files.append(file_path)

        except Exception as e:
            print(f"无法转换文件 {file_path}: {e}")

    # 打印结果
    if converted_files:
        print("\n以下文件已成功转换：")
        for file in converted_files:
            print(file)

    if skipped_files:
        print("\n以下文件被跳过：")
        for file in skipped_files:
            print(file)

    return converted_files, skipped_files


if __name__ == "__main__":
    # 指定要检查的目录
    target_directory = r'D:\yxx\project\yxx-yi'
    crlf_files, lf_files = check_line_endings_in_directory(target_directory)
    # 传入指定的文件列表，将其中的文件列表中的文件转换为指定的换行格式-crlf
    # convert_line_endings(lf_files, target_format='crlf', exclude_suffixes=['.sh', 'LICENSE', '.conf', '.sql'])
    # 传入指定的文件列表，将其中的文件列表中的文件转换为指定的换行格式-lf
    convert_line_endings(crlf_files, target_format='lf', exclude_suffixes=['.bat', 'LICENSE'])
