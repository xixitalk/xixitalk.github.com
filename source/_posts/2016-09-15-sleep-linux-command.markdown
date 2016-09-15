---
layout: post
title: "造了一个轮子：sleep命令"
date: 2016-09-15 08:03:35
comments: true
mathjax: false
categories: linux
---

我们一个嵌入式平台，系统是uClinux，不支持动态库，库形式都是静态库。linux命令用的是busybox，任何一个命令都是一个busybox，都要耗费512K内存，一个sleep命令也是这样。客户两个sh程序都用sleep做等待循环，其他程序执行出现内存不够了，但是客户又不愿意修改sh脚本。所以重新实现了一个sleep命令，替换busybox里的sleep命令，静态编译出来只有10K，运行时候16K内存就足够了，这样节省了1M内存，测试发现问题解决了。和标准linux sleep命令唯一不同的是：没有实现浮点数支持。版本里实际上用的时候，连`s` `m` `h` `d`都不会使用，所以不想实现的太复杂了。

<!--more-->

<script src="https://gist.github.com/xixitalk/354a2628bbd21214be5340b0cac0ac52.js"></script>

