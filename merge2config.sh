#!/bin/bash

# 获取项目根目录
project_root=$(git rev-parse --show-toplevel)
# 定义源目录和目标目录
source_dir="$project_root"
target_dir="$HOME/.config/clash"

# 遍历当前目录下的所有 YAML 文件
for source_file in "$source_dir"/*.yaml; do
    # 读取源文件内容，过滤掉注释行，并将内容保存到临时文件中
    grep -v '^\s*#' "$source_file" > /tmp/source_content.yaml

    # 遍历目标目录下的所有 YAML 文件
    for target_file in "$target_dir"/*.yaml; do
        # 创建一个临时文件用于存储过滤后的源文件内容
        filtered_source=$(mktemp)

        # 使用 awk 处理过滤操作
        awk '
            NR==FNR { existing[trim($0)] = 1; next }
            {
                line = $0
                sub(/^[ \t\r\n]+/, "", line)
                sub(/[ \t\r\n]+$/, "", line)
                if (!(line in existing)) print $0
            }
            function trim(s) {
                sub(/^[ \t\r\n]+/, "", s)
                sub(/[ \t\r\n]+$/, "", s)
                return s
            }
        ' "$target_file" /tmp/source_content.yaml > "$filtered_source"

        # 创建一个临时文件用于存储修改后的内容
        temp_file=$(mktemp)

        # 使用 awk 处理文件内容并插入新内容
        awk -v source_file="$filtered_source" '
            function trim(s) {
                sub(/^[ \t\r\n]+/, "", s);
                sub(/[ \t\r\n]+$/, "", s);
                return s;
            }
            BEGIN {
                while ((getline line < source_file) > 0) {
                    line = trim(line)
                    if (line != "") {
                        lines[line] = line
                    }
                }
            }
            /^rules:/ {
                print $0
                found = 1
                next
            }
            found && !inserted {
                # 获取下一行的缩进
                getline next_line
                indent = substr(next_line, 1, match(next_line, /[^ \t]/) - 1)
                # 插入新行
                for (line in lines) {
                    print indent line
                }
                inserted = 1
                print next_line
                next
            }
            {
                print $0
            }
        ' "$target_file" > "$temp_file"

        # 将临时文件内容写回目标文件
        mv "$temp_file" "$target_file"
        # 删除过滤后的临时文件
        rm "$filtered_source"
    done
done

# 删除临时文件
rm /tmp/source_content.yaml

echo "合并完成！"

