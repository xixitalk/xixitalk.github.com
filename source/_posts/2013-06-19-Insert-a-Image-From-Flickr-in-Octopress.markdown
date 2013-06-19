---
layout: post
title: "在octopress里插入flickr的图片"
date: 2013-06-19 10:17:24
comments: true
mathjax: false
categories: octopress flickr
---
flickr更新之后，免费空间大，同时可以上传质量很好的图片，instrgram图片质量太差。

参考这篇Insert a Image From Flickr in Octopress <http://blog.ychuang.org/blog/2012/11/14/insert-a-image-from-flickr-in-octopress/>

Fetch images from Flickr to show in Octopress/Jekyll <http://blog.pixarea.com/2012/07/fetch-images-from-flickr-to-show-in-octopress-slash-jekyll>

<!--more-->

国内不能直接访问`flickr.com`，需要设置代理，假设设置一个HTTP代理，修改文件`plugins/flickr_image.rb`,在`FlickRaw.api_key`和`FlickRaw.shared_secret`代码行下添加如下代理。

```
FlickRaw.proxy = "http://192.168.1.106:8118/"
```

实例测试：

{% flickr_image 6293807068 b %}
