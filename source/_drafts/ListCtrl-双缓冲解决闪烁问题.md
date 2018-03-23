title: ListCtrl 双缓冲解决闪烁问题
id: 826
categories:
  - Uncategorized
tags:
---

m_ctlLisit.SetExtendedStyle(m_ctlLisit.GetExtendedStyle() | LVS_EX_DOUBLEBUFFER);