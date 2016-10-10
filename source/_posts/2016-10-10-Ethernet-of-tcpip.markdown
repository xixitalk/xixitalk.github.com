
---
layout: post
title: "TCP/IP之以太网帧"
date: 2016-10-10 10:15:46
comments: true
mathjax: false
categories: tech network
---

### Ethernet II(以太网V2帧)

<!--more-->

|6字节|6字节|2字节|46-1500字节|4字节|
|----|----|----|----|----|
|目标MAC地址|源MAC地址|类型|数据|FCS| 

类型：08 00 是IP包，08 06 是ARP包  
数据：最常见的是IP包  
FCS：Frame check sequence帧校验序列  

更多常见类型：  
0x0800 网际协议（IP）  
0x0806 地址解析协议（ARP ： Address Resolution Protocol）  
0x0808 帧中继 ARP （Frame Relay ARP） [RFC1701]  
0x814C 简单网络管理协议（SNMP：Simple Network Management Protocol）  
0x86DD 网际协议v6 （IPv6，Internet Protocol version 6）  
0x880B 点对点协议（PPP：Point-to-Point Protocol）  
0x8847 多协议标签交换（单播）（MPLS：Multi-Protocol Label Switching unicast）  
0x8848 多协议标签交换（组播）（MPLS, Multi-Protocol Label Switching multicast）  

More Read  
<http://technow.blog.51cto.com/746816/320773>

