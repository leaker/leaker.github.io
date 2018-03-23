title: 如何安装新版本python，以及解决安装了新版python后，默认python依然调用旧版本的问题
tags:
  - atlinstall
  - configure
  - install
  - ln
  - make
  - python
  - wget
id: 462
categories:
  - linux
date: 2013-07-10 06:27:35
---

# 安装新版本python
```bash
wget http://python.org/ftp/python/2.7.3/Python-2.7.3.tar.bz2
tar xjf Python-2.7.3.tar.bz2
cd Python-2.7.3
./configure
make
make atlinstall
```

这时 python2.7.3 版本已经安装成功了。
但调用 **python --version** 依然会显示并使用旧版本

# 解决办法就是重新建立一个链接并覆盖掉旧的
```bash
ln -s /usr/local/bin/python2.7 /usr/bin/python -f
```

再调用 **python --version** 显示结果
```bash
[root@centos]# python --version
Python 2.7.3
```
至此，问题解决 :)
