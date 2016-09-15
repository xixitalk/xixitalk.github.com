---
layout: post
title: "造了一个轮子：sleep命令"
date: 2016-09-15 08:03:35
comments: true
mathjax: false
categories: linux
---

我们一个嵌入式平台，系统是`uClinux`，不支持动态库，只能用静态库，每个程序都包含了所有调用的函数代码，包括C库的。客户一个产品压力测试时偶现系统内存不够，期望当天我们能协助他们解决，内存优化有很多方向，不好入手啊。

<!--more-->

通过分析内存不够的现场，系统内存还有一些，但是碎片化了，物理连续的256K的内存块都没有了。同时发现客户有两个常驻的sh进程，两个sh程序都用`sleep`做等待循环。`linux`命令用的是`busybox`，任何一个命令都是运行`busybox`。运行一个`busybox`要耗费512K内存，`sleep`命令也是这样。

两个`sleep`本身就占用1M，把sh脚本分拆，在代码里`sleep`，就会去掉这个内存占用，是个可以优化出一点内存的方法。但是经过沟通客户不愿意修改sh脚本，从项目考虑我也理解。后来**我脑洞大开了一下，觉得`sleep`命令最后就是简单调用`sleep`函数，为何不重新实现一个，不用`busybox`的那个呢。重新实现了一个sleep命令，替换busybox里的sleep命令，这样就能减少`sleep`的内存占用了**。

于是写了一个最简单的只有20行的`sleep`命令，不支持`s` `m` `h` `d` 参数，不支持浮点数，静态编译出来只有10K，加上默认4K栈空间，运行时候16K内存就足够了，这样就能节省出这1M内存，经过客户测试发现问题解决了。好啊，中秋节不用加班了。（备注：南京受台风影响，中秋节下了一整天雨，这篇博客就是中秋节写的。）

```
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
    unsigned long int timelen = 0;
    int i = 0;

    if(1 == argc)
        return -1;

    for(i = 1; i < argc; i++)
        timelen += strtoul(argv[i], NULL, 10);

    if(timelen > 0)
        sleep(timelen);

    return 0;
}

```

后来想想还是实现一个功能比较全的吧，代码如下。和标准linux sleep命令功能唯一不同的是：没有实现浮点数支持。

<script src="https://gist.github.com/xixitalk/354a2628bbd21214be5340b0cac0ac52.js"></script>
