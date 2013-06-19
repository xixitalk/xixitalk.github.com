---
layout: post
title: "octopress加快rake generate速度"
date: 2013-06-19 21:35:54
comments: true
mathjax: false
categories: octopress
---

octopress随着文件越来越多，`rake generate`越来越慢。这样可以加快速度。

<!--more-->

```
rake isolate[new post filename]
rake preview
rake integrate
rake gen_deploy
```

`rake isolate`进行隔离，`rake integrate`进行隔离还原，`rake gen_deploy`进行生成和发布。

不过这个加快只是能够节省preview的时间而已，早点让你看到新博客的预览页面,并没有节省`rake generate && rake deploy`一起的时间。

参考：

1. Some Octopress Rake Tips <http://robdodson.me/blog/2012/06/11/some-octopress-rake-tips/>
2. 縮短重新產生文章的時間 <http://blog.eddie.com.tw/2011/10/30/speed-up-octopress-post-regeneration/>
3. 加快generate的速度 <http://blog.kent-chiu.com/blog/2013/03/04/octopress-configuration/>
