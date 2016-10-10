---
layout: post
title: "DNS在HTTP网络交互流程中的位置"
date: 2016-10-09 08:55:37
comments: true
mathjax: false
categories: tech network
---

DNS在HTTP网络交互流程中的位置

<!--more-->

一个简单的HTTP请求流程（C语言版）

1.  建立socket(socket())
1.  由域名查询到IP(getaddrinfo()或者gethostbyname())
1.  建立连接(connect())
1.  按照HTTP协议要求发送数据(send())
1.  监听socket等待接收数据(select())
1.  监听到数据后接收数据(recv())
1.  按照HTTP协议解析数据，再发送数据或者结束

