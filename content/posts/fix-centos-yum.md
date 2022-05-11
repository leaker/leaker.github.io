---
categories:
- linux
date: 2013-07-26 02:42:41+08:00
id: 468
tags: []
title: 解决CentOS安装新版本python后，yum不能使用的问题
---

# CentOS 上安装新版本 python

请看： [安装python以及解决版本问题](/2013/07/10/fix-python-deff-version.html)

但在安装新版本后，yum不能正常使用了。原因是yum是基于默认的python版本运行的，例如CentOS6.2基于python2.6。但我们安装版本后建立了链接，覆盖掉了默认python调用，导致yum脚本无法正常调用到自己想要的版本。

# 解决方案
```bash
vim /usr/bin/yum
```
将第一行 **#!/usr/bin/python** 修改成 **#!/usr/bin/python2.6**
