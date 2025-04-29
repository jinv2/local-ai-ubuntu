#!/bin/bash

# --- 配置 ---
# YAI_RULES_FILE="$HOME/.config/yai/custom_rules.yaml"
YAI_COMMAND="yai" # 假设 yai 在 PATH 中
SCAN_SCRIPT="$HOME/.config/scripts/scan_desktop_files.sh" # 桌面文件扫描脚本路径
ROFI_OPTIONS=(-dmenu -p "请输入自然语言指令/文件名" -i) # Rofi 参数，-i 表示不区分大小写
# 如果需要加载 Rofi 主题，可以添加 -theme "$HOME/.config/rofi/config.rasi"

# --- 主逻辑 ---

# (可选) 动态生成桌面文件列表用于提示
# input_options=""
# if [ -f "$SCAN_SCRIPT" ]; then
#     input_options=$(bash "$SCAN_SCRIPT")
# fi

# 弹出 rofi 输入框，获取用户输入
# input=$(echo -e "$input_options" | rofi "${ROFI_OPTIONS[@]}")
input=$(rofi "${ROFI_OPTIONS[@]}" < /dev/null) # 从标准输入读取，避免显示空列表

# 如果用户取消 (输入为空)，则退出
if [ -z "$input" ]; then
    echo "用户取消输入。"
    exit 0
fi

# (可选) 智能处理：如果输入看起来像桌面上的文件名，优先尝试打开
# file_path_on_desktop=$(find "$HOME/桌面" -maxdepth 1 -type f -iname "*$input*" | head -n 1)
# if [ -n "$file_path_on_desktop" ]; then
#     echo "检测到可能是桌面文件，尝试打开: $file_path_on_desktop"
#     xdg-open "$file_path_on_desktop" &
#     exit 0
# fi

# 将用户输入传递给 yai 处理
echo "正在将指令传递给 yai: '$input'"
# 使用 expect 或者直接管道传递，确保 yai 能正确接收
# echo "$input" | $YAI_COMMAND --rules "$YAI_RULES_FILE" # 假设 yai 支持从 stdin 读取
# 或者，如果 yai 需要参数
$YAI_COMMAND "$input" # 假设 yai 直接接收参数，并已配置好读取规则文件

# 检查 yai 命令的退出状态 (可选)
# yai_exit_code=$?
# if [ $yai_exit_code -ne 0 ]; then
#     echo "命令执行可能出错 (Yai 退出码: $yai_exit_code)"
#     # 可以用 rofi 显示错误信息
#     # rofi -e "命令执行出错: $input"
# fi

exit 0
