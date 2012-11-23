---
layout: post
title: "octopress命令备忘录"
date: 2012-11-23 23:07
comments: true
categories: 
---

创建新文章
-
	rake new_post["TITLE"]

生成静态HTML文章
-
	rake generate

本地预览
-
	rake preview
通过<http://127.0.0.1:4000>访问

发布到github空间
-
	rake deploy

将文章的makedown文件上传到github服务器
-
	git add .
	git commit -m "add source post"
	git push origin source

octopress仓库说明
-
octopress的github分master和source分支，octopress目录下，除_deploy目录外的文件上传到source分支。_deploy目录内容上传到master分支。

octopress支持中文
-
1、rake new_post生成的makedown文件要改成UTF-8无签名格式。
2、修改ruby编译器目录里搜索convertible.rb，将28行修改如下：
	self.content = File.read(File.join(base, name), :encoding => "utf-8")
