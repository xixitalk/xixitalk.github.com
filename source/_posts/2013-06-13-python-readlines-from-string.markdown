---
layout: post
title: "python从字符串用readlines读取操作"
date: 2013-06-13 09:57:17
comments: true
mathjax: false
categories: python tech
---

场景：用[cURL](http://curl.haxx.se/)命令POST了一个文本文件到web服务器，想在服务器端对这个文件进行readlines操作

<!--more-->

### 用cURL命令POST文件

```
curl --form "fileupload=@filename.txt" http://example.com/resource.cgi
```

### 服务器端解析

```
import StringIO

class Markdown():
   def get(self):
       pass

   def post(self):
       filecontent = ...
       bufStr = StringIO.StringIO(filecontent)
	for oneline in bufStr.readlines():
		oneline = oneline.replace('\n','')
		print oneline

```

参考：

What is the cURL command-line syntax to do a POST request? <http://superuser.com/questions/149329/what-is-the-curl-command-line-syntax-to-do-a-post-request>

Python readline() from a string? <http://stackoverflow.com/questions/7472839/python-readline-from-a-string>

Using cURL to automate HTTP jobs <http://curl.haxx.se/docs/httpscripting.html>
