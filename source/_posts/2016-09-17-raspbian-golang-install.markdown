---
layout: post
title: "树莓派go语言编译器安装配置"
date: 2016-09-17 19:42:13
comments: true
mathjax: false
categories: golang raspberrypi 
---

关键词：树莓派 go语言编译器安装 raspbian golang install

<!--more-->

目前树莓派raspbian系统上go语言编译器版本还是1.3.3，太旧了，很多go语言写的软件都编译不成功。go语言从1.6版本官方直接提供ARM版本二进制文件，树莓派上直接可以使用。

## go编译器下载

golang语言官方下载地址：<https://golang.org/dl/>

目前（2016.09.17）最新版是1.7.1，选择其中的ARM版本。

```
go1.7.1.linux-armv6l.tar.gz	Archive	Linux	ARMv6	66MB
```

下载后在树莓派上用tar解压，比如解压路径为：`/home/pi/go/go1.7`里，`/home/pi/go/go1.7/go/bin/go`为编译器go命令。

```
 $ file /home/pi/go/go1.7/go/bin/go
/home/pi/go/go1.7/go/bin/go: ELF 32-bit LSB executable, ARM, EABI5 version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux-armhf.so.3, not stripped
```

**编译器不用安装到系统里了，直接使用即可，后续版本更新直接替换即可**。

## go编译环境配置

配置go编译器环境，`GOROOT`是go编译器安装目录，`GOPATH`是代码工程所在目录。重新设置`PATH`，把下载的编译器命令加到系统原来PATH之前，替换系统旧的go编译器。最好把系统代理配置上，不然从`github.com`下载代码会失败。

```
export GOROOT=/home/pi/go/go1.7/go
export GOPATH=/home/pi/go/prjects
export PATH=/home/pi/go/go1.7/go/bin:$PATH
export http_proxy=http://192.168.1.106:8118
export https_proxy=http://192.168.1.106:8118
```

## 编译一个软件试试

从`github.com`自动下载代码编译一个工程试试，比如`gdns-go`

```
go get github.com/ayanamist/gdns-go
```

看看`/home/pi/go/prjects`目录是不是有`bin` `pkg` `src`三个目录，`bin`目录就有编译好的`gdns-go`程序了。`gdns-go`是一个基于[Google DNS over HTTPS API](https://developers.google.com/speed/public-dns/docs/dns-over-https)的DNS客户端程序，支持[shadowsocks](https://github.com/shadowsocks)。

我的`config.json`配置如下，然后执行`sudo ./gdns-go 2>&1 > /dev/null &`后台运行即可(53端口需要root权限账号运行)。我已经用`gdns-go`取代`dnsmasq` + `DNSCrypt`。

```
{
  "listen": "192.168.1.104:53",
  "proxy": "ss://aes-128-cfb:x123456x@17.x.x.x:15879",
  "mapping": {
    "taobao.com": "223.5.5.5"
  }
}
```


