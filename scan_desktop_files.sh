#!/bin/bash
# 扫描桌面所有文件，列出基本名称（不含扩展名）
find "$HOME/桌面" -maxdepth 1 -type f -printf "%f\n" | sed 's/\.[^.]*$//' | sort -u
