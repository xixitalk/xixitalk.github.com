---
layout: post
title: "pthread退出时自动回收资源"
date: 2016-07-18 08:49:16
comments: true
mathjax: false
categories: linux pthread
---

pthread线程创建后默认属性是joinable，线程函数执行完资源不会自动回收线程资源，需要主进程`pthread_join`进行回收，否则就会造成不必要的内存占用，频繁创建退出线程可能会造成系统内存耗尽。除了`pthread_join`用这种办法更好些。

<!--more-->

线程函数加上`pthread_detach(pthread_self())`的话，线程状态改变成`unjoinable`，这样线程函数尾部直接 pthread_exit线程就会自动退出。

```
static void  thread_fn( void *args)
{
	pthread_detach(pthread_self());

	while(flag)
	{
		/*do something*/
	}

	pthread_exit(NULL);
}
```

## 参考文章

<http://blog.csdn.net/trinea/article/details/5191165>

<http://www.lxway.net/499814656.html>

