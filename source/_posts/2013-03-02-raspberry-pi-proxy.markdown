---
layout: post
title: "利用Raspberry Pi加shadowsocks搭建代理服务"
date: 2013-03-02 12:31
comments: true
mathjax: false
categories: raspberrypi shadowsocks proxy
---

设想：路由器和Raspberry Pi的耗电都非常小，可以常开不关机。而且手机上使用SSH -D、shadowsocks和VPN都不方便，还增加电池消耗。android上的twidere和twitter官方客户端都支持HTTP代理，iOS也方便使用pac代理。HTTP代理虽然没有加密，但是因为都在国内没有通过GFW所以不会触发屏蔽。

<!--more-->

原理如图：  
![Raspberry Pi代理原理图](/static/images/2013/03/RaspberryPiProxy.png)

说明：  
1. Raspberry Pi运行在一个局域网里面，分配的IP如192.168.1.103(如果是DHCP可以在路由器设置里将MAC和IP绑定，防止IP分配变化)，Raspberry Pi运行shadowsocks或者ssh D产生一个socks代理，用polipo再转化成HTTP代理。这样产生了一个192.168.1.103:7070的socks代理和一个192.168.1.103:1080的HTTP代理。  
2. 路由器同时包含两个IP，一个是对内的192.168.1.1，一个运营商分配的公网IP。在路由器配置端口转发，将7070和1080都转发到192.168.1.103上。这样从外面访问路由器（公网IP）的这两个端口，就相当于访问192.168.1.103（Raspberry Pi）的对应的两个端口。  
3. 局域网内PC和手机可以直接用Raspberry Pi的IP和端口进行代理。  
4. 因特网上的PC和手机（外出的情况）就用路由器的公网IP和端口进行代理，当然局域网内也可以这样访问，只不过绕了路。  
5. 如果Raspberry Pi再运行一个HTTP server，路由器添加80端口转发，可以实现通过pac文件进行选择性代理。  
6. 路由器的公网IP变化比较快，推荐绑定3322.org的二级域名，花生壳和kmdns都不好使，3322.org支持API更新，可以用shell[脚本更新](http://xixitalk.github.io/blog/2013/05/29/update-ddns-with-api/)，从外面用域名加端口的方式访问，这样就可以防止公网IP变了无法使用的情况。  
7. 安全问题：这里的HTTP代理没有用户名密码验证，注意保密。以上端口除了系统占用的一小部分外，几乎可以修改为任意不常用的端口。  
