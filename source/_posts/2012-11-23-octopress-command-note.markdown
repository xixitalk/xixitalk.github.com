---
layout: post
title: "octopress命令备忘录"
date: 2012-11-23 23:07
comments: true
categories: git github octopress
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

将文章的markdown文件上传到github服务器
-

	git add .
	git commit -m "add source post"
	git push origin source

从github服务器更新本地仓库
-

	cd Octopress
	cd _deploy
	git pull origin master
	cd ..
	git pull origin source

Octopress仓库说明
-
Octopress的github分master和source分支，octopress目录下，除\_deploy目录外的文件上传到source分支。\_deploy目录内容上传到master分支。

Octopress支持中文
-
1、rake new_post生成的markdown文件要改成UTF-8无签名格式。

2、在ruby编译器目录里搜索convertible.rb，将28行修改如下：

	self.content = File.read(File.join(base, name), :encoding => "utf-8")

嵌入gist代码
-

```
<script src="https://gist.github.com/xixitalk/5142241.js"></script>
```

markdown在线编辑器
-
	http://mahua.jser.me/