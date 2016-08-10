---
layout: post
title: "在内核里获取当前任务名"
date: 2016-08-10 08:33:02
comments: true
mathjax: false
categories: linux kernel
---

遇到一个问题，在一个内核模块里使用current->comm保存当前任务名，编译报错:`dereferencing pointer to incomplete type`。

<!--more-->

经过搜索发现，除了要包含`current.h`外，还要包含`sched.h`。原因是`struct task_struct`在`sched.h`里定义。`comm`是数组字符串，长度是`TASK_COMM_LEN`，一般是16个字节，记得保证足够的空间，防止内存越界。

用法实例如下：

```
#include <linux/sched.h>
#include <asm/current.h>

static char g_cfg_app_name[TASK_COMM_LEN*2] = { 0 };

strncpy(g_cfg_app_name,current->comm,TASK_COMM_LEN);
```

####  参考文章

<http://www.xuebuyuan.com/1814455.html>

