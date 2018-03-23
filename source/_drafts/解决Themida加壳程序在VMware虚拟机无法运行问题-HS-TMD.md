title: 解决Themida加壳程序在VMware虚拟机无法运行问题_HS_TMD
id: 571
categories:
  - 经验总结
tags:
---

标 题: 解决Themida加壳程序在VMware虚拟机无法运行问题
作 者: Y4ng
时 间: 2012-08-23 12:32:13 星期四
链 接: [http://www.cnblogs.com/Y4ng/archive/2012/08/23/tmd_vmware_hs_TheMida.html](http://www.cnblogs.com/Y4ng/archive/2012/08/23/tmd_vmware_hs_TheMida.html "view: 解决Themida加壳程序在VMware虚拟机无法运行问题")

&nbsp;

在调试韩国某游戏HS保护的时候，由于主程序被加了TMD(TheMida)壳，根本就没法在虚拟机里调试；作为刚学驱动的新手来说这是一个无比摧残人的事，耗费重启时间不说 损害硬盘丢失资料~； 还有那些无辜躺在硬盘里的岛国女人们，像我这种怜香惜玉的人怎么舍得他们如此摧残呢所以为了使他们都免受伤害，翻遍看雪谷歌都不得其法。 最后不得已翻墙出去搜，结果搞定之！ 那一刻 我仿佛听到了遥远硬盘里岛国人们欢呼雀跃各种雅蠛蝶。
虚拟机运行程序会提示：
<div>
<pre>TheMida
Soory, this application cannt run under a Virtual Machine</pre>
</div>
&nbsp;

解决方案：
**1、打开对应的虚拟机配置文件 .VMX 格式（如 Windows XP Professional.vmx），记事本编辑 在尾部加入以下代码**
<div>
<pre>disable_acceleration = "TRUE"
monitor_control.restrict_backdoor = "TRUE"
monitor_control.disable_directexec = "TRUE"</pre>
</div>
&nbsp;

disable_acceleration = "TRUE"
为关闭CPU的二进制翻译加速功能， 可能会让你的虚拟机运行起来没有以前流畅

monitor_control.restrict_backdoor = "TRUE"
monitor_control.disable_directexec = "TRUE"
这两句具体功能大伙就从英文意思猜吧， 设置为TRUE会影响虚拟机中的 Vmware Tools 功能~ 但是为了能双击调 咱们可以用共享文件解决拖拽问题

&nbsp;

**2、修改虚拟机中系统的注册表项**
<div>
<pre>HKEY_LOCAL_MACHINE/SYSTEM/CurrentControlSet/Control/Class/{4D36E968-E325-11CE-BFC1-08002BE10318}/0000

将 DriverDesc 项的内容清空(千万不要删除此项)</pre>
</div>
&nbsp;

最后重启生效！ 如果还不行请问谷歌，问大牛，翻墙之！

参考连接：http://www.elitepvpers.com/forum/cabal-guides-templates/1418504-vmware-solution-themida-protection.html