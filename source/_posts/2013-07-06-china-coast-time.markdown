---
layout: post
title: "中国时区：CCT"
date: 2013-07-06 08:17:55
comments: true
mathjax: false
categories: octopress linux
---
octopress的`rake generate`的时候，如果时间在晚上22：00到24：00左右，发现生成的博客HTML文件日期会是第二天的日期。Google之后有人说要加`TZ=CCT`来设定时区。

<!--more-->

CCT（China Coast Time）是中国沿海时间。在用户目录下`.profile`或者`.bashrc`加入`TZ=CCT`。

~~~
export TZ=CCT
~~~
