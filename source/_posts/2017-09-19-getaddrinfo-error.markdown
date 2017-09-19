---
layout: post
title: "getaddrinfo 返回Name or service not known错误"
date: 2017-09-19 14:23:57
comments: true
mathjax: false
categories: tech
---

关键词：glibc  getaddrinfo

同事反馈说程序调用`getaddrinfo`函数出错（arm linux平台），glibc是2.20，我想glibc不会这么弱，这么标准的函数都有问题。

<!--more-->

从网上找了一个getaddrinfo的[实例代码](http://beej.us/guide/bgnet/examples/showip.c)，用arm交叉编译链编译后，执行，确实getaddrinfo出错，提示信息`Name or service not known`。

```
arm-linux-gcc showip.c -o getaddrinfo
./getaddrinfo baidu.com
getaddrinfo: Name or service not known
```

从strace分析getaddrinfo执行流程，和PC linux上对比，发现resolv.conf流程后，缺少socket流程。

下面是出问题的strace流程。

```
$./strace ./getaddrinfo baidu.com
execve("./getaddrinfo", ["./getaddrinfo", "baidu.com"], [/* 12 vars */]) = 0
brk(0)                                  = 0x11000
uname({sysname="Linux", nodename="root", ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb6fa8000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/usr/local/lib/tls/v6l/vfp/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/usr/local/lib/tls/v6l/vfp", 0xbed8c4c0) = -1 ENOENT (No such file or directory)
open("/usr/local/lib/tls/v6l/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/usr/local/lib/tls/v6l", 0xbed8c4c0) = -1 ENOENT (No such file or directory)
open("/usr/local/lib/tls/vfp/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/usr/local/lib/tls/vfp", 0xbed8c4c0) = -1 ENOENT (No such file or directory)
open("/usr/local/lib/tls/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/usr/local/lib/tls", 0xbed8c4c0) = -1 ENOENT (No such file or directory)
open("/usr/local/lib/v6l/vfp/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/usr/local/lib/v6l/vfp", 0xbed8c4c0) = -1 ENOENT (No such file or directory)
open("/usr/local/lib/v6l/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/usr/local/lib/v6l", 0xbed8c4c0) = -1 ENOENT (No such file or directory)
open("/usr/local/lib/vfp/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/usr/local/lib/vfp", 0xbed8c4c0) = -1 ENOENT (No such file or directory)
open("/usr/local/lib/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/usr/local/lib", {st_mode=S_IFDIR|0775, st_size=0, ...}) = 0
open("/usr/lib/tls/v6l/vfp/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/tls/v6l/vfp", 0xbed8c4c0) = -1 ENOENT (No such file or directory)
open("/usr/lib/tls/v6l/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/tls/v6l", 0xbed8c4c0)  = -1 ENOENT (No such file or directory)
open("/usr/lib/tls/vfp/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/tls/vfp", 0xbed8c4c0)  = -1 ENOENT (No such file or directory)
open("/usr/lib/tls/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/tls", 0xbed8c4c0)      = -1 ENOENT (No such file or directory)
open("/usr/lib/v6l/vfp/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/v6l/vfp", 0xbed8c4c0)  = -1 ENOENT (No such file or directory)
open("/usr/lib/v6l/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/v6l", 0xbed8c4c0)      = -1 ENOENT (No such file or directory)
open("/usr/lib/vfp/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/vfp", 0xbed8c4c0)      = -1 ENOENT (No such file or directory)
open("/usr/lib/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/usr/lib", {st_mode=S_IFDIR|0775, st_size=0, ...}) = 0
open("/lib/tls/v6l/vfp/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/lib/tls/v6l/vfp", 0xbed8c4c0)  = -1 ENOENT (No such file or directory)
open("/lib/tls/v6l/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/lib/tls/v6l", 0xbed8c4c0)      = -1 ENOENT (No such file or directory)
open("/lib/tls/vfp/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/lib/tls/vfp", 0xbed8c4c0)      = -1 ENOENT (No such file or directory)
open("/lib/tls/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/lib/tls", 0xbed8c4c0)          = -1 ENOENT (No such file or directory)
open("/lib/v6l/vfp/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/lib/v6l/vfp", 0xbed8c4c0)      = -1 ENOENT (No such file or directory)
open("/lib/v6l/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/lib/v6l", 0xbed8c4c0)          = -1 ENOENT (No such file or directory)
open("/lib/vfp/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/lib/vfp", 0xbed8c4c0)          = -1 ENOENT (No such file or directory)
open("/lib/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\\f\1\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0775, st_size=1218140, ...}) = 0
mmap2(NULL, 1254784, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb6e50000
mprotect(0xb6f75000, 32768, PROT_NONE)  = 0
mmap2(0xb6f7d000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x125000) = 0xb6f7d000
mmap2(0xb6f80000, 9600, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb6f80000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb6fa7000
set_tls(0xb6fa74c0, 0xb6fa7ba8, 0xb6faa050, 0xb6fa74c0, 0xb6faa050) = 0
mprotect(0xb6f7d000, 8192, PROT_READ)   = 0
mprotect(0xb6fa9000, 4096, PROT_READ)   = 0
socket(PF_LOCAL, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) = 3
connect(3, {sa_family=AF_LOCAL, sun_path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
close(3)                                = 0
socket(PF_LOCAL, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) = 3
connect(3, {sa_family=AF_LOCAL, sun_path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
close(3)                                = 0
brk(0)                                  = 0x11000
brk(0x32000)                            = 0x32000
open("/etc/nsswitch.conf", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
open("/etc/host.conf", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
getpid()                                = 93
open("/etc/resolv.conf", O_RDONLY|O_CLOEXEC) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=104, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb6fa6000
read(3, "nameserver 10.30.1.9\nsearch baidu."..., 4096) = 104
read(3, "", 4096)                       = 0
close(3)                                = 0
munmap(0xb6fa6000, 4096)                = 0
open("/usr/local/lib/libnss_dns.so.2", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
open("/usr/lib/libnss_dns.so.2", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
open("/lib/libnss_dns.so.2", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
open("/lib/libnss_dns.so.2", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
open("/usr/lib/libnss_dns.so.2", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
open("/usr/local/lib/libnss_files.so.2", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
open("/usr/lib/libnss_files.so.2", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
open("/lib/libnss_files.so.2", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
open("/lib/libnss_files.so.2", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
open("/usr/lib/libnss_files.so.2", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
write(2, "getaddrinfo: Name or service not"..., 39getaddrinfo: Name or service not known
) = 39
exit_group(2)                           = ?
+++ exited with 2 +++
```

PC linux正常的getaddrinfo strace流程，resolv.conf有`sendmmsg`和`recvfrom`流程，正是这个流程获取到了IP。

```
open("/etc/resolv.conf", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=224, ...}) = 0
read(3, "# Dynamic resolv.conf(5) file fo"..., 4096) = 224
read(3, "", 4096)                       = 0
close(3)                                = 0
uname({sysname="Linux", nodename="root", ...}) = 0
socket(PF_INET, SOCK_DGRAM|SOCK_NONBLOCK, IPPROTO_IP) = 3
connect(3, {sa_family=AF_INET, sin_port=htons(53), sin_addr=inet_addr("10.41.213.131")}, 16) = 0
poll([{fd=3, events=POLLOUT}], 1, 0)    = 1 ([{fd=3, revents=POLLOUT}])
sendmmsg(3, {msg_name(0)=NULL, msg_iov(1)=[{"\261\235\1\0\0\1\0\0\0\0\0\0\5baidu\3com\0\0\1\0\1", 31}], msg_controllen=0, msg_flags=0}, 31}, {msg_name(0)=NULL, msg_iov(1)=[{"\321\3\1\0\0\1\0\0\0\0\0\0\5baidu\3com\0\0\34\0\1", 31}], msg_controllen=0, msg_flags=0}, 31}, 2, MSG_NOSIGNAL) = 2
poll([{fd=3, events=POLLIN}], 1, 5000)  = 1 ([{fd=3, revents=POLLIN}])
ioctl(3, FIONREAD, [47])                = 0
recvfrom(3, "\261\235\201\200\0\1\0\1\0\0\0\0\5baidu\3com\0\0\1\0\1\300"..., 2048, 0, {sa_family=AF_INET, sin_port=htons(53), sin_addr=inet_addr("10.41.213.131")}, [16]) = 47
poll([{fd=3, events=POLLIN}], 1, 4998)  = 1 ([{fd=3, revents=POLLIN}])
ioctl(3, FIONREAD, [81])                = 0
recvfrom(3, "\321\3\201\200\0\1\0\0\0\1\0\0\5baidu\3com\0\0\34\0\1\300"..., 65536, 0, {sa_family=AF_INET, sin_port=htons(53), sin_addr=inet_addr("10.41.213.131")}, [16]) = 81
close(3)                                = 0
fstat(1, {st_mode=S_IFREG|0664, st_size=7635, ...}) = 0
write(1, "IP addresses for baidu.com:\n"..., 52IP addresses for baidu.com:

  IPv4: 10.30.1.61
) = 52
exit_group(0)                           = ?
+++ exited with 0 +++
```

对比两个strace的打印，发现出问题的平台提示`libresolv.so.2`和`libnss_dns.so.2`找不到，这两个库看起来和域名解析有关，从编译链里找到这两个库`libnss_dns-2.20.so`和`libresolv-2.20.so`，放到开发板`/lib`目录，并创建好软连接。再次运行` ./getaddrinfo baidu.com`发现正常了。看来就是`getaddrinfo`依赖`libnss_dns`和`libresolv`两个动态库。坑爹的是`ldd getaddrinfo`并发现不了getaddrinfo程序依赖这两个动态库。

`/lib`新增库如下

```
libnss_dns-2.20.so
libnss_dns.so.2 -> libnss_dns-2.20.so
libresolv-2.20.so
libresolv.so.2 -> libresolv-2.20.so
```

[root@~ ]# ./getaddrinfo baidu.com
IP addresses for baidu.com
IPv4: 10.30.1.19

### 参考资料

<http://beej-zhtw.netdpi.net/05-system-call-or-bust/5-1-getaddrinfo-start>

<http://beej.us/guide/bgnet/examples/showip.c>

