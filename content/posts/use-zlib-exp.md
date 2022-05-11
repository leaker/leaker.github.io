---
title: 一句话经验zlib
tags:
  - gcc
  - linux
  - zlib
id: 439
categories:
  - programing
date: 2013-06-29T04:27:00+08:00
---
Linux使用gcc编译使用zlib库的代码时，使用 **-lz** 来链接(link) **zlib** 库。

否则就会出现类似 **undefined reference to `deflateInit_'** 的错误
