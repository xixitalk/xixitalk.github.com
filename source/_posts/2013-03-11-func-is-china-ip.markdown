---
layout: post
title: "算法：判断是否是中国IP？"
date: 2013-03-11 19:11
comments: true
mathjax: false
categories: network
---

世界上有五个[区域互联网注册管理机构][rir_url]，负责亚洲和太平洋地区的是亚太网络信息中心(APNIC)。[点击这里][apnic_ip]可以获得亚太地址各个国家或地区申请到的IP地址区域。
中国共申请到42亿中的330026496个IPv4地址（约3.3亿）,分布在3579块不同的区域。  
IPv4地址格式是addr1.addr2.addr3.addr4，为了减少查找次数，考虑用空间换时间思路。所有2的32次方的IP，分布在256x256的区域内，每个区域表述addr1.addr2.\*.\*表述的IP（65536个IP）。
判断一个IP首先由addr1和addr2直接找到addr1.addr2.\*.\*的区域块，在块内进行搜索判断，这样查询的次数将大大降低。

<!--more-->

![Raspberry Pi代理原理图](/static/images/2013/03/ipv4search.png)

每一个区域块有三种情况：  
1、区域块为空  
如果区域块为空，则表示此区域块无中国IP分布。  
2、区域块有一个IP区域，则表示此区域有一个中国IP分布，查询一次是否匹配，如果匹配就是中国IP，如果不匹配就是外国IP。  
3、区域块有多个IP区域，则表示此区域块有多个中国IP分布，遍历查询，如果匹配就是中国IP，如果不匹配就是外国IP。  
情况2为理想情况，查询一次。情况3为恶劣情况，经过实际测试，202.14.\*.\*区域最恶劣，有40个区域块，202.14.\*.\*的IP要查询40次。虽然202.14.\*.\*区域的IP给中国分配了40次，但是不同次申请的区域是可以连续起来的，所以区域块内还可以优化。

下面是用python实现的一个测试代码：  
用法：从<http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest>下载亚太IP分配表，保存为delegated-apnic-latest文本文件，将下面代码保存为isChinaIP.py，并运行之。
<script src="https://gist.github.com/xixitalk/5142241.js"></script>

[rir_url]:http://en.wikipedia.org/wiki/Regional_Internet_registry
[apnic_ip]:http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest
