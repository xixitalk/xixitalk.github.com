---
layout: post
title: "用网页发布到octopress"
date: 2013-05-31 19:57:25
comments: true
categories: octopress raspberrypi
---
用网页发布到octopress，这样手机、iPad、办公环境都可以通过浏览器发octopress博文了。

cron 10分钟检查不好使，还是后台shell `while` 循环检查，执行一次后 `sleep` 600秒这样比较正常。


