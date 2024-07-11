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
    #content=$(printf "\n%s\n" "$content")

    # 遍历目标目录下的所有 YAML 文件
    for target_file in "$target_dir"/*.yaml; do
        # 检查rules:下面的几行前是否有两个空格
        has_two_spaces=$(awk '/^rules:/ {found=1; next} found {if ($0 ~ /^  /) {print "yes"; exit} else {print "no"; exit}}' "$target_file")

        # 插入内容到rules:下的第一行 
        #sed -i '/^rules:/a\'"$content" "$target_file"
        #sed -i "/^rules:/a\\${content}" "$target_file"
        #sed -i -e '/^rules:/a\'$'\n'"$content"$'\n' "$target_file"
        # 根据检测结果插入内容
        if [ "$has_two_spaces" == "yes" ]; then
          # 插入带两个空格的内容
          sed -i "/^rules:/a\\
  $content" "$target_file"
        else
          # 插入不带空格的内容
          sed -i "/^rules:/a\\
$content" "$target_file"
        fi
    done
done

echo "合并完成！"

