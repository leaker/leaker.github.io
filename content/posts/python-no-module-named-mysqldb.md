---
categories:
- linux
date: 2013-04-05 14:13:00+08:00
id: 373
tags: []
title: Python执行出现“No module named MySQLdb”解决方案
---

![mysqldb](/wp-content/uploads/2013/04/mysqldb_error.webp#center)

如果在python程序执行时遇到这个错误提示“**No module named MySQLdb**”

# 这个说明缺少对应的库，解决办法是：

## mix os (easy_install)
```bash
easy_install mysql-python (mix os)
```

## mix os (pip)
```bash
pip install mysql-python (mix os)
```

## Ubuntu
```bash
apt-get install python-mysqldb (Linux Ubuntu, ...)
```

## FreeBSD
```bash
cd /usr/ports/databases/py-MySQLdb && make install clean (FreeBSD)
```

## Fedora, CentOS
```bash
yum install MySQL-python (Linux Fedora, CentOS ...)
```
**对应后面括号内系统执行相应的命令就可以进行安装**
