---
layout: post
title: "linux内核代码预处理后便于阅读"
date: 2016-07-19 13:39:01
comments: true
mathjax: false
categories: linux kernel
---

linux 内核庞大而复杂。内核代码阅读的时候，有没有遇到因为宏定义或者inline层次太深而不知道到底代码是什么样子。代码预处理可以解决这个难题。

<!--more-->

平台：linux 3.4.5 ARM，PC linux上类似，更简单些。

#### 加V=1重新编译内核

`make`内核增加`V=1`选项，会详细打印编译过程，`-B`是要求重新编译内核所有模块。

```
cd linux-3.4.5 && make ARCH=arm defconfig && make ARCH=arm CROSS_COMPILE=arm-buildroot-linux-uclibcgnueabi- EXTRAVERSION=- -B V=1 uImage
```

编译内核并保存编译log到文件，搜索你要预编译的文件，如`mm/slab.c`，会找到如下编译命令：

```
arm-buildroot-linux-uclibcgnueabi-gcc -Wp,-MD,mm/.slab.o.d  -nostdinc -isystem /home/test/build/gcc-4.9.8/build_arm/staging_dir/usr/bin/../lib/gcc/arm-buildroot-linux-uclibcgnueabi/4.9.8/include -I/home/test/linux/kernels/linux-3.4.5/arch/arm/include -Iarch/arm/include/generated -Iinclude  -include /home/test/linux/kernels/linux-3.4.5/include/linux/kconfig.h -D__KERNEL__ -mlittle-endian -Iarch/arm/mach-zx297510/include -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -O2 -marm -fno-dwarf2-cfi-asm -mabi=aapcs-linux -mno-thumb-interwork -funwind-tables -D__LINUX_ARM_ARCH__=7 -march=armv7-a -msoft-float -Uarm -Wframe-larger-than=1024 -fno-stack-protector -Wno-unused-but-set-variable -fomit-frame-pointer -g -fno-inline-functions-called-once -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack -DCC_HAVE_ASM_GOTO    -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(slab)"  -D"KBUILD_MODNAME=KBUILD_STR(slab)" -c -o mm/.tmp_slab.o mm/slab.c
```

#### 编译预处理指定文件

把编译命令修改成预处理命令：`-c -o mm/.tmp_slab.o`修改成`-E -o mm/slab.E mm/slab.c`，在内核目录`linux-3.4.5`直接执行。如果是交叉编译链，可能需要把`arm-buildroot-linux-uclibcgnueabi-gcc`所在路径加入到环境变量`PATH`里。

```
arm-buildroot-linux-uclibcgnueabi-gcc -Wp,-MD,mm/.slab.o.d  -nostdinc -isystem /home/test/build/gcc-4.9.8/build_arm/staging_dir/usr/bin/../lib/gcc/arm-buildroot-linux-uclibcgnueabi/4.9.8/include -I/home/test/linux/kernels/linux-3.4.5/arch/arm/include -Iarch/arm/include/generated -Iinclude  -include /home/test/linux/kernels/linux-3.4.5/include/linux/kconfig.h -D__KERNEL__ -mlittle-endian -Iarch/arm/mach-zx297510/include -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -O2 -marm -fno-dwarf2-cfi-asm -mabi=aapcs-linux -mno-thumb-interwork -funwind-tables -D__LINUX_ARM_ARCH__=7 -march=armv7-a -msoft-float -Uarm -Wframe-larger-than=1024 -fno-stack-protector -Wno-unused-but-set-variable -fomit-frame-pointer -g -fno-inline-functions-called-once -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack -DCC_HAVE_ASM_GOTO    -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(slab)"  -D"KBUILD_MODNAME=KBUILD_STR(slab)" -E -o mm/slab.E mm/slab.c
```

执行完命令，在内核的`mm`目录就能看到`slab.c`的预处理后文件`slab.E`文件了。看一下`kmalloc`函数代码，是不是清晰很多了。

`slab_def.h`里的原始`kmalloc`

```
static __always_inline void *kmalloc(size_t size, gfp_t flags)
{
	struct kmem_cache *cachep;
	void *ret;

	if (__builtin_constant_p(size)) {
		int i = 0;

		if (!size)
			return ZERO_SIZE_PTR;

#define CACHE(x) \
		if (size <= x) \
			goto found; \
		else \
			i++;
#include <linux/kmalloc_sizes.h>
#undef CACHE
		return NULL;
found:
#ifdef CONFIG_ZONE_DMA
		if (flags & GFP_DMA)
			cachep = malloc_sizes[i].cs_dmacachep;
		else
#endif
			cachep = malloc_sizes[i].cs_cachep;

		ret = kmem_cache_alloc_trace(size, cachep, flags);

		return ret;
	}
	return __kmalloc(size, flags);
}
```

预处理后的`kmalloc`,流程是不是清晰多了。

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
```

