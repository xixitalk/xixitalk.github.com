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
 
kmalloc是内核中最常用的一种内存分配方式，**连续的物理内存**。如果size是常量，调用`kmem_cache_alloc_trace`分配，否则调用`__kmalloc`分配。size如果是常量且大于4M，直接返回0（内核版本3.4.5）；如果size是0，返回地址是`((void *)16)`。

#### vmalloc

```
void *vmalloc(unsigned long size)
```

kmalloc内存分配方式都是物理连续的，能保证较低的平均访问时间。但是在某些场合中，对内存区的请求不是很频繁，较高的内存访问时间也 可以接受，这是就可以分配一段**线性连续，物理不连续**的地址，带来的好处是一次可以分配较大块的内存。vmalloc对 一次能分配的内存大小没有明确限制。

##### kmalloc预处理后的代码

```
static inline __attribute__((always_inline)) __attribute__((always_inline)) void *kmalloc(size_t size, gfp_t flags)
{
 struct kmem_cache *cachep;
 void *ret;

 if (__builtin_constant_p(size)) {
  int i = 0;

  if (!size)
   return ((void *)16);

# 1 "include/linux/kmalloc_sizes.h" 1
 if (size <= 32) goto found; else i++;
 if (size <= 64) goto found; else i++;
 if (size <= 128) goto found; else i++;
 if (size <= 192) goto found; else i++;
 if (size <= 256) goto found; else i++;
 if (size <= 512) goto found; else i++;
 if (size <= 1024) goto found; else i++;
 if (size <= 2048) goto found; else i++;
 if (size <= 4096) goto found; else i++;
 if (size <= 8192) goto found; else i++;
 if (size <= 16384) goto found; else i++;
 if (size <= 32768) goto found; else i++;
 if (size <= 65536) goto found; else i++;
 if (size <= 131072) goto found; else i++;
 if (size <= 262144) goto found; else i++;
 if (size <= 524288) goto found; else i++;
 if (size <= 1048576) goto found; else i++;
 if (size <= 2097152) goto found; else i++;
 if (size <= 4194304) goto found; else i++;
# 145 "include/linux/slab_def.h" 2

  return ((void *)0);
found:
   cachep = malloc_sizes[i].cs_cachep;

  ret = kmem_cache_alloc_trace(size, cachep, flags);

  return ret;
 }
 return __kmalloc(size, flags);
}

void *__kmalloc(size_t size, gfp_t flags)
{
 return __do_kmalloc(size, flags, ((void *)0));
}

static inline __attribute__((always_inline)) __attribute__((always_inline)) void *__do_kmalloc(size_t size, gfp_t flags, void *caller)
{
 struct kmem_cache *cachep;
 void *ret;
 
 cachep = __find_general_cachep(size, flags);
 if (__builtin_expect(!!(((unsigned long)(cachep) <= (unsigned long)((void *)16))), 0))
  return cachep;
 ret = __cache_alloc(cachep, flags, caller);

 trace_kmalloc((unsigned long) caller, ret,
        size, cachep->buffer_size, flags);

 return ret;
}
```

# 引用文章

<http://www.ahlinux.com/start/kernel/18604.html>

<http://blog.csdn.net/bullbat/article/details/7181396>

