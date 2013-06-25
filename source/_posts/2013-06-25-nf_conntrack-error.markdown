---
layout: post
title: "树莓派nf_conntrack错误"
date: 2013-06-25 08:57:52
comments: true
mathjax: false
categories: raspberrypi
---
`/var/log/syslog`和`/var/log/messages`出现大量的nf_conntrack错误

```
 raspbmc kernel: nf_conntrack: table full, dropping packet
```

<!--more-->

```
sysctl -w "net.netfilter.nf_conntrack_max=20000"
sysctl -w "net.netfilter.nf_conntrack_tcp_timeout_established=600"
```

<http://www.wendangz.com/idc/linux/967.html>