---
title: 解决 Windows 下部署 RabbitMQ 服务本地授权问题
date: 2018-07-07T00:13:10+08:00
tags:
  - rabbitmq
  - erlang
  - cookie
  - auth
categories:
  - deploy
---
# Authentication failed (rejected by the remote node), please check the Erlang cookie
遇到这种情况原因就是本地的授权cookie文件不匹配导致的，结局方法如下：
1. 删除 **%UserProfile%** 目录下的 **.erlang.cookie** 文件
2. 使用 **C:\Windows\System32\config\systemprofile** 目录下的 **.erlang.cookie** 覆盖掉之前 **%UserProfile%** 目录的同名文件

在试试，现在应该已经可以正常访问了
