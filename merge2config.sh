#!/bin/bash

# 获取项目根目录
project_root=$(git rev-parse --show-toplevel)
# 定义源目录和目标目录
source_dir="$project_root"
target_dir="$HOME/.config/clash"

# 遍历当前目录下的所有 YAML 文件
for source_file in "$source_dir"/*.yaml; do
    # 读取源文件内容，过滤掉注释行并保留多行内容
    content=$(grep -v '^\s*#' "$source_file")

    # 遍历目标目录下的所有 YAML 文件
    for target_file in "$target_dir"/*.yaml; do
        # 创建一个临时文件用于存储修改后的内容
        temp_file=$(mktemp)

        # 使用awk处理文件内容并插入新内容
        awk -v content="$content" '
            BEGIN { 
                split(content, lines, "\n")
                for (i in lines) {
                    insert_lines[i] = lines[i]
                }
            }
            /^rules:/ {
                print $0
                found=1
                next
            }
            found && !inserted {
                for (i in insert_lines) {
                    if ($0 == insert_lines[i]) {
                        delete insert_lines[i]
                    }
                }
                if (length(insert_lines) > 0) {
                    for (i in insert_lines) {
                        if ($0 ~ /^  /) {
                            print "  " insert_lines[i]
                        } else {
                            print insert_lines[i]
                        }
                    }
                }
                inserted=1
            }
            { print $0 }
        ' "$target_file" > "$temp_file"

        # 将临时文件内容写回目标文件
        mv "$temp_file" "$target_file"
    done
done

echo "合并完成！"

