#!/bin/bash

# 如果有大规模修改，就需要用这个命令清理一遍阿里云的OSS缓存文件，否则阿里云的OSS不会自动检查源站是否更新了
ossutil rm -r oss://kaij/