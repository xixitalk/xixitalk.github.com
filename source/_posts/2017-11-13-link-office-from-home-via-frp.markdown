---
layout: post
title: "内网穿透：从家里连接办公室电脑"
date: 2017-11-13 09:11:13
comments: true
mathjax: false
categories: tech
---

环境说明: 办公室电脑是 10.40.xx.xx这样的内网IP，并且办公环境要通过HTTP代理才能访问外网。我没有公网IP的VPS，但是家里路由器是有公网IP的，可以借路由器的公网IP进行内网穿透。

#### 环境

家里一台树莓派3（IP 192.168.1.104）接在路由器下，路由器IP是192.168.1.1  公网IP假定是180.109.114.114。路由器上配置端口映射，把14827和14828都映射到树莓派3的192.168.1.104上，端口号可以自行选择其他的，和下面保持一致即可。

内网穿透使用[frp](https://github.com/fatedier/frp/blob/master/README_zh.md)软件。frp编译好的二进制下载地址<https://github.com/fatedier/frp/releases>，树莓派使用`frp_0.13.0_linux_arm.tar.gz`。

<!--more-->

#### 运行frp server

树莓派运行frp server，配置如下：

```
[common]
bind_port = 14828

```

配置如上，保存为config.ini，运行执行`nohup ./frps -c ./conf.ini -L ./log.txt &`

#### 运行frp client

办公室运行frp client，配置如下：

```
[common]
server_addr = 180.109.114.114
server_port = 14828
http_proxy = http://proxy.example.com.cn:80

[rdp]
type = tcp
local_ip = 127.0.0.1
local_port = 3389
remote_port = 14827
use_encryption = true
use_compression = true

```

配置说明：180.109.114.114为路由器公网IP，14828是frp服务的侦听端口；http_proxy是办公室访问因特网要通过HTTP代理，如果不需要直接去掉；3389是windows远程桌面的端口，其他服务换对应端口。

配置如上，保存为frpc.ini，运行`frpc.exe -c frpc.ini`。

#### 测试连接

在家里Windows电脑上打开远程桌面登录框，IP输入：192.168.1.104:14827，或者192.168.1.1:14827登录。

或者在外边因特网环境，IP输入：180.109.114.114:14827登录。


