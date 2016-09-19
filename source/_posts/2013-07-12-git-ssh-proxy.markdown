---
layout: post
title: "git ssh使用代理"
date: 2013-07-12 08:23:33
comments: true
mathjax: false
categories: git ssh proxy
---
昨天在树莓派上发现通过`ssh`方式向`github.com`的代码仓库`git push`代码一直提示连接`github.com`的22端口失败。而`HTTP`和`HTTPS`访问`github.com`正常，怀疑`github.com`的22端口被墙了。使用`ssh`方式的特点是可以不用输入密码，方便在shell里进行自动操作，而`https`需要输入密码。

树莓派上有`socks5`代理和`http`代理，下面配置`git ssh`通过代理进行`git`操作。

<!--more-->

代理分两个部分，一个是ssh协议的的代理，一个是git协议的代理。

## 第一部分 配置git协议的代理

配置git socks5代理

```
git config --global http.proxy 'socks5://127.0.0.1:1081' 
git config --global https.proxy 'socks5://127.0.0.1:1081' 
```

或者配置git http代理

```
git config --global https.proxy 'http://127.0.0.1:8080'
git config --global https.proxy 'https://127.0.0.1:8080'
```

`git config --global`会保存在`.gitconfig`文件里，可以用cat检查代理配置，或者用`git config --global -l`检查也可以。

```
$cat ~/.gitconfig
[http]
        proxy = socks5://127.0.0.1:1081
[https]
        proxy = socks5://127.0.0.1:1081
```

取消代理配置

```
git config --global --unset http.proxy
git config --global --unset https.proxy
```

## 第二部分 配置ssh的代理

### git ssh通过socks5代理
[在Mac OSX上通过SSH代理实现github访问](http://chunyemen.org/archives/813)

### git ssh通过http代理
[利用 HTTPS 代理访问 GitHub](http://blog.yxwang.me/2010/05/git-through-https-proxy/)

### 我的配置
通过`socks5`代理配置比较繁琐，配置后`git push`成功了一次，但是后面还是一直提示失败，找不到原因。后来改用`http`代理，代理成功。我的详细配置如下。

#### 安装corkscrew
如果系统里没有安装`corkscrew`，进行安装。

```
sudo apt-get install corkscrew
```

#### 配置ssh的.config
配置`~/.ssh/config`,如果`config`没有创建一个。我的`http`代理是`127.0.0.1:8118`，用户名是`pi`。

```
Host github.com
User git
ProxyCommand corkscrew 127.0.0.1 8118 %h %p
IdentityFile /home/pi/.ssh/id_rsa
```

