---
layout: post
title: "linux应用内存占用maps分析"
date: 2016-07-12 10:50:20
comments: true
mathjax: false
categories: linux
---

假设一个应用的pid是PID，则`cat /proc/PID/maps`显示这个应用的内存占用。

<!--more-->

### maps格式

```
address           perms offset  dev   inode   pathname
00008000-00009000 r-xp 00000000 b3:02 317712     /home/pi/test/pmap/a.out
```

1. **address** - This is the starting and ending address of the region in the process's address space。说明：都是虚拟地址，并不代码真实的物理地址。
2. **permissions** - This describes how pages in the region can be accessed. There are four different permissions: read, write, execute, and shared. If read/write/execute are disabled, a '-' will appear instead of the 'r'/'w'/'x'. If a region is not shared, it is private, so a 'p' will appear instead of an 's'. If the process attempts to access memory in a way that is not permitted, a segmentation fault is generated. Permissions can be changed using the `mprotect` system call.
3. **offset** - If the region was mapped from a file (using mmap), this is the offset in the file where the mapping begins. If the memory was not mapped from a file, it's just 0.
4. **device** - If the region was mapped from a file, this is the major and minor device number (in hex) where the file lives.
5. **inode** - If the region was mapped from a file, this is the file number.
6. **pathname** - If the region was mapped from a file, this is the name of the file. This field is blank for anonymous mapped regions. There are also special regions with names like [heap], [stack], or [vdso]. [vdso] stands for virtual dynamic shared object. It's used by system calls to switch to kernel mode. Here's a good article about it.

### 实例分析

写一个简单的实例main.c，funcA地址在代码段，s_buf在数据段，buf是局部变量，在栈空间，pheap是malloc申请的，是heap空间。

```
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

static char s_buf[1024];
void funcA(void)
{
  printf("funcA address:%08x\n",funcA);
}

int main(int argc,char *argv[])
{
  int i = 0;
  char buf[1024] = {0};
  char *pheap = malloc(2048);

  for(i=0;i<1000;i++)
  {
    funcA();
    printf("buf address:%08x\n",buf);
    printf("s_buf address:%08x\n",s_buf);
    printf("pheap address:%08x\n",pheap);
    sleep(10);
  }
  free(pheap);
  return 0;
}
```

编译运行

```
$gcc main.c
$./a.out
funcA address:000084a0
buf address:becb9318
s_buf address:000107ac
pheap address:01171008
funcA address:000084a0
buf address:becb9318
s_buf address:000107ac
pheap address:01171008
```

在另一个窗口

```
$ ps aux | grep out
pi       27725  0.0  0.2   1676   424 pts/0    S+   10:43   0:00 ./a.out
$ cat /proc/27725/maps > a.out.maps
$ cat a.out.maps
00008000-00009000 r-xp 00000000 b3:02 317712     /home/pi/test/pmap/a.out
00010000-00011000 rw-p 00000000 b3:02 317712     /home/pi/test/pmap/a.out
01171000-01192000 rw-p 00000000 00:00 0          [heap]
b6e36000-b6f59000 r-xp 00000000 b3:02 1925       /lib/arm-linux-gnueabihf/libc-2.13.so
b6f59000-b6f60000 ---p 00123000 b3:02 1925       /lib/arm-linux-gnueabihf/libc-2.13.so
b6f60000-b6f62000 r--p 00122000 b3:02 1925       /lib/arm-linux-gnueabihf/libc-2.13.so
b6f62000-b6f63000 rw-p 00124000 b3:02 1925       /lib/arm-linux-gnueabihf/libc-2.13.so
b6f63000-b6f66000 rw-p 00000000 00:00 0
b6f74000-b6f76000 r-xp 00000000 b3:02 27194      /usr/lib/arm-linux-gnueabihf/libcofi_rpi.so
b6f76000-b6f7d000 ---p 00002000 b3:02 27194      /usr/lib/arm-linux-gnueabihf/libcofi_rpi.so
b6f7d000-b6f7e000 rw-p 00001000 b3:02 27194      /usr/lib/arm-linux-gnueabihf/libcofi_rpi.so
b6f7e000-b6f9b000 r-xp 00000000 b3:02 1919       /lib/arm-linux-gnueabihf/ld-2.13.so
b6f9e000-b6fa2000 rw-p 00000000 00:00 0
b6fa2000-b6fa3000 r-xp 00000000 00:00 0          [sigpage]
b6fa3000-b6fa4000 r--p 0001d000 b3:02 1919       /lib/arm-linux-gnueabihf/ld-2.13.so
b6fa4000-b6fa5000 rw-p 0001e000 b3:02 1919       /lib/arm-linux-gnueabihf/ld-2.13.so
bec99000-becba000 rw-p 00000000 00:00 0          [stack]
ffff0000-ffff1000 r-xp 00000000 00:00 0          [vectors]
```

