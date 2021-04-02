title: 将M8导出的联系人XML转化成Andriod可以导入的vcf文件
tags:
  - Andriod
  - m8
  - m8toAndriod
  - python
  - XML
id: 133
categories:
  - programing
date: 2012-04-12 09:27:17
---

<center>{% img /wp-content/uploads/2012/04/android.webp %}</center>
通过我写的一段Python代码可以让M8用户将联系人导入到Andriod系统中。

## 操作需要以下步骤：

1. 先用M8PC工具将M8的联系人导出成XML格式。
2. 将导出的文件重命名为mycontact.xml，并与m8toAndriod.py放到同一目录下
3. 运行 python m8toAndriod.py 程序会生成一个名为 mycontact.vcf 的文件
4. 将 mycontact.vcf 传到Andriod手机中导入

## 以下为 m8toAndriod.py 的代码：
```python
#!/usr/bin/env python
# coding: utf-8
# 功能：将M8导出的联系人XML转化成Andriod可以导入的vcf文件
# 版本：python 2.6 以上
# 作者：leaker
# 网站：http://www.leelib.com
from xml.etree import ElementTree as ET

# 输出到的mycontact.vcf
out = file("mycontact.vcf", "wb")
root = ET.parse(file("mycontact.xml", "r")).getroot()
print root
for e in root.findall('Person'):
    out.write('BEGIN:VCARDrnVERSION:3.0rn')
    out.write('N:%s;%s;;;rn' % (e.findtext('LastName', '').encode('utf8'), e.findtext('FirstName', '').encode('utf8')))
    out.write('FN:%srn' % (e.findtext('FileAs', '').encode('utf8')))
    # print 'FN:%srn'% (e.findtext('FileAs', '').encode('gb2312'))
    for ee in root.findall('Phone'):
        if ee.findtext('PersonID','') == e.findtext('ID',''):
            primary = ee.get('IsPrimary') == 'true'
            out.write('TEL;TYPE=CELL%s:%srn' % ((';TYPE=PREF' if primary else ''), ee.findtext('Info','')))
    out.write('END:VCARDrn')
out.close()
```
点击这里下载：[m8toAndriod.7z](/wp-content/uploads/2012/04/m8toAndriod.7z)
