---
title: MacOS 图标生成
date: 2025-11-01T22:46:10+08:00
categories:
  - tools
tags:
  - macos
  - shell
  - icns
---

将 PNG 图片转换为优化的 MacOS .icns 图标文件的 Shell 脚本，使用 sips + pngquant 两级压缩，自动调整尺寸至 512x512，支持透明背景。

# 功能

- 自动调整图片尺寸为 512x512
- sips + pngquant 两级压缩优化
- 完整的依赖检查和错误处理
- 显示压缩前后文件大小对比

# 依赖安装

```bash
# 仅需安装 pngquant
brew install pngquant
```

注：sips 和 iconutil 均为 MacOS 系统自带工具，无需额外安装

# 使用方法

下载脚本：[generate-macos-icon.sh](/files/tools/generate-macos-icon.sh)

```bash
# 添加执行权限
chmod +x generate-macos-icon.sh

# 基本用法（输出同名 .icns 文件）
./generate-macos-icon.sh my_icon.png

# 指定输出文件名
./generate-macos-icon.sh my_icon.png custom_name.icns

# 批量转换
for file in *.png; do
    ./generate-macos-icon.sh "$file"
done
```
