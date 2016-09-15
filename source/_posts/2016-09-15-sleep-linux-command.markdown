---
layout: post
title: "造了一个轮子：sleep命令"
date: 2016-09-15 08:03:35
comments: true
mathjax: false
categories: linux
---

我们一个嵌入式平台，系统是uClinux，不支持动态库，库形式都是静态库。linux命令用的是busybox，任何一个命令都是一个busybox，都要耗费512K内存，一个sleep命令也是这样。客户两个程序都用sleep做等待循环，内存出现不够了，又不愿意修改sh脚本。所以系统平台决定重新实现了一个sleep命令。

<!--more-->

<script src="https://gist.github.com/xixitalk/354a2628bbd21214be5340b0cac0ac52.js"></script>

