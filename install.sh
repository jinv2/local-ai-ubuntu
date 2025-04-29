#!/bin/bash

echo "🚀 开始安装本地 AI 命令助手..."

# 确保脚本在用户目录下运行（如果需要相对路径）
# cd "$(dirname "$0")"

# --- 1. 安装依赖 ---
echo "📦 正在安装依赖包 (需要 sudo 权限)..."
sudo apt update
sudo apt install -y git golang rofi sxhkd fzf unzip xdg-utils zip nano || { echo "❌ 依赖安装失败，请检查网络或 apt 源。"; exit 1; }
# 注意: fzf 和 zip 是可选的，根据你的 custom_rules.yaml 决定是否需要

# --- 2. 安装 yai ---
echo "🛠️ 正在安装 yai..."
if [ -d "$HOME/.yai_src" ]; then
    echo "   检测到旧的 yai 源码目录，将先删除..."
    rm -rf "$HOME/.yai_src"
fi
git clone https://github.com/ekkinox/yai.git "$HOME/.yai_src" || { echo "❌ 克隆 yai 仓库失败。"; exit 1; }
cd "$HOME/.yai_src" || { echo "❌ 进入 yai 源码目录失败。"; exit 1; }
go build -o yai || { echo "❌ 编译 yai 失败，请确保 Go 环境配置正确。"; exit 1; }
sudo mv yai /usr/local/bin/ || { echo "❌ 移动 yai 到 /usr/local/bin 失败 (需要 sudo 权限)。"; exit 1; }
cd "$HOME" # 返回主目录
# 清理源码（可选）
# rm -rf "$HOME/.yai_src"

# --- 3. 创建配置目录 ---
echo "📁 正在创建配置目录..."
mkdir -p "$HOME/.config/yai"
mkdir -p "$HOME/.config/sxhkd"
mkdir -p "$HOME/.config/rofi"
mkdir -p "$HOME/.local/share/applications"
mkdir -p "$HOME/桌面" # 确保桌面目录存在

# --- 4. 复制配置文件 ---
echo "📝 正在复制配置文件..."
# 获取脚本所在目录（假设 config 文件在此目录下）
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# 复制 yai 配置
cp "$SCRIPT_DIR/config/yai/config.yaml" "$HOME/.config/yai/" || echo "   ⚠️ 未找到 config/yai/config.yaml"
cp "$SCRIPT_DIR/config/yai/custom_rules.yaml" "$HOME/.config/yai/" || { echo "❌ 无法复制 custom_rules.yaml"; exit 1; }

# 复制 sxhkd 配置
cp "$SCRIPT_DIR/config/sxhkd/sxhkdrc" "$HOME/.config/sxhkd/" || { echo "❌ 无法复制 sxhkdrc"; exit 1; }

# 复制 rofi 配置 (可选)
if [ -f "$SCRIPT_DIR/config/rofi/config.rasi" ]; then
    cp "$SCRIPT_DIR/config/rofi/config.rasi" "$HOME/.config/rofi/" || echo "   ⚠️ 无法复制 config.rasi"
fi

# 复制辅助脚本
mkdir -p "$HOME/.config/scripts" # 将脚本放在单独目录更清晰
cp "$SCRIPT_DIR/config/scripts/rofi_yai_advanced.sh" "$HOME/.config/scripts/" || { echo "❌ 无法复制 rofi_yai_advanced.sh"; exit 1; }
if [ -f "$SCRIPT_DIR/config/scripts/scan_desktop_files.sh" ]; then
    cp "$SCRIPT_DIR/config/scripts/scan_desktop_files.sh" "$HOME/.config/scripts/" || echo "   ⚠️ 无法复制 scan_desktop_files.sh"
fi

# --- 5. 设置脚本执行权限 ---
echo "🔒 正在设置脚本执行权限..."
chmod +x "$HOME/.config/scripts/rofi_yai_advanced.sh" || { echo "❌ 设置 rofi_yai_advanced.sh 权限失败。"; exit 1; }
if [ -f "$HOME/.config/scripts/scan_desktop_files.sh" ]; then
    chmod +x "$HOME/.config/scripts/scan_desktop_files.sh" || echo "   ⚠️ 设置 scan_desktop_files.sh 权限失败。"
fi

# --- 6. 创建桌面启动器 ---
echo "🖥️ 正在创建桌面启动器..."
DESKTOP_FILE_TEMPLATE="$SCRIPT_DIR/assets/natural-language-terminal.desktop"
DESKTOP_FILE_DEST_APP="$HOME/.local/share/applications/natural-language-terminal.desktop"
DESKTOP_FILE_DEST_DESKTOP="$HOME/桌面/自然语言终端.desktop"

if [ -f "$DESKTOP_FILE_TEMPLATE" ]; then
    # 替换占位符并复制到应用程序目录
    sed "s|%EXEC_PATH%|$HOME/.config/scripts/rofi_yai_advanced.sh|g" "$DESKTOP_FILE_TEMPLATE" > "$DESKTOP_FILE_DEST_APP"
    chmod +x "$DESKTOP_FILE_DEST_APP" || echo "   ⚠️ 设置应用程序启动器权限失败。"
    # 在桌面创建符号链接（可选）
    ln -sf "$DESKTOP_FILE_DEST_APP" "$DESKTOP_FILE_DEST_DESKTOP" || echo "   ⚠️ 创建桌面快捷方式失败。"
    echo "   桌面启动器已创建。"
else
    echo "   ⚠️ 未找到桌面启动器模板 assets/natural-language-terminal.desktop。"
fi

# --- 7. 提示完成和后续步骤 ---
echo ""
echo "✅ 安装成功完成！"
echo ""
echo "👉 如何使用："
echo "   1. 按下快捷键 'Ctrl + 空格' (默认) 弹出输入框。"
echo "   2. 或者，在桌面找到 '自然语言终端' 图标并双击。"
echo "   3. 输入中文指令 (如 '打开浏览器') 并按回车。"
echo ""
echo "❗ 重要后续步骤："
echo "   1. 启动快捷键服务: 请打开一个终端，运行 'sxhkd &'。"
echo "   2. 设置开机自启: 为了让快捷键能在每次开机后自动生效，请务必将 'sxhkd' 添加到您 Ubuntu 的 '启动应用程序' 设置中。"
echo "   3. 自定义: 编辑 '~/.config/yai/custom_rules.yaml' 添加更多你自己的指令！"
echo ""
echo "🎉 尽情享受你的本地 AI 命令助手吧！"

exit 0
