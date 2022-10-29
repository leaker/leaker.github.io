---
title: Linux下编译驱动代码时smp_lock.h文件找不到的解决方案
tags:
  - c
  - hardirq.h
  - linux
  - smp_lock.h
id: 401
categories:
  - linux
date: 2013-06-01T13:07:20+08:00
---

![kernel](/wp-content/uploads/2013/06/linux_kernel.webp#center)

项目中有个驱动代码之前在老版本linux系统中编写的
在移植到 **linux-kernel-3.2.0** 后，编译时出现一处错误 **fatal error: linux/smp_lock.h: No such file or directory**

# 解决办法
将：
```c
#include <linux/smp_lock.h>
```
替换成：
```c
#include <linux/hardirq.h>
```
