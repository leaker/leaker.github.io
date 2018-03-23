title: 网易的Ubuntu更新源
tags:
  - sudo
  - ubuntu
id: 42
categories:
  - linux
date: 2012-03-19 13:13:20
---

<center>![](/wp-content/uploads/2012/03/ubuntu_splash.jpg)</center>

# 步骤

1. sudo gedit /etc/apt/sources.list
   编辑你的源列表，将原来的内容全部删除并复制下面列表到文件中，然后保存列表。
2. sudo apt-get update

等第2步完成之后你就可以打开更新管理器更新了
顺便一提 网易的更新速度真的很快，我这里下载600K/s

以下是更新列表内容：

    deb http://mirrors.163.com/ubuntu/ precise main restricted
    deb-src http://mirrors.163.com/ubuntu/ precise main restricted
    deb http://mirrors.163.com/ubuntu/ precise-updates main restricted
    deb-src http://mirrors.163.com/ubuntu/ precise-updates main restricted
    deb http://mirrors.163.com/ubuntu/ precise universe
    deb-src http://mirrors.163.com/ubuntu/ precise universe
    deb http://mirrors.163.com/ubuntu/ precise-updates universe
    deb-src http://mirrors.163.com/ubuntu/ precise-updates universe
    deb http://mirrors.163.com/ubuntu/ precise multiverse
    deb-src http://mirrors.163.com/ubuntu/ precise multiverse
    deb http://mirrors.163.com/ubuntu/ precise-updates multiverse
    deb-src http://mirrors.163.com/ubuntu/ precise-updates multiverse
    deb http://mirrors.163.com/ubuntu/ precise-backports main restricted universe multiverse
    deb-src http://mirrors.163.com/ubuntu/ precise-backports main restricted universe multiverse
    deb http://mirrors.163.com/ubuntu/ precise-security main restricted
    deb-src http://mirrors.163.com/ubuntu/ precise-security main restricted
    deb http://mirrors.163.com/ubuntu/ precise-security universe
    deb-src http://mirrors.163.com/ubuntu/ precise-security universe
    deb http://mirrors.163.com/ubuntu/ precise-security multiverse
    deb-src http://mirrors.163.com/ubuntu/ precise-security multiverse
    deb http://extras.ubuntu.com/ubuntu precise main
    deb-src http://extras.ubuntu.com/ubuntu precise main

你也可以在我这里下载自动修改脚本：[点我下载](/wp-content/uploads/2012/03/163source.7z)
