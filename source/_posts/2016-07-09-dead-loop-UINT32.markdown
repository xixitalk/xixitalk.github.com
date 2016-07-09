---
layout: post
title: "UINT32引起的死循环"
date: 2016-07-09 10:02:35
comments: true
mathjax: false
categories: tech bugfix
---

UINT32 引起的死循环

<!--more-->

上周出差定位一个死循环。一个函数进行一个信号量的初始化，每次进行一次业务都要调用这个函数初始化，这个函数作用是保障初始化后信号量初始化值为`SEM_INIT_NUM`，但因为`UINT32`的关系出现死循环了。代码如下：

<script src="https://gist.github.com/xixitalk/5c176a78a8743465061ef15ab5f9a248.js"></script>

出现问题的时候，`semCount`为4，而宏`SEM_INIT_NUM`为3，造成`Count = SEM_INIT_NUM - semCount`为`-1`了，但因为`Count`是`UINT32`，从而变成`0xFFFFFFFF`，一个极大值，造成for循环执行长时间不退出。修改方法是将`Count`的`UINT32`改成`SINT32`。这是一个非常低级的代码错误。

其实更简单的是删除信号量，重新创建信号量，这样代码会容易读的多。

```
DeleteSemaphore(ptxSem);
ptxSem = CreateSemaphore(SEM_INIT_NUM);
```
