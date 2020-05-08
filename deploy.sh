#!/bin/bash

if [ -d "public" ]; then
  hexo clean
fi
hexo d

###################################################################################################
echo 正在生成urls.txt...
# 清空原文件
rm -f urls.txt
read_dir(){
    for file in `ls $1`
    do
        if [ -d $1"/"$file ]
        then
            read_dir $1"/"$file
        elif [ $file != "CNAME" ]
        then
            if [ $1 == "public" ] # 根目录
            then
                echo "https://www.kaij.cn/"${1:6}$file >> urls.txt
            else
                echo "https://www.kaij.cn"${1:6}"/"$file >> urls.txt
            fi
        fi
    done
}
read_dir "public"
