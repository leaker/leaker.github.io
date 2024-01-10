---
title: Windows 系统内禁止某些应用以管理员程序运行(RunAsInvoker)
date: 2024-01-10T22:26:31+08:00
categories:
  - programing
tags:
  - windows
  - bat
  - runasinvoker
---

在 Windows 调试一些程序的时候，有可能会遇到程序本身编译为始终以管理员身份运行的。而这些程序在拿到管理员身份的时候会启动一些保护以检测自己是否被调试注入等等。

而我们不希望这些程序以管理员身份启动。

### 如果是直接启动该程序，我们可以使用命令：
```bat
cmd /min /C "set __COMPAT_LAYER=RUNASINVOKER && start "" "(your app path)"
```
替换 **(your app path)** 部分为你们的程序路径


### 如果经常需要使用的话，还可以把该命令集成到 Windows 右键菜单里，通过注册表

*RunWithoutPrivilegeElevation.reg*
```reg
Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\*\shell\Run Without Privilege Elevation]
@="Run Without Privilege Elevation"

[HKEY_CLASSES_ROOT\*\shell\Run Without Privilege Elevation\command]
@="cmd /min /C \"set __COMPAT_LAYER=RUNASINVOKER && start \"\" \"%1\"\""
```
点我下载：[RunWithoutPrivilegeElevation.reg](/files/2024/01/RunWithoutPrivilegeElevation.reg)


但有时该程序是被另外的程序启动的，这时我们就无法执行命令来启动了。
不过不用担心，Windows 还给了我们另外的方案

### 为程序设置 Compatibility Flags

*DisableAppRunAsAdministrator.reg*
```reg
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers]
"(your app path)"="RunAsInvoker"
```
替换 **(your app path)** 部分为你们的程序路径

设置好后，无论是谁启动的该程序，程序都无法以最高的管理员身份运行了。