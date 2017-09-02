---
layout: post
title: "树莓派3上编译haproxy"
date: 2017-09-03 06:01:08
comments: true
mathjax: false
categories: proxy tech
---

最近发现树莓派上haproxy有点问题，Google Play下载有些不正常。所以想更新编译haproxy。raspbian软件仓库的haproxy的版本比较低，所以直接下载haproxy源代码编译。更新过程记录下来。

<!--more-->

为了配置省事，建议先安装raspbian软件仓库里的haproxy，然后编译好的haproxy的直接覆盖，这样启动配置不用费心配置。

1、下载源代码并解压

```
wget http://www.haproxy.org/download/1.7/src/haproxy-1.7.9.tar.gz
tar xzvf haproxy-1.7.9.tar.gz
cd haproxy-1.7.9/
```

2、编译

haproxy不能直接make，需要带配置参数。先查看已经安装的haproxy的编译参数。

```
haproxy -vv OPTIONS = USE_GETADDRINFO=1
```

执行上面的命令会得到类似以下信息。

```
Build options :
  TARGET  = linux2628
  CPU     = generic
  CC      = gcc
  CFLAGS  = -O2 -g -fno-strict-aliasing -Wdeclaration-after-statement
  OPTIONS =
```

make编译

```
make  TARGET=linux2628   CPU=generic  CFLAGS="-O2 -g -fno-strict-aliasing -Wdeclaration-after-statement"
```

正常编译完，在haproxy-1.7.9目录下就会生成haproxy可执行文件。用`./haproxy -vv`查看编译好的haproxy版本号。

3、替换系统里的haproxy

```
$which haproxy
/usr/sbin/haproxy
$sudo service haproxy stop
$sudo cp ./haproxy /usr/sbin/haproxy
$sudo service haproxy start
```

4、haproxy负载平衡shadowsocks配置参考

`14826`是haproxy提供的端口，`12222`是haproxy的状态web端口，可以用浏览器访问http://IP:12222查看haproxy状态。`j1.vps.com`等是多个SS server端。SS local访问haproxy的`14826`端口，IP为haproxy的侦听IP，SS local其他配置和直接访问SS server是一样的。

```
global
ulimit-n 51200
defaults
log global
mode tcp
option dontlognull
balance roundrobin
option persist
timeout connect 10000
timeout client 150000
timeout server 150000

listen stats
bind *:12222
mode http
stats enable
stats uri /
stats refresh 10s

retries 1
option redispatch
frontend ss-in
bind *:14826
default_backend ss-out
backend ss-out
server j1 j1.vps.com:29777 maxconn 20480 weight 1
server j2 j2.vps.com:29777 maxconn 20480 weight 100
server us0 us0.vps.com:29777 maxconn 20480 weight 1 backup
server us1 us1.vps.com:29777 maxconn 20480 weight 1 backup
server us2 us2.vps.com:29777 maxconn 20480 weight 1 backup
server us3 us3.vps.com:29777 maxconn 20480 weight 1 backup
```

