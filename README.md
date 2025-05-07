# 本地 AI 命令助手 for Ubuntu (Local AI Command Assistant for Ubuntu)

这是一个基于 `yai`, `rofi`, `sxhkd` 等工具搭建的本地自然语言命令助手，允许你在 Ubuntu 终端或通过快捷键，使用中文自然语言执行预定义的 Shell 命令。本项目旨在提供 AI 般的便捷操作，同时完全避免 API 成本和大型 AI 模型的资源负担。

本项目配置主要基于与 AI (如 ChatGPT) 的交互指导完成。

## ✨ 功能特性

*   **自然语言输入:** 使用简单的中文短语（如“打开浏览器”，“在桌面新建文档”）执行命令。
*   **本地运行:** 所有处理都在本地完成，无需联网，无需 API 密钥。
*   **轻量高效:** 不依赖大型 AI 模型，资源占用低，响应速度快。
*   **快捷键激活:** 通过可配置的快捷键（默认为 `Ctrl + 空格`）快速弹出输入框。
*   **桌面图标:** 提供桌面启动器，方便点击启动。
*   **高度可定制:** 可以轻松添加、修改或删除自定义的自然语言指令和对应的 Shell 命令。
*   **离线工作:** 无需互联网连接即可使用核心功能。

## 🔧 依赖项

在运行安装脚本之前，请确保你的 Ubuntu 系统（推荐 Ubuntu 22.04 LTS 或更高版本）已安装以下基础工具：

*   `git`: 用于克隆 `yai` 仓库。
*   `golang`: 用于编译 `yai`。
*   `rofi`: 用于弹出式输入框。
*   `sxhkd`: 用于全局快捷键监听。
*   `unzip`: 用于处理解压缩命令（如果规则中包含）。
*   `xdg-utils`: 用于 `xdg-open` 打开文件等。
*   `fzf` (可选，但某些 rofi 配置或脚本可能需要)。
*   `zip` (可选，如果需要压缩功能)。
*   `nano` 或其他文本编辑器：用于编辑配置文件。

安装脚本会自动尝试安装这些依赖。

## 🚀 安装

1.  **克隆本仓库:**
    ```bash
    git clone https://github.com/jinv2/local-ai-ubuntu.git # 如果您的仓库名不同，请修改
    cd local-ai-ubuntu # 如果您的仓库名不同，请修改
    ```

2.  **运行一键安装脚本:**
    ```bash
    chmod +x install.sh
    ./install.sh
    ```

安装脚本将完成以下工作：
*   安装必要的依赖包。
*   克隆并编译 `yai`。
*   创建必要的配置目录 (`~/.config/yai`, `~/.config/sxhkd`, `~/.config/rofi`, `~/.local/share/applications`)。
*   复制本仓库中的配置文件 (`custom_rules.yaml`, `config.yaml`, `sxhkdrc`, `rofi_yai_advanced.sh` 等) 到用户配置目录下。
*   设置脚本的执行权限。
*   创建桌面启动器图标。

## ⌨️ 如何使用

1.  **通过快捷键 (推荐):**
    *   首次安装后，你可能需要手动启动 `sxhkd`。打开一个终端，输入 `sxhkd &` 并按回车。
    *   为了让快捷键开机自启，请将 `sxhkd` 添加到你的 Ubuntu “启动应用程序”中。具体方法取决于你的桌面环境（GNOME, KDE 等），通常在系统设置里可以找到。
    *   按下 `Ctrl + 空格` (默认快捷键，可在 `~/.config/sxhkd/sxhkdrc` 修改)。
    *   会弹出一个输入框 (`rofi`)。
    *   输入你的中文自然语言指令 (例如: `打开浏览器`)，然后按回车。
    *   系统将执行对应的命令。

2.  **通过桌面图标:**
    *   在你的桌面（或应用程序菜单）找到名为 “自然语言终端” (或类似名称) 的图标。
    *   双击它，同样会弹出 `rofi` 输入框。
    *   输入指令并按回车执行。

## ⚙️ 自定义

*   **添加/修改命令:**
    *   编辑 `~/.config/yai/custom_rules.yaml` 文件。
    *   遵循 YAML 格式，添加或修改 `pattern` (自然语言短语) 和 `command` (对应的 Shell 命令)。
    *   保存文件即可生效，无需重启。
    *   **示例:**
        ```yaml
        rules:
          - pattern: "更新系统"
            command: "sudo apt update && sudo apt upgrade -y"
          - pattern: "清理系统垃圾"
            command: "sudo apt autoremove -y && sudo apt clean"
          # ... 其他规则
        ```

*   **修改快捷键:**
    *   编辑 `~/.config/sxhkd/sxhkdrc` 文件。
    *   修改 `ctrl + space` 为你想要的快捷键组合。
    *   修改后需要重启 `sxhkd` (可以先 `pkill sxhkd` 再 `sxhkd &`)。

*   **修改 Rofi 外观:**
    *   编辑 `~/.config/rofi/config.rasi` 文件 (如果存在并被 `rofi_yai_advanced.sh` 使用)。
    *   调整字体、颜色、布局等 Rofi 主题设置。

## ❓ 故障排除

*   **快捷键无效:**
    *   确保 `sxhkd` 正在运行 (可以使用 `pgrep sxhkd` 查看)。如果没有运行，请手动启动 `sxhkd &`。
    *   确保 `sxhkd` 已添加到启动应用程序。
    *   检查 `~/.config/sxhkd/sxhkdrc` 文件中的快捷键定义是否正确，并且没有被其他程序占用。
*   **命令未执行或报错:**
    *   检查 `~/.config/yai/custom_rules.yaml` 中对应的 `command` 是否书写正确，并且在普通终端中可以正常执行。
    *   检查 `~/.config/yai/rofi_yai_advanced.sh` 脚本是否有执行权限 (`chmod +x ~/.config/yai/rofi_yai_advanced.sh`)。
    *   检查脚本内部调用的命令（如 `yai`, `oathtool` 等）是否已正确安装并在 `PATH` 中。
*   **Rofi 窗口样式问题:**
    *   检查 `~/.config/rofi/config.rasi` 文件配置是否正确。
    *   检查 `rofi_yai_advanced.sh` 脚本中调用 `rofi` 的参数。

---
## 💖 支持本项目 (Support This Project)

如果您觉得这个 **本地AI命令助手** 项目对您有帮助，并希望支持我继续开发和维护这类开源工具，欢迎通过以下方式表达您的支持：

*   **通过 PayPal.Me 快速捐款给 天算AI：**
    [https://paypal.me/jinv2](https://paypal.me/jinv2)

    [![PayPal.Me Donate Button](https://img.shields.io/badge/PayPal-Donate-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/jinv2)

您的支持是我持续创作和分享的巨大动力！

---

## 🤝 贡献 (Contributing)

欢迎提交 Issue 或 Pull Request 来改进本项目！

## 📄 许可证 (License)

(可选) 可以选择一个开源许可证，例如 MIT License。
