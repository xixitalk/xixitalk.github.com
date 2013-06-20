---
layout: post
title: "octopress里插入flickr的图片"
date: 2013-06-19 10:17:24
comments: true
mathjax: false
categories: octopress flickr
---
[flickr](http://www.flickr.com)更新之后，免费1T空间，同时可以上传质量很好的图片。[instagram](http://www.instagram.com)的图片质量太差了。

<!--more-->

### Gemfile添加flickraw

```
gem 'flickraw', '~> 0.9.6'
```

执行一次`bundle install`，确保系统里安装`flickraw`

### 申请flickr的API的key

从flickr.com申请api_key和shared_secret，略过。

### 添加flickr_image.rb到plugins目录

示例代码

<script src="https://gist.github.com/3156265.js?file=flickr_image.rb"></script>

ENV["FLICKR_KEY"]和ENV["FLICKR_SECRET"]可以直接替换成从flickr.com申请的api_key和shared_secret字符串，避免使用环境变量。

### flickr_image.rb添加代理

国内不能直接访问`flickr.com`，`rake generate`生成时执行`flickr_image.rb`会出错，所以需要设置一个代理解决。假设代理为一个HTTP代理，修改文件`plugins/flickr_image.rb`,在`FlickRaw.api_key`和`FlickRaw.shared_secret`代码行下添加如下代理。其他代理类似。

```
FlickRaw.proxy = "http://192.168.1.106:8118/"
```

### 实例测试

代码里这样使用
<script src="https://gist.github.com/3156265.js?file=2012-07-21-post-with-images-from-flickr.markdown_"></script>

`b`是指big，图片大小约为1024x768，基本可以满足博客显示。如果要更小图片，可以用`m`,表示medium。再小的用`sq`,表示square thumbnail。

{% flickr_image 6293807068 b %}

### 参考

1. Insert a Image From Flickr in Octopress <http://blog.ychuang.org/blog/2012/11/14/insert-a-image-from-flickr-in-octopress/>
2. Fetch images from Flickr to show in Octopress/Jekyll <http://blog.pixarea.com/2012/07/fetch-images-from-flickr-to-show-in-octopress-slash-jekyll>
