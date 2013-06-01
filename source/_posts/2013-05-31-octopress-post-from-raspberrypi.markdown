---
layout: post
title: "用浏览器发布博客到octopress"
date: 2013-05-31 19:57:25
comments: true
categories: octopress raspberrypi
---
用网页发布到octopress，这样手机、iPad、办公环境都可以通过浏览器发octopress博文了。

cron 10分钟检查不好使，还是后台shell `while` 循环检查，执行一次后 `sleep` 600秒这样比较正常。

原理：浏览器网页编写，保存在GAE上，raspberry pi上定时检查抓取，下载到octopress的_posts目录下，调用`rake`进行发布，调用`git push`上传markdown源文件到github。


