title: Linux下编译驱动发现没有内核源码的解决办法
tags:
  - install
  - kernel
  - ko
  - linux
  - yum
id: 410
categories:
  - linux
date: 2013-06-02 12:25:27
---

## CentOS系统
```bash
yum install -y kernel-devel
```

## Ubuntu系统
```bash
apt-get install linux-source
```

以上～！

> 参考：《或许你不需要整个内核的源代码》 - [http://wiki.centos.org/zh/HowTos/I_need_the_Kernel_Source](http://wiki.centos.org/zh/HowTos/I_need_the_Kernel_Source)