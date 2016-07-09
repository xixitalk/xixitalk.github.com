---
layout: post
title: "函数栈破坏检查"
date: 2016-07-09 14:49:35
comments: true
mathjax: false
categories: bugfix
---

函数栈破坏检查 平台 ARM linux，编译器GCC

<!--more-->

产品部分音频功能是台湾某家公司提供的，开源了部分代码，实现一个功能发现偶现程序段错误，根据coredump显示死的函数是一个类似printf的打印函数，而这个打印函数基本可以肯定是没有问题的，并且出现了多次。程序这样跑飞的一个原因就是函数栈遭到破坏，函数执行完弹栈返回函数调用的下条指令时候出错了。所以写了一个函数栈检查函数。代码如下：

<script src="https://gist.github.com/xixitalk/633303a13cd3711b4efc94881e1cc0da.js"></script>

问题很快定位，问题原因是其中一个函数接收消息的时候，recv函数输入的bufffer大小比buffer实际大小大，而这个buffer恰好是局部变量（栈空间），从而recv的时候把栈破坏了。

特别提醒：如果定位的testFunc函数里局部变量过大，可能需要调整STACK_FIND_SIZE大小。定位平台是ARM linux，编译是GCC，其他平台和编译器以此类推。
