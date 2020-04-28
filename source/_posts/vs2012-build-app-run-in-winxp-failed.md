title: 解决VS2012编译的程序在WinXP上运行异常
tags:
  - Optional Header
  - Subsystem
  - VS2012
id: 391
categories:
  - programing
date: 2013-05-29 02:50:35
---
在写代码的过程中,我发现使用VS2012编译出来的程序默认支持的系统版本略高

刚发现在 Win7+VS2012 编译出来的程序默认PE信息(Optional Header):
* Major SubSystem Version = 6
* Minor SubSystem Version = 0

导致的结果就是：在WinXP中运行便会提示 **不是有效的Win32应用程序**

当时还以为是自己搞错编译选项，将程序编译成x64的了。
结果后来使用PE工具才发现的这个问题。

## 解决方案

右击项目 -> 属性 -> 配置属性 -> 链接器 -> 系统 -> 所需最低版本 填入"**5.01**"

## 参考内容
**http://msdn.microsoft.com/en-us/library/fcc1zstk(v=vs.110).aspx**

| Subsystem | Minimum | Default |
| --------- | ------- | ------- |
| BOOT_APPLICATION | 1.0 | 1.0 |
| CONSOLE | 5.01 (x86) 5.02 (x64) 6.02 (ARM) | 6.00 (x86, x64) 6.02 (ARM) |
| WINDOWS | 5.01 (x86) 5.02 (x64) 6.02 (ARM) | 6.00 (x86, x64) 6.02 (ARM) |
| NATIVE (with DRIVER:WDM) | 1.00 (x86) 1.10 (x64, ARM) | 1.00 (x86) 1.10 (x64, ARM) |
| NATIVE (without /DRIVER:WDM) | 4.00 (x86) 5.02 (x64) 6.02 (ARM) | 4.00 (x86) 5.02 (x64) 6.02 (ARM) |
| POSIX | 1.0 | 19.90 |
| EFI_APPLICATION, EFI_BOOT_SERVICE_DRIVER, EFI_ROM, EFI_RUNTIME_DRIVER | 1.0 | 1.0 |
