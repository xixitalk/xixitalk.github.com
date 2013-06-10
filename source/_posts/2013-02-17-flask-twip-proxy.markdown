---
layout: post
title: "为flask_twip添加图片代理"
date: 2013-02-17 11:31
comments: true
mathjax: false
categories: flask_twip
---

##为flask_twip添加图片代理
为flask_twip添加图片代理,理论上网页也可以，但网页只抓取第一层。  
demo参见<https://xinhuanet.herokuapp.com/twip/getimg>

<!--more-->

###1、import urllib2
在文件twip.py里增加import urllib2

	import urllib2

###2、增加/twip/getimg路径映射
在twip.py文件的函数getMapper里增加/twip/getimg路径映射

	('/getimg/',self.getimg),

###3、增加getimg函数
在文件twip.py里twip类增加getimg函数，代码参见<https://gist.github.com/xixitalk/4969986>  

<script src="https://gist.github.com/xixitalk/4969986.js"></script>

###4、浏览器访问https://YOURAPP.herokuapp.com/twip/getimg
访问https://YOURAPP.herokuapp.com/twip/getimg，输入图片地址或者网页地址即可。

###5、客户端使用
如果客户端获取图片的时候把不能访问的图片地址（以BLOCKEDIMGURL为例）以参数imgurl形式传给https://YOURAPP.herokuapp.com/twip/getimg就可以直接在客户端查看图片了。
	https://YOURAPP.herokuapp.com/twip/getimg?imgurl=BLOCKEDIMGURL