a.out.maps内容分析如下

```
00008000-00009000 r-xp 00000000 b3:02 317712     /home/pi/test/pmap/a.out  
代码段，funcA在这个区间,权限是r-xp，有读、执行权限，p是private
```

```
00010000-00011000 rw-p 00000000 b3:02 317712     /home/pi/test/pmap/a.out  
数据段，s_buf在这个区间,权限是rw-p，有读写，p是private
```

```
01171000-01192000 rw-p 00000000 00:00 0          [heap]
堆空间，pheap在这个区间，权限是rw-p，有读写，p是private
```

```
b6e36000-b6f59000 r-xp 00000000 b3:02 1925       /lib/arm-linux-gnueabihf/libc-2.13.so
libc库代码段
```

```
b6f59000-b6f60000 ---p 00123000 b3:02 1925       /lib/arm-linux-gnueabihf/libc-2.13.so
libc库内存防止越界空间，权限是---p，没有rwx权限，用户访问就触发段错误
```

```
b6f60000-b6f62000 r--p 00122000 b3:02 1925       /lib/arm-linux-gnueabihf/libc-2.13.so
libc库只读内存区。如果const变量，则在代码段；如果是全局变量则在数据段，还不知道这个区域内容。
```

```
b6f62000-b6f63000 rw-p 00124000 b3:02 1925       /lib/arm-linux-gnueabihf/libc-2.13.so
libc库数据段
```

```
b6f63000-b6f66000 rw-p 00000000 00:00 0
b6f9e000-b6fa2000 rw-p 00000000 00:00 0
未知，权限rw-p应该共享库相关的数据区
```

```
b6f74000-b6f76000 r-xp 00000000 b3:02 27194      /usr/lib/arm-linux-gnueabihf/libcofi_rpi.so
b6f76000-b6f7d000 ---p 00002000 b3:02 27194      /usr/lib/arm-linux-gnueabihf/libcofi_rpi.so
b6f7d000-b6f7e000 rw-p 00001000 b3:02 27194      /usr/lib/arm-linux-gnueabihf/libcofi_rpi.so
b6f7e000-b6f9b000 r-xp 00000000 b3:02 1919       /lib/arm-linux-gnueabihf/ld-2.13.so
b6fa3000-b6fa4000 r--p 0001d000 b3:02 1919       /lib/arm-linux-gnueabihf/ld-2.13.so
b6fa4000-b6fa5000 rw-p 0001e000 b3:02 1919       /lib/arm-linux-gnueabihf/ld-2.13.so
同libc分析
```

```
b6fa2000-b6fa3000 r-xp 00000000 00:00 0          [sigpage]
和信号相关的一个page，ARM架构独有好像
```

```
bec99000-becba000 rw-p 00000000 00:00 0          [stack]
栈空间，局部变量buf在这个区间
```

```
ffff0000-ffff1000 r-xp 00000000 00:00 0          [vectors]
中断向量
```

待完善...

### 参考资料

<http://stackoverflow.com/questions/1401359/understanding-linux-proc-id-maps>

<http://stackoverflow.com/questions/16524895/proc-pid-maps-shows-pages-with-no-rwx-permissions-on-x86-64-linux>

<https://yq.aliyun.com/articles/54405>
