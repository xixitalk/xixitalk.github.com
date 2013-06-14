---
layout: post
title: "Raspberry Pi上安装Go lang并编译cow proxy"
date: 2013-06-14 11:48:41
comments: true
mathjax: false
categories: golang raspberrypi cowproxy
---
###安装go语言

选用非官方的二进制软件包，详细：<http://dave.cheney.net/unofficial-arm-tarballs>

ARMv6 (Raspberry Pi, etc)  
[go1.1.linux-arm~armv6-1.tar.gz](http://dave.cheney.net/paste/go1.1.linux-arm~armv6-1.tar.gz)  
sha1sum 2a76c9799aa5410090234edfda36ef69f5f99a42

<!--more-->

解压到/home/pi/go目录即可

###设置go语言编译环境变量

```
export GOROOT=/home/pi/go/go
export GOPATH=/home/pi/go/mygo
export PATH=$PATH:$GOROOT/bin
```

如果系统没有安装mercurial软件包，则需要用`apt-get`安装mercurial软件，cow proxy需要用到go语言的crypto package，`go get`会调用`hg`命令来获得。

```
sudo apt-get install mercurial
```

###编译cow proxy

[cow proxy](https://github.com/cyfdecyf/cow)是[@cyfdecyf](http://twitter.com/cyfdecyf)用go语言编写的一个自动代理，代码开源，支持二级socks代理。  
用下面的命令编译

```
go get github.com/cyfdecyf/cow
```

如果上面的命令出现go build出错`signal: killed`，再单独build

```
go build github.com/cyfdecyf/cow
```

编译好的cow二进制文件位于/home/pi/go/mygo目录下。

我已经编译好的二进制在<https://github.com/xixitalk/build/tree/master/cow>

###下一次更新代码再编译

```
go get -u  github.com/cyfdecyf/cow
```
