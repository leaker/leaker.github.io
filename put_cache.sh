#!/bin/bash

# 如果当天阿里云CDN预热500次数用完后，就尝试使用使用访问预热。当然这样会产生一些费用，但问题不大。

# 预热
put_cache() {
    local i=0
    local max=$(cat $1 | wc -l)
    local arr=('|' '/' '-' '\\')
    local index=0
    for line in `cat urls.txt`
    do
        index=$(echo $i%4)
        printf "(%d/%d)[%c]\r" "$i" "$max" "${arr[$index]}"
        curl -I -k ${line} >/dev/null 2>&1
        ((i++))
    done
}

put_cache "urls.txt"