---
title: 解决用 Scoop 安装的 PowerShellCore 无法在 VSCode Shell 使用
date: 2021-03-17 20:21:55
tags:
    - pwsh
    - scoop
    - vscode
categories:
    - summarys
---
目前在 Windows 安装软件特别喜欢使用 [Scoop](https://scoop.sh/) 进行管理

使用 **Scoop** 安装 **PowerShell Core** 最新版
```pwsh
scoop install pwsh
```

发现在 **VSCode** 的 **Terminal Shells** 列表里面依然看不到新安装的 **PowerShell Core**
![VSCode Terminal Shells](/images/2021/03/vscode-terminal-shells.png)

但我又不想使用当然默认的 PowerShell 或者 cmd 当我的 Shell
这时就可以这样配置：
1. 在 **VSCode** 里打开 **Command Palette**`(Ctrl+Shift+P)` 选择 **Preferences: Open Settings (JSON)** 打开用户配置文件 **settings.json**
2. 添加如下配置
   ```json settings.json
   {
       "terminal.integrated.shell.windows": "C:/Users/${env:USERNAME}/scoop/apps/pwsh/current/pwsh.exe",
       "terminal.integrated.automationShell.windows": "C:/Users/${env:USERNAME}/scoop/apps/pwsh/current/pwsh.exe"
   }
   ```
   注：如果用户自定义了 **Scoop** 的路径`($env:SCOOP)` 则配置为
   ```json settings.json
   {
       "terminal.integrated.shell.windows": "${env:SCOOP}/apps/pwsh/current/pwsh.exe",
       "terminal.integrated.automationShell.windows": "${env:SCOOP}/apps/pwsh/current/pwsh.exe"
   }
   ```
3. 重新运行 **VSCode**

可以看到我们 **VSCode** 已经使用了 **PowerShell Core** 作为默认 **Terminal Shells** 了
![VSCode Default Terminal Shell](/images/2021/03/vscode-default-pwsh.png)

参考文献：
> [Quick Start · lukesampson/scoop Wiki](https://github.com/lukesampson/scoop/wiki/Quick-Start)