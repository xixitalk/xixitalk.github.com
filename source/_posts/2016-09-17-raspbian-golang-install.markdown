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
export GOPATH=/home/pi/go/projects
export PATH=/home/pi/go/go1.7/go/bin:$PATH
export http_proxy=http://192.168.1.106:8118
export https_proxy=http://192.168.1.106:8118
```

## 编译一个软件试试

从`github.com`自动下载代码编译一个工程试试，比如[gdns-go](http://github.com/ayanamist/gdns-go)

```
go get github.com/ayanamist/gdns-go
```

看看`/home/pi/go/projects`目录是不是有`bin` `pkg` `src`三个目录，`bin`目录就有编译好的`gdns-go`程序了。

## gdns-go推荐说明

搜索关键词：gdns-go DNS dnsmasq  DNSCrypt DNS污染

`gdns-go`是一个基于[Google DNS over HTTPS API](https://developers.google.com/speed/public-dns/docs/dns-over-https)的DNS服务器程序，因为Google的API接口被墙，所以支持通过[shadowsocks](https://github.com/shadowsocks)连接和socks5代理连接，带`Cache`缓存，解析速度有保障。是一个比较完美的解决DNS污染的DNS服务器。go语言实现，方便windows、linux环境和各种ARM+linux路由器设备树莓派编译运行。

`config.json`例子配置如下，然后执行`sudo ./gdns-go > /dev/null 2>&1 &`后台运行即可(53端口需要root权限账号运行)。我已经用`gdns-go`取代`dnsmasq` + `DNSCrypt`。

```
{
  "listen": "192.168.1.104:53",
  "proxy": "ss://aes-128-cfb:x123456x@17.x.x.x:15879",
  "mapping": {
    "taobao.com": "223.5.5.5"
  }
}
```


