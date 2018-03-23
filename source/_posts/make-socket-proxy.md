title: 让Socket通过HTTP代理通讯
tags:
  - connect
  - http
  - proxy
  - recv
  - socket
id: 562
categories:
  - programing
date: 2013-10-29 16:06:54
---

## 如果socket想使用HTTP代理，需要进行下面步骤：

1.  connect到代理服务器
2.  send(Format("CONNECT %s:%s HTTP/1.1rnUser-Agent: MyApp/0.1rnrn", <真正目标IP>, <真正目标端口>)
3.  recv 数据，并且根据数据内容判断CONNECT协议是否成功（是否有返回"HTTP/1.1 200"）
4.  如果第3步成功了，那么这个socket就已经是通过HTTP代理来连接的了，剩下的该怎么发包收包都照旧了
