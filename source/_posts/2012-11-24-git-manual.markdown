---
layout: post
title: "git manual"
date: 2012-11-24 21:54
comments: true
categories: git
---

##初始化目录
以下两种方式
###空目录初始化
	git init  
###获取一个git仓库代码
	git clone https://github.com/xixitalk/flask_twip.git

###添加代码
	git add .
	git add -u

###提交到本地仓库
并未提交远程git仓库
	git commit -m "bug fix log"

###提交到仓库
	git push origin master

###删除文件
并未在git仓库删除,只是标记删除
	git rm FILENAME

###rm删除的文件重新从服务器更新
	git checkout filename.c

###标记忽略文件
.gitignore标记忽略文件，详细<http://help.github.com/ignore-files/>

###撤销修改
如果还没有commit，可以用下面命令恢复到修改前最后一次commit的状态。
	git checkout -- path/filename

###git里文件的三种状态
* 已提交（committed）  git commit之后
* 已修改（modified）   文件修改之后
* 已暂存（staged）     git add之后
git push之后，文件的状态没有改变，依然是已提交(committed)状态。

###git里文件流转的三个目录
* 工作目录
* 暂存区域
* 本地仓库
工作目录是用户编辑的目录，git clone操作后的目录；暂存目录是git add之后加入索引文件；本地仓库是git commit之后将文件快照保持的地方。

###git配置
	git config --list 查看配置

###git配置HTTP代理
	git config --global http.proxy example.com:8080
在.gitconfig文件可以看到：
	[http]
	      proxy = example.com:8080

###配置git的默认用户名和邮箱
	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

###git命令帮助
	git help add 查看git add帮助

###git手册
* [Pro Git](http://git-scm.com/book/zh/)
* [Git 初學筆記 - 指令操作教學](http://blog.longwin.com.tw/2009/05/git-learn-initial-command-2009/)
* [Git Community Book 中文版](http://gitbook.liuhui998.com/index.html)