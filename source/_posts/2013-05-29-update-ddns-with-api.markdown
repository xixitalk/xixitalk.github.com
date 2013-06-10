---
layout: post
title: "用API更新3322.org免费二级域名的DDNS"
date: 2013-05-29 19:22
comments: true
mathjax: false
categories: DDNS
---

用API更新3322.org免费二级域名的DDNS:  
1、注册3322.org的免费二级域名：<http://www.pubyun.com/>  
2、把下面的shell脚步保存为updateDDNS.sh。mydomain替换为你自己的二级域名，username:password替换为你自己在3322注册的帐号。用<http://icanhazip.com>获得公网IP。

<!--more-->

<script src="https://gist.github.com/xixitalk/5669646.js"></script>

3、在cron里添加每N分钟执行updateDDNS.sh。  
