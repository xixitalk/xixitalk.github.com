---
layout: post
title: "用frp代替stunnel进行服务共享和安全连接"
date: 2017-11-13 16:14:36
comments: true
mathjax: false
categories: 
---

需求：家里内网的服务，办公室内网可以访问。

#### 环境说明

办公室电脑是 10.40.xx.xx这样的内网IP，并且办公环境要通过HTTP代理才能访问外网。我没有公网IP的VPS，但是家里路由器是有公网IP的。家里一台树莓派3（IP 192.168.1.104）接在路由器下，路由器IP是192.168.1.1 公网IP假定是180.109.114.114。路由器上配置端口映射，把14827和14828都映射到树莓派3的192.168.1.104上，端口号可以自行选择其他的，和下面保持一致即可。

<!--more-->

#### 原理

路由器端口映射可以将家里内网的服务开放到外网，stunnel可以加密指定端口连接，这依赖于家里路由器要有公网IP。  
而frp更自由一些，运行一个frp服务端，开放的服务和访问端各运行一个frp客户端，两个客户端之间可以安全通信，通过frp的stcp机制可以同时解决内网穿透和安全连接。公网IP主机可以是路由器，也可以是因特网上的VPS主机。

## 服务配置

下面以开放家里内网MEOW代理服务为例。MEOW运行在树莓派3上（192.168.1.104），端口是7788.

### frp服务端配置

frp服务运行在树莓派3，或者公网VPS上。

```
[common]
bind_port = 14828
```

### frp客户端1：MEOW的frp客户端配置

MEOW是运行家里内网树莓派3上的HTTP代理服务。

```
[common]
server_addr = 192.168.1.104
server_port = 14828

[meow_http]
type = stcp
sk = pass_token_123
local_ip = 192.168.1.104
local_port = 7788
```

`pass_token_123`是安全密码，自行定义。因为公网IP在路由器，14828端口开启了端口映射，所以对于14828端口frp的server_addr可以是192.168.1.104、192.168.1.1或公网IP 180.109.114.114。如果是公网VPS，这里地址改成公网IP。

###  frp客户端2：访问客户端

客户端2运行在外部内网，比如办公室内网。http_proxy是办公室上网代理，如果不需要则去掉。

```
# frpc.ini
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

因为MEOW是HTTP代理服务，所以浏览器设置http://127.0.0.1:8088就可以使用家里的MEOW服务了。如果是FTP、SSH、HTTP服务，换成对应的端口即可。

