---
layout: post
title: "免费申请S/MIME证书"
date: 2014-06-21 00:05:11
comments: true
mathjax: false
categories: tech
---

## 申请证书
从这里可以申请到免费的S/MIME 邮件证书：<http://www.instantssl.com/ssl-certificate-products/free-email-certificate.html>，
提交生成之后会把证书发送到邮箱里。

## 证书安装
在邮箱里点击连接就会把证书安装到电脑系统中（包括windows和Mac OSX)。  
证书认证关系如下：  
*   第一级根证书USERTrust(UTN-USERFirst-Client Authentication and Email)，系统中默认都带了；
*   第二级中级证书是COMODO Client Authentication and Secure Email CA;
*   第三级才是刚刚申请的个人证书。  
如果在证书管理器查看刚刚申请的个人证书显示不正常的话，说明系统中缺少第二级中级证书，从这里下载安装<http://crt.comodoca.com/COMODOClientAuthenticationandSecureEmailCA.crt>。

## 证书安装到iOS系统
在电脑系统里打开证书管理器（windows系统是运行certmgr.msc），把证书（包含私钥）导出，windows是pfx格式，Mac OSX是p12格式，导出的证书要设置私钥保护密码，iOS的证书安装需要输入这个密码。把这个pfx或者p12格式的证书发邮件到iOS上，点击打开即提示安装，输入之前的保护密码就安装到iOS系统中了。  
同样，iOS系统中缺少第二级中级证书，从这里下载安装<http://crt.comodoca.com/COMODOClientAuthenticationandSecureEmailCA.crt>。


<!--more-->

## iOS里启用加密和签名
在iOS-邮件、通讯录、日历-邮件帐户-高级 启用S/MIME，选择上面安装的证书。iOS自带的mail程序发邮件即可自动进行加密和签名。

##  群发公钥证书
在电脑证书管理里导出证书（不包含私钥），windows是cer文件，把这个文件群发出来告诉朋友。别人给你发邮件就用这个证书进行加密。

## 我的S/MIME证书
我的S/MIME证书<http://xixitalk.github.io/static/pub.cer>,欢迎用S/MIME给我发邮件。

## 其他参考
Mac OSX导出证书到iOS参考<http://feinstruktur.com/blog/2011/12/12/using-smime-on-ios-devices.html>