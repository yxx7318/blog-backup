#!/bin/sh


origin_path="/usr/local/mysqlshell"


cd "$origin_path"
source "$origin_path/Variable.sh"


submit_keywords_one=$1
submit_keywords_two=$2
day=$3


# 封装的方法，用于处理$day参数
handle_day_parameter() {
    local day_param=$day

    # 如果没有传递参数，使用默认值30
    if [ -z "$day" ]; then
        day_param=30
    fi

    local result=$((day_param * 24))

    # 返回$result
    echo "$result"
}

# 封装的方法，用于处理$submit_keywords参数
handle_submit_keywords_parameter() {
    # 校验目录
    if [ -z "$submit_keywords_two" ]; then
    echo "必须提供git提交记录唯一的完整关键词，包括日期和时间"
    exit 1
    fi
    local param=$submit_keywords_two

    # 检查参数是否为数字并且小于10
    if [[ $param =~ ^[0-9]+$ ]] && [ $param -lt 10 ]; then
        # 检查参数是否以0开头
        if [[ ${param:0:1} != "0" ]]; then
            # 如果不是以0开头，则在前面添加0
            param="0$param"
        fi
    fi

	local submit_keywords="$submit_keywords_one $param"
	echo "$submit_keywords"
}

# 判断并创建恢复目录
create_recover_path() {
	local directory=$1
	# 检查备份目录是否存在
	if [ -d "${backup_path}" ]; then
            # 目录存在，可以继续执行备份操作
            if [ ! -d "$directory" ]; then
                mkdir -p "$directory"
            fi
    else
        # 目录不存在，打印错误消息并退出
        echo "备份目录不存在！请检查先开启备份后重新尝试。"
        exit 1
	fi
}


# 获取提交的hash值
get_git_commit_hash() {
    # 获取记录数量
    local current_count=$(handle_day_parameter)
    local current_submit_keywords=$(handle_submit_keywords_parameter)
    local commit_hash=$(git log --pretty=oneline --max-count="$current_count" | grep -w "$current_submit_keywords" | head -n 1 | awk '{print$1}')
    echo "$commit_hash"
}

# 合并sql文件
cat_sql() {
    cat split_* > "$recover_path/$recover_file"
}

# 执行git提交操作
git_check_out_with_hash() {
    local current_hash=$1

    # 切换版本
    git checkout "$current_hash"
}



# 创建目录
create_recover_path "$recover_path"

# 切换到备份目录
cd "$backup_path"

# 获取hash值
current_hash=$(get_git_commit_hash)

echo ""
echo "切换版本的hash值为：$current_hash"
echo ""

# 检查是否获取到哈希值
if [ -z "$current_hash" ]; then
    echo "未能匹配到最近30天的记录，请尝试手动设置查询天数"
    exit 1
fi

# 切换版本
git_check_out_with_hash "$current_hash"

# 合并sql文件
cat_sql

# 回到最新版本
git checkout master

# 执行删库操作
# mysql -h "$recover_host" -u "$recover_username" -p"$recover_password" -e "DROP DATABASE IF EXISTS $database;"
# echo "删除原有数据库：$database"

# 执行恢复操作
# mysql -h "$recover_host" -u "$recover_username" -p"$recover_password" < "$recover_path/$recover_file"
# echo "恢复数据到对应时间节点：$1 $2"
