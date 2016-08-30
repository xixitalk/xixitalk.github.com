---
layout: post
title: "产品中多个不明可执行程序dvrHelper"
date: 2016-08-30 16:48:47
comments: true
mathjax: false
categories: linux
---

一个数据类产品，测试报告描述：上传下载加浏览器看视频，一个小时内必死机。

死机现场初步分析：系统内存耗尽死机，但是发现进程里多了三个奇怪的进程，进程名都像是随机字符串，两个死机现场都有，并且进程名还随机的不一样。

<!--more-->

有人去分析内存问题，我来分析三个奇怪的进程。

这三个进程父进程是Init，执行的命令是`dvrHelper`，开始我怀疑版本自带的程序，查看了版本编译后的文件系统，没有这个文件，在整个版本代码里搜索这个字符串，没有找到任何踪迹。这时候有人告诉我版本的根文件系统里多了`dvrHelper`文件，重烧版本是没有这个文件的。手动运行这个文件，提示

```
listening tun0
```

运行结束后，进程列表里就多了三个奇怪的进程。父进程是Init，这是linux守护进程惯用的机制。我把dvrHelper上传到`https://www.virustotal.com`在线扫描，55个杀毒软件，有2个提示异常。

```
SHA256:	c483618671766847fc75ea79fdc201df2e4a93f501dc98ec9c6f283fb1d4336c
File name:	dvrHelper
Detection ratio:	2 / 55
Analysis date:	2016-08-29 08:51:11 UTC ( 22 hours, 56 minutes ago )

AVG	Linux/Fgt.CA	20160829
ESET-NOD32	a variant of Linux/Gafgyt.SE	20160829
```

这时候基本确认，`dvrHelper`文件是个木马程序了。引入这个木马的路径分析只有两个，一个通过`adb push`，一个就是`telnet`。先禁用了`adb`功能，发现问题出现了。同时禁用`adb`和`telnetd`，问题不出现了。现在问题聚焦在`telnetd`服务上。PC上用`wireshark`抓包，没有抓到PC上应用程序登录`telnetd`的证据。后来突然想到`pppoe`功能可能会分配一个公网IP，`ifconfig`一看，果然电信分配了一个公网IP。用手机登录这个公网的`telnetd`，也果然登录到这个产品里了。这样就怀疑产品是通过公网IP登录产品的`telnetd`服务，把木马上传到产品里了。

这时候祭出了`tcpdump`工具，抓取公网网口的23端口数据包。

```
tcpdump -i ppp port 23
```

**十几分钟的时间，就抓到了来自台湾 泰国 巴西 印度的`telnet`登录，再不一会根目录就多了`dvrHelper`文件。**

修改意见：
1、发货版本禁用`telnetd`服务
2、开发版本用`iptables`设置禁止`ppp`网口的23端口访问，不用admin：admin账号密码

PS：因特网真是太危险了
