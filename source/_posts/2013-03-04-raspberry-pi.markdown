---
layout: post
title: "raspberry pi(树莓派）相关记录"
date: 2013-03-04 10:48
comments: true
mathjax: false
categories: raspberrypi
---

搜索关键词：raspberry pi 树莓派 教程 XBMC shadowsocks

上周用一件旧东西和推友交换了个[raspberry pi][raspberrypi_url](树莓派），虽然内存是256M的(最新版的树莓派升级到512M)，但想来够用了。设想是：代理服务器+[XBMC][xbmc_url]视频播放+挂载3.5寸移动硬盘+网站服务器。

<!--more-->

###入门教程
国内可以从ICKey买树莓派，这个售卖页面的“[使用说明][ickey_url]”做入门教程不错，工具也都有现成的下载。

###配件
电源只要满足700mA/5V都可以，但最好配置>1.5A/5V的电源适配器，特别如果要挂载移动硬盘  
USB的键盘鼠标，如果是PS/2接口的，需要一个转接器转化成USB  
一根HDMI线  
一张至少4G/class4的SD卡，注意[有些SD卡不兼容](http://elinux.org/RPi_SD_cards)  
一根microUSB线做电源线  

###树莓派版本选择
官方推荐[raspbian][raspbian_url]系统，这个系统默认启动进入字符终端模式，可以用apt-get安装[XBMC][xbmc_url]应用，但是有些不稳定，没有其他三个[XBMC][xbmc_url]专门版本稳定，其次首次运行[XBMC][xbmc_url]起来要几十秒。  
[raspbmc][raspbmc_url]、[xbian][xbian_url]、[OpenELEC][OpenELEC_url]三个都是[XBMC][xbmc_url]专用版本。  
如果你的树莓派用来做服务器的话，推荐使用raspbian系统，raspbian有几乎和debian一样多的软件包，如lighttpd、mysql、php、apache等，正常开机不启动[XBMC][xbmc_url]，节省资源。  
如果你有用[XBMC][xbmc_url]播放视频需求的话，推荐使用[raspbmc][raspbmc_url]，本身就是为[XBMC][xbmc_url]优化，其次可以用apt-get安装软件，比如lighttpd、nodejs、polipo。[XBMC][xbmc_url]空闲不播放时占用10%+的CPU资源，树莓派用HDMI连接到电视，要看视频打开电视就是XBMC界面。 

###代理服务器
代理服务器的原理[点击这里][proxy_url]  
我选择的版本是[raspbmc][raspbmc_url]，安装了polipo、nodejs版的shadowsocks和[cow](https://github.com/cyfdecyf/cow)。  
polipo用于将socks5转化为HTTP代理。polipo主要是做代理备份，正常情况下是使用[cow](https://github.com/cyfdecyf/cow)，cow可以设置上级代理是shadowsocks的socks5代理，cow可以自动判断网站是直接连接还是通过socks5代理。

###XBMC视频播放
raspbmc本身就是个[XBMC][xbmc_url]优化版本，支持播放windows网络共享里的视频。  
安卓手机可以安装个XBMC remote应用来控制树莓派上的XBMC  
可以配置NFS，这样iPad上的xbmc可以远程播放树莓派连接的移动电源里的视频。iPad上的xbmc也可以通过sabma连接，但是总是连接超时，所以我该用NFS来连接。

###挂载3.5寸移动硬盘
因为3.5寸移动硬盘已经外接供电，这样不需要树莓派的USB供电，USB只是作为普通的数据端口。  
测试[raspbian][raspbian_url]和[raspbmc][raspbmc_url]都可以正常挂接。驱动要安装ntfs-3g，然后通过mount挂载，具体步骤可以参考这里[raspbmc Automount an NTFS USB HDD][ntfs_url]。  
最新版的[raspbmc][raspbmc_url]连mount都不用，插入移动硬盘后系统自动挂载，挂载在/media/[磁盘名]，磁盘名和移动硬盘挂接windows下的盘符卷标一样的。windows上可以将网络共享映射为本地磁盘，这样下载和使用都像本地磁盘没什么区别。

警告：2.5寸的移动硬盘需要USB供电我没有尝试过。

###网站服务器
lighttpd用于搭建一个简单的web server，这样可以使用pac文件。  
raspbmc本身带了ftp、samba、SSH服务，并且默认是打开的，可以在[XBMC][xbmc_url]界面：程序-raspbmc settings里打开关闭。  
samba服务默认将/home/pi和/media两个目录共享，windows可以通过网上邻居访问读写,windows上可以将连接在树莓派的移动硬盘映射为一个盘符，用迅雷下载视频文件，然后在树莓派上的xbmc直接播放。  

[ickey_url]:http://www.ickey.cn/raspberrypi.php
[proxy_url]:/blog/2013/03/02/raspberry-pi-proxy/
[OpenELEC_url]:http://openelec.tv/get-openelec/download/viewcategory/10-raspberry-pi-builds
[raspberrypi_url]:http://www.raspberrypi.org/
[raspbmc_url]:http://www.raspbmc.com/download/
[xbian_url]:http://xbian.org/
[raspbian_url]:http://www.raspbian.org/
[xbmc_url]:http://xbmc.org/
[ntfs_url]:http://www.ficklelife.com/index.php?id=2
[privoxy_url]:www.privoxy.org/