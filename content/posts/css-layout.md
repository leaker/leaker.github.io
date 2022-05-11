---
categories:
- programing
date: 2021-09-17 23:22:14+08:00
tags:
- html
- css
- style
- layout
title: 记一些常用的CSS布局方式
---
# 内容部分占满页面的剩余高度

```html
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dock.Full</title>
  <style type="text/css">
    html,
    body,
    #full {
      color: #EFEFEF;
      background-color: #423F3E;
      margin: 0;
      padding: 0;
      height: 100%;
    }

    #full {
      background-color: #171010;
      display: flex;
      flex-direction: column;
    }

    #someid {
      background-color: #362222;
      flex-grow: 1;
    }
  </style>
</head>

<body>
  <div id="full">
    <div id="header">Dock.Top</div>
    <div id="someid">Dock.Full</div>
  </div>
</body>

</html>
```
[线上预览](https://codepen.io/leaker/pen/VwWQPwV)

# 登录框居中显示
```html
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
  <style type="text/css">
    html,
    body,
    #parent {
      color: #EFEFEF;
      background-color: #423F3E;
      margin: 0;
      padding: 0;
      height: 100%;
    }

    #parent {
      background-color: #171010;
      /* 使用Flex布局 */
      display: flex;
      /* 主轴位于中间 */
      justify-content: center;
      /* 交叉轴位于中间 */
      align-items: center;
    }

    #someid {
      background-color: #362222;
      width: 200px;
      height: 200px;
    }
  </style>
</head>

<body>
  <div id="parent">
    <div id="someid">Dialog Content</div>
  </div>
</body>

</html>
```
[线上预览](https://codepen.io/leaker/pen/gORvGWd)