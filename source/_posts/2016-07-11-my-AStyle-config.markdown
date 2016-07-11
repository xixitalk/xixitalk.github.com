---
layout: post
title: "我的AStyle配置选项"
date: 2016-07-11 18:35:57
comments: true
mathjax: false
categories: tech
---

我的AStyle代码格式工具的选项：AStyle.exe -A1 -C -S -K -Y -f -t -p -U -o -n main.c

在`notepad++`里添加：`运行(R)--运行(R)` 选择AStyle.exe，选项输入`-A1 -C -S -K -Y -f -t -p -U -o -n "$(FULL_CURRENT_PATH)"`，然后点击`保存`据保存在运行菜单里了。每次使用从`运行(R)`点击即可。

<!--more-->

简略选项：`-A1 -C -S -K -Y -f -t -p -U -o -n`
对应长选项如下：

1. --style=bsd
1. --indent-classes
1. --indent-switches
1. --indent-cases
1. --indent-col1-comments
1. --break-blocks
1. --indent=tab
1. --pad-oper
1. --unpad-paren
1. --keep-one-line-statements
1. --suffix=none


