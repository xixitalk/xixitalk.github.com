---
layout: post
title: "用iptables将8222端口转向22（SSH）"
date: 2013-05-30 21:53
comments: true
mathjax: false
categories: raspberrypi iptables
---

场景：家里树莓派的SSH端口是22，因为我的树莓派本身没有连接键盘，所以不敢轻易修改SSH的端口。从办公室里连接树莓派的SSH，需要家里的路由器进行端口转发。比如将路由器的22端口转发到树莓派的22端口。实际上路由器的22转发不成功，想来应该路由器本身占用了22端口，或者屏蔽了22端口的访问。所以这样操作：路由器转发8222端口到树莓派的8222端口，树莓派的8222端口再转发到本机的22端口，实现外部SSH的访问。

<!--more-->

用下面的命令进行iptables端口转发，192.168.1.106是树莓派的局域网IP  

	sudo iptables -t nat -A PREROUTING -d 192.168.1.106 -p tcp --dport 8222 -j DNAT --to-destination 192.168.1.106:22 

