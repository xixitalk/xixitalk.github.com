---
layout: post
title: "Nexus 6P上用flashfire升级系统"
date: 2016-06-12 10:53:35
comments: true
mathjax: false
categories: android flashfire
---
Nexus 6P上用flashfire升级系统

问题：Nexus原生系统root后怎么升级到最新系统？

<!--more-->

适用场景：nexus原生系统只是root，安装了superSU，其他系统文件没有修改，安装Xposed的情况我没有尝试过。

我的Nexus 6P本来系统是没有root的，每个月都通过OTA升级到最新系统，但是后来实在忍受不了国产应用间的相互唤醒了，root了系统，recovery换成了TWRP 3.0，使用了冰箱(icebox)把几个国产的应用冷冻起来了。其他系统文件没有修改。六月份系统推送了6月安全补丁MTC19V，一直在系统通知栏提示，甚是碍眼。搜索了一下发现可以使用flashfire更新系统。

参考教程 [华为 Nexus 6p 教你nexus手机root后怎么更新，就像ota一样，转自国外大神chainfire](http://bbs.mgyun.com/thread-50136-1-1.html) 

于是从google Play上下载了最新版本的flashfire，用方法2升级了系统。

## 方法1：flashfire直接OTA升级

按照flashfire的说明，系统下载完OTA升级包不要在`设置`里重启系统升级，打开flashfire会自动探测到OTA，直接一路确定升级。但是我尝试升级MTC19V没有成功，尝试了两次，系统重启进flashfire升级后系统版本号还是MTC19T，不是MTC19V。

## 方法2：flashfire刷整个新系统

方法2的理论是android系统在system分区，系统运行时候是只读的，用户产生的数据和配置都在data分区，OTA补丁是打到system分区的，所以升级新系统升级system分区而不覆盖data分区就达到了升级补丁还不破坏用户数据作用。

1.  先把冰箱里冷冻的所有应用全部解冻。
2.  从<https://developers.google.com/android/nexus/images>下载最新的MTC19V版本，有900多M，扩展名以tgz结尾：angler-mtc19v-factory-5c289974.tgz。
3.  把angler-mtc19v-factory-5c289974.tgz拷贝到手机里。
4.  打开flashfire，点击+，点击`Flash firmware package`，选择手机里angler-mtc19v-factory-5c289974.tgz。
5.  flashfire会分析tgz包，手动选择刷入Boot、system、vendor和cache分区，**recovery和data不选择**，切记。recovery就是twrp，data是用户安装的应用，不刷data是保留用户安装的应用。
6.  添加之后，flashfire会在EverRoot里自动添加刷入SuperSU，系统更新完成自动root。
7.  点击flash，系统自动关机重启进入flashfire刷入系统。
8.  flashfire更新之后系统自动重启，可以从设置里看到版本号已经是MTC19V了。


更新：7月份升级MTC19X的时候截了几张图。

![enter image description here](http://xixitalkgithubio.qiniudn.com/partition_mini.jpg)

![enter image description here](http://xixitalkgithubio.qiniudn.com/flash_mini.jpg)

