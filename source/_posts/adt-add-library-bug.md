title: Eclipse-ADT在Windows下添加library的BUG
date: 2016-04-20 18:35:35
tags:
categories: programing
---
# 问题出现
今天在Windows里使用 Cocos-Quick 创建的项目在使用ADT往Android里面部署的时候遇到了下面的问题
{% img /images/20160420/adt_add_library_bug.webp %}

出现上图的情况是这样的操作步骤：
1. 添加 D:\Tools\Quick-Cocos2dx-Community\cocos\platform\android\java 到 Library 引用里
2. 点击 OK
3. 重新打开这个配置界面

# 问题解决
测试了许久后，无意间发现有次选错了路径后Library正常了
> 当时我选择的 Quick 是 ** F:\Quick-Cocos2dx-Community **
> 选择的项目目录是 ** F:\Code\Cocos\QuickHello **

终于发现了解决这个BUG的办法：*** 将项目和想要引用的Library放在同一个分区内 ***
遂将项目和 Quick 放到同一个分区内后问题解决，效果如下：
{% img /images/20160420/adt_add_library_bug_ok.webp %}

引起这个错误的原因是：*** Eclipse 本身并不是给Windows 这种多分区系统定制的，本身是用来给 MAC 或者 Linux 这种以目录为结构的系统使用的 ***