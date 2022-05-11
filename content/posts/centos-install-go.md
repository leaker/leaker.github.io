---
title: CentOS安装GO编译环境
tags:
  - bash
  - centos
  - export
  - go
id: 648
categories:
  - linux
date: 2014-11-01T08:42:17+08:00
---

我们这里使用源码编译安装，直接按顺序执行下列命令就可以成功(我都是假设已经有root权限的情况下，所以执行之前请确认自己已有root权限)：

```shell
yum install -y mercurial gcc-c++ gcc
mkdir /usr/local
cd /usr/local
hg clone -r release https://go.googlecode.com/hg/ go
cd /usr/local/go/src
chmox +x all.bash
./all.bash
mkdir /root/go
export GOROOT=/usr/local/go
export GOPATH=/root/go
export GOBIN=/usr/local/go/bin
export GOOS=linux
export PATH=.:$PATH:/usr/local/go/bin
```

现在应该已经可以执行go命令测试了：
```shell
[root@root]# go version
go version go1.3.3 linux/amd64
```

如果想要每次进入bash时都拥有go环境，则需要新建一个文件：**/etc/profile.d/go.sh** 并写入以下内容
```bash
export GOROOT=/usr/local/go
export GOPATH=/root/go
export GOBIN=/usr/local/go/bin
export GOOS=linux
export PATH=.:$PATH:/usr/local/go/bin
```

现在随时都可以执行go命令了。

:)