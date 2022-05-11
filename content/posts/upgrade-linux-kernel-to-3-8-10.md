---
title: 升级Linux内核3.8.10记录
id: 597
categories:
  - linux
date: 2014-04-08T00:10:19+08:00
tags:
  - upgrade
  - kernel
  - make
  - mrproper
  - menuconfig
  - install
---
```bash
yum install rpmdevtools yum-utils ncurses-devel make rpm-build rpm-devel
wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.8.10.tar.gz
tar xvf linux-3.8.10.tar.gz
cd linux-3.8.10
make mrproper # 第一次可忽略
make menuconfig # 记得保存
make
make modules_install
make install
new-kernel-pkg --mkinitrd --depmod --install 3.8.10
```
