title: 仗剑江湖MUD客户端，最新更新ver 1.0 beta
tags:
  - mud
  - webmud
id: 91
categories:
  - works
date: 2012-03-22 23:48:35
---

<center>{% img /images/webmud_1_0.png %}</center>

**为一个元老级的MUD游戏开发的一个PC客户端。利用业余时间完成（主要是这阵子要钻研一个很有技术难度的工作，整天要对着封包一个字节一个字节比对，头疼的厉害。）。**

**下载地址：[仗剑江湖MUD客户端ver1.0beta](/wp-content/uploads/2012/03/webmud_client_ver1.0beta.7z "仗剑江湖MUD客户端ver1.0beta")**

# 更新历史

## ver 1.0 beta 2012.06.13

*   增加游戏界面功能
*   增加高级脚本功能及界面
*   高级脚本内部变量:Self
*   高级脚本内部函数:GetActor,Log,Cmd,Sleep,
IsFaintStatus
*   高级脚本内实现<hit> <kill> <get> <check>
等基本命令
*   高级脚本内实现RunLine,RunScript等功能
*   高级脚本内实现OnAddActor,OnDelActor,
OnChangePic,OnChangeAll,OnGetTask,
OnTaskOver,OnThing,OnHitOver,OnFaint,
OnWake,OnDead,OnDazuoOver,OnBuyItem,
OnBehead,OnPickUp,OnPickUpFrom,
OnItemInfo 等触发事件

## ver 0.4 beta 2012.04.03

*   增加按钮脚本个数为20个，具体按钮脚本的内
容到 script按纽list.txt 里面配置
*   增加脚本指令
具体使用方法请看 脚本指令说明.txt
*   增加自动任务功能。
具体使用方法请看 自动任务说明.txt

## ver 0.3 beta 2012.03.25

*   增加门派脚本功能，配置：scriptlist.txt
*   命令框自动保存最后发送的10条命令。可在命
令框使用键盘上下键翻找
*   增加显示当前任务信息功能，用于准备做自动
任务。如有发现什么任务没识别出来的，请联
系作者并回馈。

## ver 0.2sp1 beta 2012.03.24

*   修正有些人登录出错的问题
*   优化了网络代码网络效率提高，减少内存使用

## var 0.2 beta 2012.03.24

*   增加挂机功能，文件目录：script挂机
*   增加按钮功能，文件目录：script按纽
*   信息页面每当显示内容超过500行自动清空
*   当前玩家名称显示在血条上面
*   关闭主窗口会返回登录窗口

## ver 0.1 beta 2012.03.23

*   支持游戏基本功能。命令、聊天信息、房间信
息、当前房间人物列表等。

## 运行环境

操作系统：WinXP以上版本
内存需求： 512M

## 使用说明：

配置客户端目录下的 Config.ini 文件，修改Host为你需要登录的网站地址。这个地址从你登录游戏以后的页面提取。例如登录以后地址是：http://xxx.example.com/cgi-bin/mud/login1 那么这里就填：http://xxx.example.com

## 附加说明：

双击房间人物列表中的人物可以将人物名字插到命令行的最后

**如发现BUG或有好的建议，请在下面留言。**
