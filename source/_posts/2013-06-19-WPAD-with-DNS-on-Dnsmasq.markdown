---
layout: post
title: "Dnsmasq上通过DNS分发WPAD"
date: 2013-06-19 14:34:04
comments: true
mathjax: false
categories: WPAD dnsmasq
---

[WPAD](http://en.wikipedia.org/wiki/Web_Proxy_Autodiscovery_Protocol)全称是Web Proxy Auto-Discovery，可以通过DHCP或者DNS进行代理分发，这样局域网里客户端连接上后自动进行代理。

[dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html)为一个轻量的DNS和DHCP服务器。dnsmasq.conf配置说明[dnsmasq.conf.example](http://www.thekelleys.org.uk/dnsmasq/docs/dnsmasq.conf.example)。

以下配置为资料搜集，仅供参考，我并未实践，并且在我实践过程中可能随时修改，有疑问可以交流但不要期望获得答案。

<!--more-->

### Dnsmasq上通过HDCP分发WPAD
在dnsmasq.conf里这样配置

```
## dnsmasq is a combined dns and dhcp server
## 	/etc/dnsmasq.conf
dhcp-option=252,http://your.server.here/wpad.dat 
```

### Dnsmasq上通过DNS分发WPAD
在dnsmasq.conf里这样配置

```
txt-record=host.co.nz,"service:wpad:!http://wpad.host.co.nz:80/proxy.pac"
srv-host=wpad.tcp.host.co.nz,wpad.host.co.nz,80
```

参考：  
Automatic Proxy Configuration  <http://users.telenet.be/mydotcom/library/network/pac.htm>  
[Dnsmasq-discuss] wpad and DNS <http://lists.thekelleys.org.uk/pipermail/dnsmasq-discuss/2006q1/000561.html>
