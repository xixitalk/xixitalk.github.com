---
layout: post
title: "用frp代替stunnel进行服务共享和安全连接"
date: 2017-11-13 16:14:36
comments: true
mathjax: false
categories: tech
---

需求：家里内网的服务，办公室内网可以访问。

#### 环境说明

办公室电脑是 10.40.xx.xx这样的内网IP。家里路由器是有公网IP的。家里一台树莓派3（IP 192.168.1.104）接在路由器下，路由器IP是192.168.1.1 公网IP假定是180.109.114.114。路由器上配置端口映射，把端口14828映射到树莓派3的192.168.1.104上。端口号14828可以自行选择其他的，和下面保持一致即可。

<!--more-->

#### 原理

公网主机运行一个frp服务端，开放的服务和访问端各运行一个frp客户端，两个客户端之间进行通信，通过frp的stcp机制可以同时解决内网穿透和安全连接。公网IP主机可以是家里路由器，也可以是因特网上的VPS主机。  
我的环境是frp服务端运行在路由器下面的树莓派上，路由器上配置了端口转发，frp服务端等同于运行在有公网IP的路由器上。

## 服务配置

下面以开放家里内网MEOW代理服务为例。MEOW运行在树莓派3上（192.168.1.104），端口是7788。

### frp服务端配置

frp服务运行在公网VPS上。因为我路由器有公网IP，并配置了端口转发，我的环境是运行在家里树莓派3上。

```
[common]
bind_port = 14828
```

### frp客户端1：MEOW的frp客户端配置

MEOW是运行家里内网树莓派3上的HTTP代理服务。

```
# frpc1.ini
[common]
server_addr = 192.168.1.104
server_port = 14828

[meow_http]
type = stcp
sk = pass_token_123
local_ip = 192.168.1.104
local_port = 7788
use_encryption = true
use_compression = true
```

`pass_token_123`是安全密码，自行定义，和下面客户端2配置要一致。公网IP在路由器，并且14828端口开启了端口映射，所以对于192.168.1.1或公网IP 180.109.114.114的14828端口访问都会转到192.168.1.104，所以这里配置`server_addr`是192.168.1.104。如果是公网VPS，这里`server_addr`地址改成公网IP。

###  frp客户端2：服务访问端

客户端2运行在外部内网，比如办公室内网，是服务访问端。http_proxy是办公室上网代理，如果不需要则去掉。

```
# frpc2.ini
[common]
server_addr = 180.109.114.114
server_port = 14828
http_proxy = http://proxy.example.com.cn:80

[meow_http_vistor]
type = stcp
role = vistor
server_name = meow_http
sk = pass_token_123
bind_addr = 127.0.0.1
bind_port = 8088
use_encryption = true
use_compression = true
```

MEOW是HTTP代理服务，浏览器设置http://127.0.0.1:8088就可以使用家里的MEOW服务了。如果是FTP、SSH、HTTP服务，换成对应的端口即可。

