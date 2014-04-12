---
layout: post
title: "curl下载断点传续"
date: 2014-04-12 17:22:17
comments: true
mathjax: false
categories: tech
---

### curl下载断点传续

```
curl -C offset -O http://google.com/p4.mp4 
```

offset手动输入已经下载的字节数

```
curl -C - -O http://google.com/p4.mp4 
```

`-C -`可以自动识别offet续传

<!--more-->

### curl使用代理

```
curl -x 192.168.1.106:8118  http://google.com/p4.mp4 
```

`-x` 后面跟HTTP代理的host和port

```
curl  --socks5-hostname 192.168.1.106:9050  http://google.com/p4.mp4
```

`--socks5-hostname`后面跟socks5代理的host和port

