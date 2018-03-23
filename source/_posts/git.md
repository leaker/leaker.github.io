title: Git的常用命令收集
date: 2016-01-21 23:43:59
tags: git
---
```bash
# 拉取最新的代码
git fetch --all
# 恢复到最后一次提交，放弃本地所有修改
git reset --hard

# 列出所有设置
git config -l

# 抛弃对文件的修改
git co  -- <filename>
# 抛弃对目录的修改
git co .

# 从版本库中删除文件
git rm <filename>

# 比较差异
git diff

# 查看提交历史
git log
```

本篇文章后续不定期更新