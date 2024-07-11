#!/bin/bash

# 获取项目根目录
project_root=$(git rev-parse --show-toplevel)
# 定义源目录和目标目录
source_dir="$project_root"
target_dir="$HOME/.config/clash"

# 遍历当前目录下的所有 YAML 文件
for source_file in "$source_dir"/*.yaml; do
    # 读取源文件内容
    content=$(grep -v '^\s*#' "$source_file")

    # 添加换行符到内容的前后
    content="\n${content}\n"

    # 遍历目标目录下的所有 YAML 文件
    for target_file in "$target_dir"/*.yaml; do
        # 插入内容到rules:下的第一行
        sed -i '' -e "/^rules:/a\\
$content" "$target_file"
    done
done

echo "合并完成！"

