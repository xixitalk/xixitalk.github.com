---
layout: post
title: "免费申请S/MIME证书"
date: 2014-06-21 00:05:11
comments: true
mathjax: false
categories: tech
---

从这里可以申请到免费的S/MIME 邮件证书：[http://www.instantssl.com/ssl-certificate-products/free-email-certificate.html]

提交生成之后会把证书发送到邮箱里，在邮箱里点击连接就会把证书安装到电脑系统中（包括windows和Mac OSX)。在电脑系统里的证书管理器里把证书（包含私钥）导出，windows是pfx格式，Mac OSX是p12格式，导出的证书要设置私钥保护密码，iOS的证书安装需要输入这个密码。把这个pfx或者p12格式的证书发邮件到iOS上，点击打开即提示安装，输入之前的保护密码就安装到iOS系统中了。

<!--more-->

在iOS-邮件、通讯录、日历-邮件帐户-高级 启用S/MIME，选择上面安装的证书。

在电脑证书管理里导出证书（不包含私钥），windows是cer文件，把这个文件群发出来告诉朋友。别人给你发邮件就用这个证书进行加密。

我的S/MIME证书[http://xixitalk.github.io/static/pub.cer],欢迎用S/MIME给我发邮件。

其他参考：  
Mac OSX导出证书到iOS参考[http://feinstruktur.com/blog/2011/12/12/using-smime-on-ios-devices.html]