---
layout: post
title: "在octopress用mathjax显示数学公式"
date: 2013-06-08 23:32:24
comments: true
categories: math mathjax octopress
---

具体可以参看这篇博客<http://www.idryman.org/blog/2012/03/10/writing-math-equations-on-octopress/>

几点特殊说明如下：  
1、 `rdiscount` 要换成 `kramdown`，原因`rdiscount`会将公式的特殊字符转换成HTML的关键词sup、sub等。  
2、 MathJax放在`source\_includes\custom\head.html`更合适，可以精简为下面,原因是kramdown不认inline单个$  

```
<!-- mathjax config similar to math.stackexchange -->  

<script src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS_HTML" type="text/javascript"></script>
```

3、 要按照博客的说明，解决公式右键点击白屏的问题  
4、 用头尾双$进行函数书写，公式上下都空格是单独居中，公式在行内没有空格则是inline

如，单独居中的欧拉公式

```
$$  \mathrm{e}^{- \mathrm{i} \pi} + 1 = 0 $$
```

$$  \mathrm{e}^{- \mathrm{i} \pi} + 1 = 0 $$

行内的欧拉公式$$  \mathrm{e}^{- \mathrm{i} \pi} + 1 = 0 $$显示

一元二次方式求根公式

$$ x_{1,2} = \frac{-b \pm \sqrt{b^2-4ac}}{2b} $$
