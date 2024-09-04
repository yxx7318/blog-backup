#!/bin/sh


origin_path="/usr/local/mysqlshell"


cd "$origin_path"
source "$origin_path/Variable.sh"


# 判断并创建目录
create_directory_if_not_exists() {
    local directory=$1
    if [ ! -d "$directory" ]; then
        mkdir -p "$directory"
    else
        echo ""
    fi
}

# 备份指定数据库
backup_database() {
    # 执行mysqldump命令，备份指定数据库
    mysqldump -h "$backup_host" -u "$backup_username" -p"$backup_password" --default-character-set=utf8 \
	--create-options \
	--databases "$database" > "$output_file"
}

# 获取格式化的当前时间
get_formatted_time() {
    # local current_time=$(date +'%Y-%m-%d %H:%M')
    local current_time=$date_format
    echo "$current_time"
}

# 检查并初始化git仓库
check_and_initialize_git() {
    # 检查当前目录是否已经是一个git仓库
    if [ -d ".git" ]; then
        :
    else
        # 初始化git仓库
        git init
		# 创建.gitignore文件
		echo "*.sql" > .gitignore
    fi
}

# 切割sql文件
split_sql() {
    # 切割文件，后缀12位，确保不冲突
    split -b 100m -a 12 "$output_file" split_
}

# 执行git提交操作
git_commit_with_time() {
    # 如果没有git仓库，则创建
    check_and_initialize_git

    # 获取当前时间
    local commit_time=$(get_formatted_time)
    
    # 执行git add .添加所有更改
    git add .

    # 使用处理后的时间作为commit信息
    git commit -m "$commit_time"
}



# 创建目录
create_directory_if_not_exists "$backup_path"

# 切换目录
cd $backup_path

# 获取备份文件
backup_database

# 切割文件
split_sql

# 以当前时间提交并执行
git_commit_with_time
