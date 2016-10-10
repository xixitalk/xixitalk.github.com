---
layout: post
title: "DNS协议学习笔记之DNS查询"
date: 2016-10-10 19:00:54
comments: true
mathjax: false
categories: tech network
styles: [data-table]
---

<!--more-->

# DNS协议学习笔记之DNS查询

DNS主要分查询报文和答复报文。

## 1 DNS查询报文

### 1.1 整体结构

```
    +---------------------+
    |        Header       |
    +---------------------+
    |       Question      | the question for the name server
    +---------------------+
    |        Answer       | RRs answering the question
    +---------------------+
    |      Authority      | RRs pointing toward an authority
    +---------------------+
    |      Additional     | RRs holding additional information
    +---------------------+
```
  
![DNSrequest](http://s6.51cto.com/wyfs02/M02/4D/A8/wKiom1RW2KaCvqHrAABEwMOH0AE633.jpg)

### 1.2 报文头

![DNSrequest2](http://xixitalkgithubio.qiniudn.com/dnsheader.jpg)

|16位标识|16位标志|
|16位问题数|16资源记录数|
|16位授权资源记录数|16位额外资源记录数|
{: border="1"}

整个DNS包头12个字节。  

**16位标志详解**

|1位QR | 4位opcode| 1位AA| 1位TC| 1位RD| 1位RA| 3位清0 |4位RCode|
{: border="1"}

QR：0表示查询报文，1表示响应报文  
Opcode：通常值为0(标准查询)，其他值为1(反向查询)和2(服务器状态请求)。  
AA：表示授权回答(authoritative answer).  
TC：表示可截断的(truncated)  
RD：表示期望递归  
RA：表示可用递归，随后3bit必须为0  
RCode：返回码，通常为0(没有差错)和3(名字差错)  

### 1.3 查询问题(Question)结构

```

                                    1  1  1  1  1  1
      0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                                               |
    /                     QNAME                     /
    /                                               /
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                     QTYPE                     |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                     QCLASS                    |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
```

QNAME结构：**域名字符串按照`.`分割，按照字符长度+字符依次排列，00结尾**。

比如www.google.com.hk，转为QNAME的16进制格式：

**03** 77 77 77 **06** 67 6f 6f 67 6c 65 **03** 63 6f 6d **02** 68 6b 00

解读：03个字符（www），06个字符（google），03个字符（com），02个字符（hk），结尾是00

QType：长度16位，表示查询类型  
QClass:长度为16位，表示分类

##  一个典型的DNS查询包

下面是`wireshark`抓取的一个DNS查询包：

```
(前面是以太网包头+IP包头+UDP包头)    6d 54 01 00 00 01
00 00 00 00 00 00 03 77    77 77 06 67 6f 6f 67 6c 
65 03 63 6f 6d 02 68 6b    00 00 01 00 01
```

`6d 54`是标识，每次查询变化，DNS回应本次查询会用相同的标识  
`01 00`是标志，表示RD期望递归为1  
`00 01`是问题数，一个问题查询；其他三个查询记录数都是0  
接下来是QName  
倒数第二个`00 01`是QType，值是1  
最后一个`00 01`是QClass，值是是1  


```
enum QueryType //查询的资源记录类型。 
{ 
A=0x01, //指定计算机 IP 地址。 
NS=0x02, //指定用于命名区域的 DNS 名称服务器。 
MD=0x03, //指定邮件接收站（此类型已经过时了，使用MX代替） 
MF=0x04, //指定邮件中转站（此类型已经过时了，使用MX代替） 
CNAME=0x05, //指定用于别名的规范名称。 
SOA=0x06, //指定用于 DNS 区域的“起始授权机构”。 
MB=0x07, //指定邮箱域名。 
MG=0x08, //指定邮件组成员。 
MR=0x09, //指定邮件重命名域名。 
NULL=0x0A, //指定空的资源记录 
WKS=0x0B, //描述已知服务。 
PTR=0x0C, //如果查询是 IP 地址，则指定计算机名；否则指定指向其它信息的指针。 
HINFO=0x0D, //指定计算机 CPU 以及操作系统类型。 
MINFO=0x0E, //指定邮箱或邮件列表信息。 
MX=0x0F, //指定邮件交换器。 
TXT=0x10, //指定文本信息。 
UINFO=0x64, //指定用户信息。 
UID=0x65, //指定用户标识符。 
GID=0x66, //指定组名的组标识符。 
ANY=0xFF //指定所有数据类型。 
};
```

```
enum QueryClass //指定信息的协议组。 
{ 
IN=0x01, //指定 Internet 类别。 
CSNET=0x02, //指定 CSNET 类别。（已过时） 
CHAOS=0x03, //指定 Chaos 类别。 
HESIOD=0x04,//指定 MIT Athena Hesiod 类别。 
ANY=0xFF //指定任何以前列出的通配符。 
};
```

### 学习资料

1.  [rfc1035](https://www.ietf.org/rfc/rfc1035.txt)

1.  [Chapter 15 DNS Messages](http://www.zytrax.com/books/dns/ch15/)

1.  [使用Wireshark学习DNS协议及DNS欺骗原理](http://www.iprotocolsec.com/2012/01/13/%E4%BD%BF%E7%94%A8wireshark%E5%AD%A6%E4%B9%A0dns%E5%8D%8F%E8%AE%AE%E5%8F%8Adns%E6%AC%BA%E9%AA%97%E5%8E%9F%E7%90%86/)

1.  [DIY一个DNS查询器：了解DNS协议](http://www.cnblogs.com/topdog/archive/2011/11/15/2250185.html)


