---
title: Win10里添加目录右键菜单 VS2013 Command Prompt Here
date: 2015-09-16T04:08:21+08:00
tags:
  - VS2013
  - Windows10
categories:
  - summarys
---
# 需求
我有时需要在命令行里对某个VS项目目录进行编译或部署等操作，总是需要以下步骤：
1. 打开VS的Command Prompt
2. 进入该项目目录
3. 进行编译操作

个人觉得这样太浪费时间，于是萌生了添加类似 **Command Here** 右键菜单的想法。
办法很简单，在注册表添加相关项就可以了

# 解决方案
## Windows7 添加方法
将以下内容修改到自己对应VS目录后以文本形式保存到 VS2013-Command-Prompt-Here-win7.reg 文件，然后双击导入即可
```ini
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Folder\shell\VS2013 Command Prompt Here]

[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Folder\shell\VS2013 Command Prompt Here\command]
@="cmd.exe /s /k pushd \"%1\" & \"C:\\Program Files (x86)\\Microsoft Visual Studio 12.0\\VC\\vcvarsall.bat\" x86"
```

## Windows10 添加方法
将以下内容修改到自己对应VS目录后以文本形式保存到 VS2013-Command-Prompt-Here-win10.reg 文件，然后双击导入即可
```ini
Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\Directory\Background\shell\VS2013 Command Prompt Here]

[HKEY_CLASSES_ROOT\Directory\Background\shell\VS2013 Command Prompt Here\command]
@="cmd.exe /s /k pushd \"%V\" & \"C:\\Program Files (x86)\\Microsoft Visual Studio 12.0\\VC\\vcvarsall.bat\" x86"
```

# 为什么区分Windows版本
因为对于Windows来说传参的方式有所改变
**pushd %1** 是用于Windows7的
**pushd %V** 是用于Windows10的

# 下载
for Windows7: [VS2013-Command-Prompt-Here-win7.reg](/files/regfiles/VS2013-Command-Prompt-Here-win7.reg)
for Windows10: [VS2013-Command-Prompt-Here-win10.reg](/files/regfiles/VS2013-Command-Prompt-Here-win10.reg)
