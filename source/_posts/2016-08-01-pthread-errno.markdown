---
layout: post
title: "pthread和errno"
date: 2016-08-01 19:10:02
comments: true
mathjax: false
categories: pthread
---

pthread和errno：pthread函数在出错的时候不会设置errno，而是直接返回错误值。

<!--more-->

> **pthread_create() won't ever set errno**.  pthread function returns zero
> on success, and an error code on error.  So the value you are seeing
> in errno is either the result of an error in some previous other
> system call, or errno is just starting out at EINTR and never getting
> changed (this has happened to me).


```
 #define handle_error_en(en, msg) \
               do { errno = en; perror(msg); exit(EXIT_FAILURE); } while (0)

s = pthread_create(&tinfo[tnum].thread_id, &attr,
                      &thread_start, &tinfo[tnum]);
if (s != 0)
    handle_error_en(s, "pthread_create");
```

#### 参考资料

<http://man7.org/linux/man-pages/man3/pthread_create.3.html>  
<https://sourceware.org/ml/libc-alpha/2000-10/msg00153.html>  
<http://www.oschina.net/question/234345_40365>


