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

## 获取SigmaVPN代码

从github获取代码

```
git clone https://github.com/neilalexander/sigmavpn.git
```

## 安装libsodium

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

