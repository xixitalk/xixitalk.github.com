---
layout: post
title: "malloc封装检查越界"
date: 2016-07-09 13:32:35
comments: true
mathjax: false
categories: bugfix
---

malloc封装检查越界

<!--more-->

上周出差，出现一例死机现场在libc的malloc函数里，分析malloc管理内存被擦写了，想来应该是用户使用malloc越界了。但是问题难复现，程序运行大于6小时出现，共抓取了3个现场，死机位置类似，可以定位某个线程的while循环。所以现场封装了一个malloc函数用于检测内存是否越界。代码如下

<script src="https://gist.github.com/xixitalk/d9364ee670f09f0365fd45466a773ba4.js"></script>

```
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|  size | BEGIN_MAGIC |      USER      BUFFER      | END_MAGIC |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

每次内存申请多申请12个字节，前4个字节保存用户真实size，第4-8个字节保存魔术字，最后4个字节也保存魔术字，起始地址+8是用户可见的空间。

很快就定位某个函数使用缓存越界了。

