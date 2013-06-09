---
layout: post
title: "flask_twip在heroku上搭建教程"
date: 2012-11-23 21:01
comments: true
categories: heroku git flask_twip twip twitter
---

[flask_twip](https://github.com/yegle/flask_twip)是@[yegle](http://twitter.com/yegle)写的一个可以搭建在[heroku](http://www.heroku.com/)上的一个[twip](http://code.google.com/p/twip/)的port程序。

本教程使用的flask_twip-0.0.1版本，保存的OAuth是临时文件会丢失，而最新的flask_twip已经使用数据库保存不会丢失。详细参见@[xmchenyj](http://twitter.com/xmchenyj)的教程：<http://xmchenyj.wordpress.com/2013/01/24/%E9%80%9A%E8%BF%87ubuntu-12-04-lts%E5%9C%A8heroku%E4%B8%8A%E9%83%A8%E7%BD%B2flask_twip/>

补充说明：@xmchenyj的教程在git init和git add .之前缺少建一个.gitignore文件，文件内容如下，表示venv目录和pyc文件不上传git服务器,这样和他教程结尾的备注才一致。

	venv
	*.pyc

2013-2-22 更新
