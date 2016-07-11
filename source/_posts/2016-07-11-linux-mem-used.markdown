---
layout: post
title: "Linux内存占用分布分析"
date: 2016-07-11 21:07:20
comments: true
mathjax: false
categories: linux
---

## 1. 内存占用

linux内存占用分两部分：一部分是不可见的，内核代码段数据段的本身的占用空间，对于PC 上几个G的内存来说可能很小可以忽略不计，但是只有几十M内存的嵌入式环境来说就不能忽略了。另一部分就是linux系统可见的内存，`free`命令里的`total`或者`cat /proc/meminfo`里看到的`MemTotal`。

<!--more-->

### 1.1 内核代码段数据段
通过内核对应带调试信息文件vmlinux或者System.map文件，能查到如下符号：`_stext` `_etext`  `__bss_start`  `__bss_stop` `_end`。   `__bss_stop` `_end`值是一样的。`_etext` 减`_stext`就是代码段大小，  `__bss_stop`减`__bss_start` 就是数据段大小。代码段和数据段之前的空间是`Init`段，内核初始化只运行一次的代码放在这个段，内核初始化后会重新覆盖利用这块空间。

```
_stext                     C0008160
_etext                     C051B958   代码段大小：0x5137F8 
__bss_start                C05872E4
__bss_stop                 C060EBF0   数据段大小：0x8790C 
_end                       C060EBF0 
```

### 1.2 linux系统管理内存

linux系统可见的内存，`free`命令里的`total`或者`cat /proc/meminfo`里看到的`MemTotal`。内存管理太复杂了，完整拼接出来`total`或者`MemTotal`几乎不可能，但可以有几个重要的部分。

#### 1.2.1 空闲内存

空闲内存：meminfo(cat /proc/meminfo)里的`MemFree` + `Buffers` + `Cached` + `SwapCached`

#### 1.2.2 内核内存占用

内核内存占用：meminfo(cat /proc/meminfo)里的`Slab` + `KernelStack` + `PageTables`

#### 1.2.3 应用内存占用

应用内存有两个视图，一个是虚拟内存视图，一个物理内存（RSS）视图。
比如查看进程编号为1的Init进程内存占用

```
$cat /pric/1/statm
537 18 11 7 0 75 0
```

537是虚拟内存的page数，18是物理内存page数，每个page是4K Bytes。

用下面的脚本可以把系统所有应用的虚拟内存和物理内存统计出来，应用间的内存比较分析是有意义的或者同一个应用不同版本间的比较是有意义的。

```
#/bin/bash
RSS=0
VM=0
for PROC in `ls /proc/|grep "^[0-9]"`
do
  if [ -f /proc/$PROC/statm ]; then
      TEP1=`cat /proc/$PROC/statm | awk '{print ($1)}'`
      TEP2=`cat /proc/$PROC/statm | awk '{print ($2)}'`
      echo $PROC $TEP1 $TEP2
      RSS=`expr $RSS + $TEP2`
      VM=`expr $VM + $TEP1`
  fi
done
RSS=`expr $RSS \* 4`
VM=`expr $VM \* 4`

echo "APP total" $RSS"KB", $VM"KB",
```

## 2. 参考资料

http://blog.yufeng.info/archives/2456
