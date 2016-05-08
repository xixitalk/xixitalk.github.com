---
layout: post
title: "在树莓派上安装SigmaVPN"
date: 2016-05-07 20:27:44
comments: true
mathjax: false
categories: raspbian vpn
---
Install SigmaVPN on Raspbian  
在树莓派上安装SigmaVPN

<!--more-->

# 以下配置还有一些问题待解决

sigmaVPN这样正常吗：手机通过LTE连接家里树莓派上服务器，连接正常，上网也正常，但在外网查IP是LTE的IP，不是家里宽带的IP，正常吗？

## 获取SigmaVPN代码

从github获取代码

```
git clone https://github.com/neilalexander/sigmavpn.git
```

## 安装libsodium

SigmaVPN依赖libsodium，安装libsodium

```
sudo apt-get install libsodium-dev
```

## 编译SigmaVPN

```
$cd sigmavpn
$make
```

显示以下编译信息，编译完成，没有想到编译如此简单顺利。

```
cc -I/usr/local/include -O2 -fPIC -Wall -Wextra -c naclkeypair.c -o naclkeypair.o
cc -I/usr/local/include -O2 -fPIC -Wall -Wextra -c pack.c -o pack.o
cc -I/usr/local/include -O2 -fPIC -Wall -Wextra -c tai.c -o tai.o
cc -o naclkeypair naclkeypair.o -L/usr/local/lib -lsodium -ldl -pthread
cc -o sigmavpn main.o modules.o dep/ini.o -L/usr/local/lib -lsodium -ldl -pthread
cc -I/usr/local/include -I/usr/local/include proto/proto_raw.c -o proto/proto_raw.o -O2 -fPIC -Wall -Wextra -shared -L/usr/local/lib -lsodium
cc -I/usr/local/include -I/usr/local/include proto/proto_nacl0.c pack.o -o proto/proto_nacl0.o -O2 -fPIC -Wall -Wextra -shared -L/usr/local/lib -lsodium
cc -I/usr/local/include -I/usr/local/include proto/proto_nacltai.c pack.o tai.o -o proto/proto_nacltai.o -O2 -fPIC -Wall -Wextra -shared -L/usr/local/lib -lsodium
cc -I/usr/local/include intf/intf_tuntap.c -o intf/intf_tuntap.o -O2 -fPIC -Wall -Wextra -shared
cc -I/usr/local/include intf/intf_udp.c -o intf/intf_udp.o -O2 -fPIC -Wall -Wextra -shared
```

## sigmavpn执行环境

sigmavpn不安装，把需要的可执行程序提取出来。sigmavpn支持模块化，需要`proto`和`intf`里的几个`.o`文件。

```
mkdir -p ~/tools/sigmavpn
cp naclkeypair  ~/tools/sigmavpn/
cp sigmavpn     ~/tools/sigmavpn/
cp ./proto/*.o  ~/tools/sigmavpn/
cp ./intf/*.o   ~/tools/sigmavpn/
```

## SigmaVPN配置

我参考的是clowwindy的配置 <https://gist.github.com/clowwindy/57d44b69741992d3eaa3>

### 生成proto_publickey和proto_privatekey

运行`naclkeypair`生成proto_publickey和proto_privatekey。

```
cd ~/tools/sigmavpn/
./naclkeypair
```

### 创建vpn.conf

其中192.168.1.104是树莓派的IP，如果是VPS则换成VPS的公网IP。proto_publickey和proto_privatekey替换成上面的生成的值。

```
[mysigmavpn]
proto = nacltai
proto_publickey = ce499073fc29bda865d0e0a4a4cf82428252409734de4691242804e45fa67e3d
proto_privatekey = 76db698a3ef69b0e1158a4cb238ee72a1cc5d30ed1c6fadeaa4c62549e02d95d
local = tuntap
local_interface = tunnel
local_tunmode = 1
peer = udp
peer_localaddr = 192.168.1.104
peer_localport = 5678
peer_remotefloat = 1
```

### 创建tunnel网口和配置iptables

```
sudo ip tuntap add dev tunnel mode tun
sudo ifconfig tunnel 10.8.0.1/24
sudo ifconfig tunnel mtu 1440
sudo echo 1 > /proc/sys/net/ipv4/ip_forward
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -i eth0 -o tunnel -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i tunnel -o eth0 -j ACCEPT
sudo iptables -t mangle -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1400
```

### 启动sigmavpn

```
./sigmavpn -c vpn.conf -m . &
```

-m指定模块`.o`所在的目录。

## 配置android上sigmavpn客户端

在市场安装sigmavpn客户端。

### TUNNEL配置

Remote Address : vpn.conf里的peer_localaddr  
Remote Port : vpn.conf里的peer_localport  
Remote Public Key: vpn.conf里的proto_publickey  

选中Use TAI64 nonce

### NETWORK配置

Tunnel Address Prefix：10.8.0.2/24  

配置完成后，点击STATUS页的CONNECT按钮，看看状态栏是不是有VPN的小钥匙了。


