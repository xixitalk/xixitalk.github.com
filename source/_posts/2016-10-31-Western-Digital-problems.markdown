---
layout: post
title: "西部数据硬盘Load_Cycle_Count增长过快的问题"
date: 2016-10-31 08:39:21
comments: true
mathjax: false
categories: life
---

关键词：硬盘 西部数据 希捷 东芝 

我有一块西部数据的3.5寸硬盘，同时有一块笔记本淘汰下来的东芝的2.5寸硬盘，关键数据用这两个硬盘进行备份。最近东芝的硬盘偶尔读取失败，所以寻思再买一块硬盘替代东芝的这块硬盘。于是在网上搜索到底是买西部数据还是希捷，还是东芝的硬盘。搜索发现了西部数据硬盘曾经有“Load_Cycle_Count”的问题:[Western Digital Green Caviar WD10EADS and hdparm problems][blog_url]
，一看我用着的这块西部数据硬盘恰恰中招了，并且寿命快终结了。

<!--more-->

西部数据官方网站对这个问题的解释：[The S.M.A.R.T Attribute 193 Load/Unload counter keeps increasing on a SATA 2 hard drive][wd_url]

受影响的型号：

1. WD20EADS
1. WD20EARS
1. WD15EADS
1. WD15EARS
1. WD10EADS
1. WD10EARS
1. WD8000AARS
1. WD7500AADS
1. WD7500AARS
1. WD6400AADS
1. WD6400AARS
1. WD5000AADS
1. WD5000AARS

我的硬盘型号是`Device Model:     WDC WD20EARS-00MVWB1`，2T的3.5寸硬盘。我买的是西部数据 Elements Desktop 3.5寸外置硬盘2T （WDBAAU0020HBK），专门为树莓派买的，所以直接买的是西部数据外置硬盘，USB接口输出，里面是一块绿盘`WD20EARS-00MVWB1`，购买时间是2011.8.18号，到目前已经5年了。

今天（2016.10.31）SMART信息如下

```
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Always       -       0
  3 Spin_Up_Time            0x0027   166   160   021    Pre-fail  Always       -       6691
  4 Start_Stop_Count        0x0032   091   091   000    Old_age   Always       -       9326
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Always       -       0
  9 Power_On_Hours          0x0032   059   059   000    Old_age   Always       -       30290
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age   Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age   Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       789
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always       -       12
193 Load_Cycle_Count        0x0032   001   001   000    Old_age   Always       -       904905
194 Temperature_Celsius     0x0022   125   082   000    Old_age   Always       -       25
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offline      -       0
```

通电时间（Power_On_Hours）**30290**小时，折合3年多，对于5年多24/7接在树莓派上，也算正常。关键是Load_Cycle_Count，已经**904905**，90多万了。有地方说Load_Cycle_Count寿命3.5寸是30万，2.5寸是60万，我这个已经是90多万了。

西部数据Load_Cycle_Count增长多快的问题解决办法就是的就是官方提供的`wdidle3.exe`工具，增大休眠时间或者关闭绿盘的定时休眠功能。windows平台自行搜索使用教程。

西部数据官方没有提供linux下的工具，只提供windows下的工具，并且`wdidle3.exe`命令不能指定硬盘，一运行全部硬盘全部影响，建议不相关的硬盘拔掉（这是啥傻逼命令）。

有一个非官方的[linux wdidle3工具](http://idle3-tools.sourceforge.net/)，开源的，可以linux平台编译，可以指定硬盘。但是发现运行的时候提示`HDIO_DRIVE_CMD(identify) failed: Invalid argument`设置失败，这个应该是**西部数据SATA转USB接口的问题**，如果是直接SATA接口应该没有问题，我懒得折腾了。

我现在成**西部数据黑了**，原因有三：一个是因为`Load_Cycle_Count`的问题，这么严重的问题难道都不召回吗？第二我买的Elements Desktop，官方的SATA转USB接口，使用linux最常用的硬盘工具`hdparm`竟然提示错误，不可理解。上面`wdidle3`报的一样的错误。第三真的对红紫蓝绿盘挑选厌倦了。

```
$sudo hdparm -i /dev/sdb

/dev/sdb:
 HDIO_GET_IDENTITY failed: Invalid argument
$sudo hdparm -C /dev/sdb

/dev/sdb:
 drive state is:  unknown
```

我现在买了一块**希捷**的`ST4000DM000`，4T容量，依据[backblaze的数据](https://www.backblaze.com/blog/hard-drive-reliability-stats-q1-2016/)，希捷的`ST4000DM000`样本足够大，出错率低。加上**绿联**的SATA转USB线，外接12V2A供电，目前接树莓派上使用正常，`hdparm`设置也正常，推荐使用。就不知道希捷这块`ST4000DM000中国专供版`是否和国外的品质一致了。

同时在这里吐槽一下SSK的2.5寸硬盘盒，竟然`smartctl`读取东芝硬盘SMART信息都读不到。所以希捷3.5寸硬盘SATA转USB我没有再考虑SSK了，买了**绿联**的转接线。

**2T西部数据硬盘的数据已经备份，静待他的报废**，有地方说Load_Cycle_Count超过1百万会出问题，拭目以待。

**后续1**：我启动`hd-idle`服务后，西部数据这块硬盘`Load_Cycle_Count`一天竟然只增加了3，通电时间增加了2小时，之前`Load_Cycle_Count`每天平均应该是495（904905/5/365），这可能和我把平常读写硬盘的程序（btsync server）停掉了有关系，硬盘休眠时间增加了，但愿它多撑一段时间吧。

[blog_url]:https://blog.vandenbrand.org/2012/04/05/western-digital-green-caviar-wd10eads-and-hdparm-problems/

[wd_url]:http://support.wdc.com/knowledgebase/answer.aspx?ID=5357


