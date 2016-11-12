---
layout: post
title: "华硕路由器外接硬盘格式化成什么文件系统最好"
date: 2016-11-12 15:33:41
comments: true
mathjax: false
categories: tech
---

关键词：华硕 AC66U AC68U 外接硬盘 文件系统 EXT4 EXT3 NTFS FAT32

我有一台华硕AC66U，外接了一块2.5吋移动硬盘。不知道格式化成什么格式最好？硬盘本来是EXT4格式的，插上发现没有自动挂载，搜索发现，AC66U建议用**EXT3**格式，而AC68U建议用**EXT4**格式。果然格式成EXT3后，插上AC66U后**自动挂载**了。其他华硕机器未验证。

<!--more-->
 
> For usb hdd Mipsel devices is EXT3 (RT-N16, RT-N66U, RT-AC66U and all other versions: /R /W)

RT-N16, RT-N66U, RT-AC66U是[MIPS][mips_url]架构的CPU，建议最好格式化成EXT3.

> For usb hdd ARM devices is EXT4 (RT-AC56U, RT-AC68U, RT-AC87U, RT-AC88U, RT-AC3200, RT-AC5300 and all other versions: /P /R /W)

RT-AC56U, RT-AC68U, RT-AC87U, RT-AC88U, RT-AC3200, RT-AC5300是[ARM][arm_url]架构的CPU，建议最好格式化成EXT4.

华硕路由器系统是Linux，对windows的NTFS和FAT32支持并不好，所以建议外接硬盘使用EXT4或者EXT3，如果都不支持也许应该升级路由器了。

## 参考文章

[How to Format Usb Drive](https://www.hqt.ro/how-to-format-usb-drive/)

[mips_url]:https://en.wikipedia.org/wiki/MIPS_instruction_set

[arm_url]:https://en.wikipedia.org/wiki/ARM_architecture

