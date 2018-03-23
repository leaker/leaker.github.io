title: 如何用正确的 C 运行时 (CRT) 库链接
id: 511
categories:
  - programing
date: 2013-10-03 04:13:52
tags:
---

# 概要

有六种类型的可重用的库：

> 静态单线程库 （调试/发行版）
>   静态多线程的库 （调试/发行版）
>   动态链接库 (DLL)(Debug/Release)
>   注意每个库都有一个调试版本和发布版本。

    Reusable Library            Switch    Library    Macro(s) Defined
    ----------------------------------------------------------------
    Single Threaded             /ML       LIBC       (none)
    Static MultiThread          /MT       LIBCMT     _MT
    Dynamic Link (DLL)          /MD       MSVCRT     _MT and _DLL
    Debug Single Threaded       /MLd      LIBCD      _DEBUG
    Debug Static MultiThread    /MTd      LIBCMTD    _DEBUG and _MT
    Debug Dynamic Link (DLL)    /MDd      MSVCRTD    _DEBUG, _MT, and _DLL
    

    ## 下面的代码可以使用可重用库的头文件中以确保一致使用正确的编译器开关：

    // MyReusableStaticSingleThreadReleaseLibrary.h
    #if defined(_MT) || defined(_DEBUG)
        #error The /ML compiler switch is required.
    #endif

    // MyReusableStaticMultithreadReleaseLibrary.h
    #if !defined(_MT) || defined(_DLL) || defined(_DEBUG)
        #error The /MT compiler switch is required.
    #endif

    // MyReusableDynamicLinkReleaseLibrary.h
    #if !defined(_MT) || !defined(_DLL) || defined(_DEBUG)
        #error The /MD compiler switch is required.
    #endif

    // MyReusableStaticSingleThreadDebugLibrary.h
    #if defined(_MT) || !defined(_DEBUG)
        #error The /MLd compiler switch is required.
    #endif

    // MyReusableStaticMultithreadDebugLibrary.h
    #if !defined(_MT) || defined(_DLL) || !defined(_DEBUG)
        #error The /MTd compiler switch is required.
    #endif

    // MyReusableDynamicLinkDebugLibrary.h
    #if !defined(_MT) || !defined(_DLL) || !defined(_DEBUG)
        #error The /MDd compiler switch is required.
    #endif

原文：[http://support.microsoft.com/kb/140584/zh-cn](http://support.microsoft.com/kb/140584/zh-cn)