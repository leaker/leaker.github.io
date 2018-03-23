title: 获取您的IP信息
id: 171
categories:
  - Uncategorized
tags:
---

---------------------------------------
<?php
function RequestIPInfo($ip)
{
  $ch = curl_init("http://ip.taobao.com/service/getIpInfo.php?ip=$ip");
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  curl_setopt($ch, CURLOPT_BINARYTRANSFER, true);
  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
  curl_setopt($ch, CURLOPT_HTTPHEADER, array('Host: www.leelib.com'));
  $json = curl_exec($ch);
  curl_close($ch);
  return json_decode($json, TRUE);
}

$ip = getenv("REMOTE_ADDR");
$data = RequestIPInfo($ip);
if ($data['code'] == 0)
{
  echo '您的IP：' . $data['data']['ip'] . '
';
  if ($data['data']['country_id'] == '86')
    echo '您来自：' . $data['data']['region'] . $data['data']['city'] . ' ' . $data['data']['isp'];
  else
    echo '您来自：' . $data['data']['country'] . $data['data']['region'] . $data['data']['city'] . ' ' . $data['data']['isp'];
  //var_dump($data);
}
?>

---------------------------------------
以上信息来自淘宝的IP地址库
通过GET方式查询
查询方式：http://ip.taobao.com/service/getIpInfo.php?ip=<您要查询的IP地址>
获取到的是JSON编码的数据

这里给你们提供了一个接口，可以在本页面查询信息：
<form method="post">
IP地址：<input type="text" name="ip" /> <input type="submit" value=" 查询 " />
</form>
---------------------------------------
<?php
$ip = $_POST['ip'];
if ($ip != '')
{
$data = RequestIPInfo($ip);
if ($data['code'] == 0)
{
  echo '您查询的IP：' . $data['data']['ip'] . '
';
  if ($data['data']['country_id'] == '86')
    echo '该IP位于：' . $data['data']['region'] . $data['data']['city'] . ' ' . $data['data']['isp'];
  else
    echo '该IP位于：' . $data['data']['country'] . $data['data']['region'] . $data['data']['city'] . ' ' . $data['data']['isp'];
  //var_dump($data);
}
}
?>

---------------------------------------