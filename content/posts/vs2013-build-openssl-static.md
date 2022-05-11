---
title: VS2013静态编译openssl批处理
date: 2015-09-14T12:26:46+08:00
tags:
  - nasm
  - openssl
  - A2070
  - nmake
  - perl
categories:
  - programing
---
# 打开 Visual Studio 2013 Command Prompt

```shell
wget http://www.nasm.us/pub/nasm/releasebuilds/2.11.08/win32/nasm-2.11.08-win32.zip
unzip nasm-2.11.08-win32.zip -d C:/nasm
set PATH=%PATH%;C:/nasm/
wget https://www.openssl.org/source/openssl-1.0.2d.tar.gz
tar xzf openssl-1.0.2d.tar.gz
cd openssl-1.0.2d
perl configure VC-WIN32 --prefix=C:/openssl
ms\do_nasm
nmake -f ms\nt.mak
nmake -f ms\nt.mak install
echo "build successed."
```

这样编译不会产生 **error A2070:invalid instruction operands** 这个错误