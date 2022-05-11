---
title: 解决编译freeradius出现 cannot find -lperl 的问题
tags:
  - freeradius
  - libperl-dev
  - radius
  - ubuntu
id: 116
categories:
  - linux
date: 2012-03-27T04:30:09+08:00
---

![lperl](/wp-content/uploads/2012/03/lperl.webp#center)

今天因为项目需要，需要编译freeradius来使用。

# 错误原因
结果在编译过程中出现如上错误 `cannot find -lperl`。

# 解决方案
## CentOS
```bash
sudo yum -y install libtool-perl*
```

## Ubuntu
```bash
sudo apt-get install libperl-dev
```

做个笔记，希望能够帮到遇到这个问题的人。
(o≖◡≖)
