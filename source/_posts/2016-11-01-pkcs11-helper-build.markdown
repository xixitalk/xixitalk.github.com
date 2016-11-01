---
layout: post
title: "pkcs11-helper编译"
date: 2016-11-01 18:37:08
comments: true
mathjax: false
categories: tech
---

[pkcs11-helper][url_1]也真是的，软件包里`INSTALL`里说用`./configure`生成`Makefile`，但是软件包还没有`configure`文件，需要`autoreconf`生成`configure`文件。妈蛋，`INSTALL`多写一句`autoreconf -ivf`会死吗？

<!--more-->

# 准备

确保系统安装了`autoconf` `automake` `libtool`

# 下载源代码解压

```
$wget https://github.com/OpenSC/pkcs11-helper/archive/pkcs11-helper-1.10.tar.gz
$tar -zxvf pkcs11-helper-1.10.tar.gz
$cd pkcs11-helper-pkcs11-helper-1.10
```

# 生成Makefile

```
$autoreconf -ivf
$./configure
```

# 编译安装

```
$make
$make install
```

# 参考

<https://github.com/OpenSC/pkcs11-helper/issues/2>

[url_1]:https://github.com/OpenSC/pkcs11-helper/releases

