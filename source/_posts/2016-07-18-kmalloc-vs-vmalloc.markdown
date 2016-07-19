---
layout: post
title: "linux内核kmalloc和vmalloc的区别"
date: 2016-07-18 08:41:56
comments: true
mathjax: false
categories: linux kernel
---

kmalloc 和 vmalloc的区别

<!--more-->

#### kmalloc

```
void *kmalloc(size_t size, gfp_t flags)
```
 
 kmalloc是内核中最常用的一种内存分配方式，它通过调用kmem_cache_alloc函 数来实现。kmalloc一次最多能申请的内存大小由include/linux/Kmalloc_size.h的 内容来决定，在默认的2.6.18内核版本中，kmalloc一 次最多能申请大小为131702B也就是128KB字 节的连续物理内存。测试结果表明，如果试图用kmalloc函数分配大于128KB的内存，编译不能通过。

#### vmalloc

```
void *vmalloc(unsigned long size)
```

kmalloc内存分配方式都是物理连续的，能保证较低的平均访问时间。但是在某些场合中，对内存区的请求不是很频繁，较高的内存访问时间也 可以接受，这是就可以分配一段线性连续，物理不连续的地址，带来的好处是一次可以分配较大块的内存。图3-1表 示的是vmalloc分配的内存使用的地址范围。vmalloc对 一次能分配的内存大小没有明确限制。出于性能考虑，应谨慎使用vmalloc函数。在测试过程中， 最大能一次分配1GB的空间。

先记录，再结合代码验证。待完善

# 引用文章

<http://www.ahlinux.com/start/kernel/18604.html>

<http://blog.csdn.net/bullbat/article/details/7181396>

