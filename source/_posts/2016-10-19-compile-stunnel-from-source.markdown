---
layout: post
title: "编译stunnel"
date: 2016-10-19 09:21:51
comments: true
mathjax: false
categories: stunnel
---

现在最新的stunnel是v5.36，而很多平台都还是`stunnel4`

<!--more-->

[下载](https://www.stunnel.org/downloads/stunnel-5.36.tar.gz)stunnel-5.36.tar.gz，解压。

```
wget https://www.stunnel.org/downloads/stunnel-5.36.tar.gz
tar -zxvf stunnel-5.36.tar.gz
```

用`./configure --help`查看编译配置选项。

```
cd stunnel-5.36
./configure --help
```

配置选项中`--with-threads`可以配置成`ucontext`、`pthread`或者`fork`，默认是`pthread`。如果是`pthread`模式，创建一个线程处理每个连接；如果是`fork`模式，`fork`一个进程处理每个连接。用`ps aux | grep stunnel`查看，如果很多个`stunnel`进程，则是`fork`模式；如果只有一个`stunnel`进程，那就是`ucontext`或者`pthread`模式。`ucontext`和`pthread`类似，也是一种用户线程，叫协程，从资源利用上来说`ucontext`比`pthread`和`fork`更好一点。

`stunnel`依赖`libwrap`和`libssl`，如果没有安装用下面命令安装（根据发行版本调整），其他依赖根据错误log安装。

```
sudo apt-get install libwrap0-dev  libssl-dev
```

用`configure`生成`Makefile`，下面配置选项含义：禁用`ipv6`，禁用[fips][fips_www]，每个网络连接用`ucontext`获得一个协程处理。选项根据自己需要增删。

```
./configure --disable-ipv6 --disable-fips --with-threads=ucontext
```

生成`Makefile`之后，`make`进行编译。

```
make
```

`make`编译完成编译好的stunnel位于`src/stunnel`，根据发行版本配置启动。我偷懒，直接覆盖了原来安装的`/usr/bin/stunnel4`命令，其他的脚本还用`stunnel4`的，目前没有发现问题。

```
sudo service  stunnel4  stop
sudo cp /usr/bin/stunnel4 /usr/bin/stunnel4.backup
sudo cp src/stunnel /usr/bin/stunnel4
sudo service  stunnel4  start
```


[fips_www]:https://en.wikipedia.org/wiki/Federal_Information_Processing_Standards "fips"




