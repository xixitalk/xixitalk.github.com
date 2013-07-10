---
layout: post
title: "linux常用命令和配置"
date: 2013-07-10 16:08:18
comments: true
mathjax: false
categories: linux
---
### 添加新用户test

~~~
useradd test
passwd test
mkdir /home/test
chown test /home/test
~~~

<!--more-->

将用户test加到管理员组

~~~
gpasswd -a test admin
~~~

### ubuntu重启samba

~~~
sudo service smbd start
sudo service smbd stop
sudo service smbd restart
~~~

### 在terminal里方向键翻不出历史命令
修改设置用户shell为bash，debian和ubuntu的新版本默认是dash

