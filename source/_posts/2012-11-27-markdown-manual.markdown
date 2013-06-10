---
layout: post
title: "markdown manual"
date: 2012-11-27 14:56
comments: true
mathjax: false
categories: markdown
---

##链接

第一种最简单方式，地址用<>包含  

```
<http://www.example.com>
```

效果：
<http://www.example.com>

<!--more-->

第二种方式，这种方式适合短链接

```
[xixitalk](http://twittter/xixitalk)
[xixitalk](http://twittter/xixitalk "xixitalk")
```

效果：
[xixitalk](http://twittter/xixitalk)
[xixitalk](http://twittter/xixitalk "xixitalk")

第三种方式，这种方式适合长链接，过长的链接使用第二种方式容易破坏句子的整体结构，使用这种方式可以把链接像论文参考一样罗列在结尾。

```
[xixitalk][xixitalk_id]
[xixitalk_id]:http://twittter/xixitalk "xixitalk"  这行可以放在文件结尾，像论文参考
```

效果：

[xixitalk][xixitalk_id2]

[xixitalk_id2]:http://twittter/xixitalk "xixitalk"

第四种方式，章节式链接

```
[第二章](#chapter2)

<span id="chapter2">第二章 代码块</span>
```

效果：  
[第二章](#chapter2)

<span id="chapter2">第二章 代码块</span>

