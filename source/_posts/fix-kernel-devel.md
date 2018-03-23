title: 解决在安装了kernel-devel后/lib/modules/$(uname -r)/build 链接失效的问题
tags:
  - build
  - kernel-devel
  - kernels
  - ln
  - modules
  - uname
id: 486
categories:
  - linux
date: 2013-09-07 12:28:20
---

如何安装kernel-devel，可以参考我之前的文章：[《Linux下编译驱动发现没有内核源码的解决办法》](/2013/06/02/install-kernel-devel.html)

下面是我写的一个自动脚本：
```bash
cd /usr/src/kernels
cd $(ls -d */ | head -n 1)
ln -s -f $(pwd) /lib/modules/$(uname -r)/build
```

至于为什么要费劲去 **cd $(ls -d */ | head -n 1)** 的原因是：很多系统装出来的 **kernel-devel** 目录名称跟 **$(uname -r)** 并不一致

至此这个问题修复完成。
