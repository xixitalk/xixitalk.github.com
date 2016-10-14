---
layout: post
title: "stunnel双向证书认证"
date: 2016-10-13 20:09:49
comments: true
mathjax: false
categories: tech stunnel
---

stunnel 双向证书认证：**防止没授权的客户端连接stunnel服务器，防止连接假的服务器**。

<!--more-->

## 第一步 生成证书

生成两个证书，一个服务端的`stunnel_s.pem`，一个客户端的`stunnel_c.pem`，有效期设置长一点10000天。

```
$openssl req -new -x509 -days 10000 -nodes -out stunnel_c.pem -keyout stunnel_c.pem
$openssl req -new -x509 -days 10000 -nodes -out stunnel_s.pem -keyout stunnel_s.pem
```

## 第二步 服务器端stunnel.conf

将证书拷贝到/etc/stunnel目录，设置权限400.

```
$sudo cp stunnel_s.pem /etc/stunnel/
$sudo cp stunnel_c.pem /etc/stunnel/
$sudo chmod 400 /etc/stunnel/*.pem
```

创建`stunnel.conf`文件，内容如下，拷贝到`/etc/stunnel/`目录。对外端口是8445，加密的是[cow HTTP proxy](https://github.com/cyfdecyf/cow)的7777端口,根据情况自行修改。如果要调试打开`output`选项。cow是个HTTP代理，智能分流值得推荐。

```
;fips=no
client = no
sslVersion=all

chroot = /var/lib/stunnel4/
setuid = root
setgid = root

pid = /stunnel4.open.pid
;output = /stunnel.open.log
cert = /etc/stunnel/stunnel_s.pem
key = /etc/stunnel/stunnel_s.pem

[open]
accept = 8445
connect = 7777

verify=2
CAfile = /etc/stunnel/stunnel_c.pem
```

服务器端重启

```
$sudo service  stunnel4  restart
```

##  第三步 客户端stunnel.conf

我的客户端运行在windows系统，所以下面的配置是windows上stunnel验证的。其他系统自行验证。

将`stunnel_c.pem`和`stunnel_s.pem`（存放在客户端的stunnel_s.pem最好删除证书里BEGIN PRIVATE KEY私钥部分，只保留BEGIN CERTIFICATE公钥部分）拷贝到`stunnel`安装目录，修改`stunnel.conf`文件，配置如下。`stunnel_ip`是服务器端stunnel的IP，端口是8084，浏览器配置127.0.0.1:8084 HTTP代理。如果要换其他端口自行修改。

```
fips=no
client = yes
sslVersion = all
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1
socket = l:SO_LINGER=1:1
socket = r:SO_LINGER=1:1

[fastssl]
accept = 127.0.0.1:8084
connect = stunnel_ip:8445

verify = 2
CAfile = stunnel_s.pem

cert = stunnel_c.pem
key = stunnel_c.pem
```

如果客户端连接`stunnel`服务器端需要HTTP代理（公司网络），`fastssl`部分这样配置

```
[fastssl]
accept = 127.0.0.1:8084
connect = proxy.company.com:80
protocol = connect
protocolHost = stunnel_ip:8445
```

## stunnel安全说明

发现stunnel当服务器配置`verify = 2`时，服务器端会检查客户端证书是否在`CAfile`中。但是客户端配置`verify = 0`，客户端并不检查服务器端的证书，就算`CAfile`配置错误的服务器证书还是可以正常连接。

所以，stunnel服务端的**防盗**连安全机制是：在服务器`CAfile`里配置客户端的证书，并设置`verify = 2`，服务器端检查客户端证书不在`CAfile`列表则断开连接。

同样，为了避免客户端连接到**假的服务端**，则需要配置`verify = 2`，并把服务端的**公钥证书**放在客户端侧的`CAfile`里。

综上所述，当服务端和客户端都配置`verify = 2`，才是**双向证书认证**。

##  pem证书安全说明

pem证书是文本文件，里面`BEGIN PRIVATE KEY`和`END PRIVATE KEY`是私钥部分，`BEGIN CERTIFICATE`和`END CERTIFICATE`是公钥部分。`cert`和`key`配置完整的pem，而`CAfile`里只包含对方的公钥部分即可，即服务端`CAfile`是客户端的公钥，客户端`CAfile`是服务端的公钥。遵循这样原则，客户端的私钥只放客户端，服务端的私钥只放服务端，而公钥是可以多处存放的。

```
-----BEGIN PRIVATE KEY-----
MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQCo9WC13gg9WCRX
...
kPpWg2PAANRi5Bmr9ScvBISSYQ==
-----END PRIVATE KEY-----
-----BEGIN CERTIFICATE-----
MIID6TCCAtGgAwIBAgIJANBMqvP0YuV4MA0GCSqGSIb3DQEBBQUAMIGKMQswCQYD
...
o5tKoL9GcMhyjDoD9GCMfP6fY5DwPqhhqFTsPd47DzEdQ8amxPMn5kR/w/xk
-----END CERTIFICATE-----
```

##  参考博客

1.  [squid + stunnel >> 跨越长城，科学上网！](http://www.hawu.me/operation/886)
1.  [Using stunnel With Bilateral Authentication](http://briteming.blogspot.com/2013/03/stunnel.html)


