title: 修改连接SSH时的系统语言
id: 517
categories:
  - summarys
date: 2013-09-28 05:13:34
tags:
---

> 在SSH连接后执行下面命令：
```bash
export LANG=en_US
export LC_ALL=en_US
```

> 不过上面的修改只是临时的，仅这一次连接有效。等到下次再连接的时候，又得重新调用。所以可以采用下面永久解决这个问题：
```bash
echo 'LANG="en_US.UTF-8"  
LANGUAGE="en_US:en"' > /etc/default/locale
```
    