---
layout: post
title: "linux常用命令和配置"
date: 2013-07-10 16:08:18
comments: true
mathjax: false
categories: linux
---
下面是最近工作需要用到的命令，记录下来以供查阅。

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

### SVN命令操作

#### checkout

~~~
svn checkout http://10.41.1.1/svn/project/tags/  --username test
~~~

#### update

~~~
svn update   //更新到最新
svn update --revision N //更新到版本N，-r
~~~

#### add

~~~
svn add file  //添加文件到版本管理里，需要commit操作才到远程代码仓库，file支持通配符
~~~

#### commit

~~~
svn commit -m "bugs fix"
~~~

#### log

~~~
svn log [PATH]  //查看修改提交的commit log
~~~
