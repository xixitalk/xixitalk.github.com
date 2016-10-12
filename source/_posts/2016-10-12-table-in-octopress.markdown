---
layout: post
title: "octopress里用表格"
date: 2016-10-12 10:53:20
comments: true
mathjax: false
categories: octopress
styles: data-table
---

octopress里怎么样用表格？octopress默认的表格border是0，看起来不整齐。这样修改可以显示border。

<!--more-->

##  步骤一 覆盖octopress默认的CSS

表格要显示border，需要这样修改。

参考他人博文：[为Octopress追加数据表格的CSS](http://programus.github.io/blog/2012/03/07/add-table-data-css-for-octopress/)

##  步骤二 博文markdown格式

博文报头增加`styles`选项：

```
layout: post
title: "octopress里用表格"
date: 2016-10-12 10:53:20
comments: true
categories: octopress
styles: data-table
```

表格markdown这样写，我的octopress用的是`Kramdown`，其他markdown语法类似。

```
|类型值|解释|
|----|----|
|0x0800 | 网际协议（IP）|
```

显示效果如下：

|类型值|解释|
|----|----|
|0x0800 | 网际协议（IP）|


