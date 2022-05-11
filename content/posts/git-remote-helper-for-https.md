---
title: "Windows里Git出现fatal: Unable to find remote helper for 'https'的解决方案"
tags:
  - git
  - https
  - remote
  - windows
id: 830
categories:
  - summarys
date: 2014-12-25T16:10:02+08:00
---

在升级win8.1之后，重新安装的Git虽然可以正常使用
但遇到https时会报“**Unable to find remote helper for 'https'**”的错误

网络搜索了许久未果，于是自己研究

> 1.  检查安装的文件
>   结果：所有文件均完整</p>
> 2.  检查文件的访问权限
>   结果：所有文件当前用户均可访问
> 
> 3.  为调用的git等exe文件授予管理员运行权限
>   结果：问题依旧存在

<p>按理说，只要当前用户拥有文件的所有访问权限，就可以正常使用了。
并且，按这个错误来分析。应该是remote-https模块没有权限访问

挣扎了半天，尝试重装解决。

在重装的时候选择了 **管理员权限运行**
结果意外的发现重装后，https可以正常使用了。

至此问题解决。