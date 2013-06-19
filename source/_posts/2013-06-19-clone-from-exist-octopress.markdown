---
layout: post
title: "从已经存在的octopress新建环境"
date: 2013-06-19 18:45:41
comments: true
mathjax: false
categories: octopress
---
场景需求：为已经存在的octopress博客在另一个目录或者主机新建一个octopress发布环境

### 获得source和master分支代码

```
$ git clone -b source git@github.com:xixitalk/xixitalk.github.com.git octopress
$ cd octopress
$ git clone git@github.com:xixitalk/xixitalk.github.com.git _deploy 
```
<!--more-->

如果更改了Gemfile内容，用`bundle install`更新安装

```
bundle install
```

参考：

Clone Your Octopress to Blog From Two Places <http://blog.zerosharp.com/clone-your-octopress-to-blog-from-two-places/>