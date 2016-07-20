---
layout: post
title: "linux内核代码瘦身"
date: 2016-07-20 21:07:23
comments: true
mathjax: false
categories: linux kernel
---

linux内核代码瘦身，原理：把不参与编译的代码删除，这样用Source Insight工具阅读代码的时候就轻简了很多。

例子数据：原本一个嵌入式linux内核代码1万7千个C文件，精简之后只有1222个C文件，删除了1万6千个C文件。

<!--more-->

#### 第一步 清理临时文件

内核编译clean，把内核编译的临时文件都清除。

#### 第二步 保存所有C文件路径

```
cd linux-3.4.5
find ./ -name "*.c" | tee allsrc.txt
```

#### 第三步 编译内核

无需多讲，编译内核。

#### 第四步 用strip.py清除不参与编译的代码

部分代码使用了include C代码，所以用`ignorefilelist`自定义文件过滤。`scripts`是工具目录，`./drivers/usb/gadget/`里inlucde C代码太多了，所以这两个目录直接目录过滤，添加到`ignorepathlist`自定义目录过滤里。

```
import sys
import os

ignorefilelist=['fsr-2level.c','fsr-3level.c','percpu-km.c','percpu-vm.c','nf_conntrack_h323_types.c']
ignorepathlist=['./scripts/','./drivers/usb/gadget/']

f = open('allsrc.txt','r')  

for line in f.readlines():
	cfilename=line.strip('\n')
	objfilename=cfilename.replace(".c",".o")
	asmfilename=cfilename.replace(".c",".s")
	exefilename=cfilename.replace(".c","")

	cfile=cfilename.split('/')[-1]
	#print cfile
	
	flag=False
	for item in ignorepathlist:
		if cfilename.find(item)!=-1:
			#print cfilename
			flag=True
			break
	if flag:
		continue
	
	if cfile in ignorefilelist:
		#print cfile,cfilename
		continue
	
	if  os.path.exists(objfilename):
		continue
	if os.path.exists(asmfilename):
		#print asmfilename
		continue
	if os.path.exists(exefilename):
		#print exefilename
		continue
	
	if os.path.exists(cfilename):
		print objfilename,"NOT USING and rm ",cfilename
		os.remove(cfilename)
		pass

f.close()
```

保存代码为`strip.py`，保存在内核目录。

```
cd linux-3.4.5
python strip.py
```

### 第五步 重新编译内核

重新编译内核。

如果编译成功，清理临时文件后保存代码用于阅读；  
如果编译失败，恢复缺失的文件，修改strip.py，接着编译，直到内核重新编译通过，清理临时文件后保存代码用于阅读。



