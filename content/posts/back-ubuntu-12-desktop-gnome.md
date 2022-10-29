---
title: 让ubuntu 12 desktop版本回归Gnome桌面
tags:
  - desktop
  - gnome
  - ubuntu
  - unity
id: 355
categories:
  - linux
date: 2013-03-17T18:55:21+08:00
---
由于ubuntu 12.04默认采用了Unity界面，对于我这种菜鸟来说用起来很是不顺手，所以搜了一下，发现有办法回归gnome界面。

# 安装
在此记录下供自己以及还不了解这个解决办法的人使用。
1. 命令行的解决办法：
```bash
sudo apt-get install gnome-session-fallback
```
2. 去软件中心搜索“gnome-panel”并安装之

# 设置
下面就是设置了，登出当前用户后进行以下步骤：
1. 在登录用户界面选用户名右边的配置按钮

![gnome设置第一步](/wp-content/uploads/2013/03/login1.webp)

2. 选择“GNOME Classic”

![gnome设置第二步](/wp-content/uploads/2013/03/login2.webp)

现在，输入密码登录看看，是不是已经是熟悉的gnome界面了呢。至此，打完收工。
(o≖◡≖)
