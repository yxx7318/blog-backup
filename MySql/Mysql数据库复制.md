# Mysql数据库复制

> mysql数据库复制可以基于mysqldump和python代码来实现
>
> - 通过mysqldump可以复制一份完整的sql文件
> - 通过python代码可以实现备份还原的自动化
>
> **新建出来的数据库可以和目标数据库保持一样的数据，可以随意对新建出来的数据库进行任意的修改，重启脚本即可清空重建**

```python
import subprocess
import os


# 执行cmd命令
def run_command(command):
    process = None
    try:
        # 使用subprocess.Popen执行命令
        process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True,
                                   encoding='utf-8')

        # 打印输出和错误日志
        stdout, stderr = process.communicate()
        if stdout:
            print("cmd输出信息:", stdout)
        if stderr:
            print("cmd警告或错误信息:", stderr)
            if "error" in stderr:
                raise Exception(f"执行命令：{command}，发生错误", stderr)

    except Exception as e:
        raise Exception(f"执行命令：{command}，发生错误", e)
    finally:
        # 确保子进程已终止
        if process is not None:
            process.kill()


# 保存新数据库sql
def save_new_database_sql(sql_path, new_database, new_sql_path):
    def read_sql(current_sql_path):
        with open(current_sql_path, "r", encoding="utf-8") as file:
            return file.readlines()

    def replace_database(current_new_database, current_lines):
        # CREATE DATABASE /*!32312 IF NOT EXISTS*/ `cebc` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
        match_key = f"CREATE DATABASE"
        replace_line = f"CREATE DATABASE /*!32312 IF NOT EXISTS*/ `{current_new_database}` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;"
        for index, line in enumerate(current_lines):
            if match_key in line:
                print("匹配的行：" + str(index))
                print("替换前：" + current_lines[index])
                current_lines[index] = replace_line
                print("替换后：" + current_lines[index])
                # 改变use的数据库
                print("替换前：" + current_lines[index + 2])
                current_lines[index + 2] = f"USE `{current_new_database}`"
                print("替换后：" + current_lines[index + 2])
                break

    def save_sql(current_sql_path, current_lines):
        with open(current_sql_path, "w", encoding="utf-8") as file:
            file.writelines(current_lines)

    # 获取行
    lines = read_sql(sql_path)
    # 替换数据库
    replace_database(new_database, lines)
    # 保存新sql
    save_sql(new_sql_path, lines)


if __name__ == '__main__':
    backup_host = "127.0.0.1"
    backup_username = "root"
    backup_password = "123456"

    source_database = "litemall"
    output_sql_path = "source_database.sql"
    target_database = "litemall_write"
    target_database_sql_path = "target_database.sql"

    # 数据库可以通过单引号对密码中的特殊字符进行转义
    connect_params = f" -h {backup_host} -u {backup_username} -p{backup_password} "
    source_cmd = f"mysqldump {connect_params} --default-character-set=utf8 --create-options --databases {source_database} > {output_sql_path}"
    print("拉取读取库备份命令：" + source_cmd)

    delete_cmd = f"mysql {connect_params} -e 'DROP DATABASE IF EXISTS {target_database};'"
    print("删除可写入库命令：" + delete_cmd)

    recover_cmd = f"mysql {connect_params} < {target_database_sql_path}"
    print("恢复可写入库命令：" + recover_cmd)

    # 拉取读取库备份
    run_command(source_cmd)
    # 保存目标库sql
    save_new_database_sql(output_sql_path, target_database, target_database_sql_path)
    # 删除可以修改的库
    run_command(delete_cmd)
    # 通过从库备份恢复可以修改的库
    run_command(recover_cmd)
    # 删除sql文件
    os.remove(output_sql_path)
    os.remove(target_database_sql_path)

```

> ![image-20241207153043861](img/Mysql数据库复制/image-20241207153043861.png)