---
layout: post
title: "andrid上支持HTTP proxy代理的浏览器"
date: 2013-03-11 17:07
comments: true
categories: android proxy
---

之前一篇文章讲了在树莓派上搭建HTTP proxy的[原理][proxy_url]，这样就获得一个HTTP proxy，android上的[twidere][twidere_url]和[twitter][twidere_url]都支持HTTP proxy，可以在设置里进行配置。但是从[twidere][twidere_url]或者[twitter][twidere_url]打开网页又打不开了。这次推荐三个支持HTTP proxy的浏览器。  

###Firefox
android上的[Firefox][firefox_url]可以通过安装[Proxy Mobile][proxymobile_url]附加组件支持HTTP proxy，还支持DNS通过SOCKS进行远程解析。
优点：支持多tab页面，浏览器功能完整  
缺点：速度比较慢,最新版本的firefox有可能Proxy Mobile附件组件不兼容  

###orweb v2
[orweb v2浏览器][orweb_url]原本是配合tor的android版本[orbot][orbot_url]的代理的，但是可以自定义其他的HTTP proxy。  
优点：打开网页速度很快  
缺点：1、只能打开一个页面；2、如果没安装orbot，每次第一次打开浏览器都会提示系统没有安装orbot；3、如果在页面点击链接很深入之后，返回会按原路返回。

###蓝火焰浏览器
[蓝火焰浏览器][blueflame_url]是用android 2.x系统的浏览器框架封装的一个轻量级的浏览器。  
优点：支持多tab页面浏览  
缺点：打开t.co等缩短网站每次展开都提示用户选择浏览器，速度慢。

总结：如果从应用里打开网页推荐orweb v2，如果长时间浏览推荐使用firefox。

[proxy_url]:[/blog/2013-03-02-raspberry-pi-proxy/]
[firefox_url]:https://play.google.com/store/apps/details?id=org.mozilla.firefox
[blueflame_url]:https://play.google.com/store/apps/details?id=com.blueflame.web&hl=zh_CN
[orweb_url]:https://play.google.com/store/apps/details?id=info.guardianproject.browser
[twidere_url]:https://play.google.com/store/apps/details?id=org.mariotaku.twidere
[twitter_url]:https://play.google.com/store/apps/details?id=com.twitter.android
[proxymobile_url]:https://addons.mozilla.org/zh-CN/android/addon/proxy-mobile/
[orbot_url]:https://play.google.com/store/apps/details?id=org.torproject.android
