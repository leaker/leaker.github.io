---
title: '解决编译时出现“gnu/stubs-64.h: No such file or directory”的问题'
tags:
  - centos
  - glibc
  - gnu
  - libc
  - make
  - stubs
  - ubuntu
id: 464
categories:
  - linux
date: 2013-07-10T10:12:49+08:00
---

# 这个实际上是系统没有安装 **glibc** 开发包的问题

## Ubuntu x64
  ```bash
  apt-get install libc6-dev-amd64
  ```

## CentOS x64
  ```bash
  yum install glibc-devel.x86_64
  ```

