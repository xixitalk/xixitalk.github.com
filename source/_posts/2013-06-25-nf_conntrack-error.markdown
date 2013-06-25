---
layout: post
title: "树莓派nf_conntrack错误"
date: 2013-06-25 08:57:52
comments: true
mathjax: false
categories: raspberrypi
---
最近我的树莓派出现大量的重启，特别是看电影+下bt的时候，并且[Dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html)也经常退出，在`/var/log/syslog`和`/var/log/messages`出现大量的nf_conntrack错误。

```
 raspbmc kernel: nf_conntrack: table full, dropping packet
```

<!--more-->

先试试下面这种方法能不能解决问题，默认`nf_conntrack_max`是7xxx，树莓派的内存不大，暂时设置`20000`

```
sudo sysctl -w "net.netfilter.nf_conntrack_max=20000"
sudo sysctl -w "net.netfilter.nf_conntrack_tcp_timeout_established=600"
```

参考：

<http://www.wendangz.com/idc/linux/967.html>
