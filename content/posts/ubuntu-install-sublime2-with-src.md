---
title: '[摘抄笔记]sublime2在Ubuntu下命令安装以及官网压缩包安装'
tags:
  - kde
  - linux
  - sublime
  - ubuntu
id: 498
categories:
  - linux
date: 2013-09-22T07:57:24+08:00
---

# 通过终端（terminal）命令安装
```bash
sudo add-apt-repository ppa:webupd8team/sublime-text-2
sudo apt-get update
sudo apt-get install sublime-text
```

# 通过解压官网安装包安装

1.  将下载的tar.bz2文件解压
  ```bash
  tar xf Sublime Text 2.0.1 x64.tar.bz2
  ```

2.  将解压后的文件夹移动到应用程序文件夹
  ```bash
  sudo mv Sublime Text 2 /opt/
  ```

3.  设置terminal快速启动命令
  ```bash
  sudo ln -s /opt/Sublime Text 2/sublime_text /usr/bin/sublime
  ```

4.  在桌面创建快捷方式
  ```bash
  sudo sublime /usr/share/applications/sublime.desktop
  ```

5.  将下面的代码保存进去
  ```ini
  [Desktop Entry]
  Version=1.0
  Name=Sublime Text 2
  # Only KDE 4 seems to use GenericName, so we reuse the KDE strings.
  # From Ubuntu's language-pack-kde-XX-base packages, version 9.04-20090413.
  GenericName=Text Editor
  Exec=sublime
  Terminal=false
  Icon=/opt/Sublime Text 2/Icon/48x48/sublime_text.webp
  Type=Application
  Categories=TextEditor;IDE;Development
  X-Ayatana-Desktop-Shortcuts=NewWindow
  
  [NewWindow Shortcut Group]
  Name=New Window
  Exec=sublime -n
  TargetEnvironment=Unity
  ```

貌似安装sublime3的时候会自动创建快速启动命令，所以如果安装的是3就不用再手动设置了

摘抄自原文：[http://my.oschina.net/rc6688/blog/162043#OSC_h2_4](http://my.oschina.net/rc6688/blog/162043#OSC_h2_4)
