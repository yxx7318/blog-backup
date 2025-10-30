#!/bin/bash



# 完整的路径名称，包含"/dist"
DIST_PATH="$1"
VUE_PATH="/usr/local/yxx/yxx-yi/dist"



echo "================================="
echo "vue更新脚本 $0 启动：$VUE_PATH"
echo "================================="



# 检查输入参数
if [[ -z "$DIST_PATH" ]]; then
    echo "错误：请指定源目录路径作为参数"
    exit 1
fi

# 检查源目录是否存在
if [[ ! -d "$DIST_PATH" ]]; then
    echo "错误：源目录不存在 - $DIST_PATH"
    exit 1
fi

# 进入源目录
cd "$DIST_PATH" || {
    echo "错误：无法进入目录 $DIST_PATH"
    exit 1
}

echo "正在从 $DIST_PATH 复制到 $VUE_PATH..."

# 删除目标目录（如果存在）
if [[ -d "$VUE_PATH" ]]; then
    echo "删除旧目录..."
    rm -rf "$VUE_PATH"
fi

# 复制到目标目录
echo "复制文件..."
if cp -r "$DIST_PATH" "$VUE_PATH"; then
    echo "更新完成！"
else
    echo "复制过程中出现错误"
    exit 1
fi
