#!/bin/bash
set -e

# 1. 确保目标目录在 PATH 里 (通常你已经做过了)
TARGET_DIR="$HOME/.local/bin"
mkdir -p "$TARGET_DIR"

echo "🔗 正在创建直连软链接..."

# 2.
# mise bin-paths 会输出类似：
# /home/user/.local/share/mise/installs/node/20.0.0/bin
# /home/user/.local/share/mise/installs/ripgrep/14.1.0/bin
PATHS=$(mise bin-paths)

# 3. 遍历这些目录，把里面的东西链接出来
for bin_dir in $PATHS; do
    # 遍历 bin 目录下的所有可执行文件
    for tool_path in "$bin_dir"/*; do
        tool_name=$(basename "$tool_path")
        # 排除掉 mise 自己的垫片或者无关文件
        if [[ -x "$tool_path" && -f "$tool_path" ]]; then
            # 强制创建软链接 (-f 覆盖旧的)
            ln -sf "$tool_path" "$TARGET_DIR/$tool_name"
            echo "  Checking: $tool_name -> $tool_path"
        fi
    done
done

echo "✅ 所有工具已'直连'到 $TARGET_DIR，Mise 不再拦截运行！"
