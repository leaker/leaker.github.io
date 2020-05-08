if [ -d "public" ]; then
  hexo clean
fi
hexo d

echo 正在生成urls.txt...
grep -o "https://www.leelib.com/[^<]*" public/sitemap.xml > urls.txt
echo 修正域名用于阿里云CDN预热...
sed -i s/"www.leelib.com"/"www.kaij.cn"/ urls.txt
#echo 百度链接提交...
#curl -H 'Content-Type:text/plain' --data-binary @urls.txt "http://data.zz.baidu.com/urls?site=https://www.kaij.cn&token=qyTc2OCtwlf52Y64"